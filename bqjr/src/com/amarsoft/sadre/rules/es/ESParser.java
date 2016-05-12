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
package com.amarsoft.sadre.rules.es;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map;

import com.amarsoft.are.ARE;
import com.amarsoft.sadre.SADREException;
import com.amarsoft.sadre.cache.Synonymns;
import com.amarsoft.sadre.cache.snap.ExecutionSnap;
import com.amarsoft.sadre.cache.snap.Snap;
import com.amarsoft.sadre.cache.snap.SnapElement;
import com.amarsoft.sadre.rules.aco.Synonymn;

 /**
 * <p>Title: ESParser.java </p>
 * <p>Description:  </p>
 * <p>Copyright: Copyright (C) 2006-2011 Amarsoft Ltd. Co.</p> 
 *     
 * @author zllin@amarsoft.com
 * @version 
 * @date 2011-4-19 下午03:04:04
 *
 * logs: 1. 
 */
public class ESParser {
	/**
	 * 将包含变量的表达式脚本(ExpressionScript)中的变量进行求值计算
	 * @param expES
	 * @param memory
	 * @return
	 */
	public static String parseESValue(String expES, Hashtable<String,Object> memory) throws SADREException{
		
		Object pojoValue = null;
		Map<String,Object> cacheES = new HashMap<String,Object>();
		
		if(expES==null || expES.trim().length()==0) return null;
		String pojoExpress = "";
		int idx_T = -1;		//尾部指针
		int idx_H = expES.indexOf("${");	//头部指针
		while(idx_H != -1){
			idx_T = expES.indexOf("}",idx_H+1);
			if(idx_T==-1){		//无完整的变量定义
				ARE.getLog().error("表达式脚本定义有误!["+expES+"]");
				return expES;
			}
			pojoExpress = expES.substring(idx_H+2, idx_T);		//${xxx.getXXX} -> xxx.getXXX
			
			pojoValue = getPojoValue(pojoExpress, memory);
			cacheES.put(pojoExpress, pojoValue);		//变量与值的映射对象
			
			idx_H = expES.indexOf("${",idx_T+1);	//头部指针往后移
		}
		
		//-----------------逐个替换表达式脚本
		Iterator<String> tk = cacheES.keySet().iterator();
		while(tk.hasNext()){
			String esExp = tk.next();
			Object esValue = cacheES.get(esExp);
			expES = expES.replaceAll("\\$\\{"+esExp+"\\}", esValue==null?"":esValue.toString());
		}
		
		return expES;
	}
	
	private static Object getPojoValue(String pojoES, Hashtable<String,Object> memory) throws SADREException{
		String[] pojoObj = pojoES.split("\\.");
		if(pojoObj.length==0){
			return pojoES;
		}
		Object aux = null;
//		Method auxMethod = null;
		SnapElement auxResult = null;
		Synonymn synonymn = Synonymns.getSynonymn(pojoObj[0]);
		if(synonymn==null){
			throw new SADREException("未找到相应的BOM定义["+pojoObj[0]+"]!");
		}
		aux = memory.get(synonymn.getImpl());
		if (aux != null) {
//			Class auxClass = aux.getClass();
//			try {
//				auxMethod = auxClass.getMethod(pojoObj[1], new Class[0]);		//获取对应的java对象方法,getStatus etc.
//			} catch (SecurityException e) {
//				throw new SADREException(e);
//			} catch (NoSuchMethodException e) {
//				throw new SADREException(synonymn.getImpl()+" 缺少类方法["+pojoObj[1]+"].",e);
//			}	
//			
//			try {
//				auxResult = auxMethod.invoke(aux, new Object[0]);
//				
//			} catch (IllegalArgumentException e) {
//				throw new SADREException(e);
//			} catch (IllegalAccessException e) {
//				throw new SADREException(e);
//			} catch (InvocationTargetException e) {
//				throw new SADREException(e);
//			}
			Snap snap = ExecutionSnap.getInstance().getSnap(aux);
			auxResult = snap.getSnapShot(pojoObj[1]);
//			ARE.getLog().trace(auxResult.getClass().getName()+":"+auxResult.toString()+" |consuming="+auxResult.getConsuming());
		}else{
			ARE.getLog().warn(synonymn.getImpl()+" not found in WorkingMemory!");
			throw new SADREException(synonymn.getImpl()+" not found in WorkingMemory!");
		}
		
		return auxResult.getElement();
	}
}
