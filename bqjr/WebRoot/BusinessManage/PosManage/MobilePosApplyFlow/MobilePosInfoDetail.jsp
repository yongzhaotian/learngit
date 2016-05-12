<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明:示例模块主页面--
	 */
	String PG_TITLE = "移动POS点准入申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;移动Pos点准入申请&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sMobilePosNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MobilePosNo"));
	String sSNO = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sNo"));
	if (sSerialNo == null) sSerialNo = "";
	if(sMobilePosNo==null) sMobilePosNo="";
	if(sSNO==null) sSNO="";
	if(sPhaseNo==null) sPhaseNo="";
	//获得页面参数

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"移动POS点准入申请","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	tviTemp.insertPage("root","基本信息","",1);	
	if(sSerialNo.length()>0){
	tviTemp.insertPage("root","附件信息","",2);
	tviTemp.insertPage("root","关联产品","",3);
	tviTemp.insertPage("root","关联销售","",4);
	}
	
	
	//另外两种定义树图结构的方法：SQL生成和代码生成   参见View的生成 ExampleView.jsp和ExampleView01.jsp
%>
<%@include file="/Resources/CodeParts/View04.jsp"%>
<script type="text/javascript"> 
function openChildComp(sURL,sParameterString){
	sParaStringTmp = "";
	sLastChar=sParameterString.substring(sParameterString.length-1);
	if(sLastChar=="&") sParaStringTmp=sParameterString;
	else sParaStringTmp=sParameterString+"&";

	/*
	 * 附加两个参数
	 * ToInheritObj:是否将对象的权限状态相关变量复制至子组件
	 * OpenerFunctionName:用于自动注册组件关联（REG_FUNCTION_DEF.TargetComp）
	 */
	sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
	AsControl.OpenView(sURL,sParaStringTmp,"right");
}

	function TreeViewOnClick(){
		var ssSerailNo="<%=sSerialNo %>";
		var sMobilePosNo = "<%=sMobilePosNo%>";
		var sSNO = "<%=sSNO%>";
		var sPhaseNo = "<%=sPhaseNo%>";
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;
		
		if(sCurItemname=='基本信息'){
			AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/MobilePosApplyInfo.jsp","SerialNo=<%=sSerialNo%>","right");
		}else if(sCurItemname=='关联产品'){
			if(ssSerailNo==""){
				alert("请先填写基本信息！");
				return;
			}else{
				AsControl.OpenView( "/BusinessManage/PosManage/MobilePosApplyFlow/ProductList.jsp","SNo="+sSNO+"&MOBLIEPOSNO="+sMobilePosNo+"&PhaseNo="+sPhaseNo,"right");
			}
		}else if(sCurItemname=='关联销售'){
			if(ssSerailNo==""){
				alert("请先填写基本信息！");
				return;
			}else{
				AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/SalesManListForMobilePos.jsp", "SSerialNo="+ssSerailNo+"&SNo="+sSNO+"&MOBLIEPOSNO="+sMobilePosNo+"&PhaseNo="+sPhaseNo,"right");
			}
		}else if(sCurItemname=='附件信息'){
			if(ssSerailNo==""){
				alert("请先填写基本信息！");
			
				return;
			}else{
				AsControl.OpenView("/BusinessManage/PosManage/MobilePosApplyFlow/ImageViewFrame.jsp","SerialNo=<%=sSerialNo%>","right");
			}
		}else{
			return;
		}
		setTitle(getCurTVItem().name);
	}
	
	<%/*~[Describe=生成treeview;]~*/%>
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("基本信息");	//默认打开的(叶子)选项	
	}
	
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>
