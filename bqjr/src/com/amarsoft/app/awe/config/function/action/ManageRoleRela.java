package com.amarsoft.app.awe.config.function.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

/**
 * 管理子系统、菜单与可见角色的关联关系
 * @author xhgao
 *
 */
public class ManageRoleRela {

	private String functionID; //功能点编号
	private String rightPointURL; //权限点URL
	private String relaValues=""; //关联属性值序列,定义为空串，防止该值为空时传递出错
	
	public String getFunctionID() {
		return functionID;
	}

	public void setFunctionID(String functionID) {
		this.functionID = functionID;
	}

	public String getRelaValues() {
		return relaValues;
	}

	public void setRelaValues(String relaValues) {
		this.relaValues = relaValues;
	}

	public void setRightPointURL(String rightPointURL) {
		this.rightPointURL = rightPointURL;
	}

	/**
	 * 管理功能点与角色的关联关系
	 * @return
	 * @throws JBOException 
	 */
	public String manageFunctionRoleRela(JBOTransaction tx) throws JBOException{
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.awe.AWE_ROLE_FUNCTION");
		BizObject bo = null;
		tx.join(bom);
		
		//删除指定功能点与角色的关联关系
		BizObjectQuery q = bom.createQuery("DELETE FROM O WHERE FunctionID = :FunctionID").setParameter("FunctionID", functionID);
		q.executeUpdate();
		
		//再将新关联关系插入
		String[] roles = relaValues.split("@");
		for(int i=0; i<roles.length; i++){
			if(StringX.isSpace(roles[i])) continue; //有空字符串时不处理
			bo = bom.newObject().setAttributeValue("FunctionID", functionID).setAttributeValue("RoleID", roles[i]);
			bom.saveObject(bo);
		}
		return "SUCCEEDED";
	}
	
	/**
	 * 管理权限点与角色的关联关系
	 * @return
	 * @throws JBOException 
	 */
	public String manageRightRoleRela(JBOTransaction tx) throws JBOException{
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.awe.AWE_ROLE_URL");
		BizObject bo = null;
		tx.join(bom);
		
		//删除指定功能点与角色的关联关系
		BizObjectQuery q = bom.createQuery("DELETE FROM O WHERE URL = :URL").setParameter("URL", rightPointURL);
		q.executeUpdate();
		
		//再将新关联关系插入
		String[] roles = relaValues.split("@");
		for(int i=0; i<roles.length; i++){
			if(StringX.isSpace(roles[i])) continue; //有空字符串时不处理
			bo = bom.newObject().setAttributeValue("URL", rightPointURL).setAttributeValue("RoleID", roles[i]);
			bom.saveObject(bo);
		}
		return "SUCCEEDED";
	}
}
