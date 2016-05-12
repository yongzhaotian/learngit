<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "随心还服务管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;随心还服务管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请稍后";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	
	// 定义Treeview
    HTMLTreeView tviTemp = new HTMLTreeView(Sqlca, CurComp, sServletURL, PG_TITLE, "right");
    tviTemp.ImageDirectory = sResourcesPath; 			// 设置资源文件目录（图片、CSS）
    tviTemp.toRegister = false; 						// 设置是否需要将所有的节点注册为功能点及权限点
    tviTemp.TriggerClickEvent = true; 					// 是否自动触发选中事件

    // 定义树图结构：从代码表CODE_LIBRARY中查询出ApplyMain页面左边有效的树型菜单信息
    String sqlTreeView = "FROM CODE_LIBRARY WHERE CODENO = 'BOMTRManage' AND ISINUSE = '1' ";
    tviTemp.initWithSql("SORTNO", "ITEMNAME", "ATTRIBUTE5", "", "", sqlTreeView, "ORDER BY ITEMNO", Sqlca);
%>
<%@include file="/Resources/CodeParts/Main04.jsp"%>

<!-- <script type="text/javascript">
	AsControl.OpenView("/CustomService/BusinessConsult/CancelPayPkgApplyList.jsp", "", "right", "");
</script> -->
<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
    function TreeViewOnClick() {
        var sCurItemDescribe = getCurTVItem().value;        
        sCurItemDescribe = sCurItemDescribe.split("@");
        sCurItemDescribe1 = sCurItemDescribe[0];
        sCurItemDescribe2 = sCurItemDescribe[1];
        sCurItemDescribe3 = sCurItemDescribe[2];
    
        if(sCurItemDescribe1 != "root") {
        	AsControl.OpenComp(sCurItemDescribe1, "ComponentName=随心还服务管理", "right");
            setTitle(getCurTVItem().name);
        }
    }
    
    /*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
    function startMenu() {
        <%=tviTemp.generateHTMLTreeView() %>
    }
            
    </script>
<% /*~END~*/ %>
<script type="text/javascript">
    startMenu();
    expandNode('root');
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	