<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-20
		Tester:
		Content: 数据库连接管理列表
		Input Param:
                    DBConnID：    数据库连接编号
                    DBConnName：  数据库连接名称
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "数据库连接管理列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	
	//获得组件参数	

	//获得页面参数	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
   	String sHeaders[][] = {
				{"DBConnectionID","DBConnectionID"},
				{"DBConnectionName","DBConnectionName"},
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
				"From REG_DBCONN_DEF where 1=1";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_DBCONN_DEF";
	doTemp.setKey("DBConnectionID",true);
	doTemp.setHeader(sHeaders);

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

	//查询
 	doTemp.setColumnAttribute("DBConnectionID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
   
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
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
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
        sReturn=popComp("DBConnInfo","/Common/Configurator/DBConnManage/DBConnInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            //新增数据后刷新列表
            if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
            {
                sReturnValues = sReturn.split("@");
                if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
                {
                    reloadSelf(); 
                }
            }
        }
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sDBConnID = getItemValue(0,getRow(),"DBConnectionID");
        if(typeof(sDBConnID)=="undefined" || sDBConnID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        
        sReturn=popComp("DBConnInfo","/Common/Configurator/DBConnManage/DBConnInfo.jsp","DBConnID="+sDBConnID,"");
        //修改数据后刷新列表
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
            sReturnValues = sReturn.split("@");
            if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
            {
                reloadSelf();
            }
        }
	}
    
    /*~[Describe=查看及修改代码详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEditCode()
	{
        sDBConnID = getItemValue(0,getRow(),"DBConnectionID");
        if(typeof(sDBConnID)=="undefined" || sDBConnID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
        OpenPage("/Common/Configurator/DBConnManage/DBConnList.jsp?DBConnID="+sDBConnID,"_self","");    
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sDBConnID = getItemValue(0,getRow(),"DBConnectionID");
        if(typeof(sDBConnID)=="undefined" || sDBConnID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
            return ;
		}
		
		if(confirm(getHtmlMessage('46'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
	function mySelectRow()
	{
        
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
