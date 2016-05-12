<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 20050826
		Tester:
		Content: 选择树型对话框页面
		Input Param:
			SelName：查询名称
			ParaString：参数字符串
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获取参数：查询名称和参数
	String sSelName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParaString"));
	sParaString = (sParaString == null)?"":java.net.URLDecoder.decode(sParaString, "UTF-8");
	
	//将空值转化为空字符串
	if(sSelName == null) sSelName = "";
	if(sParaString == null) sParaString = "";
		
	//定义变量：查询结果集
	ASResultSet rs = null;
	//定义变量：SQL语句
	String sSql = "";
	//定义变量：查询类型、展现方式、参数、隐藏域
	String sSelType = "",sSelBrowseMode = "",sSelArgs = "",sSelHideField = "";
	//定义变量：代码、字段显示中文名称、表名、主键
	String sSelCode = "",sSelFieldName = "",sSelTableName = "",sSelPrimaryKey = "";
	//定义变量：字段显示风格、返回值、过滤字段、选择方式
	String sSelFieldDisp = "",sSelReturnValue = "",sSelFilterField = "",sMultiOrSingle = "";
	//定义变量：属性1、属性2、属性3、属性4、属性5
	String sAttribute1 = "",sAttribute2 = "",sAttribute3 = "",sAttribute4 = "",sAttribute5 = "";
	//定义变量：数组长度
	int l = 0;
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "选择信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义业务逻辑;]~*/%>
<%
	sSql =  " select SelType,SelTableName,SelPrimaryKey,SelBrowseMode,SelArgs,SelHideField,SelCode, "+
			" SelFieldName,SelFieldDisp,SelReturnValue,SelFilterField,MUTILORSINGLE,Attribute1, "+
			" Attribute2,Attribute3,Attribute4,Attribute5 "+
			" from SELECT_CATALOG "+
			" where SelName =:SelName "+
			" and IsInUse = '1' ";
	rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SelName",sSelName));
	if(rs.next()){
		sSelType = rs.getString("SelType");
		sSelTableName = rs.getString("SelTableName");
		sSelPrimaryKey = rs.getString("SelPrimaryKey");
		sSelBrowseMode = rs.getString("SelBrowseMode");
		sSelArgs = rs.getString("SelArgs");
		sSelHideField = rs.getString("SelHideField");
		sSelCode = rs.getString("SelCode");
		sSelFieldName = rs.getString("SelFieldName");
		sSelFieldDisp = rs.getString("SelFieldDisp");
		sSelReturnValue = rs.getString("SelReturnValue");
		sSelFilterField = rs.getString("SelFilterField");
		sMultiOrSingle = rs.getString("MUTILORSINGLE");
		sAttribute1 = rs.getString("Attribute1");
		sAttribute2 = rs.getString("Attribute2");
		sAttribute3 = rs.getString("Attribute3");
		sAttribute4 = rs.getString("Attribute4");
		sAttribute5 = rs.getString("Attribute5");
	}
	rs.getStatement().close();

	//将空值转化为空字符串
	if(sSelType == null) sSelType = "";
	if(sSelTableName == null) sSelTableName = "";
	if(sSelPrimaryKey == null) sSelPrimaryKey = "";
	if(sSelBrowseMode == null) sSelBrowseMode = "";
	if(sSelArgs == null) sSelArgs = "";
	else sSelArgs = sSelArgs.trim();
	if(sSelHideField == null) sSelHideField = "";
	else sSelHideField = sSelHideField.trim();
	if(sSelCode == null) sSelCode = "";
	else sSelCode = sSelCode.trim();	
	if(sSelFieldName == null) sSelFieldName = "";
	else sSelFieldName = sSelFieldName.trim();
	if(sSelFieldDisp == null) sSelFieldDisp = "";
	else sSelFieldDisp = sSelFieldDisp.trim();
	if(sSelReturnValue == null) sSelReturnValue = "";
	else sSelReturnValue = sSelReturnValue.trim();
	if(sSelFilterField == null) sSelFilterField = "";
	else sSelFilterField = sSelFilterField.trim();
	if(sMultiOrSingle == null) sMultiOrSingle = "Single";
	if(sAttribute1 == null) sAttribute1 = "";
	if(sAttribute2 == null) sAttribute2 = "";
	if(sAttribute3 == null) sAttribute3 = "";
	if(sAttribute4 == null) sAttribute4 = "";
	if(sAttribute5 == null) sAttribute5 = "";
	
	//获取返回值
	StringTokenizer st = new StringTokenizer(sSelReturnValue,"@");
	String [] sReturnValue = new String[st.countTokens()];  
	while (st.hasMoreTokens()) {
		sReturnValue[l] = st.nextToken();                
		l ++;
	}
	//设置显示标题
	String sHeaders = sSelFieldName;
	
	//将Sql中的变量用相对应的值替换	
	StringTokenizer stArgs = new StringTokenizer(sParaString,",");
	while (stArgs.hasMoreTokens()) {
		try{
			String sArgName  = stArgs.nextToken().trim();
			String sArgValue  = stArgs.nextToken().trim();		
			int i = sSelCode.indexOf("#"+sArgName);
			if(i > 2 && sSelCode.substring(0,i-2).trim().toUpperCase().endsWith("IN"))
				sSelCode = StringFunction.replace(sSelCode,"#"+sArgName,sArgValue.replaceAll("@","','"));	
			else
			sSelCode = StringFunction.replace(sSelCode,"#"+sArgName,sArgValue );		
		}catch(NoSuchElementException ex){
			throw new Exception("输入参数格式错误！");
		}
	}
	
