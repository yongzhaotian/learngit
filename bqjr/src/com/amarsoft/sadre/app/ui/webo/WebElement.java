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
package com.amarsoft.sadre.app.ui.webo;

 /**
 * @ WebElement.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-1-5 ÏÂÎç01:44:44
 *
 * logs: 1. 
 */
public interface WebElement {
	
	public String getName();
	
	public void setValue(String value);
	
	public String getValue();
	
	public String getAttribute(String attrName);
	
	public void setAttribute(String attrName,String attrValue);
	
	public String getPropertie(String propName);
	
	public void setPropertie(String propName,String propValue);
	
	public String getEvent(String eventName);
	
	public void setEvent(String eventName,String eventValue);
	
	public String getHtmlScript();
	
	public void updateKeyRadio(boolean flag);
	
	public int getColumns();
}
