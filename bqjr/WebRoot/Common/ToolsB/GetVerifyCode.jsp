<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:Thong 2005.8.29 15:20
		Tester:
		Content: �Ժ�̨У����Ĵ��� �����ϵ�ǰ����ʾ  
		Input Param:	sKindCode	��������ݵ�CODENO�ֶν���һ��һ�Ƚ�
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "У�����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql;
	String sInputUser; //������	
	String sKindCode; //����޶���
	Hashtable ht = new Hashtable();
	String sItemNo;
	String sKindItem;
	ASResultSet rs = null;
	//����������	
	sKindCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("KindCode"));

	sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	if(sInputUser==null) sInputUser="";
	//���ҳ�����	
	//sParameter =  DataConvert.toRealString(iPostChange,(String)request.getParameter("Parameter"));
%>
<%/*~END~*/%>
<html>
<head>
<title>����У��</title>
<body>
<%
	ht = (Hashtable)session.getAttribute("equalsed");

	if("IndustryType".equals(sKindCode)){
		sSql = "select ItemNo from Code_library where CodeNo = :CodeNo and Length(ItemNo)=1";
	}else{
		sSql = "select ItemNo from Code_library where CodeNo = :CodeNo";
	}
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CodeNo",sKindCode));
%>
	<table width="80%" cellpadding="10" align='center'>
		<tr>
			<td>Code_Library���ֶ�ItemNo</td>
			<td>Limiy_Info���ֶ�Kindtem</td>
		</tr>
<%	
	while(rs.next())
	{
		if(ht.get(rs.getString(1)) != null)
		{
			sItemNo = rs.getString(1).trim();
			sKindItem = ht.get(sItemNo).toString().trim();
%>
		<tr>
			<td><%=sItemNo%></td>
			<td><%=sKindItem%></td>
		</tr>

<%
		}
	}
	rs.getStatement().close();	
%>
        <tr>
            <td align="right">
                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","����","�����ұ��ֶ�","javascript: saveRecord()",sResourcesPath)%>
            </td>
            <td align="left">
                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȡ��","ȡ��","javascript: Cancel()",sResourcesPath)%>
            </td>
        </tr>
</table>	
</body>
</head>
</html>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		PopPage("/LimitManage/SetBaseConfigAction.jsp","KindCode=<%=sKindCode%>","");
		self.close();
	}
	function Cancel()
	{
		self.close();
	}
	</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
