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
 * <p>Title: AtomNode.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-9 下午2:02:15
 *
 * logs: 1. 
 */
public interface AtomNode {
	/**
	 * 节点编号
	 * @return
	 */
	public String getId();
	/**
	 * 节点名称
	 * @return
	 */
	public String getName();
	/**
	 * 节点排序号
	 * @return
	 */
	public String getSortNo();
	/**
	 * 节点描述
	 * @return
	 */
	public String getDescribe();
}
