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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

 /**
 * @ Table.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-1-5 下午01:23:05
 *
 * logs: 1. 
 */
public class Table extends GenericElement{
	
//	private Map trs = new TreeMap();
	private List trs = new ArrayList();
	private Map trIndx = new HashMap();
	
	private boolean radiokeyStaus = true;
	
	public Table(String name){
		this.tdName = name;
	}
	
	public void updateKeyRadio(boolean flag){
		radiokeyStaus = flag;
	}
	
	public void addTR(Tr tr){
//		trs.put(tr.getName(), tr);
		if(trIndx.containsKey(tr.getName())){
			String index = trIndx.get(tr.getName()).toString();
			trs.add(Integer.valueOf(index).intValue(), tr);		//update tr
		}else{
			trs.add(tr);
		}
	}
	
	public Tr[] getTrs(){
		int size = trs.size();
		Tr[] array = new Tr[size];
//		trs.values().toArray(array);
		trs.toArray(array);
		return array;
	}
	
	public Tr getTr(String name){
//		if(trs.containsKey(name)){
//			return (Tr)trs.get(name);
//		}
		if(trIndx.containsKey(name)){
			String index = trIndx.get(name).toString();
			return (Tr)trs.get(Integer.valueOf(index).intValue());
		}
		return null;
	}

	public String getHtmlScript(String header) {
		StringBuffer sb = new StringBuffer("<table");
		//-----------生成tr自身的属性
		//properties
		Iterator tk = properties.keySet().iterator();
		while(tk.hasNext()){
			String propid = (String)tk.next();
			sb.append(" ").append(properties.get(propid).toString());
		}
		//events
		tk = events.keySet().iterator();
		while(tk.hasNext()){
			String attrid = (String)tk.next();
			sb.append(" ").append(events.get(attrid).toString());
		}
		//------close emb
		sb.append(">");
		//----add header
		sb.append(header);
		//-----------将table下的所有tr遍历成html脚本
		Tr[] trs = getTrs();
		for(int i=0; i<trs.length; i++){
			trs[i].updateKeyRadio(radiokeyStaus);
			sb.append(trs[i].getHtmlScript());
		}
		sb.append("</table>");
		
		return sb.toString();
	}
	
	public String getHtmlScript() {
		return getHtmlScript("");
	}
	
	public int getColumns(){
		return getTrs()[0].getColumns();
	}
	
}
