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
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.sadre.app.misc.BasicDescribe;
import com.amarsoft.sadre.app.misc.SelectOption;

 /**
 * <p>Title: FlowDescribe.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-1 上午11:18:27
 *
 * logs: 1. 
 */
public class FlowDescribe extends BasicDescribe {
	
	public FlowDescribe(Transaction to){
		this.Sqlca = to;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getName(java.lang.String)
	 */
	
	public String getName(String id) {
		try {
			return CodeManager.getItemName("AuthorFlow", id);
		} catch (Exception e) {
			log.debug(e);
			return id;
		}
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getValueList(com.amarsoft.awe.control.model.Page)
	 */
	
	public List<SelectOption> getValueList(Page page){
		List<SelectOption> values = new ArrayList<SelectOption>();
		
		try {
		/*在Adapter之前暂时先用Code表代替
			BizObjectQuery bq = JBOFactory.createBizObjectQuery("jbo.sys.CODE_LIBRARY", 
					"select ItemName,ItemNo from O where CodeNo=:CodeNo and IsInuse='1' order by SortNo");
			bq.setParameter("CodeNo", "AuthorFlow");
			List<BizObject> result = bq.getResultList(false);
			for(int row=0; row<result.size(); row++){
				BizObject tmp = result.get(row);
				String itemNo = tmp.getAttribute("ItemNo").getString();
				String itemName = tmp.getAttribute("ItemName").getString();
//				values.put(itemNo, itemName);

				SelectOption so = new SelectOption(itemNo, itemName);
				values.add(so);
			}
		*/
			ASResultSet bq = Sqlca.getASResultSet("select FlowName,FlowNo from FLOW_CATALOG");
			while(bq.next()){
				String flowNo   = bq.getString("FlowNo");
				String flowName = bq.getString("FlowName");
				
				SelectOption so = new SelectOption(flowNo, flowName);
				values.add(so);
			}
			bq.getStatement().close();
		
		}catch (Exception e) {
			log.debug(e);
		}
		return values;
	}

}
