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

import javax.rules.RuleExecutionSetMetadata;
import javax.rules.admin.RuleExecutionSet;

 /**
 * <p>Title: RuleExecutionSetMetadataImpl</p>
 * <p>Description: This class exposes some simple properties of the RuleExecutionSet to the runtime user.
 * This interface can be extended by rule engine providers to expose additional proprietary properties to the runtime user.
 * It is recommended but not required that any properties that are exposed in such extensions be read only,
 * and that their values be static for the duration of the RuleSession. </p>
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-13 ÉÏÎç09:42:29
 *
 * logs: 1. 
 */
public class RuleExecutionSetMetadataImpl implements RuleExecutionSetMetadata {

	private static final long serialVersionUID = 1L;
	
	/** rule execution set URI */
	private String uri;

	/** rule execution set name */
	private String name;

	/** rule execution set description */
	private String description;
	
	/**
	 * @param impl
	 *            rule execution set implementation
	 */
	public RuleExecutionSetMetadataImpl(RuleExecutionSet impl) {
		name = impl.getName();
		description = impl.getDescription();
//		uri = impl.getUri();
		uri = impl.getName();
	}

	/* (non-Javadoc)
	 * @see javax.rules.RuleExecutionSetMetadata#getDescription()
	 */
	public String getDescription() {
		return description;
	}

	/* (non-Javadoc)
	 * @see javax.rules.RuleExecutionSetMetadata#getName()
	 */
	public String getName() {
		return name;
	}

	/* (non-Javadoc)
	 * @see javax.rules.RuleExecutionSetMetadata#getUri()
	 */
	public String getUri() {
		return uri;
	}

}
