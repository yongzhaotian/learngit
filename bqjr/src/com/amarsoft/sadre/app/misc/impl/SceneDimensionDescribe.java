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

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.app.misc.SelectOption;
import com.amarsoft.sadre.cache.RuleScenes;
import com.amarsoft.sadre.rules.aco.RuleScene;

 /**
 * <p>Title: SceneDimensionDescribe.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-23 ÏÂÎç3:41:30
 *
 * logs: 1. 
 */
public class SceneDimensionDescribe extends DimensionDescribe {
	
	public SceneDimensionDescribe(Transaction to){
		super(to);
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getValueList(com.amarsoft.awe.control.model.Page)
	 */
	
	public List<SelectOption> getValueList(Page page){
		List<SelectOption> values = new ArrayList<SelectOption>();
		try {
			String sceneId = page.getParameter("sceneId");

			String sqlIn = "";
			String whereClause = "";
			RuleScene rs = RuleScenes.getRuleScene(sceneId);
			String[] dms = rs.getIncludeDimensions();
			for(int i=0; i<dms.length; i++){
				sqlIn += ",'"+dms[i]+"'";
			}
			if(sqlIn.length()>0){
				whereClause = "DIMENSIONID in ("+sqlIn.substring(1)+") order by DIMENSIONID";
			}else{
				whereClause = " 1=2 ";
			}
			
			ASResultSet bq = Sqlca.getASResultSet("select DIMENSIONID,DIMENSIONNAME from SADRE_DIMENSION where "+whereClause);
			while(bq.next()){
				String dimensionID 	= bq.getString("DIMENSIONID");
				String dimensionName = bq.getString("DIMENSIONNAME");
				
				SelectOption so = new SelectOption(dimensionID, dimensionName);
				values.add(so);
			}
			bq.getStatement().close();
			
		
		} catch (Exception e) {
			log.debug(e);
		}
		
		return values;
	}

}
