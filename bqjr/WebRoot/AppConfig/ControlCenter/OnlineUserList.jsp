<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%

 String time=DateX.format(new java.util.Date(), "yyyy/MM/dd");

//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "OnlineUserList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow(time);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<head>
<title>�����û��б�</title>
</head>
<body class="pagebackground"  leftmargin="0" topmargin="0" onload="" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr height=1 valign=top >
    <td>
    	<table>
	    	<tr>
	    		<td>
					<%=HTMLControls.generateButton("�ر�","�ر�","javascript:top.close()",sResourcesPath)%>
	    		</td>
    		</tr>
    	</table>
    </td>
</tr>
<tr>
    <td colspan=3>
	<iframe name="myiframe0" width=100% height=100% frameborder=0></iframe>
    </td>
</tr>
</table>
</body>
</html>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	setPageSize(0,100);
	my_load(2,0,'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>