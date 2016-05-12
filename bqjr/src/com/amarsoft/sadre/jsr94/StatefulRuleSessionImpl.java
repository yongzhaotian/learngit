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
package com.amarsoft.sadre.jsr94;

import java.io.IOException;
import java.io.Writer;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.rules.Handle;
import javax.rules.InvalidHandleException;
import javax.rules.InvalidRuleSessionException;
import javax.rules.ObjectFilter;
import javax.rules.RuleExecutionSetMetadata;
import javax.rules.RuleRuntime;
import javax.rules.StatefulRuleSession;
import javax.rules.admin.Rule;
import javax.rules.admin.RuleExecutionSet;

import com.amarsoft.are.ARE;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.snap.ExecutionSnap;
import com.amarsoft.sadre.integration.RuleDataObject;
import com.amarsoft.sadre.jsr94.admin.RuleExecutionSetImpl;
import com.amarsoft.sadre.jsr94.admin.RuleImpl;
import com.amarsoft.sadre.rules.aco.Assumption;
import com.amarsoft.sadre.rules.aco.Decision;
import com.amarsoft.sadre.rules.aco.Dimension;
import com.amarsoft.sadre.rules.aco.WorkingObject;
import com.amarsoft.sadre.services.SADREConstants;

 /**
 * <p>Title: StatefulRuleSessionImpl</p>
 * <p>Description: This class is a representation of a stateful rules engine session.
 * A stateful rules engine session exposes a stateful rule execution API to an underlying rules engine.
 * The session allows arbitrary objects to be added and removed to and from the rule session state.
 * Additionally, objects currently part of the rule session state may be updated.
 *
 * There are inherently side-effects to adding objects to the rule session state.
 * The execution of a RuleExecutionSet can add, remove and update objects in the rule session state.
 * The objects in the rule session state are therefore dependent on the rules within the RuleExecutionSet as well as the
 * rule engine vendor's specific rule engine behavior.
 *
 * Handle instances are used by the rule engine vendor to track Objects added to the rule session state.
 * This allows multiple instances of equivalent Objects to be added to the session state and identified, even after serialization.
 * </p>
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-13 ����09:44:19
 *
 * logs: 1. 
 */
public class StatefulRuleSessionImpl implements StatefulRuleSession {

	private static final long serialVersionUID = 1L;
	
	/** rules */
	private RuleExecutionSetImpl ruleSet;

	/** working memory */
	private Hashtable<String,Object> workingMemory = new Hashtable<String,Object>();
	
	public StatefulRuleSessionImpl(RuleExecutionSet ruleset, Map properties) {
		this.ruleSet = (RuleExecutionSetImpl)ruleset;
	}

	/* (non-Javadoc)
	 * @see javax.rules.RuleSession#getRuleExecutionSetMetadata()
	 */
	public RuleExecutionSetMetadata getRuleExecutionSetMetadata()
			throws InvalidRuleSessionException, RemoteException {
		validateRuleSession();
		
		return new RuleExecutionSetMetadataImpl(ruleSet);
	}

	/* (non-Javadoc)
	 * @see javax.rules.RuleSession#getType()
	 */
	public int getType() throws RemoteException, InvalidRuleSessionException {
		validateRuleSession();
	    return RuleRuntime.STATEFUL_SESSION_TYPE; 
	}

	/* (non-Javadoc)
	 * @see javax.rules.RuleSession#release()
	 */
	public void release() throws RemoteException, InvalidRuleSessionException {
		validateRuleSession();
	    //-----------add at 20110930
		ExecutionSnap.getInstance().clearSnap(workingMemory);
		
		reset();
		ruleSet = null;
		workingMemory.clear();
	}

	/** 
	 * ���BOM����WorkingMemory��,���������ʱʹ�á�
	 * @see javax.rules.StatefulRuleSession#addObject(java.lang.Object)
	 */
	public Handle addObject(Object object) throws RemoteException,
			InvalidRuleSessionException {
		
		try {
			validateRuleSession();
			//--------------�жϼ���WorkingMemory�еĶ������ΪWorkingObject
			if(!(object instanceof WorkingObject)){
				ARE.getLog().error(object.getClass().getName()+" ����̳�WorkingObject�ӿ�!");
				throw new InvalidRuleSessionException(object.getClass().getName()+" ����̳�WorkingObject�ӿ�!");
			}
			
			if (object instanceof Decision){
//				workingMemory.put(((Decision) object).getName(),				//��ͬclauseͨ����������
//						((Clause) object).getValue());
				workingMemory.put(((Decision)object).getDecisionId(), object);
			
			}else {
				workingMemory.put(object.getClass().getName(), object);
				/* ������ͬ�ӿڵĶ����໥�滻
				if (!object.getClass().getName().startsWith("java.")) {		//�Զ��������Ѱ���������
					// add an entry for each super-class...
					Class c = object.getClass().getSuperclass();
					while (c != null) {
						workingMemory.put(c.getName(), object);
						c = c.getSuperclass();
					}
				}
				*/
			}
			return new HandleImpl(object);
			
		} catch (Exception ex) {
			throw new InvalidRuleSessionException("�ڲ�����", ex);
		}
	}

