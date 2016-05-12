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
package com.amarsoft.app.als.sadre.model.impl;

import com.amarsoft.app.als.sadre.DefaultSynonymnImpl;
import com.amarsoft.app.als.sadre.simplebo.BusinessContract;
import com.amarsoft.sadre.SADREException;

 /**
 * <p>Title: RiskGapSum3rdImpl.java </p>
 * <p>Description: 异地授信敞口余额 </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-22 下午2:46:27
 *
 * logs: 1. 
 */
public class RiskGapSum3rdImpl extends CustomerRiskGapImpl {
	
	public RiskGapSum3rdImpl(DefaultSynonymnImpl synonymn){
		super(synonymn);
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.app.als.sadre.model.OccupiedBasicUnit#filterContract(com.amarsoft.app.als.sadre.simplebo.BusinessContract)
	 */
	@Override
	public boolean filterContract(BusinessContract contract)
			throws SADREException {
		// 只统计异地分行发起的业务
		if(contract.getManageOrgId().matches("(11[0-9]+|12[0-9]+)")){		//11和12编号开头的机构编号为市内支行
			return true;
		}
		return false;
	}
	
}
