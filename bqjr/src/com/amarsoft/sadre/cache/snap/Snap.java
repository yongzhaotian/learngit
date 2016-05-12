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

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Hashtable;
import java.util.Map;

import com.amarsoft.app.als.sadre.util.DateUtil;
import com.amarsoft.are.ARE;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.rules.aco.WorkingObject;

 /**
 * <p>Title: Snap.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-9-30 上午10:45:10
 *
 * logs: 1. 
 */
public class Snap {
	private Map<String,SnapElement> snapSet = new Hashtable<String,SnapElement>();
	
	private WorkingObject snapedObject = null;
	private Class auxClass = null;
	private String createTime = "";
	
	public Snap(WorkingObject obj){
		this.snapedObject = obj;
		this.auxClass = obj.getClass();
		this.createTime = DateUtil.getNowTime();
	}
	
	public String snapCreateTime() {
		return createTime;
	}

	public boolean hasSnap(String snapId){
		return snapSet.containsKey(snapId);
	}
	
	private SnapElement addSnapShot(String method) throws SADREException{
		Method auxMethod = null;
//		Object auxResult = null;
		SnapElement element = new SnapElement();
		try {
			auxMethod = auxClass.getMethod(method, new Class[0]);		//获取对应的java对象方法,getStatus etc.
		} catch (SecurityException e) {
			throw new SADREException(e);
		} catch (NoSuchMethodException e) {
			throw new SADREException(auxClass.getName()+" 缺少类方法["+method+"].",e);
		}	
		
		try {
			Object auxResult = auxMethod.invoke(snapedObject, new Object[0]);
			element.addElement(auxResult);
		} catch (IllegalArgumentException e) {
			throw new SADREException(e);
		} catch (IllegalAccessException e) {
			throw new SADREException(e);
		} catch (InvocationTargetException e) {
			throw new SADREException(e);
		}
		ARE.getLog().trace(this.auxClass+" add snapshot for "+method+" = "+element.toString());
		snapSet.put(method, element);
		
		return element;
	}
	
	public SnapElement getSnapShot(String method) throws SADREException{
		SnapElement snapValue = null;
		if(snapSet.containsKey(method)){
//			ARE.getLog().trace(this.auxClass+".1 snaped method "+method);
			snapValue = snapSet.get(method);
		}else{
//			ARE.getLog().trace(this.auxClass+".2 add snap method "+method);
			snapValue = addSnapShot(method);
		}
		
		return snapValue;
	}
	
	public void clearSnaps(){
		if(snapSet!=null){
//			ARE.getLog().debug("clear.."+snapedObject.uniqeCode()+"..snap-elements");
			snapSet.clear();
			snapSet = null;
		}
	}
}