%>

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义业务逻辑;]~*/%>
<html>
<head> 
<title><%=PG_TITLE%></title>

<script type="text/javascript">
	function TreeViewOnClick(){
		if("single"=="<%=sMultiOrSingle.toLowerCase()%>"){
			clickSingle();
		}
	}
	function clickSingle(){
		var sType = getCurTVItem().type;
		var sName = getCurTVItem().name;
		var sValue = getCurTVItem().value;
		if(sValue == "root"){
			buff.ReturnString.value = "root";
		}else{
			if(sType == "page" && "<%=sAttribute2%>" == '2'){
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.sObjectInfo = buff.ReturnString.value;
			}else if("<%=sAttribute2%>" == '1'){
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.sObjectInfo = buff.ReturnString.value;
			}else{
				alert("页节点信息不能选择，请重新选择！");
			}
		}
	}
	
	/* 弹出多选树图时，得到选择的多条数据    2014/03/19  */
	function getMulti(){
		if("single"=="<%=sMultiOrSingle.toLowerCase()%>"){
			return;
		}
		var items = getCheckedTVItems();
		for(var ii=0; ii<items.length; ii++){
			var item = items[ii];
			if(item.type=="folder") continue;
			if(buff.ReturnString.value==null || buff.ReturnString.value==""){
				buff.ReturnString.value = item.value + "@" + item.name;
			}else{
				buff.ReturnString.value = buff.ReturnString.value + "~"+ item.value + "@" + item.name;
			}
		}
		parent.sObjectInfo = buff.ReturnString.value;
	}
	
	//新增树图双击事件响应函数 add by hwang 20090601
	function TreeViewOnDBLClick(){
		var sType = getCurTVItem().type;
		var sName = getCurTVItem().name;
		var sValue = getCurTVItem().value;
		if(sValue == "root"){
			buff.ReturnString.value = "root";
		}else{
			if(sType == "page" && "<%=sAttribute2%>" == '2'){
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.returnValue = buff.ReturnString.value;
				top.close();
			}else if("<%=sAttribute2%>" == '1'){
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.returnValue = buff.ReturnString.value;
				top.close();
			}else{
				alert("页节点信息不能选择，请重新选择！");			
			}
		}
	}	
	
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"选择信息列表","right");
		tviTemp.TriggerClickEvent=true;		
		if( "Multi".equalsIgnoreCase(sMultiOrSingle)){
			tviTemp.MultiSelect = true;
		}
		
		//参数从左至右依次为：
		//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
		tviTemp.initWithSql(sSelHideField,sSelFieldDisp,sSelFieldName,"","",sSelCode,sSelFilterField,Sqlca);		
		
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		out.println(tviTemp.generateHTMLTreeView());
	%>
		expandNode('root');
		<%
		int j = sAttribute1.split("@").length;
		String sExportNode[] = new String[20];
		sExportNode = sAttribute1.split("@");
		for(int i=0;i<j;i++){
		%>
			try{
				expandNode('<%=sExportNode[i]%>');		
			}catch(e){ }
		<%
		}
		%>
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<body class="pagebackground">
	<form name="buff">
		<input type="hidden" name="ReturnString" value="">
		<table width="100%" height="100%" border='0' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
			<tr> 
   				<td id="myleft"  align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
			</tr>
		</table>
	</form>
</body>
<script>
	startMenu();	
</script>
</html>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>