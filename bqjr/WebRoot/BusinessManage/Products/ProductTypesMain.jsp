<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "产品类型"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;产品类型&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请稍后";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";//默认的treeview宽度
	
	//产品类型
	String sProductType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));	
	//产品子类型
	String sSubProductType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubProductType"));	
	
	if(null == sProductType) sProductType = "";
	if(null == sSubProductType) sSubProductType = "";
	%>

	<%@include file="/Resources/CodeParts/Main04.jsp"%>


	<script type="text/javascript">
		myleft.width=1;
		AsControl.OpenView("/BusinessManage/Products/ProductTypesList.jsp","ProductType=<%=sProductType%>&SubProductType=<%=sSubProductType%>","right","");//update 现金贷需求(增加产品类型参数)
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	