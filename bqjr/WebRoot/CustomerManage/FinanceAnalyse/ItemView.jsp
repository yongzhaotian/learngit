<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  --
		Tester:	
		Content: --�ͻ����񱨱����
		Input Param:
	                 --CustomerID���ͻ���
	                 --Term �����������²������ݣ�
	                      --ReportCount ����������
	                      --AccountMonth1�����������
	                      --Scope������Χ
	                      --EntityCount���ͻ���
		Output param:
	                --CustomerID���ͻ���
	                --ReportNo:�����
			               
		History Log: 
			DATE	CHANGER		CONTENT
			2005-7-21 fbkang	�°汾�ĸ�д
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ָ�����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
    
    //���ҳ�����,�ͻ����롢Term������������������������¡�����Χ���ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sTerm       = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Term"));
	sTerm = sTerm.replace('@','&');
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ҳ��ı�д;]~*/%>
<html>
<head>
	<title>ָ�����</title>
</head>
<body class="ListPage" leftmargin="0" topmargin="0" style="overflow: auto;overflow-x:visible;overflow-y:visible" onload="" oncontextmenu="return false">
<table align='center' cellspacing=0 cellpadding=0 border=0 width=100% height="100%">
  <tr> 
       <td class='tabcontent' align='center' valign='top'>  
			<table cellspacing=0 cellpadding=4 border=0 width='100%' height='100%'>
				<tr> 
				<td valign="top" id="TabBodyTable" class="TabBodyTable">
					<iframe name="DeskTopInfo" src="" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 ></iframe>
				</td>
				</tr>
			</table> 
      </td>
  </tr>
</table>
</body>
</html>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List03;Describe=��һ������;]~*/%>
<script type="text/javascript">
	OpenPage("/CustomerManage/FinanceAnalyse/ItemDetail.jsp?CustomerID=<%=sCustomerID%><%=sTerm%>","DeskTopInfo");
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
