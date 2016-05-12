<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 用款记录列表
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "无预约现金贷外部客户配置列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得页面参数
	//String sProductID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("productID"));	
    //if(sProductID==null) sProductID="";

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	String sTempletNo = "NoBespeakCashLoanParaList";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	//查询条件为空不查询数据
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	
	dwTemp.setPageSize(10);  //服务器分页
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入参数,逗号分割
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
		{"true","","Button","新增","新增数据","newRecord()",sResourcesPath},
		{"true","","Button","详情","详情记录","myDetail()",sResourcesPath},	
		{"true","","Button","删除","删除所选中的数据","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/**
	 * 新增数据
	 */
	function newRecord(){
		sCompID = "NoBespeakCashLoanParaInfo";
		sCompURL = "/BusinessManage/BusinessType/NoBespeakCashLoanParaInfo.jsp";
		sCompParam = "serialno="; //新增不赋值参数
		
		var left = (window.screen.availWidth-800)/2;
		var top = (window.screen.availHeight-400)/2;
		var features ='left='+left+',top='+top+',width=800,height=400';
		var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll=no;status=no,menubar=no,'+features;
		
		popComp(sCompID, sCompURL, sCompParam , style);
		//AsControl.PopPage(sCompURL,sCompParam,style); //打开，没有刷新栏
		reloadSelf();
	}
	
	/**
	 * 删除数据
	 */
	function deleteRecord(){
		var serialno =getItemValue(0,getRow(),"serialno");//获取删除记录的单元值
		if (typeof(serialno)=="undefined" || serialno.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}
	
	/**
	 * 打开详情
	 */
	function myDetail(){
		var serialno = getItemValue(0,getRow(),"serialno");	
		if(typeof(serialno)=="undefined" || serialno.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			sCompID = "NoBespeakCashLoanParaDetail";
			sCompURL = "/BusinessManage/BusinessType/NoBespeakCashLoanParaInfo.jsp";
			sCompParam = "serialno="+serialno; //赋值参数
			
			var left = (window.screen.availWidth-800)/2;
			var top = (window.screen.availHeight-400)/2;
			var features ='left='+left+',top='+top+',width='+800+',height='+400;
			var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll:no;status=no,menubar=no,'+features;
			
			popComp(sCompID, sCompURL, sCompParam , style);
			//AsControl.PopPage(sCompURL,sParamString,style); //打开，没有刷新栏
		}
		reloadSelf();
	}
	
	/**
	 * 关闭页面
	 */
	function doCancel(){		
		top.returnValue = "_CANCEL_";
		top.close();
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

<%@	include file="/IncludeEnd.jsp"%>

