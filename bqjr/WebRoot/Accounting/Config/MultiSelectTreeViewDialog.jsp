<%@ page contentType="text/html; charset=GBK"%>
<script>
var multiTreeSelectFlag=true;
</script>
<%@ include file="/IncludeBegin.jsp"%>


<%
	//获取参数：查询名称和参数
	String sSelName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParaString"));
	String sSelectedValue = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelectedValue"));
	//将空值转化为空字符串
	if(sSelName == null) sSelName = "";
	if(sParaString == null) sParaString = "";
	if(sSelectedValue == null) sSelectedValue = "";
		
	//定义变量：查询结果集
	ASResultSet rs = null;
	//定义变量：SQL语句
	String sSql = "";
	//定义变量：查询类型、展现方式、参数、隐藏域
	String sSelType = "",sSelBrowseMode = "",sSelArgs = "",sSelHideField = "";
	//定义变量：代码、字段显示中文名称、表名、主键
	String sSelCode = "",sSelFieldName = "",sSelTableName = "",sSelPrimaryKey = "";
	//定义变量：字段显示风格、返回值、过滤字段、选择方式
	String sSelFieldDisp = "",sSelReturnValue = "",sSelFilterField = "",sMutilOrSingle = "";
	//定义变量：属性1、属性2、属性3、属性4、属性5
	String sAttribute1 = "",sAttribute2 = "",sAttribute3 = "",sAttribute4 = "",sAttribute5 = "";
	//定义变量：数组长度
	int l = 0;
	
%>

	<%
	String PG_TITLE = "选择信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%
	
	sSql =  " select SelType,SelTableName,SelPrimaryKey,SelBrowseMode,SelArgs,SelHideField,SelCode, "+
			" SelFieldName,SelFieldDisp,SelReturnValue,SelFilterField,MutilOrSingle,Attribute1, "+
			" Attribute2,Attribute3,Attribute4,Attribute5 "+
			" from SELECT_CATALOG "+
			" where SelName = '"+sSelName+"' "+
			" and IsInUse = '1' ";
	rs = Sqlca.getResultSet(sSql);
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
		sMutilOrSingle = rs.getString("MutilOrSingle");
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
	if(sMutilOrSingle == null) sMutilOrSingle = "";
	if(sAttribute1 == null) sAttribute1 = "";
	if(sAttribute2 == null) sAttribute2 = "";
	if(sAttribute3 == null) sAttribute3 = "";
	if(sAttribute4 == null) sAttribute4 = "";
	if(sAttribute5 == null) sAttribute5 = "";
	
	//获取返回值
	StringTokenizer st = new StringTokenizer(sSelReturnValue,"@");
	String [] sReturnValue = new String[st.countTokens()];  
	while (st.hasMoreTokens()) 
	{
		sReturnValue[l] = st.nextToken();                
		l ++;
	}
	//设置显示标题
	String sHeaders = sSelFieldName;
	
	//将Sql中的变量用相对应的值替换	
	StringTokenizer stArgs = new StringTokenizer(sParaString,",");
	while (stArgs.hasMoreTokens()) 
	{
		try{
			String sArgName  = stArgs.nextToken().trim();
			String sArgValue  = stArgs.nextToken().trim();		
			sSelCode = StringFunction.replace(sSelCode,"#"+sArgName,sArgValue );		
		}catch(NoSuchElementException ex){
			throw new Exception("输入参数格式错误！");
		}
	}
	
%>

<html>
<head> 
<title><%=PG_TITLE%></title>

<script language=javascript>
	function TreeViewOnClick()
	{		
		var sType = getCurTVItem().type;
		var sName = getCurTVItem().name;
		var sValue = getCurTVItem().value;
		if(sValue == "root")
		{
			buff.ReturnString.value = "root";
		}else
		{
			if(sType == "page" && "<%=sAttribute2%>" == '2')
			{
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.sObjectInfo = buff.ReturnString.value;
			}else if("<%=sAttribute2%>" == '1')
			{	
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.sObjectInfo = buff.ReturnString.value;
			}else
			{
				alert("页节点信息不能选择，请重新选择！");
			}
		}
	}
	
	//新增树图双击事件响应函数 
	function TreeViewOnDBLClick()
	{
		var sType = getCurTVItem().type;
		var sName = getCurTVItem().name;
		var sValue = getCurTVItem().value;
		if(sValue == "root")
		{
			buff.ReturnString.value = "root";
		}else
		{
			if(sType == "page" && "<%=sAttribute2%>" == '2')
			{
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.returnValue = buff.ReturnString.value;
				self.close();
			}else if("<%=sAttribute2%>" == '1')
			{	
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.returnValue = buff.ReturnString.value;
				self.close();
			}else
			{
				alert("页节点信息不能选择，请重新选择！");			
			}
		}
	}	
	
	function getMultiTreeValue(){
		var ids="";
		var names="";
		for(ik=1;ik<nodes.length;ik++){
			if(nodes[ik].checked){
				ids+=nodes[ik].value+",";
				names+=nodes[ik].name+",";
			}
		}
		if(ids.length>0) ids=ids.substring(0, ids.length-1);
		if(names.length>0) names=names.substring(0, names.length-1);
		return ids+"@"+names;
	}
	
	function setMultiTreeValue(sTreeValueList){
		var ids="";
		var names="";
		
		sTreeValueList = ","+sTreeValueList+",";
		for(ik=1;ik<nodes.length;ik++){
			if(sTreeValueList.indexOf(","+nodes[ik].value+",")>=0){
				var nodeID = nodes[ik].id;
				try{
					setCheckTVItem(nodeID,true);
				}
				catch(e){}
			}
		}
		if(ids.length>0) ids=ids.substring(0, ids.length-1);
		if(names.length>0) names=names.substring(0, names.length-1);
		return ids+"@"+names;
	}
	
	function startMenu() 
	{
		multiTreeSelectFlag=true;
	<%
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"选择信息列表","right");
		tviTemp.TriggerClickEvent=true;
		tviTemp.MultiSelect=true;
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
		for(int i=0;i<j;i++)
		{
		%>
			try{
				expandNode('<%=sExportNode[i]%>');		
			}catch(e)
			{
	
			}
		<%
		}
		%>
		
		setMultiTreeValue("<%=sSelectedValue%>");
	}
	
	
</script>
<style>

.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}

</style>
</head>

<body class="pagebackground">
	<center>
		<form  name="buff">
		<input type="hidden" name="ReturnString" value="">
			<table width="90%" border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
				<tr> 
        				<td id="myleft"  align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
				</tr>
				<tr>
					<td nowarp bgcolor="" height="25" align=center> 
						<input type="button" name="ok" value="确认" onClick="javascript:returnSelection()"  border='1'>
						<input type="button" name="ok" value="清空" onClick="javascript:clearAll()"  border='1'>
						<input type="button" name="Cancel" value="取消" onClick="javascript:doCancel();" border='1'>
					</td>
				</tr>
			</table>
		</form>
	</center>
</body>
<script>
	function returnSelection()
	{
		var returnValue=getMultiTreeValue();
		if(returnValue==""){
			if(confirm("您尚未进行选择，确认要返回吗？")){
				returnValue="_NONE_";
			}else{
				return;
			}
			
		}
		self.returnValue=returnValue;
		self.close();
	}
	
	function clearAll()
	{
		self.returnValue='_CLEAR_';
		self.close();
	
	}
	
	function doCancel()
	{
		self.returnValue='_CANCEL_';
		self.close();
	}
	
	startMenu();	
</script>
</html>


<%@ include file="/IncludeEnd.jsp"%>