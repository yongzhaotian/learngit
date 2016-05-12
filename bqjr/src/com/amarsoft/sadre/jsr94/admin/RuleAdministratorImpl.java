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

import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.rules.admin.LocalRuleExecutionSetProvider;
import javax.rules.admin.RuleAdministrator;
import javax.rules.admin.RuleExecutionSet;
import javax.rules.admin.RuleExecutionSetDeregistrationException;
import javax.rules.admin.RuleExecutionSetProvider;
import javax.rules.admin.RuleExecutionSetRegisterException;

import com.amarsoft.are.ARE;

 /**
 * @ RuleAdministratorImpl.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-13 上午09:41:36
 *
 * logs: 1. 
 */
public class RuleAdministratorImpl implements RuleAdministrator {
	/** rule execution sets */
	private static Map<String,RuleExecutionSet> ruleExecutionSets = Collections.synchronizedMap(new HashMap<String,RuleExecutionSet>());
	
	/**
	 * @return rule execution set names
	 */
	public static List<String> getRegistrations() {
		return new ArrayList<String>(ruleExecutionSets.keySet());
	}

	/**
	 * @param uri rule execution set name
	 * @return rule execution set
	 */
	public static RuleExecutionSetImpl lookup(String uri) {
		return (RuleExecutionSetImpl) ruleExecutionSets.get(uri);
	}
	
	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleAdministrator#deregisterRuleExecutionSet(java.lang.String, java.util.Map)
	 */
	public void deregisterRuleExecutionSet(String bindUri, Map properties)
			throws RuleExecutionSetDeregistrationException, RemoteException {
		RuleExecutionSetImpl set = (RuleExecutionSetImpl) ruleExecutionSets.remove(bindUri);
//		if (set != null)
//			set.setUri(null);
		if(set!=null){
			ARE.getLog().info("deregister RuleExecutionSet "+bindUri+" done!");
		}
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleAdministrator#getLocalRuleExecutionSetProvider(java.util.Map)
	 */
	public LocalRuleExecutionSetProvider getLocalRuleExecutionSetProvider(Map arg0)
			throws RemoteException {
		return new LocalRuleExecutionSetProviderImpl();
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleAdministrator#getRuleExecutionSetProvider(java.util.Map)
	 */
	public RuleExecutionSetProvider getRuleExecutionSetProvider(Map arg0)
			throws RemoteException {
		return new RuleExecutionSetProviderImpl();
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleAdministrator#registerRuleExecutionSet(java.lang.String, javax.rules.admin.RuleExecutionSet, java.util.Map)
	 */
	public void registerRuleExecutionSet(String bindUri, RuleExecutionSet set, Map properties) 
			throws RuleExecutionSetRegisterException, RemoteException {
		
		if (!(set instanceof RuleExecutionSetImpl)) {
			throw new RuleExecutionSetRegisterException("Wrong driver");
		} else {
//			((RuleExecutionSetImpl) set).setUri(bindUri);
			ruleExecutionSets.put(bindUri, set);		//每次都注册??
			ARE.getLog().info("register RuleExecutionSet "+bindUri+" done!");
			return;
		}

	}

}
