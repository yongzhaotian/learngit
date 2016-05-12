package com.amarsoft.app.awe.config.function.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ���ܵ�ɾ������ɾ�����ܵ��¼��ͬʱɾ������ɼ���ɫ�Ĺ�����ϵ
 * @author xhgao
 *
 */
public class DeleteFunctionAction {

	//�������
	private String functionID; //���ܵ���

	public String getFunctionID() {
		return functionID;
	}

	public void setFunctionID(String functionID) {
		this.functionID = functionID;
	}

	public String deleteFuncAndRela(JBOTransaction tx) throws Exception{
		
		//��ɾ�����ܵ��µ�Ȩ�޵�
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.awe.AWE_FUNCTION_URL");
		BizObjectQuery q = bom.createQuery("SELECT * FROM O WHERE FunctionID = :FunctionID").setParameter("FunctionID", functionID);
		List<BizObject> list = q.getResultList(false);
		for(BizObject bo :list){
			DeleteRightPointAction delRight = new DeleteRightPointAction();
			delRight.setRightPointURL(bo.getAttribute("URL").getString());
			delRight.deleteRightAndRela(tx);
		}
		
		//ɾ��ָ�����ܵ���ɼ���ɫ�Ĺ���
		bom = JBOFactory.getBizObjectManager("jbo.awe.AWE_ROLE_FUNCTION");
		tx.join(bom);
		bom.createQuery("DELETE FROM O where FunctionID = :FunctionID").setParameter("FunctionID", functionID).executeUpdate();
		
		//ɾ��ָ�����ܵ���Ϣ
		bom = JBOFactory.getBizObjectManager("jbo.awe.AWE_FUNCTION_INFO");
		tx.join(bom);
		bom.createQuery("DELETE FROM O WHERE FunctionID = :FunctionID").setParameter("FunctionID", functionID).executeUpdate();
		
		return "SUCCEEDED";
	}
}
