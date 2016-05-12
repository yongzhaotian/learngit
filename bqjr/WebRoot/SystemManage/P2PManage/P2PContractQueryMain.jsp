<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明:P2P平台额度配置--
	 */
	String PG_TITLE = "P2P平台额度配置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String  sP2pType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("p2pType"));
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;P2P合同查询&nbsp;&nbsp;"; //默认的内容区标题
	if( "AirtualStore".equals(sP2pType) ){	//借钱么虚拟门店的p2p合同
		PG_CONTENT_TITLE = "&nbsp;&nbsp;借钱么虚拟门店P2P合同查询&nbsp;&nbsp;"; //默认的内容区标题
	}else if( "EBuyFun".equals(sP2pType) ){	//”易佰分“的商户编号为“4403000403”
		PG_CONTENT_TITLE = "&nbsp;&nbsp;易佰分P2P合同查询&nbsp;&nbsp;"; //默认的内容区标题
	}else{	//普通消费贷的p2p合同
		PG_CONTENT_TITLE = "&nbsp;&nbsp;P2P合同查询&nbsp;&nbsp;"; //默认的内容区标题
	}
	
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "0";//默认的treeview宽度

	//获得页面参数

%><%@include file="/Resources/CodeParts/Main04.jsp"%>
<script type="text/javascript">
	myleft.width=1;
	AsControl.OpenView("/SystemManage/P2PManage/P2PContractQueryList.jsp","","right","");
</script>
<%@ include file="/IncludeEnd.jsp"%>