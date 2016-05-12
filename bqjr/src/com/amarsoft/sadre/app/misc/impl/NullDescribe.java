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
package com.amarsoft.sadre.app.misc.impl;

import java.util.List;

import com.amarsoft.awe.control.model.Page;
import com.amarsoft.sadre.app.misc.DescElement;
import com.amarsoft.sadre.app.misc.SelectOption;

 /**
 * <p>Title: NullDescribe.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-31 ÏÂÎç2:04:30
 *
 * logs: 1. 
 */
public class NullDescribe implements DescElement {

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getDescribe()
	 */
	
	public String getDescribe(String ids) {
		return "Null-Describe";
	}

	
	public String getName(String id) {
		return "Null-Name";
	}

	
	public String getOutline(String ids) {
		return "Null-Outline";
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getValueList(com.amarsoft.awe.control.model.Page)
	 */
	
	public List<SelectOption> getValueList(Page page){
		throw new UnsupportedOperationException();
	}

}
