<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Content:集团授信状况
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "集团授信状况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;集团授信状况&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
    String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	String sRightType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));
	
    if(sGroupID == null) sGroupID = "";
    if(sRightType == null) sRightType = "";
	//获得页面参数	

	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"集团授信状况","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	tviTemp.initWithCode("GroupCustomerCreditView",Sqlca);
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script type="text/javascript"> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick(){
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='集团授信信息'){
			OpenComp("GroupCreditList","/CustomerManage/GroupManage/GroupCreditList.jsp","","right");
		}else if(sCurItemname=='集团内担保信息'){
			OpenComp("GroupInnerGurantyList","/CustomerManage/GroupManage/GroupInnerGurantyList.jsp","","right");
		}else if(sCurItemname=='接收集团外客户担保信息'){
			OpenComp("GroupOuterGurantyList","/CustomerManage/GroupManage/GroupOuterGurantyList.jsp","","right");
		}else if(sCurItemname=='为集团外客户担保信息'){
			OpenComp("GroupForOuterGurantyList","/CustomerManage/GroupManage/GroupForOuterGurantyList.jsp","","right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');
	selectItemByName("集团授信信息");
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
