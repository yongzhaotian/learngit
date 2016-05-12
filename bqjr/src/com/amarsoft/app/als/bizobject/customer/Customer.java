package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;

/**
 * @author syang
 * @since 2011-6-11
 * @describe �ͻ������࣬��������ͻ���
 */
public abstract class Customer  implements Serializable{
	private static final long serialVersionUID = 5913969359820165779L;
	protected String customerID = null;			//�ͻ���
	protected String customerName = null;		//�ͻ���
	protected String englishName = null;		//Ӣ����
	protected String customerType = null;		//�ͻ�������
	protected String customerTypeName = null;		//�ͻ���������
	protected String certType = null;			//֤�����ʹ���
	protected String certID = null;				//֤����
	protected String loancardNo = null;		//�����
	protected String tempSaveFlag = null;		//�ݴ��־
	protected String creditBelong = null;		//���õȼ�����������
	protected String creditLevel = null;		//���������������õȼ�
	protected String creditFlag = null;			//���ſͻ���־
	protected String partnerFlag = null;		//�������ͻ���־
	protected String mgtUserID = null;			//����ͻ�����
	protected String mgtOrgID = null;			//�������
	
	protected String newWizardModel = null;			//������ģ��
	protected String detailCompNo = null;			//�������ҳ����
	protected String detailTempletNo = null;		//�ͻ��ſ���ʾģ����
	protected String baseInfoTreeNo = null;			//�ͻ�������Ϣ��ͼ���
	protected String objectClass = null;			//�ͻ�����
	protected String autoRiskScanID = null;		//����̽�ⳡ�����
	protected String rightControl = null;		//Ȩ�޿���ģ��
	
	protected String inputDate = null;			//�Ǽ�����
	protected String inputUserID = null;		//�Ǽ��˱��
	protected String inputOrgID = null;			//�Ǽǻ������
	protected String updateDate = null;		//��������
	protected String updateUserID = null;		//�����˱��
	protected String updateOrgID = null;		//���»������
	
