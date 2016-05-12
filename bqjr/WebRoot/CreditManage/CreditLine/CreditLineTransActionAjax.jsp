<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Content:   额度项下业务转移动作
 */
%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	String sSerialNo    = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo")); 
	String sLineID      = DataConvert.toRealString(iPostChange,CurPage.getParameter("LineID"));
	if(sSerialNo==null) sSerialNo="";
	if(sLineID==null) sLineID="";
	
	String sSql="",sReturnValue="";
	String sSerialNo1[]=sSerialNo.split(",");
	SqlObject so = null;
	try{
		for(int m=0;m<sSerialNo1.length;m++){
			//sSql=" UPDATE BUSINESS_CONTRACT  SET CreditAggreement='"+sLineID+"'  WHERE  SerialNo='"+sSerialNo1[m]+"'";
			sSql=" UPDATE BUSINESS_CONTRACT  SET CreditAggreement=:CreditAggreement  WHERE  SerialNo=:SerialNo";
			so = new SqlObject(sSql).setParameter("CreditAggreement",sLineID).setParameter("SerialNo",sSerialNo1[m]);
			Sqlca.executeSQL(so);
		}
		sReturnValue="true";
	}catch(Exception e){
		sReturnValue="false";
		throw new Exception("事务处理失败！"+e.getMessage());
	}
	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>