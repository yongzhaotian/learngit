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

 /**
 * <p>Title: SelectOption.java </p>
 * <p>Description: 本类定义的是下拉框中的选择项,用以描述下拉框的详情 </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-3-1 下午5:01:48
 *
 * logs: 1. 
 */
public class SelectOption {
	private String id = "";
	private String value = "";
	private String title = "";
	
	public SelectOption(String id,String value){
		this.id = id;
		this.value = value;
	}
	
	public SelectOption(String id){
		this(id,"");
	}
	
	public void addTitle(String title){
		this.title = title;
	}

	public String getId() {
		return id;
	}

	public String getValue() {
		return value;
	}

	public String getTitle() {
		return title==null?"":title;
	}
	
}
