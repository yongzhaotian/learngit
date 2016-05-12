<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明:手工生成树图示例页面
	 */
	String PG_TITLE = "手工生成树图"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;手工生成树图&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度

	//获得页面参数
	String sExampleId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"手工生成树图","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
	//通过insertFolder和insertPage生成树图
	String sFold1=tviTemp.insertFolder("root","管理示例","",1);                             
 	String tmp1=tviTemp.insertFolder(sFold1,"管理示例列表","",1);                               
 	tviTemp.insertPage(tmp1,"基本信息","",1);
	tviTemp.insertPage(tmp1,"其他信息(TAB)","",2);
	tviTemp.insertPage(tmp1,"上下型","",3);
	tviTemp.insertPage("root","管理示例列表2","",2);
	tviTemp.insertPage("root","管理示例列表3","",3);
%><%@include file="/Resources/CodeParts/View04.jsp"%>
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
	
	//treeview单击选中事件
	function TreeViewOnClick(){
		var sCurItemname = getCurTVItem().name;
		if(sCurItemname=="基本信息"){
			openChildComp("/FrameCase/ExampleInfo.jsp","ExampleId=<%=sExampleId%>");
		}else if(sCurItemname=="其他信息(TAB)"){
			openChildComp("/FrameCase/ExampleTab.jsp","ExampleId=<%=sExampleId%>");
			return;
		}else if(sCurItemname=="上下型"){
			openChildComp("/FrameCase/ExampleFrame.jsp","ExampleId=<%=sExampleId%>");
			return;
		}else if(sCurItemname=="管理示例列表2"){
			openChildComp("/FrameCase/ExampleList.jsp","");
			return;
		}else if(sCurItemname=="管理示例列表3"){
			openChildComp("/FrameCase/ExampleList.jsp","");
			return;
		}else{}
		setTitle(getCurTVItem().name);
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		selectItemByName("基本信息");
	}
		
	initTreeView();
</script>
<%@ include file="/IncludeEnd.jsp"%>