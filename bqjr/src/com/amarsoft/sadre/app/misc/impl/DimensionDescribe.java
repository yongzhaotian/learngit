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
import com.amarsoft.sadre.app.misc.BasicDescribe;
import com.amarsoft.sadre.app.misc.SelectOption;

 /**
 * <p>Title: DimensionDescribe.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-31 ÏÂÎç2:49:57
 *
 * logs: 1. 
 */
public class DimensionDescribe extends BasicDescribe {
	
	public DimensionDescribe(Transaction to){
		this.Sqlca = to;
	}
	
	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getName(java.lang.String)
	 */
	public String getName(String dimensionId){
		String dimensionName = "";
		try {
			/*
			BizObjectQuery query = JBOFactory.createBizObjectQuery("jbo.app.sadre.DIMENSION", "DIMENSIONID=:DIMENSIONID");
			query.setParameter("DIMENSIONID", dimensionId);
			BizObject bo = query.getSingleResult(false);
			if(bo!=null){
				dimensionName = bo.getAttribute("DIMENSIONNAME").getString();
			}
			*/
			ASResultSet bq = Sqlca.getASResultSet("select DIMENSIONNAME from SADRE_DIMENSION where DIMENSIONID='"+dimensionId+"' ");
			if(bq.next()){
				dimensionName = bq.getString("DIMENSIONNAME");
			}
			bq.getStatement().close();
		} catch (Exception e) {
			log.debug(e);
			dimensionName = dimensionId;
		}
		
		return dimensionName;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getValueList(com.amarsoft.awe.control.model.Page)
	 */
	public List<SelectOption> getValueList(Page page){
		List<SelectOption> values = new ArrayList<SelectOption>();
		try {
			/*
			BizObjectQuery query = JBOFactory.createBizObjectQuery("jbo.app.sadre.DIMENSION", "");
			List<BizObject> result = query.getResultList(false);
			for(int row=0; row<result.size(); row++){
				BizObject tmp = result.get(row);
//				values.put(tmp.getAttribute("DIMENSIONID").getString(), tmp.getAttribute("DIMENSIONNAME").getString());
				SelectOption so = new SelectOption(tmp.getAttribute("DIMENSIONID").getString(),tmp.getAttribute("DIMENSIONNAME").getString());
				values.add(so);
			}
			*/
			
			ASResultSet bq = Sqlca.getASResultSet("select DIMENSIONID,DIMENSIONNAME from SADRE_DIMENSION");
			while(bq.next()){
				String dimensionId = bq.getString("DIMENSIONID");
				String dimensionName = bq.getString("DIMENSIONNAME");
				
				SelectOption so = new SelectOption(dimensionId, dimensionName);
				values.add(so);
			}
			bq.getStatement().close();
			
		} catch (Exception e) {
			log.debug(e);
		}
		
		return values;
	}

}