	/* (non-Javadoc)
	 * @see javax.rules.StatefulRuleSession#addObjects(java.util.List)
	 */
	public List<Handle> addObjects(List objList) throws RemoteException,
			InvalidRuleSessionException {
		validateRuleSession();
	    List<Handle> al = new ArrayList<Handle>();
	    Iterator it = objList.iterator();
	    while(it.hasNext())
	      al.add(
	          addObject(it.next())
	      );
	    return al;
	}

	/* (non-Javadoc)
	 * @see javax.rules.StatefulRuleSession#containsObject(javax.rules.Handle)
	 */
	public boolean containsObject(Handle objectHandle) throws RemoteException,
			InvalidRuleSessionException, InvalidHandleException {
		try {
			validateRuleSession();
			Object obj = getObject(objectHandle);
			return workingMemory.contains(obj);
			
		} catch (Exception ex) {
			throw new InvalidRuleSessionException("�ڲ�����", ex);
		}
	}

	/* (non-Javadoc)
	 * @see javax.rules.StatefulRuleSession#executeRules()
	 */
	public void executeRules() throws RemoteException,
			InvalidRuleSessionException {
//		validateRuleSession();
//		try {
//			forwardChaining(new HashSet<Rule>());
//		} catch (Exception ex) {
//			throw new InvalidRuleSessionException("�ڲ�����", ex);
//		}
		executeRules(null);
	}
	
	public void executeRules(Writer out) throws RemoteException,
		InvalidRuleSessionException {
		
		validateRuleSession();
		try {
			forwardChaining(new HashSet<Rule>(), out);
		} catch (Exception ex) {
			throw new InvalidRuleSessionException("�ڲ�����", ex);
		}
	
	}

	/* (non-Javadoc)
	 * @see javax.rules.StatefulRuleSession#getHandles()
	 */
	public List<Handle> getHandles() throws RemoteException,
			InvalidRuleSessionException {
		validateRuleSession();
		List<Handle> al = new ArrayList<Handle>();
		Enumeration<String> en = workingMemory.keys();
		Object obj = null;
		while (en.hasMoreElements())
			try {
				obj = en.nextElement();
				al.add(new HandleImpl(obj));
			} catch (Exception ex) {
				throw new InvalidRuleSessionException("�ڲ�����", ex);
			}
		return al;
	}

	/* (non-Javadoc)
	 * @see javax.rules.StatefulRuleSession#getObject(javax.rules.Handle)
	 */
	public Object getObject(Handle handle) throws RemoteException,
			InvalidHandleException, InvalidRuleSessionException {
		validateRuleSession();
		if (!(handle instanceof HandleImpl)) {
			throw new InvalidHandleException("Wrong driver");
		} else {
			HandleImpl hi = (HandleImpl) handle;
			return hi.getObject();
		}
	}

	/* (non-Javadoc)
	 * @see javax.rules.StatefulRuleSession#getObjects()
	 */
	public List<Object> getObjects() throws RemoteException,
			InvalidRuleSessionException {
		validateRuleSession();
	    return getObjects(ruleSet.resolveObjectFilter());
	}

	/* (non-Javadoc)
	 * @see javax.rules.StatefulRuleSession#getObjects(javax.rules.ObjectFilter)
	 */
	public List<Object> getObjects(ObjectFilter filter) throws RemoteException,
			InvalidRuleSessionException {
		validateRuleSession();
		List<Object> al = new ArrayList<Object>();
		Iterator<Object> it = workingMemory.values().iterator();
		Object obj = null;
		while (it.hasNext())
			try {
				obj = it.next();
				if ((obj = filter.filter(obj)) != null)
					al.add(obj);
			} catch (Exception ex) {
				throw new InvalidRuleSessionException("�ڲ�����", ex);
			}

		return al;
	}

	/* (non-Javadoc)
	 * @see javax.rules.StatefulRuleSession#removeObject(javax.rules.Handle)
	 */
	public void removeObject(Handle handleObject) throws RemoteException,
			InvalidHandleException, InvalidRuleSessionException {
		validateRuleSession();
		try {
			workingMemory.remove(getObject(handleObject));
		} catch (Exception je) {
			throw new InvalidRuleSessionException("�ڲ�����", je);
		}

	}

