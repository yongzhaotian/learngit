package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;

/**
 * @author syang
 * @since 2011-6-11
 * @describe 客户抽象类，定义基础客户类
 */
public abstract class Customer  implements Serializable{
	private static final long serialVersionUID = 5913969359820165779L;
	protected String customerID = null;			//客户号
	protected String customerName = null;		//客户名
	protected String englishName = null;		//英文名
	protected String customerType = null;		//客户类别代码
	protected String customerTypeName = null;		//客户类型名称
	protected String certType = null;			//证件类型代码
	protected String certID = null;				//证件号
	protected String loancardNo = null;		//贷款卡号
	protected String tempSaveFlag = null;		//暂存标志
	protected String creditBelong = null;		//信用等级评估表类型
	protected String creditLevel = null;		//本行评估即期信用等级
	protected String creditFlag = null;			//授信客户标志
	protected String partnerFlag = null;		//合作方客户标志
	protected String mgtUserID = null;			//主办客户经理
	protected String mgtOrgID = null;			//主办机构
	
	protected String newWizardModel = null;			//新增向导模型
	protected String detailCompNo = null;			//详情组合页面编号
	protected String detailTempletNo = null;		//客户概况显示模板编号
	protected String baseInfoTreeNo = null;			//客户基本信息树图编号
	protected String objectClass = null;			//客户对象
	protected String autoRiskScanID = null;		//风险探测场景编号
	protected String rightControl = null;		//权限控制模型
	
	protected String inputDate = null;			//登记日期
	protected String inputUserID = null;		//登记人编号
	protected String inputOrgID = null;			//登记机构编号
	protected String updateDate = null;		//更新日期
	protected String updateUserID = null;		//更新人编号
	protected String updateOrgID = null;		//更新机构编号
	
