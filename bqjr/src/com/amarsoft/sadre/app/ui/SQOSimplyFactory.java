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

import com.amarsoft.are.ARE;
import com.amarsoft.sadre.app.ui.impl.NullObjectImpl;
import com.amarsoft.sadre.app.ui.impl.RuleInfoImpl;
import com.amarsoft.sadre.app.ui.impl.RuleListImpl;

 /**
 * @ SQOSimplyFactory.java
 * DESCRIPT: 生成SADRE查询对象(SQO:Sadre Query Object)类的简单工厂
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-1-5 下午01:07:29
 *
 * logs: 1. 
 */
public class SQOSimplyFactory {
	public static SUIQuery getQueryObject(String sqoName){
		if(sqoName==null || sqoName.trim().length()==0){
			ARE.getLog().warn("SQO对象名称["+sqoName+"]非法!");
			return null;
		}
		
		String objectName = sqoName.trim().toUpperCase();
		SUIQuery sqo = null;
		if(objectName.equalsIgnoreCase("RuleList")){
			sqo = new RuleListImpl();
		}else if(objectName.equalsIgnoreCase("RuleInfo")){
			sqo = new RuleInfoImpl();
//		}else if(objectName.equals("PROJECTSUMARRY")){
//			sqo = new ProjectSumarryImpl();
//		}else if(objectName.equals("CUSTOMERREPORT")){
//			sqo = new CustomerReportImpl();
//		}else if(objectName.equals("RECORDDETAIL")){
//			sqo = new RecordDetailImpl();
//		}else if(objectName.equals("CUSTOMERSUPPORTCHANGE")){
//			sqo = new CustomerSupportChangeImpl();
//		}else if(objectName.equals("SERVICELOGSEARCH")){
//			sqo = new ServiceLogSearchImpl();
		}else{
			sqo = new NullObjectImpl();
		}
		
		return sqo;
	}
}
