<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Author:zywei 20050826
		Tester:
		Content: 选择对话框页面
		Input Param:
		Output param:
		History Log: 
			zywei 2007/10/11 解决大数据量查询引起的响应延迟
			xhgao 2009/04/09 增加KeyFilter加快查询速度；增加双击确认
			fwang 2009/08/26 增加公共页面搜索可配置化
	 */
	String PG_TITLE = "选择信息"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//获取参数：查询名称和参数
	String sSelName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParaString"));
	sParaString = (sParaString == null)?"":java.net.URLDecoder.decode(sParaString, "UTF-8");
	//将空值转化为空字符串
	if(sSelName == null) sSelName = "";
	if(sParaString == null) sParaString = "";
		
	//定义变量：查询类型、展现方式、参数、隐藏域
	String sSelType = "",sSelBrowseMode = "",sSelArgs = "",sSelHideField = "";
	//定义变量：代码、字段显示中文名称、表名、主键
	String sSelCode = "",sSelFieldName = "",sSelTableName = "",sSelPrimaryKey = "";
	//定义变量：字段显示风格、返回值、过滤字段、选择方式
	String sSelFieldDisp = "",sSelReturnValue = "",sSelFilterField = "",sMutilOrSingle = "";
	//定义变量：显示字段对齐方式、显示字段类型、显示字段检查模式、是否根据检索条件查询、属性5、分页显示
	String sAttribute1 = "",sAttribute2 = "",sAttribute3 = "",sAttribute4 = "",sAttribute5 = "",sRemark = "";
	//定义变量：数组长度
	int l = 0;
	//定义变量：返回字段的个数
	int iReturnFiledNum = 0;
	
	String sSql =  " select SelType,SelTableName,SelPrimaryKey,SelBrowseMode,SelArgs,SelHideField,SelCode, "+
			" SelFieldName,SelFieldDisp,SelReturnValue,SelFilterField,MutilOrSingle, "+
			" Attribute1,Attribute2,Attribute3,Attribute4,Attribute5,Remark "+
			" from SELECT_CATALOG "+
			" where SelName =:SelName and IsInUse = '1' ";
	ASResultSet rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SelName",sSelName));
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
		sRemark = rs.getString("Remark");
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
	if(sRemark == null) sRemark = "";
	
	//获取返回值
	StringTokenizer st = new StringTokenizer(sSelReturnValue,"@");
	String [] sReturnValue = new String[st.countTokens()];  
	while (st.hasMoreTokens()) {
		sReturnValue[l] = st.nextToken();                
		l ++;
	}
	iReturnFiledNum = sReturnValue.length;
	//设置显示标题
	String sHeaders = sSelFieldName;
	
	//将Sql中的变量用相对应的值替换	
	StringTokenizer stArgs = new StringTokenizer(sParaString,",");
	while (stArgs.hasMoreTokens()) {
		try{
			String sArgName  = stArgs.nextToken().trim();
			String sArgValue  = stArgs.nextToken().trim();		
			sSelCode = StringFunction.replace(sSelCode,"#"+sArgName,sArgValue );		
		}catch(NoSuchElementException ex){
			throw new Exception("输入参数格式错误！");
		}
	}	
	
	//实例化DataObject	
	ASDataObject doTemp = new ASDataObject(sSelCode);
	doTemp.UpdateTable = sSelTableName;
	doTemp.setKey(sSelPrimaryKey,true);
	doTemp.setHeader(sHeaders);	
	
	//设置隐藏字段	
	if(!sSelHideField.equals("")) doTemp.setVisible(sSelHideField,false);	
	
	//设置对齐格式
	StringTokenizer stAlign = new StringTokenizer(sAttribute1,"@");
	while (stAlign.hasMoreTokens()) {
		String sAlignName  = stAlign.nextToken().trim();
		String sAlignValue  = stAlign.nextToken().trim();		
		doTemp.setAlign(sAlignName,sAlignValue);  	
	}
	
	//设置类型
	StringTokenizer stType = new StringTokenizer(sAttribute2,"@");
	while (stType.hasMoreTokens()) {
		String sTypeName  = stType.nextToken().trim();
		String sTypeValue  = stType.nextToken().trim();		
		doTemp.setType(sTypeName,sTypeValue);  	
	}
	
	//设置检查模式
	StringTokenizer stCheck = new StringTokenizer(sAttribute3,"@");
	while (stCheck.hasMoreTokens()) {
		String sCheckName  = stCheck.nextToken().trim();
		String sCheckValue  = stCheck.nextToken().trim();		
		doTemp.setCheckFormat(sCheckName,sCheckValue);  	
	}	
	
	//KeyFilter加快查询速度
	StringTokenizer stFilter = new StringTokenizer(sAttribute4,"@");
	String sFilter="";
	while (stFilter.hasMoreTokens()) {
		String sFilterValue  = stFilter.nextToken().trim();	
		sFilter=sFilter+"||"+sFilterValue;
	}
	if(sFilter.length()>2){
		doTemp.setKeyFilter(sSelPrimaryKey);
	}
	
	//设置下拉框来源
	StringTokenizer sDrawDownList = new StringTokenizer(sAttribute5,"@");
	ArrayList ddwColumn = new ArrayList();
	while (sDrawDownList.hasMoreTokens()) {
		String sFilterOptions = null;
		String sColumnList = sDrawDownList.nextToken().trim();
		String sSourceType = sDrawDownList.nextToken().trim();
		String sSource = sDrawDownList.nextToken().trim();
		if(sDrawDownList.hasMoreTokens())
			sFilterOptions = sDrawDownList.nextToken().trim(); 
		if("Code".equalsIgnoreCase(sSourceType)){
			doTemp.setDDDWCode(sColumnList,sSource);
		}else if("Sql".equalsIgnoreCase(sSourceType)){
			doTemp.setDDDWSql(sColumnList,sSource);
		}else if("CodeTable".equalsIgnoreCase(sSourceType)){
			doTemp.setDDDWCodeTable(sColumnList,sSource);
		}
		if(sFilterOptions == null) sFilterOptions = " ";
		ddwColumn.add(sColumnList+"@"+sFilterOptions);
	}	
	
	//设置显示格式
	StringTokenizer stDisp = new StringTokenizer(sSelFieldDisp,"@");
	while (stDisp.hasMoreTokens()) {
		String sDispName  = stDisp.nextToken().trim();
		String sDispValue  = stDisp.nextToken().trim();		
		doTemp.setHTMLStyle(sDispName,sDispValue);  
	}		
	
	//设置检索区
	if(!sSelFilterField.equals("")){
		String[] sColName= sSelFilterField.split(",");
		for(int i=0;i<sColName.length;i++){
			boolean executed = false;
			for(int j=0;j<ddwColumn.size();j++){
				String stColumn = ddwColumn.get(j).toString().split("@")[0].trim();
				String stOptions = "Operators="+ddwColumn.get(j).toString().split("@")[1].trim();
				
				if(stColumn.equals(sColName[i].toString())){
					doTemp.setFilter(Sqlca,"DF"+i,sColName[i],stOptions);
					executed = true;
				}
			}
			if(!executed){
				doTemp.setFilter(Sqlca,"DF"+i,sColName[i],"");
			}
		}
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	}
	
	doTemp.appendHTMLStyle(""," style=\"cursor:pointer;\" ondblclick=javascript:parent.parent.returnSelection() ");
	//费用减免申请--新增进入界面默认不查询
	if(sSelName.equals("SelectWaiveFee")){
		if(!doTemp.haveReceivedFilterCriteria()){
			doTemp.WhereClause+=" and 1=2";
		}else{
			if((doTemp.Filters.get(0).sFilterInputs[0][1] != null && doTemp.Filters.get(0).sFilterInputs[0][1] != "") && (doTemp.Filters.get(0).sFilterInputs[0][1].contains("%")||doTemp.Filters.get(0).sFilterInputs[0][1].trim().length() < 8) ){
				%>
				<script type="text/javascript">
					alert("合同号不能含有\"%\"符号且长度不能少于8位!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
			}
			if((doTemp.Filters.get(1).sFilterInputs[0][1] != null && doTemp.Filters.get(1).sFilterInputs[0][1] != "") && (doTemp.Filters.get(1).sFilterInputs[0][1].contains("%")) ){
				%>
				<script type="text/javascript">
					alert("客户名称不能含有\"%\"符号!");
				</script>
				<%
				doTemp.WhereClause+=" and 1=2";
			}
		}
	}
	
	//贷款交易申请--新增进入点击退货或利息减免默认不查询
	 if(sSelName.equals("SelectPayableLoan1")||sSelName.equals("SelectPayableLoan")){
			if(!doTemp.haveReceivedFilterCriteria()){
				doTemp.WhereClause+=" and 1=2";
			}else{
				if((doTemp.Filters.get(0).sFilterInputs[0][1] != null && doTemp.Filters.get(0).sFilterInputs[0][1] != "") && (doTemp.Filters.get(0).sFilterInputs[0][1].contains("%")||doTemp.Filters.get(0).sFilterInputs[0][1].trim().length() < 8) ){
					%>
					<script type="text/javascript">
						alert("合同号不能含有\"%\"符号且长度不能少于8位!");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2";
				}
				if((doTemp.Filters.get(1).sFilterInputs[0][1] != null && doTemp.Filters.get(1).sFilterInputs[0][1] != "") && (doTemp.Filters.get(1).sFilterInputs[0][1].contains("%")||doTemp.Filters.get(1).sFilterInputs[0][1].trim().length() < 8) ){
					%>
					<script type="text/javascript">
						alert("借据号不能含有\"%\"符号且长度不能少于8位!");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2";
				}
				if((doTemp.Filters.get(2).sFilterInputs[0][1] != null && doTemp.Filters.get(2).sFilterInputs[0][1] != "") && (doTemp.Filters.get(2).sFilterInputs[0][1].contains("%")||doTemp.Filters.get(2).sFilterInputs[0][1].trim().length() < 2) ){
					%>
					<script type="text/javascript">
						alert("客户名称不能含有\"%\"符号且长度不能少于2位!");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2";
				}
			}
		}
	
	//如果需要根据检索条件查询结果，则默认查询为空
	if(sAttribute4.equals("1") && !doTemp.haveReceivedFilterCriteria())
		doTemp.WhereClause += " and 1=2 ";
	
	if(!sMutilOrSingle.equals("Single"))
		doTemp.multiSelectionEnabled=true;
	//实例化DataWindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	int setPageSize = 15;
	if(!"".equals(sRemark)) setPageSize = Integer.parseInt(sRemark, 10);
	
	dwTemp.setPageSize(setPageSize);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	<%/*~[Describe=提交;]~*/%>	
	function doSearch(){
		document.forms["form1"].submit();
	}
	
	<%/*~[Describe=将选择行的信息拼成字符串并返回;]~*/%>	
	function mySelectRow(){
		if (getRow()<0) return;
		var sReturnValue = "";
		try{
			<%for(int j = 0 ; j < sReturnValue.length ; j ++){%>
				sReturnValue += getItemValue(0,getRow(),"<%=sReturnValue[j]%>") + "@";
			<%}%>
		}catch(e){
			return;
		}
		parent.sObjectInfo = sReturnValue; 
	}
	
	<%/*~[Describe=将选择行的信息拼成字符串并返回;]~*/%>	
	function returnValue(){
		var sReturnValue = "";
		var sMutilOrSingle = "<%=sMutilOrSingle%>";		
		if(sMutilOrSingle == "Multi")		//多选
			sReturnValue = myMultiSelectRow();
		else
			sReturnValue = mySingleSelectRow();
		
		sReturnSplit = sReturnValue.split("@"); //在返回时，只要判断第一个是undefined，就可以说明它没有选择到任何数据
		if(sReturnSplit[0]=="undefined"){		//其他项不会有undefied的。
			parent.sObjectInfo="";
		}else{
			parent.sObjectInfo = sReturnValue;
		}		
	}
	
	<%/*~[Describe=将选择行的信息拼成字符串并返回;]~*/%>	
	function mySingleSelectRow(){
		try{			
			var sReturnValue = "";			
			<%for(int j = 0 ; j < iReturnFiledNum ; j ++){%>
				sReturnValue += getItemValue(0,getRow(),"<%=sReturnValue[j]%>") + "@";
			<%}%>
		}catch(e){
			return;
		}				
		return (sReturnValue); 
	}
	
	<%/*~[Describe=将选择行的信息拼成字符串并返回;]~*/%>	
	function myMultiSelectRow(){
		try{
			var b = getRowCount(0);
			var sReturnValue = "";				
			for(var iMSR = 0 ; iMSR < b ; iMSR++){
				var a = getItemValue(0,iMSR,"MultiSelectionFlag");				
				if(a == "√"){
					<%for(int j = 0 ; j < iReturnFiledNum ; j ++){%>
						sReturnValue += getItemValue(0,iMSR,"<%=sReturnValue[j]%>") + "@";
					<%}%>
				}
			}
		}catch(e){
			return;
		}				
		return (sReturnValue); 
	}
			
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');		
</script>	
<%@ include file="/IncludeEnd.jsp"%>