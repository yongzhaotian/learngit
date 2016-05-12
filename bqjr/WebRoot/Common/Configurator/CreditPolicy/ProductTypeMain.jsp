<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.aa.ProductManageTree" %>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "产品管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;产品管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = ProductManageTree.getTree(SqlcaRepository,CurComp,sServletURL,sResourcesPath);
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script type="text/javascript"> 
    /*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
    function openPhase(sTypeNo,sTypeName)
    {
        //打开产品列表页面
        OpenComp("ProuductTypeList","/Common/Configurator/CreditPolicy/ProductTypeList.jsp","ParentTypeNo="+sTypeNo,"right");
        setTitle(sTypeName);
    }
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>

<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
    <script type="text/javascript">
    try{
	    startMenu();
	    expandNode('root');
	    selectItemByName('公司业务');
    }catch(e){}
    </script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>