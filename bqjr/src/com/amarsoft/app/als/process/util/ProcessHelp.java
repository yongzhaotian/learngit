package com.amarsoft.app.als.process.util;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.core.json.JSONObject;
import com.amarsoft.core.object.ResultObject;

/**
 * 流程操作辅助类，用于生成页面下拉选项，json字符串等。
 * @author zszhang
 *
 */

public class ProcessHelp {
	/**
	 * 生成选择列表
	 * @param sValues
	 * @param sNames
	 * @param sDefault
	 * @return
	 */
	public static String generateDropDownSelect(String[] sValues, String[] sNames, String sDefault){
		String sTmp = null;
		int i;
		
		sTmp = "";
		if(sValues==null)return "";
		for(i=0;i<sValues.length;i++) {
			if (sValues[i].equals(sDefault))
				sTmp += "<option selected value=\""+sValues[i]+"\" >" + StringFunction.replace(sNames[i]," ","&nbsp;") + "</option>";	
			else
				sTmp += "<option value=\""+sValues[i]+"\" >" + StringFunction.replace(sNames[i]," ","&nbsp;") + "</option>";	
		}
		
		return sTmp;
	}
	
	/**
	 * 生成选择列表(未指定协办检查人)
	 * @param sValues
	 * @param sNames
	 * @param sDefault
	 * @return
	 */
	public static String generateDropDownSelect2(String[] sValues, String[] sNames, String sDefault){
		String sTmp = null;
		int i;
		
		sTmp = "";
		for(i=0;i<sValues.length;i++) {
			
			if (sNames[i].equals("提交协办检查人审查")) continue;
			if (sValues[i].equals(sDefault))
				sTmp += "<option selected value=\""+sValues[i]+"\" >" + StringFunction.replace(sNames[i]," ","&nbsp;") + "</option>";	
			else
				sTmp += "<option value=\""+sValues[i]+"\" >" + StringFunction.replace(sNames[i]," ","&nbsp;") + "</option>";	
		}
		return sTmp;
	}
	
	/**
	 * 生成选择列表(指定协办检查人)
	 * @param sValues
	 * @param sNames
	 * @param sDefault
	 * @return
	 */
	public static String generateDropDownSelect3(String[] sValues, String[] sNames, String sDefault){
		String sTmp = null;
		int i;
		
		sTmp = "";
		for(i=0;i<sValues.length;i++) {
			if (!(sNames[i].equals("提交协办检查人审查"))) continue;
			if (sValues[i].equals(sDefault))
				sTmp += "<option selected value=\""+sValues[i]+"\" >" + StringFunction.replace(sNames[i]," ","&nbsp;") + "</option>";	
			else
				sTmp += "<option value=\""+sValues[i]+"\" >" + StringFunction.replace(sNames[i]," ","&nbsp;") + "</option>";	
		}
		return sTmp;
	}

	/**
	 * 生成JSON字符串
	 * @param object 原有的JSON字符串
	 * @param name 对象编号
	 * @param value 对象值
	 * @return String 新的JSON字符串
	 */
	public static String generateJSONObject(String object,String name,String value) throws Exception{
		JSONObject jObject = null;
		if(object==null || "".equals(object.trim())){
			jObject = new JSONObject();
		}else{
			jObject = new JSONObject(object);
		}
	    ResultObject rObject = new ResultObject(jObject);
	    if(name==null || "".equals(name.trim())){
	    	throw new Exception("name不能为空");
	    }
	    rObject.put(name, value);
		return rObject.toString();
	}
	
//	public static void main(String args[]) throws Exception{
//		String object = "";
//		object = ProcessHelp.generateJSONObject(object,"a", "");
//		object = ProcessHelp.generateJSONObject(object,"a1.a1", "");
//		object = ProcessHelp.generateJSONObject(object,"a1.a1", "1.1");
//	}
	
}
