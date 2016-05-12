/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2011 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.sadre.rules.aco;

import com.amarsoft.app.als.sadre.util.DateUtil;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.sadre.services.SADREConstants;

 /**
 * <p>Title: Clause.java </p>
 * <p>Description: This class represents a simple clause, composed of a name and a value.</p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-19 ����10:21:47
 *
 * logs: 1. 
 */
public class Decision implements WorkingObject{
	
	public static final int ����У��_��Ȩ���� 	= 1;
	
	public static final int ����У��_��Ȩ���� 	= 0;
	
	public static final int ����У��_δ�趨���� 	= 3;
	
	/** property decision of rule */
	private String decisionId = "";

	/** property value */
	private int decision = ����У��_δ�趨����;
	
	private String satisfiedRule = "";

	public String getSatisfiedRule() {
		return satisfiedRule;
	}

//	public void setSatisfiedRule(String satisfiedRule) {
//		this.satisfiedRule = satisfiedRule;
//	}

	/**
	 * @param rule
	 *            belong-rule id
	 */
	public Decision(String rule) {
		this.decisionId = "decision_"+rule;
//		setSatisfiedRule(rule);
//		satisfiedRule = rule;
	}
	public Decision() {
		this.decisionId = "decision_"+DateUtil.getNowTime("yyyyMMddHHmmssSSS")+StringFunction.getMathRandom();
	}
	
	public void registerSatisfiedRule(String ruleId){
		satisfiedRule = ruleId;
	}

	/**
	 * @return property name
	 */
	public final String getDecisionId() {
		return decisionId;
	}

	/**
	 * @return property value
	 */
	public final int getDecision() {
		return decision;
	}

	/**
	 * Set property value.
	 * 
	 * @param value
	 *            property value
	 */
	public final void setDecision(int value) {
		this.decision = value;
	}
	
	public final void setDecision(String value) {
		if(value.equals(SADREConstants.���붨��_��Ȩ����)){
			setDecision(����У��_��Ȩ����);
		}else if(value.equals(SADREConstants.����У��_��Ȩ����)){
			setDecision(����У��_��Ȩ����);
		}else{
			setDecision(����У��_δ�趨����);
		}
	}

	
	public String getType() {
		return "Decision";
	}
	
	public String toString(){
		return "Decision:Id="+getDecisionId()+" |decision="+getDecision();
	}

	
	public String uniqeCode() {
		return this.getClass().getName()+"@"+Integer.toHexString(this.hashCode());
	}
}
