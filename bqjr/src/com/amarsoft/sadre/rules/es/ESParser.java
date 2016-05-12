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
 * @date 2011-4-19 ����03:04:04
 *
 * logs: 1. 
 */
public class ESParser {
	/**
	 * �����������ı��ʽ�ű�(ExpressionScript)�еı���������ֵ����
	 * @param expES
	 * @param memory
	 * @return
	 */
	public static String parseESValue(String expES, Hashtable<String,Object> memory) throws SADREException{
		
		Object pojoValue = null;
		Map<String,Object> cacheES = new HashMap<String,Object>();
		
		if(expES==null || expES.trim().length()==0) return null;
		String pojoExpress = "";
		int idx_T = -1;		//β��ָ��
		int idx_H = expES.indexOf("${");	//ͷ��ָ��
		while(idx_H != -1){
			idx_T = expES.indexOf("}",idx_H+1);
			if(idx_T==-1){		//�������ı�������
				ARE.getLog().error("���ʽ�ű���������!["+expES+"]");
				return expES;
			}
			pojoExpress = expES.substring(idx_H+2, idx_T);		//${xxx.getXXX} -> xxx.getXXX
			
			pojoValue = getPojoValue(pojoExpress, memory);
			cacheES.put(pojoExpress, pojoValue);		//������ֵ��ӳ�����
			
			idx_H = expES.indexOf("${",idx_T+1);	//ͷ��ָ��������
		}
		
		//-----------------����滻���ʽ�ű�
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
			throw new SADREException("δ�ҵ���Ӧ��BOM����["+pojoObj[0]+"]!");
		}
		aux = memory.get(synonymn.getImpl());
		if (aux != null) {
//			Class auxClass = aux.getClass();
//			try {
//				auxMethod = auxClass.getMethod(pojoObj[1], new Class[0]);		//��ȡ��Ӧ��java���󷽷�,getStatus etc.
//			} catch (SecurityException e) {
//				throw new SADREException(e);
//			} catch (NoSuchMethodException e) {
//				throw new SADREException(synonymn.getImpl()+" ȱ���෽��["+pojoObj[1]+"].",e);
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
