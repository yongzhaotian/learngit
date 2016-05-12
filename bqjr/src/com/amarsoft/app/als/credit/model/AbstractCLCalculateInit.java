package com.amarsoft.app.als.credit.model;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;

public abstract class AbstractCLCalculateInit {
	
	private String serialNo = null;
	private String applyType = null;
	private String applyNo = null;
	private String refModelID = null;
	private String customerID = null;
	private String fsRecordNo = null;
	private String userID = null;
	private String orgID = null;
	private String cLModRecordID = null;
	
	public String getCLModRecordID() {
		return cLModRecordID;
	}

	public void setCLModRecordID(String modRecordID) {
		cLModRecordID = modRecordID;
	}

	public String getApplyType() {
		return applyType;
	}
	
	public void setApplyType(String applyType) {
		this.applyType = applyType;
	}
	
	public String getApplyNo() {
		return applyNo;
	}
	
	public void setApplyNo(String applyNo) {
		this.applyNo = applyNo;
	}
	
	public String getRefModelID() {
		return refModelID;
	}
	
	public void setRefModelID(String refModelID) {
		this.refModelID = refModelID;
	}
	
	public String getCustomerID() {
		return customerID;
	}
	
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	
	public String getFsRecordNo() {
		return fsRecordNo;
	}
	
	public void setFsRecordNo(String fsRecordNo) {
		this.fsRecordNo = fsRecordNo;
	}
	
	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getOrgID() {
		return orgID;
	}

	public void setOrgID(String orgID) {
		this.orgID = orgID;
	}
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	
	public AbstractCLCalculateInit()
	{
		
	}
	
	public void init(JBOTransaction tx) throws JBOException{
		newRecord(tx);
		insertData(tx);	
		initModelData(tx);
		initRuleRecord(tx);
	}

	/**
	 * У���Ƿ��ظ�������㣬���ؽ����false,��ͨ����true��ͨ��
	 */
	public String check(){
		try{
			BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CLCALCULATE_RECORD");
			BizObjectQuery bq = bm.createQuery("ApplyNo=:ApplyNo and RefModelID=:RefModelID and FSRecordNo=:FSRecordNo");
			bq.setParameter("ApplyNo", applyNo);
			bq.setParameter("RefModelID", refModelID);
			bq.setParameter("FSRecordNo", fsRecordNo);
			
			BizObject bo = bq.getSingleResult();
			if(bo==null){
				return "true";
			}else{
				return "false";
			}
		}
		catch(JBOException jbx){
			jbx.printStackTrace();
			return "false";
		}
	}
	
	/**
	 * �����������»ؼ�¼�����ݱ�
	 */
	public void updateCLModelRecord(JBOTransaction tx,String s)throws JBOException{

		BizObjectManager bmcr = JBOFactory.getFactory().getManager("jbo.app.CLCALCULATE_RECORD");
		tx.join(bmcr);
		
		BizObjectQuery bq = bmcr.createQuery("SerialNo=:SerialNo");
		bq.setParameter("SerialNo", this.getSerialNo());
		BizObject bocr = bq.getSingleResult();
		bocr.getAttribute("RatingScore01").setValue(Double.parseDouble(s));
		
		bmcr.saveObject(bocr);
	}

	/**
	 * ��ʼ��CLCALCULATE_RECORD��
	 */
	protected void newRecord(JBOTransaction tx) throws JBOException{
		
		String stoday = StringFunction.getToday();
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CLCALCULATE_RECORD");
		tx.join(bm);
		
		BizObject bo = bm.newObject();
		bo.getAttribute("APPLYTYPE").setValue(applyType);
		bo.getAttribute("APPLYNO").setValue(applyNo);
		bo.getAttribute("REFMODELID").setValue(refModelID);
		bo.getAttribute("FSRECORDNO").setValue(fsRecordNo);
		bo.getAttribute("CUSTOMERID").setValue(customerID);
		bo.getAttribute("OCCURDATE").setValue(stoday);
		bo.getAttribute("CLPERION").setValue(stoday.substring(0, 7));
		bo.getAttribute("INPUTUSERID").setValue(userID);
		bo.getAttribute("INPUTORGID").setValue(orgID);
		bo.getAttribute("INPUTDATE").setValue(stoday);
		
		bm.saveObject(bo);
		
		this.setSerialNo(bo.getAttribute("SERIALNO").getString());
	}
	
