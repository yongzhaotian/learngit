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
 * @date 2012-2-9 ����2:02:15
 *
 * logs: 1. 
 */
public interface AtomNode {
	/**
	 * �ڵ���
	 * @return
	 */
	public String getId();
	/**
	 * �ڵ�����
	 * @return
	 */
	public String getName();
	/**
	 * �ڵ������
	 * @return
	 */
	public String getSortNo();
	/**
	 * �ڵ�����
	 * @return
	 */
	public String getDescribe();
}
