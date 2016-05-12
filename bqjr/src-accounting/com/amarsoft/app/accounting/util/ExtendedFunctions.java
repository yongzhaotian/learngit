package com.amarsoft.app.accounting.util;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.amarsoft.amarscript.Any;
import com.amarsoft.amarscript.Expression;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.util.expression.FunctionManager;
import com.amarsoft.are.io.FileTool;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;
import com.amarsoft.awe.util.Transaction;

/**
 * @author ygwang 扩展函数
 */
public class ExtendedFunctions {

	/**
	 * 不区分大小写替换
	 * 
	 * @param s1
	 *            目标字符串
	 * @param s2
	 *            匹配段
	 * @param s3
	 *            替换段
	 * @return
	 */
	public static String replaceAllIgnoreCase(String s1, String s2, String s3) {
		if(s3==null)s3="";
	    Matcher localMatcher = Pattern.compile(Pattern.quote(s2),Pattern.CASE_INSENSITIVE).matcher(s1);
		return localMatcher.replaceAll(s3);
	}
	
	
	public static List<String> getParameterList(String s){
		List<String> parameterList = new ArrayList<String>();
		int i=0;
		while(i<s.length()){
			int index1=s.indexOf("${", i);
			if(index1<0) break;
			i=s.indexOf("}", index1+2);
			if(i<0) break;
			String parameter = s.substring(index1+2,i);
			if(parameter.indexOf("${")>0){
				parameter=parameter.substring(parameter.lastIndexOf("${")+2);
			}
			parameterList.add(parameter);
		}
		return parameterList;
	}
	/**
	 * 不区分大小写批量替换
	 * 
	 * @param s1
	 *            目标字符串
	 * @param resultObject
	 *            替换变量池
	 * @return
	 * @throws Exception
	 *//*
	public static String replaceAllIgnoreCase(String s1, ResultObject resultObject)
			throws Exception {
		if(resultObject==null) return s1;
		if(s1==null||s1.length()==0) return s1;
		s1 = s1.trim();
		String[] s1split = s1.split(Pattern.quote("${"));
		for (int i = 0; i < s1split.length; ++i) {
			String s=s1split[i];
			if(s.indexOf("}")<=0) continue;
			//if(s.indexOf("{")<0) continue;
			String paraID = s.substring(0,s.indexOf("}"));
			String value=resultObject.get(paraID, "");
			if(value==null) value="";//throw new Exception("参数值为空：paraID="+paraID);
			s1 = ExtendedFunctions.replaceAllIgnoreCase(s1,"${"+paraID+"}",value);
		}
		return s1;
	}*/

	/**
	 * 不区分大小写批量替换
	 * 
	 * @param s1
	 *            目标字符串
	 * @param valuepool
	 *            替换变量池
	 * @return
	 * @throws Exception
	 */
	public static String replaceAllIgnoreCase(String s1, ASValuePool valuepool)
			throws Exception {
		if(valuepool==null) return s1;
		s1 = s1.trim();
		Object[] arrayOfObject = valuepool.getKeys();
		for (int i = 0; i < arrayOfObject.length; ++i) {
			String paraID=(String)arrayOfObject[i];
			if(s1.toUpperCase().indexOf(paraID.toUpperCase())<0) continue;
			String value=(String) valuepool.getAttribute((String) arrayOfObject[i]);
			if(value==null) continue;//throw new Exception("参数值为空：paraID="+paraID);
			s1 = ExtendedFunctions.replaceAllIgnoreCase(s1,"${"+paraID+"}",value);
		}
		return s1;
	}
	
	
	/**
	 * 不区分大小写批量替换
	 * 
	 * @param s1
	 *            目标字符串
	 * @param objectTypeID
	 * 				对象类型
	 * @param valuepool
	 *            替换变量池
	 * @return
	 * @throws Exception
	 */
	public static String replaceAllIgnoreCase(String s1,String objectTypeID, BusinessObject businessObject)
			throws Exception {
		if(businessObject==null) return s1;
		s1 = s1.trim();
		List<String> parameterList = getParameterList(s1);
		for(String parameterID:parameterList){
			String[] t;
			if(parameterID.lastIndexOf(".") < 0)
			{
				t = new String[1];
				t[0]= parameterID;
			}
			else
			{
				t = new String[2];
				t[0] = parameterID.substring(0, parameterID.lastIndexOf("."));
				t[1] = parameterID.substring(parameterID.lastIndexOf(".")+1);
			}
			String value=null;
			if(t.length==1&&(objectTypeID.length()==0||objectTypeID==null)){
				value=businessObject.getString(t[0]);
			}
			else if (t[0].equalsIgnoreCase(objectTypeID)){
				Object ob = businessObject.getString(t[1]);
				if(ob==null){
					if(s1.indexOf(parameterID+"}'")<0){
						value = "0";
					}
					else{
						value="";
					}
				}else{
					value=businessObject.getString(t[1]);
				}
				
			}
			if(value==null) continue;
			s1 = ExtendedFunctions.replaceAllIgnoreCase(s1,"${"+parameterID+"}",value);
		}
		return s1;
	}
	
