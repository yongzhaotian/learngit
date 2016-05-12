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
import java.util.List;

import javax.rules.InvalidRuleSessionException;
import javax.rules.ObjectFilter;
import javax.rules.admin.Rule;
import javax.rules.admin.RuleExecutionSet;

import com.amarsoft.sadre.jsr94.ObjectFilterImpl;

 /**
 * @ RuleExecutionSetImpl.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-13 ÉÏÎç09:41:56
 *
 * logs: 1. 
 */
//public class RuleExecutionSetImpl extends Hashtable implements RuleExecutionSet {
public class RuleExecutionSetImpl implements RuleExecutionSet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/** rule execution set name */
	private String name;

	/** rule execution set description */
	private String description;

	/** rule execution set URI */
	private String uri;

	/** rule filter */
	private String filter;

	/** rules */
	private List<Rule> rules = new ArrayList<Rule>();

	/** user defined or vendor defined properties */
	private Hashtable<Object,Object> props = new Hashtable<Object,Object>();

	/**
	 * Create the rule execution set.
	 * 
	 * @param name
	 *            rule execution set name
	 * @param description
	 *            rule execution set description
	 * @param uri
	 *            rule execution set URI
	 */
	RuleExecutionSetImpl(String name, String description, String uri) {
		this.name = name;
		this.description = description;
		this.uri = uri;
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleExecutionSet#getDefaultObjectFilter()
	 */
	public String getDefaultObjectFilter() {
		
		return this.filter;
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleExecutionSet#getDescription()
	 */
	public String getDescription() {
		
		return this.description;
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleExecutionSet#getName()
	 */
	public String getName() {
		
		return this.name;
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleExecutionSet#getProperty(java.lang.Object)
	 */
	public Object getProperty(Object propName) {
		
		return this.props.get(propName);
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleExecutionSet#getRules()
	 */
	public List<Rule> getRules() {
		
		return this.rules;
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleExecutionSet#setDefaultObjectFilter(java.lang.String)
	 */
	public void setDefaultObjectFilter(String objectFilterClassname) {
		filter = objectFilterClassname;
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.RuleExecutionSet#setProperty(java.lang.Object, java.lang.Object)
	 */
	public void setProperty(Object propName, Object propValue) {
		props.put(propName,propValue);
	}

	/**
	 * @return filter
	 * @throws InvalidRuleSessionException
	 */
	public final ObjectFilter resolveObjectFilter()
			throws InvalidRuleSessionException {
		try {
			if (filter == null) {
				return new ObjectFilterImpl();
			}
			Class c = Class.forName(filter);
			return (ObjectFilter) c.newInstance();
		} catch (Exception ex) {
			throw new InvalidRuleSessionException("Bad object filter", ex);
		}
	}
	
	public String toString(){
		return "RuleExecutionSet:"+getName()+" |Rules="+getRules();
	}
}
