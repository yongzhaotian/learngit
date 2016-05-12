<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.biz.reserve.business.DateTools" %>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
	/*
		Author:zwang 2008.11.12
		Tester:
		Content: 参数维护列表页面
		Input Param:		
		Output param:	
			会计月份：AccountMonth
			客户类型：CustomerType
				01 公司客户 
				03 个人客户
		History Log: 
			zytan 20090108 调整新增参数记录的模式
	*/
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
<%
	// 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_TITLE = "参数维护列表"; 
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
    String sCurrentAccountMonth = DateTools.getAccountMonth("yyyy/MM/dd",3);
	//获得组件参数
	
	//获得页面参数
	String sCustomerType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType = "";

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sTempletNo = "ReserveEntParaList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca); 
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);			
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));			
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="1"; 
	//设置是否只读 1:只读 0:可写     
	dwTemp.ReadOnly = "1"; 
	dwTemp.setPageSize(10);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerType);
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
		{"true","","Button","新增参数信息","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","查看参数信息","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","复制","复制所选中的记录","copyRecord()",sResourcesPath}
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
		var sCurrentAccountMonth = "<%=sCurrentAccountMonth%>";
		var sCustomerType = "<%=sCustomerType%>";
		var sAssetsType = sCustomerType;
		var sParaString = sCurrentAccountMonth + "," + sCustomerType + "," + sAssetsType;
		var sReturn = RunMethod("ReserveManage","ReserveCheckAccountMonth",sParaString);
		if (typeof(sReturn) == "undefined" || sReturn == "Refuse") {
		    if (confirm("当期会计月份基础参数信息已存在，您希望查看该信息吗？")) {
		    	OpenPage("/Reserve/ReservePara/ReserveEntParaInfo.jsp","_self","");
		    }
		} else if (sReturn == "Pass") {
			OpenPage("/Reserve/ReservePara/ReserveEntParaInfo.jsp","_self","");
		}
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sAccountMonth=getItemValue(0,getRow(),"AccountMonth");
		sAssetsType=getItemValue(0,getRow(),"AssetsType");
		if((typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
				|| (typeof(sAssetsType) == "undefined" || sAssetsType.length == 0))
		{
			alert("请选择一条记录！");
			return;
		}
		OpenPage("/Reserve/ReservePara/ReserveEntParaInfo.jsp?AccountMonth="+sAccountMonth+"&AssetsType="+sAssetsType,"_self","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sAccountMonth=getItemValue(0,getRow(),"AccountMonth");
		sAssetsType=getItemValue(0,getRow(),"AssetsType");
		if((typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0) 
			|| (typeof(sAssetsType) == "undefined" || sAssetsType.length == 0))
		{
			alert("请选择一条记录！");
			return;
		}
		if(confirm("您真的想删除该信息吗？")) 
		{
			as_del("myiframe0");
			//如果单个删除，则要调用此语句
			as_save("myiframe0"); 
		}
		reloadSelf();
	}

	/*~[Describe=复制记录;InputParam=无;OutPutParam=无;]~*/
	function copyRecord()
	{
		var sAccountMonth=getItemValue(0,getRow(),"AccountMonth");
		var sAssetsType=getItemValue(0,getRow(),"AssetsType");
		var sCustomerType="<%=sCustomerType%>";
		var sFlag = "3";//表示会计月份的频度，1代表按照月，3代表按照季度，6代表按照半年，12代表按照年
		if((typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0) 
			|| (typeof(sAssetsType) == "undefined" || sAssetsType.length == 0))
		{
			alert("请选择一条记录！");
			return;
		}
		//传入参数flag，资产组类型
		var sReturn = RunMethod("ReserveManage","ReserveCopyPara",sAccountMonth+","+sAssetsType+","+sCustomerType+","+sFlag);
		if(sReturn == "SuccessFul"){
			alert("当前会计月份基础参数配置信息复制成功！");
			reloadSelf();
		}else if(sReturn == "Exit"){
			alert("当前会计月份基础参数配置信息已经存在，请确认！");
			return;
		}else{
			alert("复制基础参数配置信息出错，请联系系统管理员！");
			return;
		}		
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
