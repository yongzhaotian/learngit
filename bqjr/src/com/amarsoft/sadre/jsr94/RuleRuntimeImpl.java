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

import java.rmi.RemoteException;
import java.util.List;
import java.util.Map;

import javax.rules.RuleExecutionSetNotFoundException;
import javax.rules.RuleRuntime;
import javax.rules.RuleSession;
import javax.rules.RuleSessionCreateException;
import javax.rules.RuleSessionTypeUnsupportedException;
import javax.rules.admin.RuleExecutionSet;

import com.amarsoft.sadre.jsr94.admin.RuleAdministratorImpl;

 /**
 * @ RuleRuntimeImpl.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-13 ÉÏÎç09:43:13
 *
 * logs: 1. 
 */
public class RuleRuntimeImpl implements RuleRuntime {

	private static final long serialVersionUID = 1L;

	/* (non-Javadoc)
	 * @see javax.rules.RuleRuntime#createRuleSession(java.lang.String, java.util.Map, int)
	 */
	public RuleSession createRuleSession(String uri, Map properties, int ruleSessionType)
			throws RuleSessionTypeUnsupportedException,
			RuleSessionCreateException, RuleExecutionSetNotFoundException,
			RemoteException {
		
		RuleExecutionSet res = RuleAdministratorImpl.lookup(uri);
		if (res == null)
			throw new RuleExecutionSetNotFoundException(uri);
		
		switch (ruleSessionType) {
			case RuleRuntime.STATELESS_SESSION_TYPE:
				return new StatelessRuleSessionImpl(res, properties);
			case RuleRuntime.STATEFUL_SESSION_TYPE:
				return new StatefulRuleSessionImpl(res, properties);
		}
		
		String message = String.valueOf(ruleSessionType);
		throw new RuleSessionTypeUnsupportedException(message);
	}

	/* (non-Javadoc)
	 * @see javax.rules.RuleRuntime#getRegistrations()
	 */
	public List getRegistrations() throws RemoteException {
		
		return RuleAdministratorImpl.getRegistrations();
	}

}
