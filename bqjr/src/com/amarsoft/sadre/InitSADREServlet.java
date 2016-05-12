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
 * <p>Description:  �������ڶ�SADRE����ĳ�ʼ��,����BOM����ά�ȶ���͹��򳡾��ĳ�ʼ����</p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-20 ����10:05:12
 *
 * logs: 1. 
 */
public class InitSADREServlet extends HttpServlet implements Servlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * ��ʼ��Servlet 
	 * @throws ServletException 
	 * @see javax.servlet.GenericServlet#init()
	 */
	public void init() throws ServletException {
		super.init();
		System.out.println("**********************************InitSADREServlet Start*********************************");
		
		//�Ӳ�����ConfigFile��ȡ�����ļ���
		String database = getInitParameter("database");
		if (database == null || database.length() == 0) {
			ARE.getLog().info("Servlet��δָ��SADRE�����ݿ���������,����als��ΪĬ�����ݿ����ӽ��г�ʼ��.");
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
