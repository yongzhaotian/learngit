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

import java.util.List;

import com.amarsoft.awe.control.model.Page;

 /**
 * <p>Title: DescElement.java </p>
 * <p>Description: 本接口定义了代码序列(,分隔)转换为中文描述的处理对象 </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-1-31 下午1:48:44
 *
 * logs: 1. 
 */
public interface DescElement {
	public static final String 分隔符 = ",";
	
	/**
	 * 转换后的中文描述
	 * @param ids
	 * @return
	 */
	public String getDescribe(String ids);
	/**
	 * 转换后的中文概要描述
	 * @param ids
	 * @return
	 */
	public String getOutline(String ids);
	
	public String getName(String id);
	
//	public Map<String,String> getValueList();
	/**
	 * 子类预留的供外部传入参数的接口实现
	 * @param attr
	 * @return
	 */
	public List<SelectOption> getValueList(Page page);
}
