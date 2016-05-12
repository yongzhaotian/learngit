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

import javax.rules.ConfigurationException;
import javax.rules.RuleRuntime;
import javax.rules.RuleServiceProvider;
import javax.rules.RuleServiceProviderManager;
import javax.rules.admin.RuleAdministrator;

 /**
 * @ RuleServiceProviderImpl.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-13 ÉÏÎç09:43:58
 *
 * logs: 1. 
 */
public class RuleServiceProviderImpl extends RuleServiceProvider {
	
	static {
		try {
			RuleServiceProviderManager.registerRuleServiceProvider("com.amarsoft.sadre.jsr94", RuleServiceProviderImpl.class);
		} catch (ConfigurationException ce) {
			ce.printStackTrace();
		}
	}

	/* (non-Javadoc)
	 * @see javax.rules.RuleServiceProvider#getRuleAdministrator()
	 */
	public RuleAdministrator getRuleAdministrator()
			throws ConfigurationException {
		try {
			return (RuleAdministrator) createInstance("com.amarsoft.sadre.jsr94.admin.RuleAdministratorImpl");
		} catch (Exception ex) {
			throw new ConfigurationException("Can't create RuleAdministrator", ex);
		}
	}

	/* (non-Javadoc)
	 * @see javax.rules.RuleServiceProvider#getRuleRuntime()
	 */
	public RuleRuntime getRuleRuntime() throws ConfigurationException {
		try {
			return (RuleRuntime) createInstance("com.amarsoft.sadre.jsr94.RuleRuntimeImpl");
		} catch (Exception ex) {
			throw new ConfigurationException("Can't create RuleRuntime", ex);
		}
	}

}