	public static String getValueList(String parameterID, List<BusinessObject> businessObjectList)
		throws Exception {
		String s="";
		if(businessObjectList==null) return s;
		for(BusinessObject a:businessObjectList){
			s+=a.getString(parameterID)+",";
		}
		if(s.endsWith(",")) s=s.substring(0,s.length()-1);
		return s;
	}
	
	public static double getValueSum(String parameterID, List<BusinessObject> businessObjectList)
		throws Exception {
		double d=0d;
		if(businessObjectList==null) return d;
		for(BusinessObject a:businessObjectList){
			d+=a.getDouble(parameterID);
		}
		return d;
	}
	
	public static String replaceAllIgnoreCase(String s1, BusinessObject businessObject)
			throws Exception {
	
		if(businessObject==null) return s1;
		s1 = s1.trim();
		String objectType = businessObject.getObjectType();
		if(businessObject.getObjectType()!=null)
			s1 = replaceAllIgnoreCase(s1,objectType,businessObject);
		
		Object[] keys=businessObject.getRelativeObjectList().getKeys();
		if(keys==null) return s1;
		for(int i=0;i<keys.length;i++){
			if(s1.indexOf("${")<0) break;
			String objectName = (String)keys[i];
			if(s1.indexOf("${"+objectName+".")<0) continue;

			List<BusinessObject> list = businessObject.getRelativeObjects(objectName);
			if(list==null||list.isEmpty()) continue;
			
			for(BusinessObject a:list){
				if(s1.indexOf("${")<0) break;
				if(a.getObjectType()!=null&&s1.indexOf("${"+a.getObjectType())<0) break;
				if(a.getObjectType()!=null)
					s1 = replaceAllIgnoreCase(s1,a.getObjectType(),a);
			}
		}
		return s1;
	}

	
	/**
	 * 
	 * @param a
	 * @param sortAttributeID
	 * @return
	 * @throws Exception
	 */
	public static ArrayList<String> sortASValuePool(ASValuePool a,String sortAttributeID) throws Exception{
		ArrayList<String> sortedKey_t=new ArrayList<String>();
		Object[] keys = a.getKeys();
		for(int i=0;i<keys.length;i++){
			String key = (String)keys[i];
			ASValuePool values = (ASValuePool)a.getAttribute(key);
			if(values==null) continue;
			String sortNo = values.getString(sortAttributeID);
			String s=sortNo+"----------"+key;
			sortedKey_t.add(s);
		}
		Collections.sort(sortedKey_t);
		ArrayList<String> sortedKey =new ArrayList<String>();
		for(int i=0;i<sortedKey_t.size();i++){
			String[] key =((String)sortedKey_t.get(i)).split("----------");
			sortedKey.add(key[1]);
		}
		return sortedKey;
	}
	
	
	public static String[] getASValuePoolListAttribute(ArrayList a,String attributeID) throws Exception{
		if(a.isEmpty()||a==null) return null;
		String[] s =new String[a.size()];
		for(int i=0;i<a.size();i++){
			ASValuePool valuepool = (ASValuePool)a.get(i);
			String value = valuepool.getString(attributeID);
			s[i]=value;
		}
		return s;
	}
	
	public static String asValuePoolToString(BusinessObject a) throws Exception{
		StringBuffer sb=new StringBuffer();
		DataElement[] keys=a.getBo().getAttributes();
		for(int i=0;i<keys.length;i++){
			sb.append("{");
			sb.append(keys[i].getName());
			sb.append("=");
			String value=a.getString(keys[i].getName());
			sb.append(value==null?"null":value.toString());
			sb.append("}");
		}
		return sb.toString();
	}
	
