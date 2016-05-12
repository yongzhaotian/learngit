package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.sadre.DefaultSynonymnImpl;
import com.amarsoft.app.util.DataConvertTools;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.sadre.rules.aco.Decision;
import com.amarsoft.sadre.rules.aco.WorkingObject;
import com.amarsoft.sadre.services.EngineService;

public class AuthorizationDecision extends Bizlet{
	public Object run(Transaction Sqlca) throws Exception {
		//获取参数：对象类型、对象编号、当前用户、当前角色,若参数值为null,则转成空字符串
		String sObjectType = DataConvertTools.nullToEmptyString((String)this.getAttribute("ObjectType"));
		String sObjectNo = DataConvertTools.nullToEmptyString((String)this.getAttribute("ObjectNo"));
		String sUserID = DataConvertTools.nullToEmptyString((String)this.getAttribute("UserID"));
		String sRoleID = DataConvertTools.nullToEmptyString((String)this.getAttribute("RoleID"));
		
		//定义变量：对象所在流程编号、用户所在机构
		String sCurrentFlowNo="",sOrgID;
		//定义变量：查询结果集
		ASResultSet rs = null;
		/*****************第一步:取对象所在流程信息:流程编号、用户所在机构编号*****************/
		String sSql = "select FlowNo,OrgID from FLOW_OBJECT where ObjectType=:ObjectType and ObjectNo=:ObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo));
		if(rs.next()){ 
			sCurrentFlowNo = rs.getString("FlowNo");
			sOrgID = rs.getString("OrgID");
		}else{//这笔业务不存在
			rs.getStatement().close();
			return "false";
		}
		/*****************第二步:调用授权服务,获取授权结果*****************/
		DefaultSynonymnImpl synonymn = new DefaultSynonymnImpl(sObjectNo,sObjectType, Sqlca);
		//---------------WorkingMemory-------------------
		List<WorkingObject> oWorkingMemory = new ArrayList<WorkingObject>();
		oWorkingMemory.add(synonymn);
		Decision ov = EngineService.validateInSceneFlow(sCurrentFlowNo,sRoleID,sUserID,sOrgID,oWorkingMemory);
		
		return ov.getDecision()==Decision.规则校验_有权规则?"true":"false";
	}
}
