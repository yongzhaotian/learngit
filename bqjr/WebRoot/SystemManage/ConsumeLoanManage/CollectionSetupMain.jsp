<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:示例模块主页面
	 */
	String PG_TITLE = "催收设置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;催收设置&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得页面参数

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"催收设置","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	//String sFolder1=tviTemp.insertFolder("root","示例信息","",1);
	//tviTemp.insertPage(sFolder1,"所有的示例信息","",1);
	//tviTemp.insertPage(sFolder1,"我的示例信息","",2);
	//tviTemp.insertPage(sFolder1,"他的示例信息","",3);
	tviTemp.insertPage("root","流程管理","",1);
	tviTemp.insertPage("root","委案时长管理","",2);
	tviTemp.insertPage("root","委托案件清单生成日期管理","",3);
	tviTemp.insertPage("root","一手委托案件有效期管理","",4);
	tviTemp.insertPage("root","二手委托案件有效期管理","",5);
	tviTemp.insertPage("root","三手及以上委托案件有效期管理","",6);
	tviTemp.insertPage("root","催收渠道管理","",7);
	tviTemp.insertPage("root","行动代码管理","",8);
	tviTemp.insertPage("root","委案公司管理","",9);
	tviTemp.insertPage("root","逾期天数送入催收的定义","",10);
	tviTemp.insertPage("root","逾期金额送入催收的定义","",11);
	tviTemp.insertPage("root","批量代扣逻辑设置","",12);
	
	//另外两种定义树图结构的方法：SQL生成和代码生成   参见View的生成 ExampleView.jsp和ExampleView01.jsp
%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='流程管理') {
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/CollectionFlowList.jsp","","right");
		}else  if(sCurItemname=='委案时长管理'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateDuration.jsp","TypeCode=DelegateDuration","right");
		}else if(sCurItemname=='委托案件清单生成日期管理'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCaseListCreateDate.jsp","TypeCode=DelegateCaseListCreateDate","right");
		}else if(sCurItemname=='一手委托案件有效期管理'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/FirstCaseWorkDuration.jsp","TypeCode=FirstCaseWorkDuration","right");
		}else if(sCurItemname=='二手委托案件有效期管理'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/SecondCaseWorkDuration.jsp","TypeCode=SecondCaseWorkDuration","right");
		}else if(sCurItemname=='三手及以上委托案件有效期管理'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/ThreeMoreCaseWorkDuration.jsp","TypeCode=ThreeMoreCaseWorkDuration","right");
		}else if(sCurItemname=='催收渠道管理'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/CollectionChannelList.jsp","","right");
		}else if(sCurItemname=='行动代码管理'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/ActionCodeList.jsp","","right");
		}else if(sCurItemname=='委案公司管理'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCompanyList1.jsp","","right");
		}else if(sCurItemname=='逾期天数送入催收的定义'){
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/OverDayDuration.jsp","TypeCode=OverDayDuration","right");
		}else if(sCurItemname=='逾期金额送入催收的定义') {
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/OverDayCollectionAmount.jsp","TypeCode=OverDayCollectionAmount","right");
		}else if(sCurItemname=='批量代扣逻辑设置') {
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/BatchWithholdLogic.jsp","","right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=生成treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("流程管理");	//默认打开的(叶子)选项	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
