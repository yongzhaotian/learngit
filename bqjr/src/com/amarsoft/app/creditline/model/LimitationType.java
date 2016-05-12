package com.amarsoft.app.creditline.model;

import java.io.Serializable;
import java.lang.reflect.Method;

public class LimitationType implements Serializable {
	private static final long serialVersionUID = 1L;
	private String typeID;
	private String typeName;
	private String checkerClass;
	private String limitationExpr;
	private String compileCheckExpr;
	private String controlType;
	private String objectType;
	private String crossUsageEnabled;
	private String limitationComp;
	private String limitationWizard;

	public LimitationType(){
		
	}
	
	public LimitationType(String typeID, String typeName) {
		setTypeID(typeID);
		setTypeName(typeName);
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
    
	public String getTypeID() {
		return typeID;
	}

	public void setTypeID(String typeID) {
		this.typeID = typeID;
	}

	public String getTypeName() {
		return typeName;
	}

	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}

	public String getCheckerClass() {
		return checkerClass;
	}

	public void setCheckerClass(String checkerClass) {
		this.checkerClass = checkerClass;
	}

	public String getLimitationExpr() {
		return limitationExpr;
	}

	public void setLimitationExpr(String limitationExpr) {
		this.limitationExpr = limitationExpr;
	}

	public String getCompileCheckExpr() {
		return compileCheckExpr;
	}

	public void setCompileCheckExpr(String compileCheckExpr) {
		this.compileCheckExpr = compileCheckExpr;
	}

	public String getControlType() {
		return controlType;
	}

	public void setControlType(String controlType) {
		this.controlType = controlType;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}

	public String getCrossUsageEnabled() {
		return crossUsageEnabled;
	}

	public void setCrossUsageEnabled(String crossUsageEnabled) {
		this.crossUsageEnabled = crossUsageEnabled;
	}

	public String getLimitationComp() {
		return limitationComp;
	}

	public void setLimitationComp(String limitationComp) {
		this.limitationComp = limitationComp;
	}

	public String getLimitationWizard() {
		return limitationWizard;
	}

	public void setLimitationWizard(String limitationWizard) {
		this.limitationWizard = limitationWizard;
	}

}
