/*
 * @(#)ErrorType.java
 *
 * Copyright 2001-2012 Amarsoft, Inc. All Rights Reserved.
 * 
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * 
 * Author:Administrator
 */
package com.amarsoft.app.creditline.model;

import java.io.Serializable;
import java.lang.reflect.Method;

/**
 * @author Administrator
 *
 */
public class ErrorType implements Serializable {
	private static final long serialVersionUID = 1L;
	private String id;
	private String name;
	private String errorLevel;
	private String errorDescribe;
	private String handleDescribe;
	
	public ErrorType(String id, String name,String errorLevel) {
		setId(id);
		setName(name);
		setErrorLevel(errorLevel);
	}

	public ErrorType(String id, String name,String errorLevel,String errorDescribe,String handleDescribe) {
		setId(id);
		setName(name);
		setErrorLevel(errorLevel);
		setErrorDescribe(errorDescribe);
		setHandleDescribe(handleDescribe);
	}
	
	/**
	 * @param sKey 属性名
	 * @return 属性值
	 * @throws Exception
	 */
    public Object getAttribute(String sKey)throws Exception{
    	String m = "get" + sKey.substring(0, 1).toUpperCase() + sKey.substring(1);
    	Method method = this.getClass().getMethod(m);
        return method.invoke(this);
    }
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getErrorLevel() {
		return errorLevel;
	}

	public void setErrorLevel(String errorLevel) {
		this.errorLevel = errorLevel;
	}

	public String getErrorDescribe() {
		return errorDescribe;
	}

	public void setErrorDescribe(String errorDescribe) {
		this.errorDescribe = errorDescribe;
	}

	public String getHandleDescribe() {
		return handleDescribe;
	}

	public void setHandleDescribe(String handleDescribe) {
		this.handleDescribe = handleDescribe;
	}
}
