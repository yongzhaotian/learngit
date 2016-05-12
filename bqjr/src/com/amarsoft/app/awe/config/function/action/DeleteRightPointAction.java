package com.amarsoft.app.awe.config.function.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * Ȩ�޵�ɾ������ɾ�����ܵ��¼��ͬʱɾ������ɼ���ɫ�Ĺ�����ϵ
 * @author xhgao
 *
 */
public class DeleteRightPointAction {

	//�������
	private String rightPointNo; //Ȩ�޵�SerialNo
	private String rightPointURL; //Ȩ�޵�URL

	public String getRightPointNo() {
		return rightPointNo;
	}

	public void setRightPointNo(String rightPointNo) {
		this.rightPointNo = rightPointNo;
	}

	public String getRightPointURL() {
		return rightPointURL;
	}

	public void setRightPointURL(String rightPointURL) {
		this.rightPointURL = rightPointURL;
	}

	/*public String deleteRightAndRela() throws Exception{
		JBOTransaction tx = null;
		try{
			tx = JBOFactory.createJBOTransaction();
			deleteRightAndRela(tx);
			tx.commit();
			return "SUCCEEDED";
		} catch (Exception e) {
			if(tx != null) tx.rollback();
			return "FAILED";
		}
	}*/
	
	public String deleteRightAndRela(JBOTransaction tx) throws Exception{
		if(rightPointURL == null){
			BizObject bo = JBOFactory.createBizObjectQuery("jbo.awe.AWE_FUNCTION_URL", "SerialNo=:SerialNo").setParameter("SerialNo", rightPointNo).getSingleResult(false);
			if(bo != null){
				rightPointURL = bo.getAttribute("URL").getString();
			}
		}
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bom = null;
		//ɾ��ָ��Ȩ�޵���ɼ���ɫ�Ĺ���
		bom = f.getManager("jbo.awe.AWE_ROLE_URL");
		tx.join(bom);
		bom.createQuery("DELETE FROM O where URL = :URL").setParameter("URL", rightPointURL).executeUpdate();
		
		//ɾ��ָ��Ȩ�޵���Ϣ
		bom = f.getManager("jbo.awe.AWE_FUNCTION_URL");
		tx.join(bom);
		bom.createQuery("DELETE FROM O WHERE URL = :URL").setParameter("URL", rightPointURL).executeUpdate();
		
		return "SUCCEEDED";
	}
}
