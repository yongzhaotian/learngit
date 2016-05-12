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
package com.amarsoft.sadre.app.action;

import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;

 /**
 * <p>Title: BasicWebAction.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-29 上午11:20:49
 *
 * logs: 1. 
 */
public abstract class BasicWebAction implements WebAction {
	
	protected Log log = ARE.getLog("com.amarsoft.sadre.app.action.WebAction");

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.swui.action.WebAction#execute()
	 */
	public int execute(Transaction Sqlca) throws SADREException {
		throw new UnsupportedOperationException();
	}
	
	public static String describe(int flag){
		switch(flag){
			case WEB_ACTION_成功:
				return ACTION_DESC_成功;
			default:
				return ACTION_DESC_失败;
		}
	}
	
}