	public static String getScript(String script,BusinessObject businessObject,Transaction sqlca)throws Exception {
		script = ExtendedFunctions.replaceAllIgnoreCase(script, businessObject);
		if(script==null||script.equals("")||(script.indexOf("${")<0&&script.indexOf("'")<0&&script.indexOf("(")<0)) {
			return script;
		}
		/**
		 * 获取交易关联的核算对象的属性值（该方法一般不使用，在表达式中可直接写变量名代替），写法参见:'${GetObjectAttribute('jbo.app.ACCT_LOAN','BusinessSum')}'
		 * 	这种写法可以用'${jbo.app.ACCT_LOAN.BusinessSum}'所代替
		 *  参数一、交易处理核算对象类型
		 *  参数二、核算对象所包含的属性
		 */
		script=runFunctions("GetObjectAttribute", script,businessObject.getObjectType(),businessObject);
		/**
		 * 获取机构存款账户信息，写法参见：
		 * 	'${GetOrgAccount('${jbo.app.ACCT_LOAN.AccountingOrgID}','010','${jbo.app.ACCT_LOAN.Currency}')}'
		 * 此段代码表示取信贷与核心往来账户
		 * 参数一，核算业务所属机构号
		 * 参数二，所取机构层面存款账户类型，参见代码OrgAccountType
		 * 参数三，核算业务所属币种
		 */
		script=runFunctions("GetOrgAccount",script,businessObject.getObjectType(),businessObject);
		/**
		 * 获取核算对象自身关联的存款账户信息，写法参见：
		 *  '${GetRelativeAccount('jbo.app.ACCT_LOAN','PayAccountNo@PayAccountName@PayAccountOrgID@PayAccountCurrency@PayAccountType@PayAccountFlag','AccountIndicator@01')}'
		 *  此段代码取处理核算对象所关联的存款账户信息
		 * 参数一、交易处理核算对象类型
		 * 参数二、需要从交易单据中获取那些数据字段信息，排序及写法为：账号@账户名@账户机构@账户币种@账户类型@账户标示
		 * 参数三、需要从关联账户信息表中获取数据的条件，写法为：字段1@值1@字段2@值2@…… 例如 AccountIndicator@01 表示只取AccountIndicator=01的记录
		 */
		script=runFunctions("GetRelativeAccount",script,businessObject.getObjectType(),businessObject);
		/**
		 * 获取交易关联的核算对象关联的子对象的属性值，写法参见： '${GetRelativeObjectAttribute('jbo.app.ACCT_LOAN','jbo.app.ACCT_DEPOSIT_ACCOUNTS','ACCOUNTNO','ACCOUNTINDICATOR','00')}'
		 *  参数一、交易处理核算对象类型
		 *  参数二、核算对象关联子对象
		 *  参数三、核算对象关联子对象属性字段名
		 *  参数四、参数五配合使用，表示核算对象关联子对象筛选条件，参数四是关联子对象属性字段，参数五是值
		 */
		script=runFunctions("GetRelativeObjectAttribute", script,businessObject.getObjectType(),businessObject);
		/**
		 * 获取交易关联的核算对象关联的子对象的金额值，写法参见： '${GetBalance('jbo.app.ACCT_LOAN','jbo.app.ACCT_SUBSIDIARY_LEDGER','DebitBalance','AccountCodeNo','LAS10301')}'
		 *  参数一、交易处理核算对象类型
		 *  参数二、核算对象关联子对象
		 *  参数三、核算对象关联子对象属性字段名
		 *  参数四、参数五配合使用，表示核算对象关联子对象筛选条件，参数四是关联子对象属性字段，参数五是值
		 */
		script=runFunctions("GetBalance", script,businessObject.getObjectType(),businessObject);
		/**
		 * 获取两个日期之间的月数（向上取整），写法参见： ${GetUpMonths('${jbo.app.ACCT_LOAN.PutOutDate}','${jbo.app.ACCT_LOAN.MaturityDate}')}
		 *  参数一、起始日期
		 *  参数二、到期日期
		 */
		script=runFunctions("GetUpMonths", script,businessObject.getObjectType(),businessObject);
		/**
		 * 获取两个日期之间的月数（向下取整），写法参见： ${GetMonths('${jbo.app.ACCT_LOAN.PutOutDate}','${jbo.app.ACCT_LOAN.MaturityDate}')}
		 *  参数一、起始日期
		 *  参数二、到期日期
		 */
		script=runFunctions("GetMonths", script,businessObject.getObjectType(),businessObject);
		/**
		 * 获取两个日期之间的天数，写法参见： ${GetDays('${jbo.app.ACCT_LOAN.PutOutDate}','${jbo.app.ACCT_LOAN.MaturityDate}')}
		 *  参数一、起始日期
		 *  参数二、到期日期
		 */
		script=runFunctions("GetDays", script,businessObject.getObjectType(),businessObject);
		
		File f = FileTool.findFile("function_config.xml"); 
		if(f != null) 
		{
			Document function_document = new Document(f);
			List l = function_document.getRootElement().getChildren("Function");
			for(Object o : l){
				Element e = (Element)o;
				String functionID = e.getAttributeValue("functionid");
				script=runFunctions(functionID, script, businessObject.getObjectType(), businessObject);
			}
		}
		
		return script;
	}
	
