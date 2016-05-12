package com.amarsoft.app.billions;

import java.math.BigDecimal;


/**
 * 
 * @author quliangmao
 *
 */
public class BatchMingAninsuranceVo {
	/**
	 * 客户Id
	 */
	private String customerId;
	/**
	 * 客户名称
	 */
	private String customerName;
	/**
	 * 客户身份证号码
	 */
	private String certid;
	/**
	 * 合同号
	 */
	private String contractNo;
	
	/**
	 * 注册时间
	 */
	private String registrationDate;
	
	
	/**
	 * 手机号码
	 */
	private String  mobiletelephone;
	
	/**
	 * 居住地址
	 */
	private String  familyadd;
	
	/**
	 * 邮箱地址
	 */
	private String  emailadd;
	
	/**
	 * 保费
	 */
	private BigDecimal  premium;
	
	/**
	 * 合同计划生效日
	 */
	private String  putoutdate;
	/**
	 * 投保是否成功
	 */
	private String  status;
	
	/**
	 * 1,投保 2退保
	 */
	private String  minganType;
	
	
	
	/**
	 * 贷款本金
	 */
	private String  businesssum;

	/**
	 * 民安保险返回码
	 */
	private String  retResult;
	
	/**
	 * 民安保险返回的失败原因
	 */
	private String  retrInfo;
	
	
	/**
	 * 操作时间
	 */
	private String  operateTime;
	
	
	/**
	 * 民安保险单号
	 */
	private String  policyNo;
	/**
	 * 次数
	 */
	private int  batchCount;	
	
	/**
	 * 退保时间
	 */
	private String  cancellationDate;	
	/**
	 * 退保时间
	 */
	private String  changepremium;
	
	/**
	 * 保险起期
	 */
	private String  startDate;
	/**
	 * 保险止期
	 */
	private String  endDate;
	
	/**
	 * 保险止期
	 */
	private String  insuredcertNo;
	
	/**
	 * 保险止期
	 */
	private String  createBy;
	/**
	 * 保险止期
	 */
	private String  createDate;
	/**
	 * 保险止期
	 */
	private String  updateBy;
	/**
	 * 保险止期
	 */
	private String  updateDate;
	
	/**
	 * 退保金额
	 */
	private BigDecimal changePremium;
	/**
	 * 是否犹豫期
	 */
	private String appStatus;
	
	
	public String getAppStatus() {
		return appStatus;
	}

	public void setAppStatus(String appStatus) {
		this.appStatus = appStatus;
	}

	public BigDecimal getPremium() {
		return premium;
	}

	public void setPremium(BigDecimal premium) {
		this.premium = premium;
	}

	public BigDecimal getChangePremium() {
		return changePremium;
	}

	public void setChangePremium(BigDecimal changePremium) {
		this.changePremium = changePremium;
	}

	public String getCreateBy() {
		return createBy;
	}

	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getUpdateBy() {
		return updateBy;
	}

	public void setUpdateBy(String updateBy) {
		this.updateBy = updateBy;
	}

	public String getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}

	public int getBatchCount() {
		return batchCount;
	}

	public void setBatchCount(int batchCount) {
		this.batchCount = batchCount;
	}

	public String getInsuredcertNo() {
		return insuredcertNo;
	}

	public void setInsuredcertNo(String insuredcertNo) {
		this.insuredcertNo = insuredcertNo;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getChangepremium() {
		return changepremium;
	}

	public void setChangepremium(String changepremium) {
		this.changepremium = changepremium;
	}

	public String getCancellationDate() {
		return cancellationDate;
	}

	public void setCancellationDate(String cancellationDate) {
		this.cancellationDate = cancellationDate;
	}


	public String getPolicyNo() {
		return policyNo;
	}

	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}

	public String getOperateTime() {
		return operateTime;
	}

	public void setOperateTime(String operateTime) {
		this.operateTime = operateTime;
	}

	public String getBusinesssum() {
		return businesssum;
	}

	public String getRetResult() {
		return retResult;
	}

	public void setRetResult(String retResult) {
		this.retResult = retResult;
	}

	public String getRetrInfo() {
		return retrInfo;
	}

	public void setRetrInfo(String retrInfo) {
		this.retrInfo = retrInfo;
	}

	public void setBusinesssum(String businesssum) {
		this.businesssum = businesssum;
	}



	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getMinganType() {
		return minganType;
	}

	public void setMinganType(String minganType) {
		this.minganType = minganType;
	}

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getCertid() {
		return certid;
	}

	public void setCertid(String certid) {
		this.certid = certid;
	}

	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}

	public String getRegistrationDate() {
		return registrationDate;
	}

	public void setRegistrationDate(String registrationDate) {
		this.registrationDate = registrationDate;
	}

	public String getMobiletelephone() {
		return mobiletelephone;
	}

	public void setMobiletelephone(String mobiletelephone) {
		this.mobiletelephone = mobiletelephone;
	}

	public String getFamilyadd() {
		return familyadd;
	}

	public void setFamilyadd(String familyadd) {
		this.familyadd = familyadd;
	}

	public String getEmailadd() {
		return emailadd;
	}

	public void setEmailadd(String emailadd) {
		this.emailadd = emailadd;
	}



	public String getPutoutdate() {
		return putoutdate;
	}

	public void setPutoutdate(String putoutdate) {
		this.putoutdate = putoutdate;
	}
	
	
}
