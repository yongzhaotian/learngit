<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zbdeng 2004.02.12
 * Tester:
 *
 * Content: 业务检查显示 
 * Input Param:
 *	    CustomerID：客户代码
 *      Flag：风险探测结果  
 * Output param:
 *	
 * History Log: zywei 2005/08/01

 */
%>

<html>
<head>
<title>自动风险探测结果</title>
</head>
<body>
<br>
<table align="center" width="100%" >
	<tr>
		<td>
			<font face="Geneva, Arial, Helvetica, sans-serif, 华文中宋">
				<strong>
					检查结果提示如下： 
				</strong>
			</font>
		</td>
	</tr>
	
</table> 
<br>
<table width="100%" border="1" cellspacing="0" cellpadding="3"  bordercolordark="#EAEAEA">

<%
	//获得风险探测结果
	String sExistFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));	
	if (sExistFlag == null)  sExistFlag = "";
			
	int i = 0,iCount = 0;
	StringTokenizer st = new StringTokenizer(sExistFlag,"@");
	String [] sRiskTip = new String[st.countTokens()];  
	while (st.hasMoreTokens()) 
	{
		sRiskTip[i] = st.nextToken();                
		i ++;
	}
	
	String sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt=''>&nbsp;";
       
	for(int j = 0 ; j < sRiskTip.length ; j ++)
	{
	    iCount = iCount + 1;	   
	    out.println("<tr  height=20px><td nowrap align=\"left\" class=\"black9pt\">"+sTipsFlag+"<font color=red>"+iCount+"、&nbsp&nbsp"+sRiskTip[j]+"</font></tr></td>");
	}
	  
%>
	<tr>
		<td align = "center" valign = "bottom"  nowrap height=100px class="black9pt"  > 
       		 	<input type="button" style="width:70px"  value=" 关  闭 " class="button" onClick="javascipt:self.close()">
    		</td>
	</tr>
</table>
</body>
</html>


<%@ include file="/IncludeEnd.jsp"%>
