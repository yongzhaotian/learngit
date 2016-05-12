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
package com.amarsoft.app.als.sadre.model.impl;

import com.amarsoft.app.als.sadre.model.OccupiedBasicUnit;
import com.amarsoft.app.als.sadre.simplebo.BusinessContract;
import com.amarsoft.sadre.SADREException;

/**
 * <p>Title: NullOccupiedImpl.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-6-21 ÏÂÎç04:26:48</p>
 *
 * logs: 1. </p>
 */
public class NullOccupiedImpl extends OccupiedBasicUnit {

	/* (non-Javadoc)
	 * @see mybank.app.fudian.dimensions.OccupiedBasicUnit#filterContract(mybank.app.fudian.sbo.BusinessContract)
	 */
	@Override
	public boolean filterContract(BusinessContract contract) throws SADREException {
		return false;
	}
	
	public double calculate() throws SADREException {
		throw new UnsupportedOperationException();
	}

}
