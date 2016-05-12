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

import java.io.Writer;
import java.rmi.RemoteException;
import java.util.List;
import java.util.Map;

import javax.rules.InvalidRuleSessionException;
import javax.rules.ObjectFilter;
import javax.rules.RuleExecutionSetMetadata;
import javax.rules.RuleRuntime;
import javax.rules.StatelessRuleSession;
import javax.rules.admin.RuleExecutionSet;

import com.amarsoft.sadre.jsr94.admin.RuleExecutionSetImpl;

 /**
 * @ StatelessRuleSessionImpl.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-13 ÉÏÎç09:44:35
 *
 * logs: 1. 
 */
public class StatelessRuleSessionImpl implements StatelessRuleSession {
	
	/** stateful session */
	private StatefulRuleSessionImpl session;

	/** rules */
	private RuleExecutionSetImpl ruleSet;

	public StatelessRuleSessionImpl(RuleExecutionSet res, Map properties) {
		session = new StatefulRuleSessionImpl(res, properties);
		this.ruleSet = (RuleExecutionSetImpl)res;
	}

	/* (non-Javadoc)
	 * @see javax.rules.RuleSession#getRuleExecutionSetMetadata()
	 */
	public RuleExecutionSetMetadata getRuleExecutionSetMetadata()
			throws InvalidRuleSessionException, RemoteException {
		
		return session.getRuleExecutionSetMetadata();
	}

	/* (non-Javadoc)
	 * @see javax.rules.RuleSession#getType()
	 */
	public int getType() throws RemoteException, InvalidRuleSessionException {
		session.validateRuleSession();
	    return RuleRuntime.STATELESS_SESSION_TYPE;
	}

	/* (non-Javadoc)
	 * @see javax.rules.RuleSession#release()
	 */
	public void release() throws RemoteException, InvalidRuleSessionException {
		session.release();
	    session = null;
	}

	/* (non-Javadoc)
	 * @see javax.rules.StatelessRuleSession#executeRules(java.util.List)
	 */
	public List executeRules(List objects) throws InvalidRuleSessionException,
			RemoteException {
		
		return executeRules(objects, ruleSet.resolveObjectFilter());
	}
	
	public List executeRules(List objects,Writer out) throws InvalidRuleSessionException,
			RemoteException {
		
		return executeRules(objects, ruleSet.resolveObjectFilter(), out);
	}

	/* (non-Javadoc)
	 * @see javax.rules.StatelessRuleSession#executeRules(java.util.List, javax.rules.ObjectFilter)
	 */
	public List executeRules(List objects, ObjectFilter filter)
			throws InvalidRuleSessionException, RemoteException {
//		session.reset();
//	    session.addObjects(objects);
//	    session.executeRules();
//	    return session.getObjects(filter);
		return executeRules(objects, filter, null);
	}
	
	public List executeRules(List objects, ObjectFilter filter, Writer out)
			throws InvalidRuleSessionException, RemoteException {
		session.reset();
	    session.addObjects(objects);
	    session.executeRules(out);
	    return session.getObjects(filter);
	}

}