	/**
	 * ��ʼ��CLCALCULATE_DATA��(Insert)
	 */
	protected void insertData(JBOTransaction tx) throws JBOException{
		String serialno = this.getSerialNo();
		String srefModelID = this.getRefModelID();
		
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		tx.join(bm);
		BizObjectQuery bq = bm.createQuery("CodeNo=:CodeNo and isinuse = '1' order by SortNo");
		bq.setParameter("CodeNo", srefModelID);
		
		List ls = bq.getResultList();
		for(int i=0;i<=ls.size()-1;i++){
			BizObject bo = (BizObject)ls.get(i);
			String sItemNo = bo.getAttribute("ItemNo").getString();
		
			BizObjectManager bmcd = JBOFactory.getFactory().getManager("jbo.app.CLCALCULATE_DATA");
			tx.join(bmcd);
			
			BizObject bocd = bmcd.newObject();
			bocd.getAttribute("SerialNo").setValue(serialno);
			bocd.getAttribute("SubjectNo").setValue(sItemNo);
			bocd.getAttribute("Value1").setValue("0.00");
			
			bmcd.saveObject(bocd);
		}
	}
	
	/**
	 * ��ʼ��Rule_Model_Record
	 */
	protected void initRuleRecord(JBOTransaction tx) throws JBOException{
		// TODO Auto-generated method stub
		String stoday = StringFunction.getToday();
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
		tx.join(bm);
		
		BizObject bo = bm.newObject();
		bo.getAttribute("RefRatingRecordID").setValue(this.getSerialNo());
		bo.getAttribute("RefModelID").setValue(refModelID);
		bo.getAttribute("InputUserID").setValue(userID);
		bo.getAttribute("InputOrgID").setValue(orgID);
		bo.getAttribute("InputDate").setValue(stoday);
		
		bm.saveObject(bo);
		
		//����Rule_Model_Record�󣬷������clcalculate_record��CLModRecordID
		String sCLModRecordID = bo.getAttribute("RuleModRecordID").getString();
		BizObjectManager bmcr = JBOFactory.getFactory().getManager("jbo.app.CLCALCULATE_RECORD");
		tx.join(bmcr);
		
		BizObjectQuery bq = bmcr.createQuery("SerialNo=:SerialNo");
		bq.setParameter("SerialNo", this.getSerialNo());
		BizObject bocr = bq.getSingleResult();
		bocr.getAttribute("CLModRecordID").setValue(sCLModRecordID);
		
		bmcr.saveObject(bocr);
	}
	
	/**
	 * ����װ�õ�Bomtextin������Rule_Model_Record
	 */
	public void updateBomtextin(JBOTransaction tx) throws JBOException{
		String sBomtextin = this.combineBomItem(tx);
		BizObjectManager bmcr = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
		tx.join(bmcr);
		
		BizObjectQuery bq = bmcr.createQuery("RuleModRecordID=:RuleModRecordID");
		bq.setParameter("RuleModRecordID", this.getCLModRecordID());
		BizObject bocr = bq.getSingleResult();
		bocr.getAttribute("BomTextIn").setValue(sBomtextin);
		
		bmcr.saveObject(bocr);
	}
	
	/**
	 * ɾ����������
	 */
	protected void deleteModelData(JBOTransaction tx) throws JBOException{
		//��ɾ��CLCALCULATE_DATA
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CLCALCULATE_DATA");
		tx.join(bm);
		BizObjectQuery bq = bm.createQuery("delete from o where SerialNo=:SerialNo");
		bq.setParameter("SerialNo", this.getSerialNo());
		
		bq.executeUpdate();
		
		//ɾ������Rule_Model_Record
		BizObjectManager bmrm = JBOFactory.getFactory().getManager("jbo.app.RULE_MODEL_RECORD");
		tx.join(bmrm);
		BizObjectQuery bqcd = bmrm.createQuery("RuleModRecordID=:RuleModRecordID");
		bqcd.setParameter("RuleModRecordID", this.getCLModRecordID());
		BizObject bo = bqcd.getSingleResult();
		
		bmrm.deleteObject(bo);
	}
	
	/**
	 * ���ݲ���ģ�ͳ�ʼ���������ݣ�������ģ�͸���ҵ���߼�������ʵ��
	 */
	protected abstract void initModelData(JBOTransaction tx) throws JBOException;
	
	/**
	 * ��װBomtext
	 */
	protected abstract String combineBomItem(JBOTransaction tx) throws JBOException;
	
}
