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
import java.io.InputStream;
import java.io.Reader;
import java.util.Map;

import javax.rules.admin.LocalRuleExecutionSetProvider;
import javax.rules.admin.RuleExecutionSet;
import javax.rules.admin.RuleExecutionSetCreateException;

import com.amarsoft.sadre.rules.aco.RuleScene;

 /**
 * @ LocalRuleExecutionSetProviderImpl.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-13 上午09:39:09
 *
 * logs: 1. 
 */
public class LocalRuleExecutionSetProviderImpl implements
		LocalRuleExecutionSetProvider {
	
	public static final String NAME = "name";
	public static final String DESCRIPTION = "description";

	/* (non-Javadoc)
	 * @see javax.rules.admin.LocalRuleExecutionSetProvider#createRuleExecutionSet(java.io.InputStream, java.util.Map)
	 */
	public RuleExecutionSet createRuleExecutionSet(InputStream inputStream, Map props)
			throws RuleExecutionSetCreateException, IOException {
		//目前不支持全xml配置的规则定义
		throw new RuleExecutionSetCreateException("Operation Not Supported by SADRE Yet!");
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.LocalRuleExecutionSetProvider#createRuleExecutionSet(java.io.Reader, java.util.Map)
	 */
	public RuleExecutionSet createRuleExecutionSet(Reader reader, Map props)
			throws RuleExecutionSetCreateException, IOException {
		//目前不支持全xml配置的规则定义
		throw new RuleExecutionSetCreateException("Operation Not Supported by SADRE Yet!");
	}

	/* (non-Javadoc)
	 * @see javax.rules.admin.LocalRuleExecutionSetProvider#createRuleExecutionSet(java.lang.Object, java.util.Map)
	 */
	public RuleExecutionSet createRuleExecutionSet(Object obj, Map properties)
			throws RuleExecutionSetCreateException {
		
		if (obj == null || !(obj instanceof RuleScene))
		throw new RuleExecutionSetCreateException(
				"Invalid type argument: OBJ argument must be a com.amarsoft.sadre.rules.aco.RuleScene Object");
		
		try {
			return createRuleExecutionSetFromRuleScene((RuleScene)obj);
		} catch (Exception ex) {
			throw new RuleExecutionSetCreateException(ex.getMessage());
		}
	}
	
	
	private RuleExecutionSet createRuleExecutionSetFromRuleScene(RuleScene scene)
			throws RuleExecutionSetCreateException, IOException {
		try {
			RuleExecutionSet rs = new RuleExecutionSetImpl(scene.getRuleSceneId(), scene.getRuleSceneName(), null);		//(name,description,uri)
//			System.out.println("rs1="+rs);
			rs.getRules().addAll(scene.getRules());
//			System.out.println("rs2="+rs);

			return rs;
		} catch (Exception ex) {
			throw new RuleExecutionSetCreateException("系统内部错误!", ex);
		}
	}

}
