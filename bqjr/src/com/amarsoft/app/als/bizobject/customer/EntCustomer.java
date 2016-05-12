package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;

/**
 * @author syang
 * @since 2011-6-11
 * @describe 公司客户
 */
public class EntCustomer extends Customer implements Serializable{
	private static final long serialVersionUID = -7024727581008648243L;
	private String corpID = null;			//组织机构代码
	private String fictitiousPersonId = null;	//法人代表客户编号
	private String fictitiousPerson = null;		//法人代表名称
	private String orgNature = null;			//机构类型(法人/非法人/事业单位)
	private String orgType = null;		//企业组织形式(内资、外资等)
	private String setupDate = null;		//成立日期
	private String licenseNo = null;		//营业执照号
	private String licenseDate = null;		//营业执照颁发日期
	private String licenseMaturity = null;	//营业执照到期日
	private String industryType = null;		//国标行业分类代码
	private String countryCode = null;		//国别代码
	private String regionCode = null;		//行政区划
	private String creditBelong = null;		//信用等级评估模板
	private String creditLevel = null;		//即期信用评级
	private String financeBelong = null;		//财务报表模型
	private String taxNo = null;			//地税号
	private String taxNo1 = null;			//国税号
	private String officeTel = null;		//联系电话
	private String scope = null;			//企业规模
	private int employeeNumber = 0;			//职员人数
	private int Totalassets = 0;			//总资产
	private int Netassets = 0;				//净资产
	private int Annualincome = 0;			//年收入
	/**
	 * @return 总资产
	 */
	public int getTotalassets() {
		return Totalassets;
	}
	/**
	 * @param totalassets 总资产
	 */
	public void setTotalassets(int totalassets) {
		Totalassets = totalassets;
	}
	/**
	 * @return 净资产
	 */
	public int getNetassets() {
		return Netassets;
	}
	/**
	 * @param netassets 净资产
	 */
	public void setNetassets(int netassets) {
		Netassets = netassets;
	}
	/**
	 * @return 年收入
	 */
	public int getAnnualincome() {
		return Annualincome;
	}
	/**
	 * @param annualincome 年收入
	 */
	public void setAnnualincome(int annualincome) {
		Annualincome = annualincome;
	}
	/**
	 * @return 组织机构代码
	 */
	public String getCorpID() {
		return corpID;
	}
	/**
	 * @param corpID 组织机构代码
	 */
	public void setCorpID(String corpID) {
		this.corpID = corpID;
	}
	/**
	 * @return 成立日期
	 */
	public String getSetupDate() {
		return setupDate;
	}
	/**
	 * @param setupDate 成立日期
	 */
	public void setSetupDate(String setupDate) {
		this.setupDate = setupDate;
	}
	/**
	 * @return 营业执照号
	 */
	public String getLicenseNo() {
		return licenseNo;
	}
	/**
	 * @param licenseNo 营业执照号
	 */
	public void setLicenseNo(String licenseNo) {
		this.licenseNo = licenseNo;
	}
	/**
	 * @return 营业执照颁发日期
	 */
	public String getLicenseDate() {
		return licenseDate;
	}
	/**
	 * @param licenseDate 营业执照颁发日期
	 */
	public void setLicenseDate(String licenseDate) {
		this.licenseDate = licenseDate;
	}
	/**
	 * @return 营业执照到期日
	 */
	public String getLicenseMaturity() {
		return licenseMaturity;
	}
	/**
	 * @param licenseMaturity 营业执照到期日
	 */
	public void setLicenseMaturity(String licenseMaturity) {
		this.licenseMaturity = licenseMaturity;
	}
	/**
	 * @return 国别代码
	 */
	public String getCountryCode() {
		return countryCode;
	}
	/**
	 * @param country 国别代码
	 */
	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}
	/**
	 * @return 国标行业分类代码
	 */
	public String getIndustryType() {
		return industryType;
	}
	/**
	 * @param industryType 国标行业分类代码
	 */
	public void setIndustryType(String industryType) {
		this.industryType = industryType;
	}
	/**
	 * @return 地税号
	 */
	public String getTaxNo() {
		return taxNo;
	}
	/**
	 * @param taxNo 地税号
	 */
	public void setTaxNo(String taxNo) {
		this.taxNo = taxNo;
	}
	/**
	 * @return 国税号
	 */
	public String getTaxNo1() {
		return taxNo1;
	}
	/**
	 * @param taxNo1 国税号
	 */
	public void setTaxNo1(String taxNo1) {
		this.taxNo1 = taxNo1;
	}
	/**
	 * @return 企业类型
	 */
	public String getOrgType() {
		return orgType;
	}
	/**
	 * @param orgType 企业类型
	 */
	public void setOrgType(String orgType) {
		this.orgType = orgType;
	}
	
	public String getFictitiousPersonId() {
		return fictitiousPersonId;
	}
	public void setFictitiousPersonId(String fictitiousPersonId) {
		this.fictitiousPersonId = fictitiousPersonId;
	}
	public String getFictitiousPerson() {
		return fictitiousPerson;
	}
	public void setFictitiousPerson(String fictitiousPerson) {
		this.fictitiousPerson = fictitiousPerson;
	}
	public String getOrgNature() {
		return orgNature;
	}
	public void setOrgNature(String orgNature) {
		this.orgNature = orgNature;
	}
	public String getRegionCode() {
		return regionCode;
	}
	public void setRegionCode(String regionCode) {
		this.regionCode = regionCode;
	}
	public String getCreditBelong() {
		return creditBelong;
	}
	public void setCreditBelong(String creditBelong) {
		this.creditBelong = creditBelong;
	}
	public String getCreditLevel() {
		return creditLevel;
	}
	public void setCreditLevel(String creditLevel) {
		this.creditLevel = creditLevel;
	}
	public String getFinanceBelong() {
		return financeBelong;
	}
	public void setFinanceBelong(String financeBelong) {
		this.financeBelong = financeBelong;
	}
	public void setOfficeTel(String officeTel) {
		this.officeTel = officeTel;
	}
	public String getOfficeTel() {
		return officeTel;
	}
	public void setEmployeeNumber(int employeeNumber) {
		this.employeeNumber = employeeNumber;
	}
	public int getEmployeeNumber() {
		return employeeNumber;
	}
	public void setScope(String scope) {
		this.scope = scope;
	}
	public String getScope() {
		return scope;
	}
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("EntCustomer [corpID=");
		builder.append(corpID);
		builder.append(", setupDate=");
		builder.append(setupDate);
		builder.append(", licenseNo=");
		builder.append(licenseNo);
		builder.append(", licenseDate=");
		builder.append(licenseDate);
		builder.append(", licenseMaturity=");
		builder.append(licenseMaturity);
		builder.append(", country=");
		builder.append(countryCode);
		builder.append(", industryType=");
		builder.append(industryType);
		builder.append(", loancardNo=");
		builder.append(loancardNo);
		builder.append(", taxNo=");
		builder.append(taxNo);
		builder.append(", taxNo1=");
		builder.append(taxNo1);
		builder.append(", customerID=");
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
		builder.append(", scope=");
		builder.append("scope");
		builder.append(", tempSaveFlag=");
		builder.append(tempSaveFlag);
		builder.append(", detailTempletNo=");
		builder.append(detailTempletNo);
		builder.append(", detailCompNo=");
		builder.append(detailCompNo);
		builder.append(", baseInfoTreeNo=");
		builder.append(baseInfoTreeNo);
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
