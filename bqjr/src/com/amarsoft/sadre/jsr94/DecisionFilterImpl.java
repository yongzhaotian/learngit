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
package com.amarsoft.sadre.jsr94;

import javax.rules.ObjectFilter;

import com.amarsoft.sadre.rules.aco.Decision;

 /**
 * <p>Title: DecisionFilterImpl.java </p>
 * <p>Description: 本类用于从WorkingMemory中提取授权判断结果的Filter实现 </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-22 下午03:51:16
 *
 * logs: 1. 
 */
public class DecisionFilterImpl implements ObjectFilter {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/* (non-Javadoc)
	 * @see javax.rules.ObjectFilter#filter(java.lang.Object)
	 */
	
	public Object filter(Object object) {
		if(object instanceof Decision){
			return object;
		}
		return null;
	}

	/* (non-Javadoc)
	 * @see javax.rules.ObjectFilter#reset()
	 */
	
	public void reset() {
		// TODO Auto-generated method stub

	}

}
