package com.amarsoft.app.awe.config.function.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 权限点删除处理，删除功能点记录的同时删除其与可见角色的关联关系
 * @author xhgao
 *
 */
public class DeleteRightPointAction {

	//定义变量
	private String rightPointNo; //权限点SerialNo
	private String rightPointURL; //权限点URL

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
		//删除指定权限点与可见角色的关联
		bom = f.getManager("jbo.awe.AWE_ROLE_URL");
		tx.join(bom);
		bom.createQuery("DELETE FROM O where URL = :URL").setParameter("URL", rightPointURL).executeUpdate();
		
		//删除指定权限点信息
		bom = f.getManager("jbo.awe.AWE_FUNCTION_URL");
		tx.join(bom);
		bom.createQuery("DELETE FROM O WHERE URL = :URL").setParameter("URL", rightPointURL).executeUpdate();
		
		return "SUCCEEDED";
	}
}
