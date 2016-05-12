package com.amarsoft.app.util;

public class DataConvertTools {
	/**
	 * 字符串类型变量若值为null,转成空字符串
	 * @param s
	 * @return
	 */
	public static String nullToEmptyString(String s){
		return s==null?"":s;
	}
}
