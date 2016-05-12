package com.amarsoft.app.lending.bizlets;

import java.util.StringTokenizer;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateColValue extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//��������ʽ��"����1,����2"��
		String sColName = (String)this.getAttribute("ColName");
		if(sColName == null) sColName = "";
		//����
		String sTableName = (String)this.getAttribute("TableName");
		if(sTableName == null) sTableName = "";
		//��ѯ��������ʽ��"����,����,��ֵ"��
		String sWhereClause = (String)this.getAttribute("WhereClause");
		if(sWhereClause == null) sWhereClause = "";
		//�����ַ����������ַ����������ַ���
		String sColStr = "",sTableStr = "",sWhereStr = "";
		//SQL��䡢����ֵ
		String sSql = "",sReturnValue = "";
		//������i��������j��������m
		int i = 0,j = 0,m = 0;
		
		//�������
		StringTokenizer stColArgs1 = new StringTokenizer(sColName,"~");
		String [] stColArgsCount = new String[stColArgs1.countTokens()];
		while (stColArgs1.hasMoreTokens()) 
		{
			sColStr = "";
			StringTokenizer stColArgs2 = new StringTokenizer(stColArgs1.nextToken().trim(),"@");
			while(stColArgs2.hasMoreTokens())
			{				
				String sColArgType  = stColArgs2.nextToken().trim();				
				String sColArgName  = stColArgs2.nextToken().trim();				
				String sColArgValue  = stColArgs2.nextToken().trim();	
				
				if (sColArgType.equals("String"))
				{
					if(sColArgValue.equals("None"))
						sColStr = sColStr + sColArgName + " = " + "null";
					else
						sColStr = sColStr + sColArgName + " = " + "'" + sColArgValue + "'";
				}else if (sColArgType.equals("Number"))
				{
					if(sColArgValue.equals("None"))
						sColStr = sColStr + sColArgName + " = " + "0";
					else
						sColStr = sColStr + sColArgName + " = " + sColArgValue;
				}else if (sColArgType.equals("Date"))
				{
					if(sColArgValue.equals("None"))
						sColStr = sColStr + sColArgName + " = " + "null";
					else
						sColStr = sColStr + sColArgName + " = " + "'" + sColArgValue + "'";
				}
				sColStr = sColStr + ", ";				
			}
			if(sColStr.length() > 0)
				sColStr = sColStr.substring(0,sColStr.length()-2);			
			stColArgsCount[i] = sColStr;
			i++;			
		}
				
		//��ֱ���
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
		
		//�������
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
					sWhereStr = sWhereStr +  sArgName + " = " + "'" + sArgValue + "'";
				}else if (sArgType.equals("Number"))
				{
					sWhereStr = sWhereStr + sArgName + " = " + sArgValue;
				}else if (sArgType.equals("None"))
				{
					sWhereStr = sWhereStr +  sArgName +  " = " + sArgValue;
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
			try{
				sSql = sSql + " update " + stTableArgsCount[n] + " set " + stColArgsCount[n] + " where " + stWhereArgsCount[n];
				Sqlca.executeSQL(sSql);
				sReturnValue = "TRUE";
			}catch(Exception e)
			{
				sReturnValue = "FALSE";
				throw e;
			}
		}
		
		return sReturnValue;
	}

}
