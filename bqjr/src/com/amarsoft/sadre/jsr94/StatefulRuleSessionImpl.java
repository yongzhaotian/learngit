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
 * @date 2011-4-13 上午09:44:19
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
	 * 添加BOM对象到WorkingMemory中,供规则计算时使用。
	 * @see javax.rules.StatefulRuleSession#addObject(java.lang.Object)
	 */
	public Handle addObject(Object object) throws RemoteException,
			InvalidRuleSessionException {
		
		try {
			validateRuleSession();
			//--------------判断加入WorkingMemory中的对象必须为WorkingObject
			if(!(object instanceof WorkingObject)){
				ARE.getLog().error(object.getClass().getName()+" 必须继承WorkingObject接口!");
				throw new InvalidRuleSessionException(object.getClass().getName()+" 必须继承WorkingObject接口!");
			}
			
			if (object instanceof Decision){
//				workingMemory.put(((Decision) object).getName(),				//不同clause通过名称区分
//						((Clause) object).getValue());
				workingMemory.put(((Decision)object).getDecisionId(), object);
			
			}else {
				workingMemory.put(object.getClass().getName(), object);
				/* 避免相同接口的对象相互替换
				if (!object.getClass().getName().startsWith("java.")) {		//自定义对象逐步寻求其根对象
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
			throw new InvalidRuleSessionException("内部错误", ex);
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
			throw new InvalidRuleSessionException("内部错误", ex);
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
//			throw new InvalidRuleSessionException("内部错误", ex);
//		}
		executeRules(null);
	}
	
	public void executeRules(Writer out) throws RemoteException,
		InvalidRuleSessionException {
		
		validateRuleSession();
		try {
			forwardChaining(new HashSet<Rule>(), out);
		} catch (Exception ex) {
			throw new InvalidRuleSessionException("内部错误", ex);
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
				throw new InvalidRuleSessionException("内部错误", ex);
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
				throw new InvalidRuleSessionException("内部错误", ex);
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
			throw new InvalidRuleSessionException("内部错误", je);
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
			throw new InvalidRuleSessionException("内部错误", ex);
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
		boolean satisfyAnyRule = false;		//满足任何一条授权规则(通过/拒绝)

		Decision decision = new Decision(this.ruleSet.getName());
//		ARE.getLog().debug("decisoin_id="+this.ruleSet.getName());
		
		for(int i=0; i<ruleSet.getRules().size(); i++) {
			rule = (RuleImpl)ruleSet.getRules().get(i);
			
			if (rulesAlreadyFired.contains(rule))		//已经执行的rule跳过
		        continue;
			
//			if(rule.getRuleType()==RuleImpl.规则类型_子规则){
//				//子规则自身不独立运行  add at 2011-06-16
//				continue;
//			}
			if(rule.isReference()){
				//前置规则自身不独立运行 at 2012-01-19
				continue;
			}
			
//			ARE.getLog().trace("校验规则..("+rule.getName()+")..."+vldtPass);
			String vldtDecision = rule.getDecision();
			boolean vldtPass = validateRule(rule, out);
//			//--------如果该规则项下含有子规则,则需判断其子规则的状态,来决定父规则的最终结果 add at 20110615---------
//			if(vldtPass && rule.hasSubRules()){
//				Iterator<RuleImpl> srset = rule.getSubRuleObjs().iterator();
//				while(srset.hasNext()){
//					RuleImpl subrule = srset.next();
//					vldtPass = validateRule(subrule, out);
//					if(vldtPass){	//子规则之间为"或"关系,在父规则成立的情况下,任一子规则成立则父规则成立(ˇ⊙_⊙ˇ)
//						vldtDecision = subrule.getDecision();		//以子规则的结果作为父类结果
//						break;
//					}
//				}
//				ARE.getLog().debug(rule.getName()+" 项下子规则判断结果为 "+vldtPass);
//			}
//			//-------- add end at the fucking 2011-06-15 22:34:42
			
			//--------如果该规则项下含有前置规则,则需要判断其前置规则的状态,来决定当前规则的最终结果  add at 2012-0119
			if(vldtPass && rule.hasReferencedRule()){
				/******modify by hwang 20130124,修改独立规则项下前置规则判断逻辑,前置规则之间的关系为"或",只要有一条前置规则执行结果为true,则该独立规则项下前置规则判断结果为true*****begin***/
				boolean bRefRuleExeResult=false;//前置规则允许结果,默认为否
				RuleImpl[] refRules = rule.getLinkedReferenceRules();
				for(int cnt=0; cnt<refRules.length; cnt++){
					bRefRuleExeResult = bRefRuleExeResult || validateRule(refRules[cnt], out);
					if(bRefRuleExeResult){		//任一前置规则成立,则该规则成立
						ARE.getLog().debug("当前规则["+rule.getName()+"]的第"+(cnt+1)+"条前置规则["+refRules[cnt].getName()+"]成立!");
						break;
					}else{
						ARE.getLog().debug("当前规则["+rule.getName()+"]的第"+(cnt+1)+"条前置规则["+refRules[cnt].getName()+"]不成立!");
					}
					ARE.getLog().debug(cnt+","+refRules.length);
				}
				ARE.getLog().debug(rule.getName()+" 项下前置规则判断结果为 "+bRefRuleExeResult);
				/******modify by hwang 20130124,修改独立规则项下前置规则判断逻辑,前置规则之间的关系为"或",只要有一条前置规则执行结果为true,则该独立规则项下前置规则判断结果为true*****end***/
				//合并独立规则与前置规则运行结果
				vldtPass=vldtPass&&bRefRuleExeResult;
			}
			//-------- add end at the boring 2012-01-19 15:40:55, o-shit~~
			
			if(!vldtPass){			//不通过则进行下一条维度规则校验判断
				satisfyAnyRule = false;
				continue;
			}else{					//规则满足条件下,判断规则流向是否为继续执行其他规则  add at 20110615
				if(rule.getActions().equalsIgnoreCase("continue")){
					ARE.getLog().trace("规则["+rule.getName()+"]为继续执行(continue)规则.");
					satisfyAnyRule = true;
					continue;
				}
			}
			
//			decision = new Decision(rule.getName());
			//该规则所有维度校验通过,赋值结果对象为该规定定义的操作(通过/拒绝)
			// execute all actions associated to the current rule...
//			decision.setDecision(rule.getDecision());		//引入子规则后改为变量引用
			decision.setDecision(vldtDecision);
//			decision.setSatisfiedRule(rule.getName());
			decision.registerSatisfiedRule(rule.getName());		//回传满足要求的Rule
			
			satisfyAnyRule = true;
			
			break;
		}
		
		//-------------如果没有任何一条规则得到满足,则规则集结果为"权限外"
		if(!satisfyAnyRule){
			decision.setDecision(Decision.规则校验_未设定规则);
		}
		
		try {
			addObject(decision);			//将结果对象放入到WorkingMemory中
		} catch (Exception e) {
			ARE.getLog().error(e);
			throw new SADREException(e);
		}
	}
	
	/**
	 * 针对授权规则中的每个授权维度条件逐个解析计算,返回计算结果.
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
			
			//--------拆解规则表达式xxx op xxx.xxx.xxx.xxx中的左部:授权维度编号,根据授权维度编号获取维度实现对象
			Dimension dimension = ast.belongDimension();		//授权维度
			if(dimension==null){
				ARE.getLog().warn("维度["+ast.belongDimension()+"]不存在!");
				continue;
			}
			
			vldtPass = ast.doValidate(workingMemory, out);
			if(vldtPass){		//维度规则校验通过,则进行该规则中的下一条维度校验
				continue;
			}else{				//规则集中存在任何一条不满足条件,该规则视为不满足
				break;
			}
		}
		ARE.getLog().trace("校验规则..("+rule.getName()+") ... "+vldtPass);

		//----------------------add at 2011-07-12 for 增加对jsp输出的支持
		try {
			if(out!=null){
				String ico="<img src=../../Resources/1/arrow.gif></img>";
				String message = "";
				if(vldtPass){
					message = "<img src=../../Resources/1/alarm/icon7.gif></img>";
					out.write("&nbsp;&nbsp;"+ico+" 校验规则("+rule.getName()+").. 规则类型("+(rule.getDecision().equalsIgnoreCase(SADREConstants.规则校验_无权规则)?"无权规则":"有权规则")+")..规则结果： "+message+" </p>");
					
				}else{
					message="<img src=../../Resources/1/alarm/icon10.gif></img>";
					out.write("&nbsp;&nbsp;"+ico+" 校验规则("+rule.getName()+").. 规则类型("+(rule.getDecision().equalsIgnoreCase(SADREConstants.规则校验_无权规则)?"无权规则":"有权规则")+")..规则结果： "+message+" </p>");
					
				}	
			}
		} catch (IOException e) {
			ARE.getLog().warn("日志信息输出有误!",e);
		}
		//----------------------add end
		
		return vldtPass;
	}
}