	public static Any getScriptValue(String script,BusinessObject businessObject,Transaction sqlca) throws Exception {
		script = ExtendedFunctions.getScript(script, businessObject, sqlca);
		if(script==null||script.equals("")||(script.indexOf("${")<0&&script.indexOf("'")<0&&script.indexOf("(")<0)) {
			try{
				return Expression.getExpressionValue(script, sqlca);
			}
			catch(Exception e){
				e.printStackTrace();
				throw new Exception("脚本错误:"+script);
			}
		}
		
		if(script.indexOf("${")>=0){
			throw new Exception("脚本-"+script+"参数未替换完整，请确认所需参数是否都已加载到对应对象");
		}
		try{
			return Expression.getExpressionValue(script, sqlca);
		}
		catch(Exception e){
			e.printStackTrace();
			throw new Exception("脚本错误:"+script);
		}
	}
	
	public static String runFunctions(String functionName,String script,String boname,BusinessObject bo) throws Exception{
		String t1="${"+functionName+"(";
		if(script==null||script.equals("")||script.indexOf(t1)<0) return script;
		HashMap<String,Object> objectParas = new HashMap<String,Object>();
		objectParas.put(boname, bo);
		while(true){
			int i = script.indexOf(t1);
			if(i<0) break;
			String paras= script.substring(i+t1.length(),script.indexOf(")}",i));
			String value=FunctionManager.runFunction(functionName, paras,objectParas);
			script=ExtendedFunctions.replaceAllIgnoreCase(script, t1+paras+")}", value);
		}
		return script;
	}
	
	public static String getScriptStringValue(String script,BusinessObject businessObject,Transaction sqlca) throws Exception {
		if(script==null||script.length()==0) return "";
		if(script.indexOf("${")<0&&script.indexOf("'")<0&&script.indexOf(",")<0&&script.indexOf("(")<0)
			return script;
		try{
			return getScriptValue(script,businessObject,sqlca).stringValue();
		}
		catch(Exception e){
			e.printStackTrace();
			throw new Exception("脚本错误:"+script);
		}
	}
	
	public static double getScriptDoubleValue(String script,BusinessObject businessObject,Transaction sqlca) throws Exception {
		if(script==null||script.length()==0) return 0d;
		try{
			return getScriptValue(script,businessObject,sqlca).doubleValue();
		}
		catch(Exception e){
			e.printStackTrace();
			throw new Exception("脚本错误:"+script);
		}
	}
	
	public static double getScriptMoneyValue(String script,BusinessObject businessObject,Transaction sqlca) throws Exception {
		double d=getScriptDoubleValue(script,businessObject,sqlca);
		return Arith.round(d, 2);
	}
	
	public static int getScriptIntValue(String script,BusinessObject businessObject,Transaction sqlca) throws Exception {
		if(script==null||script.length()==0) return 0;
		try{
			return getScriptValue(script,businessObject,sqlca).intValue();
		}
		catch(Exception e){
			throw new Exception("脚本错误:"+script);
		}
	}
	
	public static boolean getScriptBooleanValue(String script,BusinessObject businessObject,Transaction sqlca) throws Exception {
		if(script==null||script.length()==0) return true;
		try{
			return getScriptValue(script,businessObject,sqlca).booleanValue();
		}
		catch(Exception e){
			throw new Exception("脚本错误:"+script);
		}
	}
}
