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
package com.amarsoft.sadre.app.misc.impl;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.sadre.app.misc.BasicDescribe;
import com.amarsoft.sadre.app.misc.SelectOption;
import com.amarsoft.sadre.cache.Synonymns;
import com.amarsoft.sadre.rules.aco.Synonymn;

 /**
 * <p>Title: ImplementDescribe.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2012-2-6 上午11:46:33
 *
 * logs: 1. 
 */
public class ImplementDescribe extends BasicDescribe {

	public ImplementDescribe(Transaction to){
		this.Sqlca = to;
	}

	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getName(java.lang.String)
	 */
	
	public String getName(String id) {
//		throw new UnsupportedOperationException();
		return id;
	}
	
	/* (non-Javadoc)
	 * @see com.amarsoft.sadre.app.misc.DescElement#getValueList(com.amarsoft.awe.control.model.Page)
	 */
	
//	public Map<String, String> getValueList(Page page) {
	public List<SelectOption> getValueList(Page page){
		List<SelectOption> values = new ArrayList<SelectOption>();
		
		Synonymn synonymn = Synonymns.getSynonymn("default");
		
		Class aux = null;
		try {
			aux = Class.forName(synonymn.getImpl());
//			ARE.getLog().debug(aux.getName());
		} catch (ClassNotFoundException e) {
			ARE.getLog().error(e);
			return null;
		}
		
		Method[] methods = aux.getDeclaredMethods();
		for(int i=0; i<methods.length; i++){
			/*
			 public static final int PRIVATE 2 
			 public static final int PROTECTED 4 
			 public static final int PUBLIC 1 
			 public static final int STATIC 8 
			 */
			if(methods[i].getModifiers()==Modifier.PUBLIC 
					|| methods[i].getModifiers()==Modifier.PROTECTED){		//列举出public/protected的类方法
				String methodName = methods[i].getName();
				/*不包含继承的4个内部方法*/
				if(!methodName.matches("(finalPost|getType|process|releaseResource|prepare)")){
					String returnType = methods[i].getGenericReturnType().toString();
//					
//					MethodComment ann = methods[i].getAnnotation(MethodComment.class);
//					String describe = ann==null?"":ann.value();
					
					String implKey = "${"+synonymn.getId()+"."+methods[i].getName()+"}";
					String implValue = (returnType.equals("class java.lang.String")?"String":returnType)+" "+methods[i].getName();
//					String implValue = (returnType.equals("class java.lang.String")?"String":returnType)+" "+methods[i].getName()+" "+describe;
//					ARE.getLog().debug(implKey+" "+implValue);
					
//					result.put(implKey, implValue);
					SelectOption so = new SelectOption(implKey, implValue);
					values.add(so);
				}
			}
		}
//		ARE.getLog().debug(result);
		return values;
	}

}
