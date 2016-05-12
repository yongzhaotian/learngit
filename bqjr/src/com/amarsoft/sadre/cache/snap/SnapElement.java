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
package com.amarsoft.sadre.cache.snap;

import java.util.Date;

 /**
 * <p>Title: SnapElement.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-10-8 ÉÏÎç9:52:30
 *
 * logs: 1. 
 */
public class SnapElement {
	private Date beginTime 	= null;
	private Date endTime 	= null;
	private Object element 	= null;
	private double consuming = 0D;
	
	public SnapElement(){
		this.beginTime = new Date();
	}
	
	public void addElement(Object obj){
		this.element = obj;
		this.endTime = new Date();
		this.consuming = (this.endTime.getTime()-this.beginTime.getTime())/1000.0;
	}

	public double getConsuming() {
		return consuming;
	}

	public Object getElement() {
		return element;
	}
	
	public String toString(){
		return element==null?"null-value":element.toString();
	}
}
