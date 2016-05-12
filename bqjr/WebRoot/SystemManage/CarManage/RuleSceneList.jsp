<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe:规则引擎场景列表
		Input Param:
       		文档编号:DocNo
		Output Param:

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "规则引擎场景列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量                     
    String sSql = "";
	
	//获得组件参数
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	String docTitle = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocTitle"));
	
	if(docTitle == null) docTitle = "";
	if(sUserID == null) sUserID = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
 	String sTempletNo = "RuleSceneList"; //模版编号

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);//25条一分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入显示模板参数
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
		{"true","All","Button","新增","新增规则引擎场景","newRecord()",sResourcesPath},
		{"true","All","Button","详情","查看规则引擎场景详情","viewRecord()",sResourcesPath},
		{"true","All","Button","删除","删除规则引擎场景","deleteRecord()",sResourcesPath},
		{"true","All","Button","配置数据准备规则","配置数据准备规则","setRecord()",sResourcesPath},
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
		AsControl.OpenView("/SystemManage/CarManage/RuleSceneInfo.jsp","","_self");
	}
	
	/*~[Describe=查看详情;InputParam=无;OutPutParam=无;]~*/	
	function viewRecord()
	{
		var sSceneId = getItemValue(0,getRow(),"SCENEID");
		if (typeof(sSceneId)=="undefined" || sSceneId.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
		AsControl.OpenView("/SystemManage/CarManage/RuleSceneInfo.jsp","SceneId="+sSceneId,"_self");
		}
		
	}
	
	/*~[Describe=配置数据准备规则;InputParam=无;OutPutParam=无;]~*/	
	function setRecord()
	{
		var sSceneId = getItemValue(0,getRow(),"SCENEID");
		var sDataType = getItemValue(0,getRow(),"DATATYPE");
		if (typeof(sSceneId)=="undefined" || sSceneId.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			OpenComp("PrepareDateMain","/SystemManage/CarManage/PrepareDateList.jsp","SceneId="+sSceneId+"&DataType="+sDataType,"_blank","");
		}
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sSceneId = getItemValue(0,getRow(),"SCENEID");
		var sDataType = getItemValue(0,getRow(),"DATATYPE");//数据类型
		if (typeof(sSceneId)=="undefined" || sSceneId.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			//select itemdescribe from code_library where codeno='RuleDataType' and ItemNo='"+sDataType+"'"));
			var TableName="CODE_LIBRARY";
			var ColName = "itemdescribe";
			var WhereClause="CODENO='RuleDataType' AND ITEMNO='"+sDataType+"'";
			//String TableName,String ColName,String WhereClause
			TableName = RunMethod("公用方法","GetColValue",TableName+","+ColName+","+WhereClause);
			ColName=" count(1) ";
			WhereClause = " sceneID='"+sSceneId+"'";
			var n = RunMethod("公用方法","GetColValue",TableName+","+ColName+","+WhereClause);
			n = n*1 | 0 || 0;//去除小数
			if(confirm("该场景包含"+n+"条数据规则，您真的想删除吗？")) //您真的想删除该信息吗？
			{
				//14	公用方法	DelByWhereClause	Sql	根据where条件删除表中数据	Number	String TableName, String whereClause	delete from #TableName where #whereClause							
				RunMethod("公用方法","DelByWhereClause",TableName+","+WhereClause);
        		as_del('myiframe0');
        		as_save('myiframe0'); 
        		reloadSelf();
    		}
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

<%@	include file="/IncludeEnd.jsp"%>