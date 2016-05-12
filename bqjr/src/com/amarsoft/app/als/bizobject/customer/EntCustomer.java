package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;

/**
 * @author syang
 * @since 2011-6-11
 * @describe ��˾�ͻ�
 */
public class EntCustomer extends Customer implements Serializable{
	private static final long serialVersionUID = -7024727581008648243L;
	private String corpID = null;			//��֯��������
	private String fictitiousPersonId = null;	//���˴���ͻ����
	private String fictitiousPerson = null;		//���˴�������
	private String orgNature = null;			//��������(����/�Ƿ���/��ҵ��λ)
	private String orgType = null;		//��ҵ��֯��ʽ(���ʡ����ʵ�)
	private String setupDate = null;		//��������
	private String licenseNo = null;		//Ӫҵִ�պ�
	private String licenseDate = null;		//Ӫҵִ�հ䷢����
	private String licenseMaturity = null;	//Ӫҵִ�յ�����
	private String industryType = null;		//������ҵ�������
	private String countryCode = null;		//�������
	private String regionCode = null;		//��������
	private String creditBelong = null;		//���õȼ�����ģ��
	private String creditLevel = null;		//������������
	private String financeBelong = null;		//���񱨱�ģ��
	private String taxNo = null;			//��˰��
	private String taxNo1 = null;			//��˰��
	private String officeTel = null;		//��ϵ�绰
	private String scope = null;			//��ҵ��ģ
	private int employeeNumber = 0;			//ְԱ����
	private int Totalassets = 0;			//���ʲ�
	private int Netassets = 0;				//���ʲ�
	private int Annualincome = 0;			//������
	/**
	 * @return ���ʲ�
	 */
	public int getTotalassets() {
		return Totalassets;
	}
	/**
	 * @param totalassets ���ʲ�
	 */
	public void setTotalassets(int totalassets) {
		Totalassets = totalassets;
	}
	/**
	 * @return ���ʲ�
	 */
	public int getNetassets() {
		return Netassets;
	}
	/**
	 * @param netassets ���ʲ�
	 */
	public void setNetassets(int netassets) {
		Netassets = netassets;
	}
	/**
	 * @return ������
	 */
	public int getAnnualincome() {
		return Annualincome;
	}
	/**
	 * @param annualincome ������
	 */
	public void setAnnualincome(int annualincome) {
		Annualincome = annualincome;
	}
	/**
	 * @return ��֯��������
	 */
	public String getCorpID() {
		return corpID;
	}
	/**
	 * @param corpID ��֯��������
	 */
	public void setCorpID(String corpID) {
		this.corpID = corpID;
	}
	/**
	 * @return ��������
	 */
	public String getSetupDate() {
		return setupDate;
	}
	/**
	 * @param setupDate ��������
	 */
	public void setSetupDate(String setupDate) {
		this.setupDate = setupDate;
	}
	/**
	 * @return Ӫҵִ�պ�
	 */
	public String getLicenseNo() {
		return licenseNo;
	}
	/**
	 * @param licenseNo Ӫҵִ�պ�
	 */
	public void setLicenseNo(String licenseNo) {
		this.licenseNo = licenseNo;
	}
	/**
	 * @return Ӫҵִ�հ䷢����
	 */
	public String getLicenseDate() {
		return licenseDate;
	}
	/**
	 * @param licenseDate Ӫҵִ�հ䷢����
	 */
	public void setLicenseDate(String licenseDate) {
		this.licenseDate = licenseDate;
	}
	/**
	 * @return Ӫҵִ�յ�����
	 */
	public String getLicenseMaturity() {
		return licenseMaturity;
	}
	/**
	 * @param licenseMaturity Ӫҵִ�յ�����
	 */
	public void setLicenseMaturity(String licenseMaturity) {
		this.licenseMaturity = licenseMaturity;
	}
	/**
	 * @return �������
	 */
	public String getCountryCode() {
		return countryCode;
	}
	/**
	 * @param country �������
	 */
	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}
	/**
	 * @return ������ҵ�������
	 */
	public String getIndustryType() {
		return industryType;
	}
	/**
	 * @param industryType ������ҵ�������
	 */
	public void setIndustryType(String industryType) {
		this.industryType = industryType;
	}
	/**
	 * @return ��˰��
	 */
	public String getTaxNo() {
		return taxNo;
	}
	/**
	 * @param taxNo ��˰��
	 */
	public void setTaxNo(String taxNo) {
		this.taxNo = taxNo;
	}
	/**
	 * @return ��˰��
	 */
	public String getTaxNo1() {
		return taxNo1;
	}
	/**
	 * @param taxNo1 ��˰��
	 */
	public void setTaxNo1(String taxNo1) {
		this.taxNo1 = taxNo1;
	}
	/**
	 * @return ��ҵ����
	 */
	public String getOrgType() {
		return orgType;
	}
	/**
	 * @param orgType ��ҵ����
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
