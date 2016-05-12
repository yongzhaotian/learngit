/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2007 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.sadre.jsr94.admin;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.rules.admin.Rule;

import com.amarsoft.are.ARE;
import com.amarsoft.sadre.rules.aco.Assumption;
import com.amarsoft.sadre.rules.aco.RuleScene;

 /**
 * @ RuleImpl.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-13 上午09:45:26
 *
 * logs: 1. 
 */
public class RuleImpl implements Rule {

	private static final long serialVersionUID = 1L;
	
	public static final int 规则类型_未知 		= -1;
	public static final int 规则类型_独立规则 	= 1;
	public static final int 规则类型_前置规则 	= 3;
	
	/** rule name */
	private String name;

	/** assumptions list */
	private List<Assumption> assumptions;
	
	//条件满足后的"操作流向":continue/break;
	private String actions;

	/** rule description */
	private String description;
	
	private String priority;
	
//	private boolean isSub;
	private int ruleType;
	//前置规则编号
	private String referenceRule;
	
	///条件满足后的规则结果:授权内accept/禁批授权prohibit/授权外noright
	private String decision = "";
	
	//前置规则实例(按顺序记录前置规则,按次序执行)
	private Map<String,RuleImpl> linkedRuleInstance = new LinkedHashMap<String,RuleImpl>();
	
	/** user defined or vendor defined properties */
	private Hashtable<Object,Object> props = new Hashtable<Object,Object>();
	
	/**
	 * @param name
	 *            rule name
	 * @param description
	 *            rule description
	 * @param assumptions
	 *            assumptions list
	 */
	public RuleImpl(String name, String description, List<Assumption> assumptions) {
		this.name = name;
		this.description = description;
		this.assumptions = assumptions;
	}
	
	public RuleImpl[] getLinkedReferenceRules(){
		RuleImpl[] ruleLink = new RuleImpl[linkedRuleInstance.size()];
		return linkedRuleInstance.values().toArray(ruleLink);
	}
	
	/**
	 * 将方案下所包含的规则项下前置规则,由规则编号转换为规则链,避免形成规则环.
	 * @param rs
	 * @return
	 */
	public void generateRuleLink(RuleScene scene){
		generateRuleLink(scene,linkedRuleInstance);
	}
	
	public void generateRuleLink(RuleScene scene,Map<String,RuleImpl> ruleLink){
		if(!hasReferencedRule()){
			//当前规则无前置规则,中止遍历规则链
			return ;
		}
		/**modify by hwang,20130124*****取独立规则下属前置规则逻辑bug修正,支持关联多个前置规则.前置规则按优先级,规则编号排序(不同优先级间优先级高者先执行,相同优先级间规则编号小者先执行)***begin***/
		String referenceRuleID=getReferenceRule();
		
		if(referenceRuleID!=null && referenceRuleID.indexOf(",")>0){//有多个前置规则
			List<RuleImpl> referenceRuleList= new ArrayList<RuleImpl>();
			List<RuleImpl> sceneRuleList= scene.getRules();
			for(RuleImpl rule:sceneRuleList){
				if(referenceRuleID.indexOf(rule.getName())>=0){
					referenceRuleList.add(rule);
				}
			}
			for(RuleImpl rule:referenceRuleList){
				generateRuleLink(scene,ruleLink,rule.getName());
			}
		}else{
			generateRuleLink(scene,ruleLink,referenceRuleID);
		}
		/**modify by hwang,20130124*****取独立规则下属前置规则逻辑bug修正,支持关联多个前置规则.前置规则按优先级,规则编号排序(不同优先级间优先级高者先执行,相同优先级间规则编号小者先执行)***end***/
	}
	
	private void generateRuleLink(RuleScene scene,Map<String,RuleImpl> ruleLink,String referenceRuleID){
		if(ruleLink.containsKey(referenceRuleID)){
			//规则链中已经存在了前置规则,则形成了规则环,中止继续遍历
			String tipStr = "";
			Iterator<RuleImpl> tk = ruleLink.values().iterator();
			while(tk.hasNext()){
				RuleImpl tmp = tk.next();
				tipStr += tmp.getName() + " -> ";
			}
			ARE.getLog().warn("当前规则的前置规则形成了调用规则环！规则链："+(tipStr.length()>=4?tipStr+referenceRuleID:""));
			
			//--由于当前的规则(为最初的前置规则发起者)造成了规则环，因此将当前的规则剔除
			ruleLink.remove(this.getName());
//			ARE.getLog().info("ruleLink="+ruleLink);
			return ;
		}
		
		//取得当前规则的前置规则
		RuleImpl rule = scene.getRule(referenceRuleID);
		if(rule==null){
			//前置规则不存在
			ARE.getLog().info("当前规则的前置规则不存在!"+referenceRuleID);
			return;
		}
		ruleLink.put(rule.getName(), rule);		//当前规则纳入规则链中	//add at 20120210
		rule.generateRuleLink(scene, ruleLink);		//向上遍历前置规则
	}
	
	/**
	 * 是否为前置规则
	 * @return
	 */
	public boolean isReference(){
		return getRuleType()==规则类型_前置规则;
	}
	
	/**
	 * 项下时候有前置规则
	 * @return
	 */
	public boolean hasReferencedRule(){
		return (getReferenceRule()!=null && getReferenceRule().length()>0);
	}
	/**
	 * 关联的前置规则编号
	 * @return
	 */
	public String getReferenceRule() {
		return referenceRule;
	}
	
	public void setReferenceRule(String referenceRule) {
		this.referenceRule = referenceRule;
	}
	
	public String getDecision() {
		return decision;
	}

	public void setDecision(String decision) {
		this.decision = decision;
	}
	
	public int getRuleType() {
		return ruleType;
	}

	public void setRuleType(int ruleType) {
		this.ruleType = ruleType;
	}

	public String getPriority() {
		return priority;
	}

	public void setPriority(String priority) {
		this.priority = priority;
	}

	public String getActions() {
		return actions;
	}

	public void setActions(String actions) {
		this.actions = actions;
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.Rule#getDescription()
	 */
	public String getDescription() {
		return this.description==null?"":this.description;
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.Rule#getName()
	 */
	public String getName() {
		return this.name;
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.Rule#getProperty(java.lang.Object)
	 */
	public final Object getProperty(Object propName) {
		
		return props.get(propName);
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.Rule#setProperty(java.lang.Object, java.lang.Object)
	 */
	public final void setProperty(Object propName, Object propValue) {
		
		props.put(propName,propValue);
	}
	
	/**
	 * @return assumptions list
	 */
	public final List<Assumption> getAssumptions() {
		return assumptions;
	}
	
	public Assumption getAssumption(String dmsId){
//		ARE.getLog().info("assumptions.size()="+assumptions.size());
		for(int i=0; i<assumptions.size(); i++){
			Assumption assumption = assumptions.get(i);
//			ARE.getLog().info("Available="+assumption.isAvailable()+" null="+(assumption==null)+" string="+assumption);
			if(!assumption.isAvailable()) continue;
			
			if(assumption.belongDimension().getId().equalsIgnoreCase(dmsId)){
				return assumption;
			}
		}
		return null;
	}
	
	public String toString(){
		String strValue = "rule:name="+getName()+"|description="+getDescription()+"|actions="+getActions()+" |reference=["+getReferenceRule()+"] |assumptions="+assumptions;
		return strValue;
	}
}
