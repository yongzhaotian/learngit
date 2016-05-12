package com.amarsoft.app.als.rating.model;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.StringFunction;

public class CustomerRatingLoader {
	
	public static CustomerRatingInfo getCusRatingInfo(String sCustomerID) throws JBOException{
		
		
		//װ�ؿͻ�������Ϣ
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RATING");
		BizObjectQuery bq = bm.createQuery("CustomerID=:CustomerID and StatusFlag = '1'");
		bq.setParameter("CustomerID",sCustomerID);
		BizObject bo = bq.getSingleResult();
		
		if(bo!=null){
			CustomerRatingInfo cri = new CustomerRatingInfo();
			cri.setSerialNo(bo.getAttribute("SerialNo").toString());
			cri.setCustomerID(bo.getAttribute("CustomerID").toString());
			cri.setRefModelID(bo.getAttribute("RefModelID").toString());
			cri.setVersion(bo.getAttribute("Version").toString());
			cri.setBomTextIn(bo.getAttribute("BomTextIn").toString());
			cri.setSaveFlag(bo.getAttribute("SaveFlag").toString());
			cri.setStatusFlag(bo.getAttribute("StatusFlag").toString());
			cri.setCustomerType(bo.getAttribute("CustomerType").toString());
			
			return cri;
		}else{
			return null;
		}
	}
	
	public static CustomerRatingInfo getCusRatingInfoSaved(String sCustomerID) throws JBOException{
		
		
		//װ�ؿͻ��ѱ���������Ϣ
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RATING");
		BizObjectQuery bq = bm.createQuery("CustomerID=:CustomerID and StatusFlag = '1' and SaveFlag = '2'");
		bq.setParameter("CustomerID",sCustomerID);
		BizObject bo = bq.getSingleResult();
		
		if(bo!=null){
			CustomerRatingInfo cri = new CustomerRatingInfo();
			cri.setSerialNo(bo.getAttribute("SerialNo").toString());
			cri.setCustomerID(bo.getAttribute("CustomerID").toString());
			cri.setRefModelID(bo.getAttribute("RefModelID").toString());
			cri.setVersion(bo.getAttribute("Version").toString());
			cri.setBomTextIn(bo.getAttribute("BomTextIn").toString());
			cri.setSaveFlag(bo.getAttribute("SaveFlag").toString());
			cri.setStatusFlag(bo.getAttribute("StatusFlag").toString());
			cri.setCustomerType(bo.getAttribute("CustomerType").toString());
			
			return cri;
		}else{
			return null;
		}
	}
	
	public static String updateCusRatingInfo(String CustomerID,String Parm){
		String sResult = null;
		String sToday = StringFunction.getToday();
		try{
			BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RATING");
			BizObjectQuery bq = bm.createQuery("update o set BomTextIn =:BomTextIn,SaveFlag = '2',UpdateDate =:UpdateDate where CustomerID=:CustomerID and StatusFlag = '1'");
			bq.setParameter("CustomerID",CustomerID);
			bq.setParameter("BomTextIn",Parm);
			bq.setParameter("UpdateDate",sToday);
			bq.executeUpdate();
			sResult = "_OK_";
		}
		catch(JBOException jbex){
			jbex.printStackTrace();
			ARE.getLog().error("���¿ͻ�������Ϣʧ�ܣ�");
			sResult = "_ERROR_";	
		}
		return sResult;
	}
	
	public static String getRuleModelName(String sModelID) throws Exception{
		String sResult = null;
		
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_TYPE");
		BizObjectQuery bq = bm.createQuery("CurModelID=:CurModelID");
		bq.setParameter("CurModelID",sModelID);
		BizObject bo = bq.getSingleResult();
		
		if(bo!=null){
			sResult = bo.getAttribute("ModelTypeName").toString();
		}
		
		return sResult;
	}
	
	/**
	 * ��ȡ�ͻ���Ч���������(1����Ч��)
	 * @return
	 * @throws Exception
	 */
	public static String getCusRatingResult(String CustomerID){
		String sResult = "";
		try{
			BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RATING_RESULT");
			BizObjectQuery bq = bm.createQuery("CustomerNo=:CustomerNo order by ConfirmDate Desc");
			bq.setParameter("CustomerNo",CustomerID);
			BizObject bo = bq.getSingleResult();
			
			if(bo!=null){
				sResult = bo.getAttribute("RatingGrade99").toString();
			}
		}
		catch(JBOException jbx){
			sResult = "";
		}
		
		return sResult;	
	}
}
