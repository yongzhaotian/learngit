/*
 * This software is the confidential and proprietary information
 * of Amarsoft, Inc. You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms
 * of the license agreement you entered into with Amarsoft.
 * 
 * Copyright (c) 1999-2011 Amarsoft, Inc.
 * 23F Building A Fudan University Technology Center,
 * No.11 Guotai Road YangPu District, Shanghai,P.R. China 200433
 * All Rights Reserved.
 * 
 */
package com.amarsoft.sadre.integration;

import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.jsr94.admin.RuleImpl;

 /**
 * <p>Title: RuleDataObject.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-20 ����10:38:03
 *
 * logs: 1. add at 2011-6-16 �����ڹ�������(RunTime-Binding),���ά������
 */
public interface RuleDataObject {
	
	public static final int �����ڱ���_�Ƿ� 		= -1;
	public static final int �����ڱ���_������ 	= 0;
	public static final int �����ڱ���_���� 		= 1;
	
	public void loadData() throws SADREException;
	
	public RuleImpl getRuntimeRule();
	
	public void bindingRuntimeRule(RuleImpl runtimeBindingRule);
	
	public int existsRuntime(String bindingName) throws SADREException;
	
	public boolean validateRuntime(String bindingName,String sourceValue) throws SADREException;
}
