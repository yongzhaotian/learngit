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
 * @date 2011-4-13 ����09:45:26
 *
 * logs: 1. 
 */
public class RuleImpl implements Rule {

	private static final long serialVersionUID = 1L;
	
	public static final int ��������_δ֪ 		= -1;
	public static final int ��������_�������� 	= 1;
	public static final int ��������_ǰ�ù��� 	= 3;
	
	/** rule name */
	private String name;

	/** assumptions list */
	private List<Assumption> assumptions;
	
	//����������"��������":continue/break;
	private String actions;

	/** rule description */
	private String description;
	
	private String priority;
	
//	private boolean isSub;
	private int ruleType;
	//ǰ�ù�����
	private String referenceRule;
	
	///���������Ĺ�����:��Ȩ��accept/������Ȩprohibit/��Ȩ��noright
	private String decision = "";
	
	//ǰ�ù���ʵ��(��˳���¼ǰ�ù���,������ִ��)
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
	 * ���������������Ĺ�������ǰ�ù���,�ɹ�����ת��Ϊ������,�����γɹ���.
	 * @param rs
	 * @return
	 */
	public void generateRuleLink(RuleScene scene){
		generateRuleLink(scene,linkedRuleInstance);
	}
	
	public void generateRuleLink(RuleScene scene,Map<String,RuleImpl> ruleLink){
		if(!hasReferencedRule()){
			//��ǰ������ǰ�ù���,��ֹ����������
			return ;
		}
		/**modify by hwang,20130124*****ȡ������������ǰ�ù����߼�bug����,֧�ֹ������ǰ�ù���.ǰ�ù������ȼ�,����������(��ͬ���ȼ������ȼ�������ִ��,��ͬ���ȼ��������С����ִ��)***begin***/
		String referenceRuleID=getReferenceRule();
		
		if(referenceRuleID!=null && referenceRuleID.indexOf(",")>0){//�ж��ǰ�ù���
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
		/**modify by hwang,20130124*****ȡ������������ǰ�ù����߼�bug����,֧�ֹ������ǰ�ù���.ǰ�ù������ȼ�,����������(��ͬ���ȼ������ȼ�������ִ��,��ͬ���ȼ��������С����ִ��)***end***/
	}
	
	private void generateRuleLink(RuleScene scene,Map<String,RuleImpl> ruleLink,String referenceRuleID){
		if(ruleLink.containsKey(referenceRuleID)){
			//���������Ѿ�������ǰ�ù���,���γ��˹���,��ֹ��������
			String tipStr = "";
			Iterator<RuleImpl> tk = ruleLink.values().iterator();
			while(tk.hasNext()){
				RuleImpl tmp = tk.next();
				tipStr += tmp.getName() + " -> ";
			}
			ARE.getLog().warn("��ǰ�����ǰ�ù����γ��˵��ù��򻷣���������"+(tipStr.length()>=4?tipStr+referenceRuleID:""));
			
			//--���ڵ�ǰ�Ĺ���(Ϊ�����ǰ�ù�������)����˹��򻷣���˽���ǰ�Ĺ����޳�
			ruleLink.remove(this.getName());
//			ARE.getLog().info("ruleLink="+ruleLink);
			return ;
		}
		
		//ȡ�õ�ǰ�����ǰ�ù���
		RuleImpl rule = scene.getRule(referenceRuleID);
		if(rule==null){
			//ǰ�ù��򲻴���
			ARE.getLog().info("��ǰ�����ǰ�ù��򲻴���!"+referenceRuleID);
			return;
		}
		ruleLink.put(rule.getName(), rule);		//��ǰ���������������	//add at 20120210
		rule.generateRuleLink(scene, ruleLink);		//���ϱ���ǰ�ù���
	}
	
	/**
	 * �Ƿ�Ϊǰ�ù���
	 * @return
	 */
	public boolean isReference(){
		return getRuleType()==��������_ǰ�ù���;
	}
	
	/**
	 * ����ʱ����ǰ�ù���
	 * @return
	 */
	public boolean hasReferencedRule(){
		return (getReferenceRule()!=null && getReferenceRule().length()>0);
	}
	/**
	 * ������ǰ�ù�����
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
