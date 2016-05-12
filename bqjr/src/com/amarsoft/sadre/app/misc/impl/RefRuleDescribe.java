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

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.SpecialTools;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.app.misc.BasicDescribe;
import com.amarsoft.sadre.app.misc.SelectOption;

 /**
 * <p>Title: RefRuleDescribe.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-2 下午1:45:59
 *
 * logs: 1. 
 */
public class RefRuleDescribe extends BasicDescribe {
	
	public RefRuleDescribe(Transaction to){
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
	
//	public Map<String, String> getValueList(Page page) {
	public List<SelectOption> getValueList(Page page){
		String currentRule = "";		//当前规则编号,不能出现在可选择项中
		try {
			currentRule = page.getParameter("currentRule");
		} catch (Exception e1) {
			ARE.getLog().debug(e1);
		}
//		Map<String,String> values = new LinkedHashMap<String,String>();
		List<SelectOption> values = new ArrayList<SelectOption>();
		try {
			String sSceneId  = SpecialTools.amarsoft2Real(page.getParameter("SceneId"));
			
			/*
			BizObjectQuery bq = JBOFactory.createBizObjectQuery("jbo.app.sadre.ASSUMPTION", 
					"select ASSUMPTIONID,NOTE from O where SCENEID=:SCENEID order by SceneId");
			bq.setParameter("SCENEID", sSceneId);
			List<BizObject> result = bq.getResultList(false);
			for(int row=0; row<result.size(); row++){
				BizObject tmp = result.get(row);
				String assumptionid = tmp.getAttribute("ASSUMPTIONID").getString();
				String note = tmp.getAttribute("NOTE").getString();
				if(assumptionid.equals(currentRule)) continue;
				
//				values.put(assumptionid, assumptionid);		//规则无名称
				
				SelectOption so = new SelectOption(assumptionid,assumptionid);
				//-----------如果存在规则说明,则取其前60个字
				if(note.length()>=60) note = note.substring(0, 60)+"...";
				String ruleDesc = note.replaceAll("\r\n", " ");
				so.addTitle(ruleDesc);
				values.add(so);
			}
			*/
			//modify by hwang,选择关联前置规则时排除独立规则
			ASResultSet bq = Sqlca.getASResultSet("select ASSUMPTIONID,NOTE from SADRE_ASSUMPTION where SCENEID='"+sSceneId+"' and RuleType='3' order by SceneId ");
			while(bq.next()){
				String assumptionid = bq.getString("ASSUMPTIONID");
				String note 	= bq.getString("NOTE");
				if(assumptionid.equals(currentRule)) continue;
				
				SelectOption so = new SelectOption(assumptionid,assumptionid);
				//-----------如果存在规则说明,则取其前60个字
				if(note.length()>=60) note = note.substring(0, 60)+"...";
				String ruleDesc = note.replaceAll("\r\n", " ");
				so.addTitle(ruleDesc);
				values.add(so);
			}
			bq.getStatement().close();
			
		} catch (Exception e) {
			log.debug(e);
		}
		
		return values;
	}

}
