<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%  
    String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));

	//���������������ʱ��
   	String sSql = "Update FLOW_TASK set EndTime=:EndTime where SerialNo=:SerialNo";
	Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo",sSerialNo).setParameter("EndTime",StringFunction.getToday()));	
%>

<%@ include file="/IncludeEndAJAX.jsp"%>