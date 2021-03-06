<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明:示例模块主页面--
	 */
	String PG_TITLE = "门店准入审批"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;门店准入审批&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sRegCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RegCode1"));
	if (sSerialNo == null) sSerialNo = "";
	//获得页面参数
ARE.getLog().info("sSerialNo===协议审核========================================="+sSerialNo);
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"门店准入审批","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	String [] ssSerialNo=sSerialNo.split(",");
	if((ssSerialNo.length)==1){
		tviTemp.insertPage("root","协议审核","",1);
		tviTemp.insertPage("root","附件信息","",2);
	}else{
	tviTemp.insertPage("root","协议审核","",1);
	tviTemp.insertPage("root","附件信息","",2);
	}
	
	
	
	//另外两种定义树图结构的方法：SQL生成和代码生成   参见View的生成 ExampleView.jsp和ExampleView01.jsp
%>
<%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
	function TreeViewOnClick(){
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=='协议审核'){
			AsControl.OpenView("/BusinessManage/RetailManage/StoreApplyInfo1.jsp","SerialNo=<%=sSerialNo%>","right");
		}else if(sCurItemname=='附件信息'){
			AsControl.OpenView("/BusinessManage/RetailManage/ImageViewFrameStore.jsp","SerialNo=<%=sSerialNo%>&RegCode=<%=sRegCode%>","right");
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=生成treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("协议审核");	//默认打开的(叶子)选项	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
