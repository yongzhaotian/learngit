package com.amarsoft.app.alarm;

import java.util.Map;

import com.amarsoft.amarscript.Any;
import com.amarsoft.amarscript.Expression;
import com.amarsoft.awe.util.Transaction;

/**
 * @author syang
 * @date 2011-6-29
 * @describe 字符串处理工具
 */
public class StringTool {
	
	/**
	 * 运行一个AmarScript
	 * @param sqlca 数据库连接
	 * @param script 脚本
	 * @param args 参数池
	 * @return
	 * @throws Exception
	 */
	public static Any runAmarScript(Transaction sqlca,String script,Map<String,Object> args) throws Exception{
		Any anyResult = null;
		String sRunCondition = script;
		if(sRunCondition == null || sRunCondition.length() == 0) return anyResult;
		sRunCondition = pretreat(args,sRunCondition);
		sRunCondition = Expression.pretreatMethod(sRunCondition,sqlca);
		anyResult = Expression.getExpressionValue(sRunCondition,sqlca);
		return anyResult;
	}	
	/**
	 * 预处理字串
	 * @param pool
	 * @param str
	 * @return
	 * @throws Exception
	 */
	public static String pretreat(Map<String,Object> pool,String str) throws Exception{
		if(str == null) return str;
		String sReturn = macroReplace(pool,str.trim(),"#{","}");
		sReturn = macroReplace(pool,sReturn,"${","}");
		return sReturn;
	}	
	/**
	 * 宏替换
	 * @param vpAttributes
	 * @param sSource
	 * @param sBeginIdentifier
	 * @param sEndIdentifier
	 * @return
	 * @throws Exception
	 */
    public static String macroReplace(Map<String,Object> vpAttributes, String sSource, String sBeginIdentifier, String sEndIdentifier)throws Exception{
	    if(sSource == null) return null;
	    if(vpAttributes == null || vpAttributes.size() == 0) return sSource;
	    
	    int iPosBegin = 0,iPosEnd = 0;
	    String sAttributeID = "",sAttributeValue = "";
	    Object oTmp = null;
	    String sReturn = sSource;
	    try{
	        while((iPosBegin = sReturn.indexOf(sBeginIdentifier, iPosBegin)) >= 0){
	            iPosEnd = sReturn.indexOf(sEndIdentifier, iPosBegin);
	            sAttributeID = sReturn.substring(iPosBegin + sBeginIdentifier.length(), iPosEnd);
	            oTmp = vpAttributes.get(sAttributeID);
	            if(oTmp == null){
	                iPosBegin = iPosEnd;
	            }else{
	                sAttributeValue = (String)oTmp;
	                sReturn = sReturn.substring(0, iPosBegin) + sAttributeValue + sReturn.substring(iPosEnd + sEndIdentifier.length());
	            }
	        }
	    }catch(Exception ex){
	        throw new Exception("\u5B8F\u66FF\u6362\u9519\u8BEF:" + ex.toString());
	    }
	    return sReturn;
    }
}

