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
 * @ Tr.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-1-5 下午01:23:14
 *
 * logs: 1. 
 */
public class Tr extends GenericElement{
	
//	private Map tds = new TreeMap();
	private List tds = new ArrayList();
	private Map tdIndx = new HashMap();
	private Map keyAttr = new HashMap();
	
	private boolean radiokeyStaus = true;
	
	public Tr(String name){
		this.tdName = name;
	}
	
	public void addTD(Td td){
//		tds.put(td.getName(), td);
		if(tdIndx.containsKey(td.getName())){
			String index = tdIndx.get(td.getName()).toString();
			tds.add(Integer.valueOf(index).intValue(), td);		//update td
		}else{
			tds.add(td);
		}
	}
	
	public void addKey(String key,String value){
		keyAttr.put(key.toUpperCase(), key+"="+value);
	}
	
	public String[] getKeys(){
		String[] kv = new String[keyAttr.size()];
		keyAttr.entrySet().toArray(kv);
		return kv;
	}
	
	public void addTD(String name,String value){
		Td td = new Td(name);
		td.setValue(value);
		addTD(td);
	}
	
	public void addTD(String name,int value){
		addTD(name,String.valueOf(value));
	}
	
	public void addTD(String name,double value){
		addTD(name,String.valueOf(value));
	}
	
//	public void addHideTD(String name,String value){
//		Td td = new Td(name);
//		td.setValue(value);
//		addTD(td);
//	}
	
	public Td[] getTds(){
		int size = tds.size();
		Td[] array = new Td[size];
//		tds.values().toArray(array);
		tds.toArray(array);
		return array;
	}
	
	public Td getTd(String name){
//		if(tds.containsKey(name)){
//			return (Td)tds.get(name);
//		}
		if(tdIndx.containsKey(name)){
			String index = tdIndx.get(name).toString();
			return (Td)tds.get(Integer.valueOf(index).intValue());
		}
		return null;
	}

	public String getHtmlScript() {
		
		StringBuffer sb = new StringBuffer("<tr");
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
		
		if(radiokeyStaus){		//radiokeyStaus true=保留  false=不保留
			//radio key-value
			String kvExp = "";
			tk = keyAttr.keySet().iterator();
			while(tk.hasNext()){
				String attrid = (String)tk.next();
				//sb.append(" ").append(keyAttr.get(attrid).toString());
				kvExp += keyAttr.get(attrid).toString()+"@";
			}
			sb.append("<td><INPUT type=radio name=\"radio\" onclick=\"javascript:selectRow('"+kvExp+"')\"></td>");
		}
//		else{
//			sb.append("<td>&nbsp;</td>");
//		}
		//-----------将table下的所有td遍历成html脚本
		Td[] tds = getTds();
		for(int i=0; i<tds.length; i++){
			sb.append(tds[i].getHtmlScript());
		}
		sb.append("</tr>");
		
		return sb.toString();
	}

	public void updateKeyRadio(boolean flag) {
		radiokeyStaus = flag;
	}
	
	public int getColumns(){
		return tds.size();
	}
	
}