	protected boolean entFlag = false;			//�Ƿ�˾�ͻ�
	protected boolean indFlag = false;			//�Ƿ���˿ͻ�
	protected boolean finFlag = false;			//�Ƿ�ͬҵ�ͻ�
	protected boolean groupFlag = false;			//�Ƿ��ſͻ�
	protected boolean indComFlag = false;			//�Ƿ���幤�̻�
	/**
	 * @return �ͻ���
	 */
	public String getCustomerID() {
		return customerID;
	}
	/**
	 * @param customerID �ͻ���
	 */
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	/**
	 * @return �ͻ�����
	 */
	public String getCustomerName() {
		return customerName;
	}
	/**
	 * @param customerName �ͻ�����
	 */
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}
	/**
	 * @return �ͻ�Ӣ������
	 */
	public String getEnglishName() {
		return englishName;
	}
	/**
	 * @param englishName �ͻ�Ӣ������
	 */
	public void setEnglishName(String englishName) {
		this.englishName = englishName;
	}
	/**
	 * @return �ͻ����ʹ���
	 */
	public String getCustomerType() {
		return customerType;
	}
	/**
	 * @param customerType �ͻ����ʹ���
	 */
	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}
	public String getLoancardNo() {
		return loancardNo;
	}
	public void setLoancardNo(String loancardNo) {
		this.loancardNo = loancardNo;
	}
	public String getCustomerTypeName() {
		return customerTypeName;
	}
	public void setCustomerTypeName(String customerTypeName) {
		this.customerTypeName = customerTypeName;
	}
	/**
	 * @return ֤��������
	 */
	public String getCertType() {
		return certType;
	}
	/**
	 * @param certType ֤��������
	 */
	public void setCertType(String certType) {
		this.certType = certType;
	}
	/**
	 * @return ֤�����
	 */
	public String getCertID() {
		return certID;
	}
	/**
	 * @param certID ֤�����
	 */
	public void setCertID(String certID) {
		this.certID = certID;
	}
	/**
	 * @return �ݴ��־��1.�ݴ棬2.���棩
	 */
	public String getTempSaveFlag() {
		return tempSaveFlag;
	}
	/**
	 * @param tempSaveFlag �ݴ��־��1.�ݴ棬2.���棩
	 */
	public void setTempSaveFlag(String tempSaveFlag) {
		this.tempSaveFlag = tempSaveFlag;
	}
	/**
	 * @return	���ſͻ���־
	 */
	public String getCreditFlag(){
		return creditFlag;
	}
	/**
	 * @param creditFlag	���ſͻ���־
	 */
	public void setCreditFlag(String creditFlag){
		this.creditFlag = creditFlag;
	}
	/**
	 * @return �������ͻ���־
	 */
	public String getPartnerFlag(){
		return partnerFlag;
	}
	/**
	 * @param partnerFlag �������ͻ���־
	 */
	public void setPartnerFlag(String partnerFlag){
		this.partnerFlag = partnerFlag;
	}
	/**
	 * @return mgtUserID ����ͻ�����
	 */
	public String getMgtUserID(){
		return  mgtUserID;
	}
	/**
	 * @param mgtUserID ����ͻ�����
	 */
	public void setMgtUserID(String mgtUserID){
		this.mgtUserID = mgtUserID;
	}
	/**
	 * @return mgtOrgID �������
	 */
	public String getMgtOrgID(){
		return mgtOrgID;
	}
	/**
	 * @param mgtOrgID �������
	 */
	public void setMgtOrgID(String mgtOrgID){
		this.mgtOrgID = mgtOrgID;
	}
	/**
	 * @return detailCompNo �ͻ�����ʹ�õ����ҳ����
	 */
	public String getDetailCompNo() {
		return detailCompNo;
	}
	/**
	 * @param detailCompNo �ͻ�����ʹ�õ����ҳ����
	 */
	public void setDetailCompNo(String detailCompNo) {
		this.detailCompNo = detailCompNo;
	}
	/**
	 * @return �ͻ��ſ�ʹ�õ�detailTemplateNoģ����
	 */
	public String getDetailTempletNo() {
		return detailTempletNo;
	}
	/**
	 * @param detailTemplateNo �ͻ��ſ�ʹ�õ�datawindowģ����
	 */
	public void setDetailTempletNo(String detailTempletNo) {
		this.detailTempletNo = detailTempletNo;
	}
	
	/**
	 * @return the autoRiskScanID �ͻ��Զ�����̽��ʱ��ʹ�õ�̽��ģ�ͱ��
	 */
	public String getAutoRiskScanID() {
		return autoRiskScanID;
	}
	/**
	 * @param autoRiskScanID �ͻ��Զ�����̽��ʱ��ʹ�õ�̽��ģ�ͱ��
	 */
	public void setAutoRiskScanID(String autoRiskScanID) {
		this.autoRiskScanID = autoRiskScanID;
	}
	/**
	 * @return creditBelong ���õȼ�����������
	 */
	public String getCreditBelong(){
		return creditBelong;
	}
	/**
	 * @param creditBelong ���õȼ�����������
	 */
	public void setCreditBelong(String creditBelong){
		this.creditBelong = creditBelong;
	}
	/**
	 * @return creditLevel ���������������õȼ�
	 */
	public String getCreditLevel(){
		return creditLevel;
	}
	/**
	 * @param creditLevel ���������������õȼ�
	 */
	public void setCreditLevel(String creditLevel){
		this.creditLevel = creditLevel;
	}
	/**
	 * @return �Ǽ�����
	 */
	public String getInputDate() {
		return inputDate;
	}
	/**
	 * @param inputDate �Ǽ�����
	 */
	public void setInputDate(String inputDate) {
		this.inputDate = inputDate;
	}
	/**
	 * @return �Ǽ���ID
	 */
	public String getInputUserID() {
		return inputUserID;
	}
	/**
	 * @param inputUserID �Ǽ���ID
	 */
	public void setInputUserID(String inputUserID) {
		this.inputUserID = inputUserID;
	}
	/**
	 * @return �Ǽǻ���ID
	 */
	public String getInputOrgID() {
		return inputOrgID;
	}
	/**
	 * @param inputOrgID �Ǽǻ���ID
	 */
	public void setInputOrgID(String inputOrgID) {
		this.inputOrgID = inputOrgID;
	}
	
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	public String getUpdateUserID() {
		return updateUserID;
	}
	public void setUpdateUserID(String updateUserID) {
		this.updateUserID = updateUserID;
	}
	public String getUpdateOrgID() {
		return updateOrgID;
	}
	public void setUpdateOrgID(String updateOrgID) {
		this.updateOrgID = updateOrgID;
	}
	
	public String getNewWizardModel() {
		return newWizardModel;
	}
	public void setNewWizardModel(String newWizardModel) {
		this.newWizardModel = newWizardModel;
	}
	public String getBaseInfoTreeNo() {
		return baseInfoTreeNo;
	}
	public void setBaseInfoTreeNo(String baseInfoTreeNo) {
		this.baseInfoTreeNo = baseInfoTreeNo;
	}
	public String getObjectClass() {
		return objectClass;
	}
	public void setObjectClass(String objectClass) {
		this.objectClass = objectClass;
	}
	public String getRightControl() {
		return rightControl;
	}
	public void setRightControl(String rightControl) {
		this.rightControl = rightControl;
	}
	
	public boolean isEnt(){
		return entFlag;
	}
	/**
	 * �Ƿ��С��ҵ
	 * @return
	 */
	public boolean isLargeEnt(){
		if(this.customerType!=null && this.customerType.equalsIgnoreCase(DefaultCustomerManagerFactory.LARGE_ENT_CUSTOMERTYPE)){
			return true;
		}
		return false;
	}
