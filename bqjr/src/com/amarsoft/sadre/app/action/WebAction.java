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

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;

 /**
 * <p>Title: WebAction.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-29 上午11:15:40
 *
 * logs: 1. 
 */
public interface WebAction {
	public static final int WEB_ACTION_成功 = 1;
	public static final int WEB_ACTION_失败 = 0;
	public static final int WEB_ACTION_未知 = -1;
	
	public static final String ACTION_DESC_成功 = "SUCCESSFUL";
	public static final String ACTION_DESC_失败 = "FAILED";
	
	
	/**
	 * 兼容ALS6的执行调用接口
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public int execute(Transaction Sqlca) throws SADREException ;
}
