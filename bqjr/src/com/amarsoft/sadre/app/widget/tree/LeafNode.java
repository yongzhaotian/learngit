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

 /**
 * <p>Title: LeafNode.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-9 ÏÂÎç2:04:58
 *
 * logs: 1. 
 */
public abstract class LeafNode implements AtomNode {
	protected String nodeId  	= "";
	protected String nodeName  	= "";
	protected String sortNo	 	= "";

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.model.tree.AtomNode#getName()
	 */
	
	public String getName() {
		return nodeName;
	}
	
	public String getSortNo() {
		return sortNo;
	}

	public void setSortNo(String sortNo) {
		this.sortNo = sortNo;
	}
	
	
	public String getId() {
		return nodeId;
	}

}
