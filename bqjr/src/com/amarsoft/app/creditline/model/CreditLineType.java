package com.amarsoft.app.creditline.model;

import java.io.Serializable;
import java.lang.reflect.Method;

public class CreditLineType implements Serializable {
	private static final long serialVersionUID = 1L;
	private String clTypeID;
	private String clTypeName;
	private String clKeeperClass;
	private String line1BalExpr;
	private String line2BalExpr;
	private String line3BalExpr;
	private String checkExpr;
	private String effStatus;
	private String circulatable;
	private String beneficialType;
	private String creationWizard;
	private String doNo;
	private String overviewComp;
	private String currencyMode;
	private String approvalPolicy;
	private String contractFlag;
	private String subContractFlag;
	private String defaultLimitation;
	
	//添加3个参数
	private String LineSum1;
	private String LineSum2;
	private String LineSum3;
	
	public CreditLineType(){
		
	}
	
	public CreditLineType(String clTypeID, String clTypeName) {
		setClTypeID(clTypeID);
		setClTypeName(clTypeName);
	}
	
	/**
	 * @param sKey 属性名
	 * @return 属性值
	 * @throws Exception
	 */
    public Object getAttribute(String sKey)throws Exception{
    	String m = "get" + sKey.substring(0, 1).toUpperCase() + sKey.substring(1);
    	Method method = this.getClass().getMethod(m);
        return method.invoke(this);
    }

	public String getClTypeID() {
		return clTypeID;
	}

	public void setClTypeID(String clTypeID) {
		this.clTypeID = clTypeID;
	}

	public String getClTypeName() {
		return clTypeName;
	}

	public void setClTypeName(String clTypeName) {
		this.clTypeName = clTypeName;
	}

	public String getClKeeperClass() {
		return clKeeperClass;
	}

	public void setClKeeperClass(String clKeeperClass) {
		this.clKeeperClass = clKeeperClass;
	}

	public String getLine1BalExpr() {
		return line1BalExpr;
	}

	public void setLine1BalExpr(String line1BalExpr) {
		this.line1BalExpr = line1BalExpr;
	}

	public String getLine2BalExpr() {
		return line2BalExpr;
	}

	public void setLine2BalExpr(String line2BalExpr) {
		this.line2BalExpr = line2BalExpr;
	}

	public String getLine3BalExpr() {
		return line3BalExpr;
	}

	public void setLine3BalExpr(String line3BalExpr) {
		this.line3BalExpr = line3BalExpr;
	}

	public String getCheckExpr() {
		return checkExpr;
	}

	public void setCheckExpr(String checkExpr) {
		this.checkExpr = checkExpr;
	}

	public String getEffStatus() {
		return effStatus;
	}

	public void setEffStatus(String effStatus) {
		this.effStatus = effStatus;
	}

	public String getCirculatable() {
		return circulatable;
	}

	public void setCirculatable(String circulatable) {
		this.circulatable = circulatable;
	}

	public String getBeneficialType() {
		return beneficialType;
	}

	public void setBeneficialType(String beneficialType) {
		this.beneficialType = beneficialType;
	}

	public String getCreationWizard() {
		return creationWizard;
	}

	public void setCreationWizard(String creationWizard) {
		this.creationWizard = creationWizard;
	}

	public String getDoNo() {
		return doNo;
	}

	public void setDoNo(String doNo) {
		this.doNo = doNo;
	}

	public String getOverviewComp() {
		return overviewComp;
	}

	public void setOverviewComp(String overviewComp) {
		this.overviewComp = overviewComp;
	}

	public String getCurrencyMode() {
		return currencyMode;
	}

	public void setCurrencyMode(String currencyMode) {
		this.currencyMode = currencyMode;
	}

	public String getApprovalPolicy() {
		return approvalPolicy;
	}

	public void setApprovalPolicy(String approvalPolicy) {
		this.approvalPolicy = approvalPolicy;
	}

	public String getContractFlag() {
		return contractFlag;
	}

	public void setContractFlag(String contractFlag) {
		this.contractFlag = contractFlag;
	}

	public String getSubContractFlag() {
		return subContractFlag;
	}

	public void setSubContractFlag(String subContractFlag) {
		this.subContractFlag = subContractFlag;
	}

	public String getDefaultLimitation() {
		return defaultLimitation;
	}

	public void setDefaultLimitation(String defaultLimitation) {
		this.defaultLimitation = defaultLimitation;
	}

	public String getLineSum1() {
		return LineSum1;
	}

	public void setLineSum1(String lineSum1) {
		LineSum1 = lineSum1;
	}

	public String getLineSum2() {
		return LineSum2;
	}

	public void setLineSum2(String lineSum2) {
		LineSum2 = lineSum2;
	}

	public String getLineSum3() {
		return LineSum3;
	}

	public void setLineSum3(String lineSum3) {
		LineSum3 = lineSum3;
	}

}