	protected boolean entFlag = false;			//是否公司客户
	protected boolean indFlag = false;			//是否个人客户
	protected boolean finFlag = false;			//是否同业客户
	protected boolean groupFlag = false;			//是否集团客户
	protected boolean indComFlag = false;			//是否个体工商户
	/**
	 * @return 客户号
	 */
	public String getCustomerID() {
		return customerID;
	}
	/**
	 * @param customerID 客户号
	 */
	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}
	/**
	 * @return 客户名称
	 */
	public String getCustomerName() {
		return customerName;
	}
	/**
	 * @param customerName 客户名称
	 */
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}
	/**
	 * @return 客户英文名称
	 */
	public String getEnglishName() {
		return englishName;
	}
	/**
	 * @param englishName 客户英文名称
	 */
	public void setEnglishName(String englishName) {
		this.englishName = englishName;
	}
	/**
	 * @return 客户类型代码
	 */
	public String getCustomerType() {
		return customerType;
	}
	/**
	 * @param customerType 客户类型代码
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
	 * @return 证件类别代码
	 */
	public String getCertType() {
		return certType;
	}
	/**
	 * @param certType 证件类别代码
	 */
	public void setCertType(String certType) {
		this.certType = certType;
	}
	/**
	 * @return 证件编号
	 */
	public String getCertID() {
		return certID;
	}
	/**
	 * @param certID 证件编号
	 */
	public void setCertID(String certID) {
		this.certID = certID;
	}
	/**
	 * @return 暂存标志（1.暂存，2.保存）
	 */
	public String getTempSaveFlag() {
		return tempSaveFlag;
	}
	/**
	 * @param tempSaveFlag 暂存标志（1.暂存，2.保存）
	 */
	public void setTempSaveFlag(String tempSaveFlag) {
		this.tempSaveFlag = tempSaveFlag;
	}
	/**
	 * @return	授信客户标志
	 */
	public String getCreditFlag(){
		return creditFlag;
	}
	/**
	 * @param creditFlag	授信客户标志
	 */
	public void setCreditFlag(String creditFlag){
		this.creditFlag = creditFlag;
	}
	/**
	 * @return 合作方客户标志
	 */
	public String getPartnerFlag(){
		return partnerFlag;
	}
	/**
	 * @param partnerFlag 合作方客户标志
	 */
	public void setPartnerFlag(String partnerFlag){
		this.partnerFlag = partnerFlag;
	}
	/**
	 * @return mgtUserID 主办客户经理
	 */
	public String getMgtUserID(){
		return  mgtUserID;
	}
	/**
	 * @param mgtUserID 主办客户经理
	 */
	public void setMgtUserID(String mgtUserID){
		this.mgtUserID = mgtUserID;
	}
	/**
	 * @return mgtOrgID 主办机构
	 */
	public String getMgtOrgID(){
		return mgtOrgID;
	}
	/**
	 * @param mgtOrgID 主办机构
	 */
	public void setMgtOrgID(String mgtOrgID){
		this.mgtOrgID = mgtOrgID;
	}
	/**
	 * @return detailCompNo 客户详情使用的组合页面编号
	 */
	public String getDetailCompNo() {
		return detailCompNo;
	}
	/**
	 * @param detailCompNo 客户详情使用的组合页面编号
	 */
	public void setDetailCompNo(String detailCompNo) {
		this.detailCompNo = detailCompNo;
	}
	/**
	 * @return 客户概况使用的detailTemplateNo模板编号
	 */
	public String getDetailTempletNo() {
		return detailTempletNo;
	}
	/**
	 * @param detailTemplateNo 客户概况使用的datawindow模板编号
	 */
	public void setDetailTempletNo(String detailTempletNo) {
		this.detailTempletNo = detailTempletNo;
	}
	
	/**
	 * @return the autoRiskScanID 客户自动风险探测时，使用的探测模型编号
	 */
	public String getAutoRiskScanID() {
		return autoRiskScanID;
	}
	/**
	 * @param autoRiskScanID 客户自动风险探测时，使用的探测模型编号
	 */
	public void setAutoRiskScanID(String autoRiskScanID) {
		this.autoRiskScanID = autoRiskScanID;
	}
	/**
	 * @return creditBelong 信用等级评估表类型
	 */
	public String getCreditBelong(){
		return creditBelong;
	}
	/**
	 * @param creditBelong 信用等级评估表类型
	 */
	public void setCreditBelong(String creditBelong){
		this.creditBelong = creditBelong;
	}
	/**
	 * @return creditLevel 本行评估即期信用等级
	 */
	public String getCreditLevel(){
		return creditLevel;
	}
	/**
	 * @param creditLevel 本行评估即期信用等级
	 */
	public void setCreditLevel(String creditLevel){
		this.creditLevel = creditLevel;
	}
	/**
	 * @return 登记日期
	 */
	public String getInputDate() {
		return inputDate;
	}
	/**
	 * @param inputDate 登记日期
	 */
	public void setInputDate(String inputDate) {
		this.inputDate = inputDate;
	}
	/**
	 * @return 登记人ID
	 */
	public String getInputUserID() {
		return inputUserID;
	}
	/**
	 * @param inputUserID 登记人ID
	 */
	public void setInputUserID(String inputUserID) {
		this.inputUserID = inputUserID;
	}
	/**
	 * @return 登记机构ID
	 */
	public String getInputOrgID() {
		return inputOrgID;
	}
	/**
	 * @param inputOrgID 登记机构ID
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
	 * 是否非小企业
	 * @return
	 */
	public boolean isLargeEnt(){
		if(this.customerType!=null && this.customerType.equalsIgnoreCase(DefaultCustomerManagerFactory.LARGE_ENT_CUSTOMERTYPE)){
			return true;
		}
		return false;
	}
//	/**
//	 * 是否小企业
//	 * @return
//	 */
//	public boolean isSmallEnt(){
//		if(this.customerType!=null && this.customerType.equalsIgnoreCase(DefaultCustomerManagerFactory.SMALL_ENT_CUSTOMERTYPE)){
//			return true;
//		}
//		return false;
//	}
	
	/**
	 * 是否个人客户
	 */
	public boolean isPersonInd(){
		if(this.customerType!=null && this.customerType.equalsIgnoreCase(DefaultCustomerManagerFactory.PERSONAL_IND_CUSTOMERTYPE)){
			return true;
		}
		return false;
	}
	
	/**
	 * 是否个体经营户
	 * @return
	 */
	public boolean isIndividulInd(){
		if(this.customerType!=null && this.customerType.equalsIgnoreCase(DefaultCustomerManagerFactory.INDIVIDUL_IND_CUSTOMERTYPE)){
			return true;
		}
		return false;
	}
	
	/**
	 * 是否农户
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