//	/**
//	 * �Ƿ�С��ҵ
//	 * @return
//	 */
//	public boolean isSmallEnt(){
//		if(this.customerType!=null && this.customerType.equalsIgnoreCase(DefaultCustomerManagerFactory.SMALL_ENT_CUSTOMERTYPE)){
//			return true;
//		}
//		return false;
//	}
	
	/**
	 * �Ƿ���˿ͻ�
	 */
	public boolean isPersonInd(){
		if(this.customerType!=null && this.customerType.equalsIgnoreCase(DefaultCustomerManagerFactory.PERSONAL_IND_CUSTOMERTYPE)){
			return true;
		}
		return false;
	}
	
	/**
	 * �Ƿ���徭Ӫ��
	 * @return
	 */
	public boolean isIndividulInd(){
		if(this.customerType!=null && this.customerType.equalsIgnoreCase(DefaultCustomerManagerFactory.INDIVIDUL_IND_CUSTOMERTYPE)){
			return true;
		}
		return false;
	}
	
	/**
	 * �Ƿ�ũ��
	 * @return
	 */
	public boolean isFarmerInd(){
		if(this.customerType!=null && this.customerType.equalsIgnoreCase(DefaultCustomerManagerFactory.FARMER_IND_CUSTOMERTYPE)){
			return true;
		}
		return false;
	}
	
	public boolean isIndCom(){
		return indComFlag;
	}
	
	
	public boolean isInd(){
		return indFlag;
	}
	
	public boolean isFin(){
		return finFlag;
	}
	
	public boolean isGroup(){
		return groupFlag;
	}
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("Customer [customerID=");
		builder.append(customerID);
		builder.append(", customerName=");
		builder.append(customerName);
		builder.append(", englishName=");
		builder.append(englishName);
		builder.append(", customerType=");
		builder.append(customerType);
		builder.append(", certType=");
		builder.append(certType);
		builder.append(", certID=");
		builder.append(certID);
		builder.append(", creditFlag=");
		builder.append(creditFlag);
		builder.append(", partnerFlag=");
		builder.append(partnerFlag);
		builder.append(", tempSaveFlag=");
		builder.append(tempSaveFlag);
		builder.append(", detailTempletNo=");
		builder.append(detailTempletNo);
		builder.append(", detailCompNo=");
		builder.append(detailCompNo);
		builder.append(", creditLevel=");
		builder.append(creditLevel);
		builder.append(", creditBelong=");
		builder.append(creditBelong);
		builder.append(", baseInfoTreeNo=");
		builder.append(baseInfoTreeNo);
		builder.append(", newWizardModel=");
		builder.append(newWizardModel);
		builder.append(", objectClass=");
		builder.append(objectClass);
		builder.append(", rightControl=");
		builder.append(rightControl);
		builder.append(", autoRiskScanID=");
		builder.append(autoRiskScanID);
		builder.append(", inputDate=");
		builder.append(inputDate);
		builder.append(", inputUserID=");
		builder.append(inputUserID);
		builder.append(", inputOrgID=");
		builder.append(inputOrgID);
		builder.append("]");
		return builder.toString();
	}
}
