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

import javax.rules.Handle;

 /**
 * @ HandleImpl.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-4-13 ÉÏÎç09:39:51
 *
 * logs: 1. 
 */
public class HandleImpl implements Handle {

	private static final long serialVersionUID = 1L;

	private Object object;

	public HandleImpl(Object o) {
		object = o;
	}

	public final Object getObject() {
		return object;
	}

	public final void setObject(Object o) {
		object = o;
	}

	public final boolean equals(Object o) {
		if (!(o instanceof HandleImpl))
			return false;
		else
			return object.equals(((HandleImpl) o).object);
	}

	public final int hashCode() {
		return object.hashCode();
	}
}
