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
package com.amarsoft.sadre.app.misc;

import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;
import com.amarsoft.awe.util.Transaction;

 /**
 * <p>Title: BasicDescribe.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-31 下午2:22:35
 *
 * logs: 1. 
 */
public abstract class BasicDescribe implements DescElement {
	
	protected Log log = ARE.getLog("com.amarsoft.sadre.app.misc");
	
	protected Transaction Sqlca;

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getDescribe(java.lang.String)
	 */
	public String getDescribe(String ids) {
		if(ids==null || ids.trim().length()==0) return "";
		
		StringBuffer describe = new StringBuffer();
		String[] elements = ids.split(分隔符);
		for(int i=0; i<elements.length; i++){
			String tmpName = getName(elements[i]);
			if(tmpName!=null && tmpName.length()>0){
				describe.append(",").append(tmpName);
			}
		}
		if(describe.length()>0){
			describe.deleteCharAt(0);
		}
		return describe.toString();
	}
	
	public String getOutline(String ids) {
		if(ids==null || ids.trim().length()==0) return "";
		
		int handledNum = 0;		//已处理的编号数
		StringBuffer describe = new StringBuffer();
		String[] elements = ids.split(分隔符);
		for(int i=0; i<elements.length; i++){
			String tmpName = getName(elements[i]);
			if(tmpName!=null && tmpName.length()>0){
				describe.append(",").append(tmpName);
				handledNum++;
			}
			/*如果处理个数超过3,则后续处理结束*/
			if(handledNum >= 3){
				describe.append(" ... ");
				break;
			}
		}
		if(describe.length()>0){
			describe.deleteCharAt(0);
		}
		return describe.toString();
	}
	
}
