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
package com.amarsoft.app.als.sadre.bizlet;

import com.amarsoft.app.als.sadre.widget.Describes;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.sadre.app.misc.DynamicDescribe;

/**
 * <p>Title: AuthorSubSelection.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2012-4-11 下午3:07:11</p>
 *
 * logs: 1. </p>
 */
public class AuthorSubSelection extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	@Override
	public Object run(Transaction Sqlca) throws Exception {
		String type = DataConvert.toString((String)this.getAttribute("type"));
		String parentSortNo = DataConvert.toString((String)this.getAttribute("ParentSortNo"));
		String selected = DataConvert.toString((String)this.getAttribute("Selected"));
		ARE.getLog().info("type="+type);
		ARE.getLog().info("parentSortNo="+parentSortNo);
		ARE.getLog().info("selected="+selected);
		
		DynamicDescribe element = (DynamicDescribe)Describes.getElement(type, Sqlca);
		if(element==null){
			throw new Exception("动态树图未定义响应事件.");
		}
		element.setParentSortNo(parentSortNo);
		element.setSelected(selected);
		
		return element.getSubSelection();
	}

}
