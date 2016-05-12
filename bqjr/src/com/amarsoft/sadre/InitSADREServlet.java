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
package com.amarsoft.sadre;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import com.amarsoft.are.ARE;
import com.amarsoft.sadre.services.SADREService;

 /**
 * <p>Title: InitSADREServlet.java </p>
 * <p>Description:  本类用于对SADRE服务的初始化,包括BOM对象、维度定义和规则场景的初始化。</p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-20 上午10:05:12
 *
 * logs: 1. 
 */
public class InitSADREServlet extends HttpServlet implements Servlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * 初始化Servlet 
	 * @throws ServletException 
	 * @see javax.servlet.GenericServlet#init()
	 */
	public void init() throws ServletException {
		super.init();
		System.out.println("**********************************InitSADREServlet Start*********************************");
		
		//从参数中ConfigFile获取参数文件名
		String database = getInitParameter("database");
		if (database == null || database.length() == 0) {
			ARE.getLog().info("Servlet中未指定SADRE的数据库连接名称,将以als作为默认数据库连接进行初始化.");
			database = "als";
		}
		SADREService.setDatabase(database);
		SADREService.init();
		
		if (ARE.isInitOk()) {
			System.out.println("**********************************InitSADREServlet Success*********************************");
		}else{
			System.out.println("**********************************InitSADREServlet Failed***********************************");
		}
	}
}
