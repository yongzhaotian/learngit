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
package com.amarsoft.sadre.rules.aco;

 /**
 * <p>Title: Synonymn.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-15 ÉÏÎç11:42:09
 *
 * logs: 1. 
 */
public class Synonymn {

	private String id;
	private String name;
	private String impl;
	
	public Synonymn(String id,String name){
		this.id = id;
		this.name = name;
	}
	
	public void setName(String name) {
		this.name = name;
	}

	public String getImpl() {
		return impl;
	}

	public void setImpl(String impl) {
		this.impl = impl;
	}

	public String getId() {
		return id;
	}

	public String getName() {
		return name;
	}
	
	public String toString(){
		return "Synonymn:id="+getId()+"|name="+getName()+"|impl="+this.getImpl();
	}
}
