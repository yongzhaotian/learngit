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

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import com.amarsoft.app.als.sadre.util.Escape;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.web.ui.HTMLTreeView;

 /**
 * <p>Title: DynamicDescribe.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-28 上午11:03:00
 *
 * logs: 1. 
 */
public abstract class DynamicDescribe extends BasicDescribe {
	
	/** 上级编号 */
	private String parentSortNo;
	private String elementName = "elmAvlb";
	private Set<String> selectedElement = new HashSet<String>();
	private String nodeField = "SortNo";		//树图中获取节点value的field名称
	
	public void setParentSortNo(String parentSortNo) {
		this.parentSortNo = parentSortNo;
	}
	
	public String getParentSortNo() {
		return parentSortNo;
	}
	
	public String getElementName() {
		return elementName;
	}

	public void setElementName(String elementName) {
		this.elementName = elementName;
	}
	
	public String clickedNodeField(){
		return nodeField;
	}
	
	public void setSelected(String selected) {
		if(selected!=null && selected.length()>0){
//			ARE.getLog().info("selected="+selected);
			String[] elmTmp = Escape.unescape(selected).split(",");
			for(int i=0; i<elmTmp.length; i++){
				selectedElement.add(elmTmp[i]);
			}
		}
//		ARE.getLog().info("selectedElement="+selectedElement);
	}
	
	public boolean isSelected(String id){
		return selectedElement.contains(id);
	}

	/**
	 * 将结果列表转换为javascript脚本
	 */
	public String getSubSelection() {
		StringBuffer sb = new StringBuffer();
		
		int countSltd=0;
//		Map<String,String> values = getValueList(null);
//		Iterator<String> chosenId = values.keySet().iterator();
		Iterator<SelectOption> chosenId = getValueList(null).iterator();
		while(chosenId.hasNext()){
//			String id = chosenId.next();
//			sb.append(getElementName()).append(".options[").append(countSltd).append("] = new Option('").append(values.get(id)).append("','").append(id).append("');");
			SelectOption so = chosenId.next();
			sb.append("var obj = new Option('").append(so.getValue()).append("','").append(so.getId()).append("');");
			if(so.getTitle().length()>0) sb.append("obj.title = \"").append(so.getTitle()).append("\";");
			sb.append(getElementName()).append(".options[").append(countSltd).append("] = obj;");
			countSltd++;
		}
//		ARE.getLog().debug(sb.toString());
		return sb.toString();
	}
	
	/**
	 * ALS6的TreeView格式接口
	 * @param tmpSqlca
	 * @param tmpCurComp
	 * @param sTmpServletURL
	 * @param sTreeViewName
	 * @param sTargetWindow
	 * @return
	 * @throws Exception
	 */
	abstract public HTMLTreeView getRootTree(Transaction tmpSqlca,HTMLTreeView tmpTreeView) throws Exception;
	
}
