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

import java.io.IOException;
import java.io.Serializable;
import java.net.URL;
import java.net.URLConnection;
import java.rmi.RemoteException;
import java.util.Map;

import javax.rules.admin.RuleExecutionSet;
import javax.rules.admin.RuleExecutionSetCreateException;
import javax.rules.admin.RuleExecutionSetProvider;

import org.w3c.dom.Element;

 /**
 * @ RuleExecutionSetProviderImpl.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-13 ÉÏÎç09:42:52
 *
 * logs: 1. 
 */
public class RuleExecutionSetProviderImpl implements RuleExecutionSetProvider {

	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleExecutionSetProvider#createRuleExecutionSet(org.w3c.dom.Element, java.util.Map)
	 */
	public RuleExecutionSet createRuleExecutionSet(Element docElement, Map properties)
			throws RuleExecutionSetCreateException, RemoteException {
		
		return (new LocalRuleExecutionSetProviderImpl()).createRuleExecutionSet(docElement, properties);
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleExecutionSetProvider#createRuleExecutionSet(java.io.Serializable, java.util.Map)
	 */
	public RuleExecutionSet createRuleExecutionSet(Serializable arg0, Map arg1)
			throws RuleExecutionSetCreateException, RemoteException {
		
		throw new RuleExecutionSetCreateException("Operation not supported");
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleExecutionSetProvider#createRuleExecutionSet(java.lang.String, java.util.Map)
	 */
	public RuleExecutionSet createRuleExecutionSet(String uri, Map properties)
			throws RuleExecutionSetCreateException, IOException,
			RemoteException {
		
		URLConnection urlc = (new URL(uri)).openConnection();
	    java.io.InputStream is = urlc.getInputStream();
	    return (new LocalRuleExecutionSetProviderImpl()).createRuleExecutionSet(is, properties);
	}

}
