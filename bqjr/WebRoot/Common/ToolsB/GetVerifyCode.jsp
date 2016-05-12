<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:Thong 2005.8.29 15:20
		Tester:
		Content: 对后台校验过的代码 不符合的前端显示  
		Input Param:	sKindCode	与代表内容的CODENO字段进行一对一比较
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "校验代码"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sInputUser; //排序编号	
	String sKindCode; //组合限额编号
	Hashtable ht = new Hashtable();
	String sItemNo;
	String sKindItem;
	ASResultSet rs = null;
	//获得组件参数	
	sKindCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("KindCode"));

	sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	if(sInputUser==null) sInputUser="";
	//获得页面参数	
	//sParameter =  DataConvert.toRealString(iPostChange,(String)request.getParameter("Parameter"));
%>
<%/*~END~*/%>
<html>
<head>
<title>代码校验</title>
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
			<td>Code_Library中字段ItemNo</td>
			<td>Limiy_Info中字段Kindtem</td>
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
                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","更新","更新右表字段","javascript: saveRecord()",sResourcesPath)%>
            </td>
            <td align="left">
                <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","取消","取消","javascript: Cancel()",sResourcesPath)%>
            </td>
        </tr>
</table>	
</body>
</head>
</html>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
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
