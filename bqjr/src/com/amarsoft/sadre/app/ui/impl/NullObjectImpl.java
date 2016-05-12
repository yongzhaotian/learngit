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
package com.amarsoft.sadre.app.ui.impl;

import java.io.Writer;

import com.amarsoft.sadre.app.ui.AbstractSUIQuery;

 /**
 * @ NullObjectImpl.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-1-6 下午12:00:06
 *
 * logs: 1. 
 */
public class NullObjectImpl extends AbstractSUIQuery {

	/* (non-Javadoc)
	 * @see com.amarsoft.erp.support.AbstractSupportQuery#drawHeader()
	 */
	public void drawHeader() {
		header = "  <tr>"+
			"  <td><font color=red>查询对象错误!请确认后重试!</font></td>"+
			"  </tr>";
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.erp.support.AbstractSupportQuery#prepareRequest()
	 */
	public void prepareRequest() throws Exception {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.erp.support.AbstractSupportQuery#doQuery()
	 */
	public void doQuery(String url) throws Exception {
		// TODO Auto-generated method stub
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.erp.support.AbstractSupportQuery#clearResource()
	 */
	public void clearResource() {
		// TODO Auto-generated method stub
	}

	public void generateButtons(Writer out, String url) throws Exception {
		// TODO Auto-generated method stub
	}

}
