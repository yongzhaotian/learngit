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
package com.amarsoft.sadre.app.ui;

import java.io.IOException;
import java.io.Writer;

import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.app.ui.webo.Table;

 /**
 * @ SUIQuery.java
 * DESCRIPT: 用于SADRE的简单扩展查询对象
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-1-5 下午01:02:03
 *
 * logs: 1. 
 */
public interface SUIQuery {
	
	/**
	 * 获取查询统计的实现SQL
	 * @return
	 */
	public String getDynamicSQL();
	
	/**
	 * 生成最终输出的HTML脚本
	 * @return
	 */
	public String generateHTMLScript() throws IOException;
	
	public void executeQuery(Page page,Transaction sqlca,String url) throws Exception;
	
//	public void generateFilters(Writer out)throws Exception;
	
	public void generateButtons(Writer out,String url)throws Exception;
	
	public void updateKeyRadio(boolean flag);
	
	public void setRequestAttribute(String attrId,String attrValue);
	
	public Table getTable();
	
}
