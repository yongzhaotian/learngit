<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-20
		Tester:
		Content: 数据库连接信息详情
		Input Param:
                    DBConnID：    数据库连接编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "数据库连接信息详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	
	//获得组件参数	
	String sDBConnID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DBConnID"));
	if(sDBConnID==null) sDBConnID="";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

   	String sHeaders[][] = {
				{"DBConnectionID","DBConnectionID"},
				{"DBConnectionName DBConnectionName"},
				{"ConnType","ConnType"},
				{"ContextFactory","ContextFactory"},
				{"DataSourceName","DataSourceName"},
				{"DBURL","DBURL",""},
				{"DriverClass","DriverClass"},
				{"UserID","UserID"},
				{"Password","Password"},
				{"ProviderURL","ProviderURL"},
				{"DBChange","DBChange"},
			       };  

	sSql = " Select  "+
				"DBConnectionID,"+
				"DBConnectionName,"+
				"ConnType,"+
				"ContextFactory,"+
				"DataSourceName,"+
				"DBURL,"+
				"DriverClass,"+
				"UserID,"+
				"Password,"+
				"ProviderURL,"+
				"DBChange "+ 
				"From REG_DBCONN_DEF Where DBConnectionID ='"+sDBConnID+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_DBCONN_DEF";
	doTemp.setKey("DBConnectionID",true);
	doTemp.setHeader(sHeaders);

	if (!sDBConnID.equals(""))
	{
		doTemp.setReadOnly("DBConnectionID",true);	
	}
	else
	{
		doTemp.setRequired("DBConnectionID",true);
	}
	doTemp.setHTMLStyle("DBConnectionID"," style={width:160px} ");
	doTemp.setHTMLStyle("DBConnectionName"," style={width:160px} ");
	doTemp.setHTMLStyle("ConnType"," style={width:160px} ");
	doTemp.setHTMLStyle("ContextFactory"," style={width:600px} ");
	doTemp.setHTMLStyle("DataSourceName"," style={width:160px} ");
	doTemp.setHTMLStyle("DBURL"," style={width:600px} ");
	doTemp.setHTMLStyle("UserID"," style={width:160px} ");
	doTemp.setHTMLStyle("Password"," style={width:160px} ");
	doTemp.setHTMLStyle("ProviderURL"," style={width:460px} ");
	doTemp.setHTMLStyle("DBChange"," style={width:160px} ");

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sCriteriaAreaHTML = ""; 
%>

<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
		// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回代码列表","doReturn('N')",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurDBConnID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
        as_save("myiframe0","doReturn('Y');");
	}
    
    /*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"DBConnectionID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
		    bIsInsert = true;
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
