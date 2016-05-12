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
package com.amarsoft.sadre.app.action;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.Dimensions;

/**
 * @ SADRERemoveDimension.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-5-12 下午01:55:17
 *
 * logs: 1. 
 */
public class RemoveDimension extends BasicWebAction {
	private String dimensionId = "";

	public String getDimensionId() {
		return dimensionId;
	}

	public void setDimensionId(String dimensionId) {
		this.dimensionId = dimensionId;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	
	public int execute(Transaction Sqlca) throws SADREException {
		String sDimensionId = DataConvert.toString(getDimensionId());
		
		Dimensions.removeDimension(sDimensionId);
		
//		ARE.getLog().info("授权维度删除成功!维度编号:"+sDimensionId);
		
		return WEB_ACTION_成功;
	}

}