	/* (non-Javadoc)
	 * @see javax.rules.StatefulRuleSession#reset()
	 */
	public void reset() throws RemoteException, InvalidRuleSessionException {
		validateRuleSession();
		try {
			workingMemory.clear();
		} catch (Exception ex) {
			throw new InvalidRuleSessionException("�ڲ�����", ex);
		}

	}

	/* (non-Javadoc)
	 * @see javax.rules.StatefulRuleSession#updateObject(javax.rules.Handle, java.lang.Object)
	 */
	public void updateObject(Handle objectHandle, Object newObject) throws RemoteException,
			InvalidRuleSessionException, InvalidHandleException {
		validateRuleSession();
		try {
			Object obj = getObject(objectHandle);

			workingMemory.remove(obj);

			HandleImpl newHandle = (HandleImpl) addObject(newObject);

			((HandleImpl) objectHandle).setObject(newHandle.getObject());
		} catch (Exception je) {
			throw new InvalidHandleException("Internal error", je);
		}

	}

	/**
	 * Verify that there exixts a rule execution set.
	 */
	public final void validateRuleSession() throws InvalidRuleSessionException {
		if (ruleSet == null)
			throw new InvalidRuleSessionException("Null RuleExecutionSet");
	}
	
	private void forwardChaining(HashSet<Rule> rulesAlreadyFired, Writer out) throws SADREException {
		
		RuleImpl rule = null;
//		Assumption ast = null;
		boolean satisfyAnyRule = false;		//�����κ�һ����Ȩ����(ͨ��/�ܾ�)

		Decision decision = new Decision(this.ruleSet.getName());
//		ARE.getLog().debug("decisoin_id="+this.ruleSet.getName());
		
		for(int i=0; i<ruleSet.getRules().size(); i++) {
			rule = (RuleImpl)ruleSet.getRules().get(i);
			
			if (rulesAlreadyFired.contains(rule))		//�Ѿ�ִ�е�rule����
		        continue;
			
//			if(rule.getRuleType()==RuleImpl.��������_�ӹ���){
//				//�ӹ���������������  add at 2011-06-16
//				continue;
//			}
			if(rule.isReference()){
				//ǰ�ù��������������� at 2012-01-19
				continue;
			}
			
//			ARE.getLog().trace("У�����..("+rule.getName()+")..."+vldtPass);
			String vldtDecision = rule.getDecision();
			boolean vldtPass = validateRule(rule, out);
//			//--------����ù������º����ӹ���,�����ж����ӹ����״̬,����������������ս�� add at 20110615---------
//			if(vldtPass && rule.hasSubRules()){
//				Iterator<RuleImpl> srset = rule.getSubRuleObjs().iterator();
//				while(srset.hasNext()){
//					RuleImpl subrule = srset.next();
//					vldtPass = validateRule(subrule, out);
//					if(vldtPass){	//�ӹ���֮��Ϊ"��"��ϵ,�ڸ���������������,��һ�ӹ�������򸸹������(����_�ѡ�)
//						vldtDecision = subrule.getDecision();		//���ӹ���Ľ����Ϊ������
//						break;
//					}
//				}
//				ARE.getLog().debug(rule.getName()+" �����ӹ����жϽ��Ϊ "+vldtPass);
//			}
//			//-------- add end at the fucking 2011-06-15 22:34:42
			
			//--------����ù������º���ǰ�ù���,����Ҫ�ж���ǰ�ù����״̬,��������ǰ��������ս��  add at 2012-0119
			if(vldtPass && rule.hasReferencedRule()){
				/******modify by hwang 20130124,�޸Ķ�����������ǰ�ù����ж��߼�,ǰ�ù���֮��Ĺ�ϵΪ"��",ֻҪ��һ��ǰ�ù���ִ�н��Ϊtrue,��ö�����������ǰ�ù����жϽ��Ϊtrue*****begin***/
				boolean bRefRuleExeResult=false;//ǰ�ù���������,Ĭ��Ϊ��
				RuleImpl[] refRules = rule.getLinkedReferenceRules();
				for(int cnt=0; cnt<refRules.length; cnt++){
					bRefRuleExeResult = bRefRuleExeResult || validateRule(refRules[cnt], out);
					if(bRefRuleExeResult){		//��һǰ�ù������,��ù������
						ARE.getLog().debug("��ǰ����["+rule.getName()+"]�ĵ�"+(cnt+1)+"��ǰ�ù���["+refRules[cnt].getName()+"]����!");
						break;
					}else{
						ARE.getLog().debug("��ǰ����["+rule.getName()+"]�ĵ�"+(cnt+1)+"��ǰ�ù���["+refRules[cnt].getName()+"]������!");
					}
					ARE.getLog().debug(cnt+","+refRules.length);
				}
				ARE.getLog().debug(rule.getName()+" ����ǰ�ù����жϽ��Ϊ "+bRefRuleExeResult);
				/******modify by hwang 20130124,�޸Ķ�����������ǰ�ù����ж��߼�,ǰ�ù���֮��Ĺ�ϵΪ"��",ֻҪ��һ��ǰ�ù���ִ�н��Ϊtrue,��ö�����������ǰ�ù����жϽ��Ϊtrue*****end***/
				//�ϲ�����������ǰ�ù������н��
				vldtPass=vldtPass&&bRefRuleExeResult;
			}
			//-------- add end at the boring 2012-01-19 15:40:55, o-shit~~
			
			if(!vldtPass){			//��ͨ���������һ��ά�ȹ���У���ж�
				satisfyAnyRule = false;
				continue;
			}else{					//��������������,�жϹ��������Ƿ�Ϊ����ִ����������  add at 20110615
				if(rule.getActions().equalsIgnoreCase("continue")){
					ARE.getLog().trace("����["+rule.getName()+"]Ϊ����ִ��(continue)����.");
					satisfyAnyRule = true;
					continue;
				}
			}
			
//			decision = new Decision(rule.getName());
			//�ù�������ά��У��ͨ��,��ֵ�������Ϊ�ù涨����Ĳ���(ͨ��/�ܾ�)
			// execute all actions associated to the current rule...
//			decision.setDecision(rule.getDecision());		//�����ӹ�����Ϊ��������
			decision.setDecision(vldtDecision);
//			decision.setSatisfiedRule(rule.getName());
			decision.registerSatisfiedRule(rule.getName());		//�ش�����Ҫ���Rule
			
			satisfyAnyRule = true;
			
			break;
		}
		
		//-------------���û���κ�һ������õ�����,����򼯽��Ϊ"Ȩ����"
		if(!satisfyAnyRule){
			decision.setDecision(Decision.����У��_δ�趨����);
		}
		
		try {
			addObject(decision);			//�����������뵽WorkingMemory��
		} catch (Exception e) {
			ARE.getLog().error(e);
			throw new SADREException(e);
		}
	}
	
