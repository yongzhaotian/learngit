<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
	<%
	/*
		Author:   FSGong  2004.12.22
		Content: ���պ�����ҳ��
		Input Param:
			        SerialNo:��ծ�ʲ�������ˮ��
					ApplyType:����������
						
		Output param:
		
		History Log: 
	 */
	%>
<html>
<head>
<title>���պ�����</title>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" onload="" >
<table border="1" width="100%" height="100%" cellspacing="3" cellpadding="0">
  <tr height="50%"> 
    <td> <iframe name="rightup" scrolling="no"  src="<%=sWebRootPath%>/Blank.jsp" width=100% height=100% frameborder=0></iframe> 
    </td>
  </tr>

<td>
	��ͬ��ش��պ��б�
</td>

  <tr height="50%"> 
    <td> <iframe name="rightdown" scrolling="no"  src="<%=sWebRootPath%>/Blank.jsp?TextToShow=�����Ϸ��б���ѡ��һ��" width=100% height=100% frameborder=0></iframe> 
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
	OpenPage("/Blank.jsp?TextToShow=�����Ϸ���ͬ�б���ѡ��һ����Ϣ���Թ۲������δ��պ����","rightdown","");
</script>

<%@ include file="/IncludeEnd.jsp"%>