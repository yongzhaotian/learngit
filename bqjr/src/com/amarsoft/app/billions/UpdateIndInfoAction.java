package com.amarsoft.app.billions;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 
 * ���¿ͻ���ϢIND_INFO�����ֶ�����
 * 
 * @author huzp
 * @date 2016-03-29
 */
public class UpdateIndInfoAction {
	
	private String CustomerID; // �ͻ���
	private String CustomerName; // �ͻ�����
	private String CertID; // ���֤��
	private String MobileTelephone = "";//�ֻ�����
	private String WorkCorp = "";//��λ����
	private String SelfMonthIncome ="";//����������
	private String RelativeType = "";//������ϵ
	private String KinshipName ="";//��������
	private String KinshipTel ="";//������ϵ�绰
	private String Contactrelation = "";//������ϵ�˹�ϵ
	private String OtherContact = "";//������ϵ������
	private String ContactTel ="";//������ϵ�˵绰
	private String UpdateDate; // ����ʱ��
	private String STATE ="";//״̬
	private String SERIALNO ="";//��ˮ��
	
	public String getSTATE() {
		return STATE;
	}

	public void setSTATE(String sTATE) {
		STATE = sTATE;
	}

	public String getSERIALNO() {
		return SERIALNO;
	}

	public void setSERIALNO(String sERIALNO) {
		SERIALNO = sERIALNO;
	}

	public String getCustomerID() {
		return CustomerID;
	}

	public void setCustomerID(String customerID) {
		CustomerID = customerID;
	}

	public String getCustomerName() {
		return CustomerName;
	}

	public void setCustomerName(String customerName) {
		CustomerName = customerName;
	}

	public String getCertID() {
		return CertID;
	}

	public void setCertID(String certID) {
		CertID = certID;
	}

	public String getMobileTelephone() {
		return MobileTelephone;
	}

	public void setMobileTelephone(String mobileTelephone) {
		MobileTelephone = mobileTelephone;
	}

	public String getWorkCorp() {
		return WorkCorp;
	}

	public void setWorkCorp(String workCorp) {
		WorkCorp = workCorp;
	}

	public String getSelfMonthIncome() {
		return SelfMonthIncome;
	}

	public void setSelfMonthIncome(String selfMonthIncome) {
		SelfMonthIncome = selfMonthIncome;
	}

	public String getRelativeType() {
		return RelativeType;
	}

	public void setRelativeType(String relativeType) {
		RelativeType = relativeType;
	}

	public String getKinshipName() {
		return KinshipName;
	}

	public void setKinshipName(String kinshipName) {
		KinshipName = kinshipName;
	}

	public String getKinshipTel() {
		return KinshipTel;
	}

	public void setKinshipTel(String kinshipTel) {
		KinshipTel = kinshipTel;
	}

	public String getContactrelation() {
		return Contactrelation;
	}

	public void setContactrelation(String contactrelation) {
		Contactrelation = contactrelation;
	}

	public String getOtherContact() {
		return OtherContact;
	}

	public void setOtherContact(String otherContact) {
		OtherContact = otherContact;
	}

	public String getContactTel() {
		return ContactTel;
	}

	public void setContactTel(String contactTel) {
		ContactTel = contactTel;
	}

	public String getUpdateDate() {
		return UpdateDate;
	}

	public void setUpdateDate(String updateDate) {
		UpdateDate = updateDate;
	}

	/**
	 * ���Ŀͻ���Ϣ
	 * @param Sqlca
	 * @throws Exception
	 */
	public void updateIndInfo(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
			osql = new SqlObject("   update IND_INFO "+
							     "   set WorkCorp    = :WorkCorp, "+
							     "   MobileTelephone = :MobileTelephone, "+
							     "   SelfMonthIncome = :SelfMonthIncome, "+
							     "   KinshipName     = :KinshipName, "+
							     "   KinshipTel      = :KinshipTel, "+
							     "   RelativeType    = :RelativeType, "+
							     "   OtherContact    = :OtherContact, "+
							     "   Contactrelation = :Contactrelation, "+
							     "   ContactTel      = :ContactTel, "+
							     "   UpdateDate      = :UpdateDate, "+
							     "   TEMPSAVEFLAG    = '1' "+
							     "   where CustomerID = :CustomerID");
			osql.setParameter("WorkCorp", WorkCorp);
			osql.setParameter("MobileTelephone", MobileTelephone);
			osql.setParameter("SelfMonthIncome", SelfMonthIncome);
			osql.setParameter("KinshipName", KinshipName);
			osql.setParameter("KinshipTel", KinshipTel);
			osql.setParameter("RelativeType", RelativeType);
			osql.setParameter("OtherContact", OtherContact);
			osql.setParameter("Contactrelation", Contactrelation);
			osql.setParameter("ContactTel", ContactTel);
			osql.setParameter("UpdateDate", StringFunction.getToday());
			osql.setParameter("CustomerID", CustomerID);

			Sqlca.executeSQL(osql);
	}
	
	/**
	 * ����Ԥ��ͻ���Ϣ״̬
	 * @param Sqlca
	 * @throws Exception
	 */
	public void updatePretrialInfoState(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
			osql = new SqlObject("   update Pretrial_Info "+
							     "   set STATE    = '005' "+
							     "   where SERIALNO = :SERIALNO");
			osql.setParameter("SERIALNO", SERIALNO);
			Sqlca.executeSQL(osql);
	}
	
	private String getvalus(String val){
		if(null==val){
			return val;
		}
		if("undefined".equals(val)){
			return null;
		}
		return  "'"+val+"'";
	}
}
