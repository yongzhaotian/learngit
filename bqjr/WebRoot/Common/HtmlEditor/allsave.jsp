<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   
 * Tester:
 * Content: 
 * Input Param:
 *	                            
 * Output param:
 *                             	
 * History Log:  
 *
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//获取参数：
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sDocID = DataConvert.toRealString(iPostChange,(String)request.getParameter("DocID"));
	String sOrderID = DataConvert.toRealString(iPostChange,(String)request.getParameter("OrderID"));	
	String sDirID = DataConvert.toRealString(iPostChange,(String)request.getParameter("DirID"));
	String sSerialNo1 = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo1"));	
	String sContentLength = DataConvert.toRealString(iPostChange,(String)request.getParameter("ContentLength"));		
		
	sDocID = sOrderID.substring(0,2);
	sDirID = sOrderID.substring(2,7);
	String sOrderIDTop = sDocID+sDirID+"OWC";
	String sOrderIDDown = sDocID+sDirID+"EDIT";
	//hxli 审查报告sSerialNo增加了v1%,这里要去掉.
	sSerialNo = sSerialNo.substring(0,12);	
	String sMethod = "";// 第一次打开:1   保存:2
	sMethod = DataConvert.toRealString(iPostChange,(String)request.getParameter("Method"));
	if(sMethod==null) sMethod="1";
	
	String sReportData1 = "", sReportData2 = ""; //存放数据
	sReportData1 = DataConvert.toRealString(iPostChange,(String)request.getParameter("ReportData1"));
	sReportData2 = DataConvert.toRealString(iPostChange,(String)request.getParameter("ReportData2"));
	if(sReportData1==null) sReportData1=" ";
	if(sReportData2==null) sReportData2=" ";
		
	//获得借款人姓名
	ASResultSet rs = null;
	String sSql = "",sCustomerName = "";
	
	sSql =" select CustomerID,enterprisename "+
			" from ent_info where customerid "+
			" in ( select customerid from BUSINESS_APPLY where serialno=:serialno)";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("serialno",sSerialNo));
	if(rs.next())
	{
		sCustomerName = rs.getString("enterprisename");
		if(sCustomerName == null) sCustomerName=" ";
	}
	rs.getStatement().close();	
	
	if(sMethod.equals("2")) //save
	{
		byte abyte1[] = sReportData1.getBytes("GBK");
		byte abyte2[] = sReportData2.getBytes("GBK");

		String sUpdate1 = " update FORMATDOC_DATA set HtmlData=?,ContentLength=? " +
					     " where SerialNo='"+sSerialNo+"' and OrderID='"+sOrderIDTop+"'";
        PreparedStatement pre1 = Sqlca.getConnection().prepareStatement(sUpdate1);
        pre1.clearParameters();
        pre1.setBinaryStream(1, new ByteArrayInputStream(abyte1,0,abyte1.length), abyte1.length);
        pre1.setInt(2, abyte1.length);
        pre1.executeUpdate();
        pre1.close();
        
		String sUpdate2 = " update FORMATDOC_DATA set HtmlData=?,ContentLength=? " +
					     " where SerialNo='"+sSerialNo+"' and OrderID='"+sOrderIDDown+"'";
        PreparedStatement pre2 = Sqlca.getConnection().prepareStatement(sUpdate2);
        pre2.clearParameters();
        pre2.setBinaryStream(1, new ByteArrayInputStream(abyte2,0,abyte2.length), abyte2.length);
        pre2.setInt(2, abyte2.length);
        pre2.executeUpdate();
        pre2.close();

%>
<script type="text/javascript">
	alert("保存成功！");
</script>        	
<%
	}
%>	

<body class="ReportPage" leftmargin="0" topmargin="0" onload=" " >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
	<tr id="DetailTitle" class="DetailTitle" >
	    <td >
	    </td>
	</tr>
	
	<tr height=1 valign=top id="buttonback" >
		<td>
			<table>
	    	<tr>
	    		<td>
                      &nbsp;借款人名称：&nbsp;<%=sCustomerName%>

	    		</td>
	    		<td>
                       <script type="text/javascript">hc_drawButtonWithTip("保存当前内容","保存当前页的上下数据","javascript:my_save()","/cecm/Resources/6")</script>
	    		</td>
    		</tr>
	    	</table>
		</td>
	</tr>
</table>	
	
<form method='post' action='allsave.jsp' name='reportInfo'>
	<input type='hidden' name='SerialNo' value='<%=sSerialNo%>'>	
	<input type='hidden' name='ReportData1' value=''>
	<input type='hidden' name='ReportData2' value=''>
	<input type='hidden' name='Method' value='0'>
	<input type='hidden' name='Rand' value=''>
	<input type='hidden' name='OrderID' value='<%=sOrderID%>'>
	<input type='hidden' name='SerialNo1' value='<%=sSerialNo1%>'>
</form>

<script type="text/javascript">
	function my_save()
	{
		//temp = parent.frames["OWC"].document.getElementById("Spreadsheet1").HTMLData;
		temp = parent.frames["OWC"].document.getElementById("reporttable").innerHTML;

		temp = temp.replace(/"/g,"&quot;");
		reportInfo.ReportData1.value = temp;

		temp = parent.frames["EDIT"].HtmlEdit.document.body.innerHTML;
		temp = temp.replace(/"/g,"&quot;");
		temp = temp.replace(/\n/g,"");
		temp = temp.replace(/\r/g,"");
		reportInfo.ReportData2.value = temp;
                
                
		reportInfo.Method.value = "2"; //save
 
		reportInfo.Rand.value = randomNumber();
		reportInfo.submit();			
	}
</script>

<%@ include file="/IncludeEnd.jsp"%>

