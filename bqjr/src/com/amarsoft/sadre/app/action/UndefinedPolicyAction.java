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
 * <p>Title: UndefinedPolicyAction.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-16 下午5:28:47
 *
 * logs: 1. 
 */
public class UndefinedPolicyAction implements WebAction {


	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.action.WebAction#execute(com.amarsoft.awe.util.Transaction)
	 */
	public int execute(Transaction Sqlca) throws SADREException {
//		throw new UnsupportedOperationException(this.getClass().getName()+"未定义授权方案不支持执行execute(Transaction)");
		return WEB_ACTION_失败;
	}

}
