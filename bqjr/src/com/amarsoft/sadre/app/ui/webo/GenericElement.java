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

import java.util.HashMap;
import java.util.Map;

 /**
 * @ GenericElement.java
 * DESCRIPT: 
 *     
 * @author zllin@amarsoft.com
 * 
 * @date 2011-1-5 ÏÂÎç01:47:10
 *
 * logs: 1. 
 */
public abstract class GenericElement implements WebElement {
	
	protected Map attributes = new HashMap();
	
	protected Map properties = new HashMap();
	
	protected Map events = new HashMap();
	
	protected String tdName = "";
	
	protected String tdValue = "";
	
	public String getName(){
		return this.tdName;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.erp.support.webo.WebElement#setValue(java.lang.String)
	 */
	public void setValue(String value) {
		// TODO Auto-generated method stub
		this.tdValue = value;
	}
	
	public String getValue() {
		return this.tdValue;
	}
	
	private boolean existsObject(Map map,String key){
		if(map.containsKey(key.toUpperCase())){
			return true;
		}
		return false;
	}
	
	private String getMapObject(Map map,String key){
		String keyValue = null;
		if(existsObject(map,key)){
			keyValue = map.get(key.toUpperCase()).toString();
		}
		return keyValue;
	}
	
	private void setMapObject(Map map,String key,String value){
		map.put(key.toUpperCase(), key.toLowerCase()+"=\""+value+"\"");
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.erp.support.webo.WebElement#getAttribute(java.lang.String)
	 */
	public String getAttribute(String attrName) {
		return getMapObject(attributes,attrName);
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.erp.support.webo.WebElement#setAttribute(java.lang.String, java.lang.String)
	 */
	public void setAttribute(String attrName, String attrValue) {
		setMapObject(attributes,attrName,attrValue);

	}

	/* (non-Javadoc)
	 * @see com.amarsoft.erp.support.webo.WebElement#getPropertie(java.lang.String)
	 */
	public String getPropertie(String propName) {
		return getMapObject(properties,propName);
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.erp.support.webo.WebElement#setPropertie(java.lang.String, java.lang.String)
	 */
	public void setPropertie(String propName, String propValue) {
		setMapObject(properties,propName,propValue);
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.erp.support.webo.WebElement#getEvent(java.lang.String)
	 */
	public String getEvent(String eventName) {
		return getMapObject(events,eventName);
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.erp.support.webo.WebElement#setEvent(java.lang.String, java.lang.String)
	 */
	public void setEvent(String eventName, String eventValue) {
		setMapObject(events,eventName,eventValue);
	}

	public int getColumns(){
		return 1;
	}
}
