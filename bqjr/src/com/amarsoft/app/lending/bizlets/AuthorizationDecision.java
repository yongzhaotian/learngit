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
		//��ȡ�������������͡������š���ǰ�û�����ǰ��ɫ,������ֵΪnull,��ת�ɿ��ַ���
		String sObjectType = DataConvertTools.nullToEmptyString((String)this.getAttribute("ObjectType"));
		String sObjectNo = DataConvertTools.nullToEmptyString((String)this.getAttribute("ObjectNo"));
		String sUserID = DataConvertTools.nullToEmptyString((String)this.getAttribute("UserID"));
		String sRoleID = DataConvertTools.nullToEmptyString((String)this.getAttribute("RoleID"));
		
		//��������������������̱�š��û����ڻ���
		String sCurrentFlowNo="",sOrgID;
		//�����������ѯ�����
		ASResultSet rs = null;
		/*****************��һ��:ȡ��������������Ϣ:���̱�š��û����ڻ������*****************/
		String sSql = "select FlowNo,OrgID from FLOW_OBJECT where ObjectType=:ObjectType and ObjectNo=:ObjectNo ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo));
		if(rs.next()){ 
			sCurrentFlowNo = rs.getString("FlowNo");
			sOrgID = rs.getString("OrgID");
		}else{//���ҵ�񲻴���
			rs.getStatement().close();
			return "false";
		}
		/*****************�ڶ���:������Ȩ����,��ȡ��Ȩ���*****************/
		DefaultSynonymnImpl synonymn = new DefaultSynonymnImpl(sObjectNo,sObjectType, Sqlca);
		//---------------WorkingMemory-------------------
		List<WorkingObject> oWorkingMemory = new ArrayList<WorkingObject>();
		oWorkingMemory.add(synonymn);
		Decision ov = EngineService.validateInSceneFlow(sCurrentFlowNo,sRoleID,sUserID,sOrgID,oWorkingMemory);
		
		return ov.getDecision()==Decision.����У��_��Ȩ����?"true":"false";
	}
}
