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
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.sadre.app.misc.BasicDescribe;
import com.amarsoft.sadre.app.misc.SelectOption;
import com.amarsoft.sadre.cache.Dimensions;
import com.amarsoft.sadre.rules.aco.Dimension;

 /**
 * <p>Title: RuleConfDescribe.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-2 ����9:45:05
 *
 * logs: 1. 
 */
public class RuleConfDescribe extends BasicDescribe {
	
	public RuleConfDescribe(Transaction to){
		this.Sqlca = to;
	}
	
	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getName(java.lang.String)
	 */
	
	public String getName(String id) {
		throw new UnsupportedOperationException();
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getValueList(com.amarsoft.awe.control.model.Page)
	 */
	
	public List<SelectOption> getValueList(Page page){
		List<SelectOption> values = new ArrayList<SelectOption>();
		try {
			String sDimensionId = page.getParameter("dimensionID");
			Dimension dimension = Dimensions.getDimension(sDimensionId);
			if(dimension!=null){
				String[] codeArray = null;		//ż��Ϊֵ������Ϊ��ʾֵ
				switch(dimension.getOptionType()){
					case Dimension.ȡֵ��Դ����_CODE:
//						sQuerySql = "select ItemNo,ItemName from CODE_LIBRARY where CodeNo='"+dimension.getOptionSource()+"' and IsInUse='1' order by SortNo ";
						codeArray = CodeManager.getItemArray(dimension.getOptionSource());
						break;
					case Dimension.ȡֵ��Դ����_SQL:
//						sQuerySql = dimension.getOptionSource();
						codeArray = CodeManager.getItemArrayFromSql(dimension.getOptionSource());
						break;
					default:
				}
				
				/*��CODE��������ת��ΪMAP*/
				if(codeArray!=null){
					for(int p=0; p<codeArray.length; p++){
						SelectOption so = new SelectOption(codeArray[p], codeArray[++p]);
						values.add(so);
					}
				}
			}
			
		} catch (Exception e) {
			log.debug(e);
		}
		
		return values;
	}
}
