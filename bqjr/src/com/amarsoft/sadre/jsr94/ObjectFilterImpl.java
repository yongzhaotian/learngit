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

import javax.rules.ObjectFilter;

 /**
 * @ ObjectFilterImpl.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-13 ÉÏÎç09:39:31
 *
 * logs: 1. 
 */
public class ObjectFilterImpl implements ObjectFilter {

	private static final long serialVersionUID = 1L;

	/* (non-Javadoc)
	 * @see javax.rules.ObjectFilter#filter(java.lang.Object)
	 */
	public Object filter(Object obj) {
		return obj;
	}

	/* (non-Javadoc)
	 * @see javax.rules.ObjectFilter#reset()
	 */
	public void reset() {

	}

}
