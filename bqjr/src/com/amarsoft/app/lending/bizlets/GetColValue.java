package com.amarsoft.app.lending.bizlets;

import java.util.StringTokenizer;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetColValue extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//列名（格式："列名1,列名2"）
		String sColName = (String)this.getAttribute("ColName");
		if(sColName == null) sColName = "";
		//表名
		String sTableName = (String)this.getAttribute("TableName");
		if(sTableName == null) sTableName = "";
		//查询条件（格式："类型,列名,列值"）
		String sWhereClause = (String)this.getAttribute("WhereClause");
		if(sWhereClause == null) sWhereClause = "";
		//列名字符串、表名字符串、条件字符串
		String sColStr = "",sTableStr = "",sWhereStr = "";
		//SQL语句、列值、返回字符串
		String sSql = "",sColValue = "",sReturnValue = "" ;
		//计数器i、计数器j、计数器m、列数
		int i = 0,j = 0,m = 0,iColCount = 0;
		//查询结果集
		ASResultSet rs = null;
		
		//拆分列名
		StringTokenizer stColArgs1 = new StringTokenizer(sColName,"~");
		String [] stColArgsCount = new String[stColArgs1.countTokens()];
		while (stColArgs1.hasMoreTokens()) 
		{
			sColStr = "";
			StringTokenizer stColArgs2 = new StringTokenizer(stColArgs1.nextToken().trim(),"@");
			while(stColArgs2.hasMoreTokens())
			{					
				String sField  = stColArgs2.nextToken().trim();
				sColStr = sColStr + sField + ",";
			}
			if(sColStr.length() > 0)
				sColStr = sColStr.substring(0,sColStr.length() - 1);
			stColArgsCount[i] = sColStr;
			i++;
		}
				
		//拆分表名
		StringTokenizer stTableArgs1 = new StringTokenizer(sTableName,"~");
		String [] stTableArgsCount = new String[stTableArgs1.countTokens()];
		while (stTableArgs1.hasMoreTokens()) 
		{
			sTableStr = "";	
			sTableStr = sTableStr + stTableArgs1.nextToken().trim();
			sTableStr = StringFunction.replace(sTableStr,"|",",");
			stTableArgsCount[j] = sTableStr;
			j++;			
		}
		
		//拆分条件
		StringTokenizer stWhereArgs1 = new StringTokenizer(sWhereClause,"~");
		String [] stWhereArgsCount = new String[stWhereArgs1.countTokens()];
		while (stWhereArgs1.hasMoreTokens()) 
		{
			sWhereStr = "";
			StringTokenizer stWhereArgs2 = new StringTokenizer(stWhereArgs1.nextToken().trim(),"@");
			while(stWhereArgs2.hasMoreTokens())
			{				
				String sArgType  = stWhereArgs2.nextToken().trim();
				String sArgName  = stWhereArgs2.nextToken().trim();
				String sArgValue  = stWhereArgs2.nextToken().trim();					
				if (sArgType.equals("String"))
				{
					sWhereStr = sWhereStr +  sArgName +  " = " + "'" + sArgValue + "'";
				}else if (sArgType.equals("Number"))
				{
					sWhereStr = sWhereStr + sArgName + " = " + sArgValue;
				}else if (sArgType.equals("None"))
				{
					sWhereStr = sWhereStr +  sArgName +  " = "  + sArgValue ;
				}else if (sArgType.equals("Date"))
				{
					sWhereStr = sWhereStr +  sArgName + " = " + "'" + sArgValue + "'";
				}
				sWhereStr = sWhereStr + " and ";				
			}
			if(sWhereStr.length() > 0)
				sWhereStr = sWhereStr.substring(0,sWhereStr.length()-4);			
			stWhereArgsCount[m] = sWhereStr;
			m++;			
		}
			
		for(int n = 0 ; n < stColArgsCount.length ; n ++)
		{
			sSql = "";
			sSql = sSql + " select " + stColArgsCount[n] + " from " + stTableArgsCount[n] + " where " + stWhereArgsCount[n];
			
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sColValue = "";
				iColCount = rs.getColumnCount();
				for(int k = 0; k< iColCount;k++)
				{
					int l = k + 1;
					sColValue += upCase(rs.getColumnName(l)) + "@";
					sColValue += rs.getString(l) + "@";				
				}
				
				sReturnValue = sReturnValue + sColValue + "~";
			}
			rs.getStatement().close();
		}
		
		return sReturnValue;
	}
	
	private static String upCase(String str)
	{	  
		String tempstr = "";
		char tempch = ' ';
		for(int i = 0; i < str.length(); i ++)
		{
			tempch = str.charAt(i);
			if(64 < str.charAt(i)&& str.charAt(i) < 91)//是大写字母
				tempch += 32;
			tempstr +=  tempch;
		}  
	return  tempstr;
	}

}
