<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
	<%
	/*
		Author:   FSGong  2004.12.22
		Content: 催收函关联页面
		Input Param:
			        SerialNo:抵债资产申请流水号
					ApplyType:申请子类型
						
		Output param:
		
		History Log: 
	 */
	%>
<html>
<head>
<title>催收函管理</title>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >
<table border="1" width="100%" height="100%" cellspacing="3" cellpadding="0">
  <tr height="50%"> 
    <td> <iframe name="rightup" scrolling="no"  src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0></iframe> 
    </td>
  </tr>

<td>
	合同相关催收函列表
</td>

  <tr height="50%"> 
    <td> <iframe name="rightdown" scrolling="no"  src="<%=sWebRootPath%>/Blank.jsp?TextToShow=请在上方列表中选择一项" width=100% height=100% frameborder=0></iframe> 
    </td>
  </tr>
</table>
</body>
</html>

<%
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sPropertyType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PropertyType"));
%>

<script type="text/javascript">
	sObjectType="<%=sObjectType%>";
	sPropertyType="<%=sPropertyType%>";
	OpenComp("DunManageList","/RecoveryManage/DunManage/DunManageList.jsp","PropertyType="+sPropertyType+"&ObjectType="+sObjectType,"rightup","");
	OpenPage("/Blank.jsp?TextToShow=请在上方合同列表中选择一条信息，以观察其历次催收函情况","rightdown","");
</script>

<%@ include file="/IncludeEnd.jsp"%>