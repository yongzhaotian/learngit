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
 * @date 2012-1-29 ����11:15:40
 *
 * logs: 1. 
 */
public interface WebAction {
	public static final int WEB_ACTION_�ɹ� = 1;
	public static final int WEB_ACTION_ʧ�� = 0;
	public static final int WEB_ACTION_δ֪ = -1;
	
	public static final String ACTION_DESC_�ɹ� = "SUCCESSFUL";
	public static final String ACTION_DESC_ʧ�� = "FAILED";
	
	
	/**
	 * ����ALS6��ִ�е��ýӿ�
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public int execute(Transaction Sqlca) throws SADREException ;
}
