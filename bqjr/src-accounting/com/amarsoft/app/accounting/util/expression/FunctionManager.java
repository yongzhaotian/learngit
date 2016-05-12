package com.amarsoft.app.accounting.util.expression;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.amarsoft.are.util.ASValuePool;

public class FunctionManager {
	
	private static ASValuePool functionContext = new ASValuePool();
	
	public static List<Object>[] parseParas(String paras)  throws Exception{
		ArrayList[] list=new ArrayList[2];
		list[0]=new ArrayList<Class>();
		list[1]=new ArrayList<Object>();
		String s="";
		int i=0;
		if(paras.startsWith("'")){
			s = paras.substring(1,paras.indexOf("'", 1));
			i=paras.indexOf("'", 1)+2;
			list[0].add(String.class);
			list[1].add(s);
		}
		else{
			i=paras.indexOf(",");
			if(i<0){
				s=paras;
				i=paras.length();
			}
			else {
				s = paras.substring(0,paras.indexOf(","));
				i++;
			}
			if(s.equalsIgnoreCase("false")||s.equalsIgnoreCase("true")){
				list[0].add(boolean.class);
				list[1].add(Boolean.parseBoolean(s));
			}
			else if(s.indexOf(".")>=0){
				try
				{
					Double d = Double.valueOf(Double.parseDouble(s));
					list[0].add(double.class);
					list[1].add(d);
				}catch(Exception ex)
				{
					list[0].add(String.class);
					list[1].add(s);
				}
					
			}
			else if(s.indexOf(".")<0){
				
				try
				{
					Integer n = Integer.valueOf(Integer.parseInt(s));
					list[0].add(int.class);
					list[1].add(n);
				}catch(Exception ex)
				{
					list[0].add(String.class);
					list[1].add(s);
				}
			}
			else throw new Exception("参数传入格式错误！");
		}
		if(i<paras.length()){
			List[] list_t=parseParas(paras.substring(i));
			list[0].addAll(list_t[0]);
			list[1].addAll(list_t[1]);
		}
		return list;
	}
	
	public static void regFunction(String functionName,String executorName) throws Exception{
		ASValuePool function = new ASValuePool();
		function.setAttribute("FunctionName", functionName);
		function.setAttribute("ExecutorName", executorName);
		functionContext.setAttribute(functionName, function);
	}
	
	public static void regFunction(String functionName,String javaClassName,String javaMethodName) throws Exception{
		ASValuePool function = new ASValuePool();
		function.setAttribute("FunctionName", functionName);
		function.setAttribute("ExecutorName", "com.amarsoft.app.accounting.util.expression.SimpleJavaFunction");
		function.setAttribute("ClassName", javaClassName);
		function.setAttribute("MethodName", javaMethodName);
		functionContext.setAttribute(functionName, function);
	}
	
	public static String getFunctionAttribute(String functionName,String attributeID) throws Exception{
		ASValuePool function = (ASValuePool)functionContext.getAttribute(functionName);
		if(function==null) throw new Exception("未找到方法："+functionName);
		return function.getString(attributeID);
	}
	
	public static IFunction getFunctionExecutor(String functionName) throws Exception{
		ASValuePool function = (ASValuePool)functionContext.getAttribute(functionName);
		if(function==null) throw new Exception("未找到方法："+functionName);
		//IFunction i= (IFunction)function.getAttribute("ExecutorClass");
		//if(i==null) {
			String executorName = getFunctionAttribute(functionName,"ExecutorName");
			IFunction i=(IFunction)Class.forName(executorName).newInstance();
		//}
		return i;
	}
	
	public static String runFunction(String functionName,String parascript,HashMap<String,Object> objectParas) throws Exception{
		IFunction i=getFunctionExecutor(functionName);
		Iterator<Map.Entry<String,Object>> iter = objectParas.entrySet().iterator(); 
		while (iter.hasNext()) { 
		    Map.Entry<String,Object> entry = (Map.Entry<String,Object>) iter.next(); 
		    String key = entry.getKey(); 
		    Object value = entry.getValue(); 
		    i.setObjectPara(key, value);
		} 
		return i.run((ASValuePool)functionContext.getAttribute(functionName), parascript);
	}
}
