/*
		Author: --djia 2010-08-05
		Tester:
		Describe: --探测调查报告中
		Input Param:
				ObjectType: 对象类型
				ObjectNo: 对象编号
		Output Param:
				Message：风险提示信息
		HistoryLog:
*/

package com.amarsoft.app.check;

import java.util.StringTokenizer;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


public class CheckReportRisk extends AlarmBiz 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		String sMessage="",s="";
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		SqlObject so = null;//声明对象
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";

		String sSql = " select distinct DocID from FORMATDOC_DATA where ObjectNo =:ObjectNo and ObjectType =:ObjectType ";
		so = new SqlObject(sSql);
        so.setParameter("ObjectNo", sObjectNo);
        so.setParameter("ObjectType", sObjectType);
		String sDocID = Sqlca.getString(so);
		if(sDocID == null) sDocID = "";
		
		ASResultSet rs  = null; 
		StringTokenizer st = null;
	    String sDirID = "";
	    String sTemp = "";

	    sSql = "select distinct DefaultValue from FORMATDOC_PARA where DocID =:DocID"; 
	    so = new SqlObject(sSql);
        so.setParameter("DocID", sDocID);
 		rs = Sqlca.getASResultSet(so);
	    
		if(rs.next()) sTemp = rs.getString(1);
		rs.getStatement().close();
		
		if((sTemp == null) || (sTemp.length() == 0)) sTemp = "   ";
		st = new StringTokenizer(sTemp,",");
		while(st.hasMoreTokens())
		{	
			s=st.nextToken();
			sDirID += "'"+s+"',";
			
		}
		sDirID = sDirID.substring(0,sDirID.length()-1);

		sSql = " select FD.TreeNo,FD.DirName from FORMATDOC_DATA FD,FORMATDOC_DEF FF where FD.DirID = FF.DirID and FF.DocID =:DocID  and FF.DirID IN ("+ sDirID +") and FF.Attribute1 = '1' and FD.ObjectNo =:ObjectNo and FD.ContentLength=0";
		so = new SqlObject(sSql);
        so.setParameter("DocID", sDocID);
        so.setParameter("ObjectNo", sObjectNo);
		ASResultSet rsData = Sqlca.getASResultSet(so);
		sTemp = "";
		while(rsData.next())
		{
			sTemp += rsData.getString(1)+"@";  
			sTemp += rsData.getString(2)+"@";  
		}
		rsData.getStatement().close();		
		
		st = new StringTokenizer(sTemp,"@");
		int iCount = st.countTokens()/2;
		String[] sTreeNo = new String[iCount];
		String[] sDirName = new String[iCount];
		int i = 0;
		while(st.hasMoreTokens())
		{
			sTreeNo[i] = st.nextToken();
			sDirName[i] = st.nextToken();
			i++;
		}

		for(i=0;i<iCount;i++)
		{
			sMessage=sDirName[i]+" 没有录入数据！";
			putMsg(sMessage);
		}
		
              
        /** 返回结果处理 **/
        if( iCount > 0 || sDocID == null || sDocID.length() == 0){
            setPass(false);
        }else{
            setPass(true);
        }
        
        return null;
	 }
	 

}
