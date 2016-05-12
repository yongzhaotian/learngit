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
package com.amarsoft.sadre.app.widget.tree;

import java.util.Map;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.web.ui.HTMLTreeView;


/**
 * <p>Title: ITreeNode.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 1999-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com</p>
 * @version </p>
 * @date 2012-4-10 下午5:51:08</p>
 *
 * logs: 1. </p>
 */
public interface ITreeNode {
	
	/**
	 * 追加树图节点到TreeView对象中
	 * @param treeView
	 * @param attributes
	 * @param sqlca
	 */
	public void appendTreeNode(HTMLTreeView treeView, Map<String, String> attributes, Transaction sqlca);
}
