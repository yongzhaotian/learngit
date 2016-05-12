package com.amarsoft.app.als.process.util;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.core.json.JSONObject;
import com.amarsoft.core.object.ResultObject;

/**
 * ���̲��������࣬��������ҳ������ѡ�json�ַ����ȡ�
 * @author zszhang
 *
 */

public class ProcessHelp {
	/**
	 * ����ѡ���б�
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
	 * ����ѡ���б�(δָ��Э������)
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
			
			if (sNames[i].equals("�ύЭ���������")) continue;
			if (sValues[i].equals(sDefault))
				sTmp += "<option selected value=\""+sValues[i]+"\" >" + StringFunction.replace(sNames[i]," ","&nbsp;") + "</option>";	
			else
				sTmp += "<option value=\""+sValues[i]+"\" >" + StringFunction.replace(sNames[i]," ","&nbsp;") + "</option>";	
		}
		return sTmp;
	}
	
	/**
	 * ����ѡ���б�(ָ��Э������)
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
			if (!(sNames[i].equals("�ύЭ���������"))) continue;
			if (sValues[i].equals(sDefault))
				sTmp += "<option selected value=\""+sValues[i]+"\" >" + StringFunction.replace(sNames[i]," ","&nbsp;") + "</option>";	
			else
				sTmp += "<option value=\""+sValues[i]+"\" >" + StringFunction.replace(sNames[i]," ","&nbsp;") + "</option>";	
		}
		return sTmp;
	}

	/**
	 * ����JSON�ַ���
	 * @param object ԭ�е�JSON�ַ���
	 * @param name ������
	 * @param value ����ֵ
	 * @return String �µ�JSON�ַ���
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
	    	throw new Exception("name����Ϊ��");
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
