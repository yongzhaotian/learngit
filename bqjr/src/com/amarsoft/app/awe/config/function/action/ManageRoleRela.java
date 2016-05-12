package com.amarsoft.app.awe.config.function.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

/**
 * ������ϵͳ���˵���ɼ���ɫ�Ĺ�����ϵ
 * @author xhgao
 *
 */
public class ManageRoleRela {

	private String functionID; //���ܵ���
	private String rightPointURL; //Ȩ�޵�URL
	private String relaValues=""; //��������ֵ����,����Ϊ�մ�����ֹ��ֵΪ��ʱ���ݳ���
	
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
	 * �����ܵ����ɫ�Ĺ�����ϵ
	 * @return
	 * @throws JBOException 
	 */
	public String manageFunctionRoleRela(JBOTransaction tx) throws JBOException{
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.awe.AWE_ROLE_FUNCTION");
		BizObject bo = null;
		tx.join(bom);
		
		//ɾ��ָ�����ܵ����ɫ�Ĺ�����ϵ
		BizObjectQuery q = bom.createQuery("DELETE FROM O WHERE FunctionID = :FunctionID").setParameter("FunctionID", functionID);
		q.executeUpdate();
		
		//�ٽ��¹�����ϵ����
		String[] roles = relaValues.split("@");
		for(int i=0; i<roles.length; i++){
			if(StringX.isSpace(roles[i])) continue; //�п��ַ���ʱ������
			bo = bom.newObject().setAttributeValue("FunctionID", functionID).setAttributeValue("RoleID", roles[i]);
			bom.saveObject(bo);
		}
		return "SUCCEEDED";
	}
	
	/**
	 * ����Ȩ�޵����ɫ�Ĺ�����ϵ
	 * @return
	 * @throws JBOException 
	 */
	public String manageRightRoleRela(JBOTransaction tx) throws JBOException{
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.awe.AWE_ROLE_URL");
		BizObject bo = null;
		tx.join(bom);
		
		//ɾ��ָ�����ܵ����ɫ�Ĺ�����ϵ
		BizObjectQuery q = bom.createQuery("DELETE FROM O WHERE URL = :URL").setParameter("URL", rightPointURL);
		q.executeUpdate();
		
		//�ٽ��¹�����ϵ����
		String[] roles = relaValues.split("@");
		for(int i=0; i<roles.length; i++){
			if(StringX.isSpace(roles[i])) continue; //�п��ַ���ʱ������
			bo = bom.newObject().setAttributeValue("URL", rightPointURL).setAttributeValue("RoleID", roles[i]);
			bom.saveObject(bo);
		}
		return "SUCCEEDED";
	}
}