	/**
	 * �����Ȩ�����е�ÿ����Ȩά�����������������,���ؼ�����.
	 * @param rule
	 * @return
	 * @throws SADREException
	 */
	private boolean validateRule(RuleImpl rule, Writer out) throws SADREException{
		//-------------add Rule Runtime-Binding
		Iterator<Object> tk = workingMemory.values().iterator();
		while(tk.hasNext()){
			RuleDataObject rdo = (RuleDataObject)tk.next();
			rdo.bindingRuntimeRule(rule);
		}
		//-------------add end
		
		Assumption ast = null;
		boolean vldtPass = true;
		for(int j=0; j<rule.getAssumptions().size(); j++) {
			ast = rule.getAssumptions().get(j);
			
			//--------��������ʽxxx op xxx.xxx.xxx.xxx�е���:��Ȩά�ȱ��,������Ȩά�ȱ�Ż�ȡά��ʵ�ֶ���
			Dimension dimension = ast.belongDimension();		//��Ȩά��
			if(dimension==null){
				ARE.getLog().warn("ά��["+ast.belongDimension()+"]������!");
				continue;
			}
			
			vldtPass = ast.doValidate(workingMemory, out);
			if(vldtPass){		//ά�ȹ���У��ͨ��,����иù����е���һ��ά��У��
				continue;
			}else{				//�����д����κ�һ������������,�ù�����Ϊ������
				break;
			}
		}
		ARE.getLog().trace("У�����..("+rule.getName()+") ... "+vldtPass);

		//----------------------add at 2011-07-12 for ���Ӷ�jsp�����֧��
		try {
			if(out!=null){
				String ico="<img src=../../Resources/1/arrow.gif></img>";
				String message = "";
				if(vldtPass){
					message = "<img src=../../Resources/1/alarm/icon7.gif></img>";
					out.write("&nbsp;&nbsp;"+ico+" У�����("+rule.getName()+").. ��������("+(rule.getDecision().equalsIgnoreCase(SADREConstants.����У��_��Ȩ����)?"��Ȩ����":"��Ȩ����")+")..�������� "+message+" </p>");
					
				}else{
					message="<img src=../../Resources/1/alarm/icon10.gif></img>";
					out.write("&nbsp;&nbsp;"+ico+" У�����("+rule.getName()+").. ��������("+(rule.getDecision().equalsIgnoreCase(SADREConstants.����У��_��Ȩ����)?"��Ȩ����":"��Ȩ����")+")..�������� "+message+" </p>");
					
				}	
			}
		} catch (IOException e) {
			ARE.getLog().warn("��־��Ϣ�������!",e);
		}
		//----------------------add end
		
		return vldtPass;
	}
}
