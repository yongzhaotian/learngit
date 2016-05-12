<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content:
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "连接管理列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	
    //获得组件参数	

	//获得页面参数
	String sCONNECTID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CONNECTID"));
    if (sCONNECTID == null) 
        sCONNECTID = "";

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {
		{"CONNECTID","CONNECTID"},
		{"CONNECTDESC","CONNECTDESC"},
		{"CONNHOST","CONNHOST"},
		{"CONNPORT","CONNPORT"},
	};
	sSql = "select "+
		   "CONNECTID,"+
		   "CONNECTDESC,"+
		   "CONNHOST,"+
		   "CONNPORT "+
		  "from RI_CONNECTDEF where 1=1";

	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "RI_CONNECTDEF";
	doTemp.setKey("CONNECTID",true);
	doTemp.setHeader(sHeaders);

	//设置小数显示状态,
	doTemp.setAlign("CONNECTID,CONNPORT","3");
	doTemp.setType("CONNECTID,CONNPORT","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("CONNECTID,CONNPORT","2");
	

	//查询
 	doTemp.setColumnAttribute("CONNECTID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
   	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
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
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		sReturn=popComp("RIConnInfo","/Common/Configurator/RTInterface/RIConnInfo.jsp","","");
		//修改数据后刷新列表
		if (typeof(sReturn)!='undefined' && sReturn.length!=0 && sReturn=='HasModified') 
		{
			reloadSelf();
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sCONNECTID = getItemValue(0,getRow(),"CONNECTID");
		if(typeof(sCONNECTID)=="undefined" || sCONNECTID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
        sReturn=popComp("RIConnInfo","/Common/Configurator/RTInterface/RIConnInfo.jsp","CONNECTID="+sCONNECTID,"");
        //修改数据后刷新列表
        if (typeof(sReturn)!='undefined' && sReturn.length!=0 && sReturn=='HasModified') 
        {
			reloadSelf();
        }
	}
    
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		as_save("myiframe0","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sCONNECTID = getItemValue(0,getRow(),"CONNECTID");
		if(typeof(sCONNECTID)=="undefined" || sCONNECTID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	</script>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	
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
