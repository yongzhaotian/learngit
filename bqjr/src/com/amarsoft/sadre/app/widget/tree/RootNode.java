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
package com.amarsoft.sadre.app.widget.tree;

import java.text.DecimalFormat;
import java.util.LinkedHashMap;
import java.util.Map;

 /**
 * <p>Title: RootNode.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-9 œ¬ŒÁ2:04:44
 *
 * logs: 1. 
 */
public abstract class RootNode implements AtomNode {
	protected String treeId 		= "";
	protected String treeName 	= "";
	protected String treeSortNo 	= "";
	protected Map<String,LeafNode> sortedLeafs = new LinkedHashMap<String,LeafNode>();
	
	private DecimalFormat format = new DecimalFormat("0000");

	/**
	 * …Ë÷√≈≈–Ú±‡∫≈
	 * @param sortno
	 */
	public void setSortNo(String sortno){
		this.treeSortNo = sortno;
	}
	
	public Map<String,LeafNode> getLeafs(){
		return sortedLeafs;
	}
	
	
	public String getId() {
		return treeId;
	}

	
	public String getName() {
		return treeName;
	}

	
	public String getSortNo() {
		return treeSortNo;
	}
	
//	abstract public void addRule(LeafNode rule);
	public void addLeaf(LeafNode leaf){
		if(containsLeaf(leaf.getId())){
			//do nothing
		}else{
			leaf.setSortNo(getSortNo()+format.format(getLeafCount()));
			sortedLeafs.put(leaf.getId(), leaf);
		}
	}
	
	public int getLeafCount(){
		return sortedLeafs.size();
	}
	
	public boolean containsLeaf(String rootId){
		return sortedLeafs.containsKey(rootId);
	}
}
