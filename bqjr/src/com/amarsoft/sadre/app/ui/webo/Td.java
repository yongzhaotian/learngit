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
package com.amarsoft.sadre.app.ui.webo;

import java.util.Iterator;

 /**
 * @ Td.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-1-5 下午01:23:22
 *
 * logs: 1. 
 */
public class Td extends GenericElement{
	
	public Td(String name){
		this.tdName = name;
	}
	
//	public void addRadio(String name){
//		String desc = "<INPUT type=radio name=\""+name+"\">";
//		this.setValue(desc);
//	}
//	public void addRadio(){
//		addRadio("radio");
//	}

	public String getHtmlScript() {
		StringBuffer sb = new StringBuffer("<td");
		//-----------生成tr自身的属性
		//properties
		Iterator tk = attributes.keySet().iterator();
		while(tk.hasNext()){
			String attrid = (String)tk.next();
			sb.append(" ").append(attributes.get(attrid).toString());
		}
		//events
		tk = events.keySet().iterator();
		while(tk.hasNext()){
			String attrid = (String)tk.next();
			sb.append(" ").append(events.get(attrid).toString());
		}
		//------close emb
		sb.append(">");
		String tdValue = this.getValue();
		if(tdValue==null || tdValue.length()==0){
			tdValue = "&nbsp;";
		}else{
			//tdValue = tdValue.replaceAll(" ", "&nbsp;");
		}
		sb.append(tdValue);
		sb.append("</tr>");
		
		return sb.toString();
	}

	public void updateKeyRadio(boolean flag) {
		
	}
	
}
