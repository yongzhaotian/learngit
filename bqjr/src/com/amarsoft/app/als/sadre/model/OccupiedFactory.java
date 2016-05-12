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
package com.amarsoft.app.als.sadre.model;

import com.amarsoft.app.als.sadre.DefaultSynonymnImpl;
import com.amarsoft.app.als.sadre.model.impl.CustomerRiskGapImpl;
import com.amarsoft.app.als.sadre.model.impl.CustomerTotalImpl;
import com.amarsoft.app.als.sadre.model.impl.NullOccupiedImpl;
import com.amarsoft.app.als.sadre.model.impl.RiskGapSum3rdImpl;

/**
 * <p>Title: OccupiedFactory.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2011-6-11 上午11:13:08</p>
 *
 * logs: 1. </p>
 */
public class OccupiedFactory {
	
	public static OccupiedCalcUnit getCalcUnit(String type,DefaultSynonymnImpl synonymn){
		OccupiedCalcUnit ocu = null;
		if (type.equalsIgnoreCase("CustomerTotal")){		//合同汇总
			ocu = new CustomerTotalImpl(synonymn);
		}else if(type.equalsIgnoreCase("CustomerRiskGap")){		//敞口汇总
			ocu = new CustomerRiskGapImpl(synonymn);
		}else if(type.equalsIgnoreCase("RiskGapSum3rd")){
			ocu = new RiskGapSum3rdImpl(synonymn);
		}else{
			ocu = new NullOccupiedImpl();
		}
		
		return ocu;
	}
}
