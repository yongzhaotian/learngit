<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "非法数据修复"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTNET_TEXT = "温馨提示：【数据正在修复中...】</br>&nbsp;&nbsp;&nbsp;&nbsp;请用户退出系统时尽量点击右上角的退出系统按钮正常退出.如出现网页突然崩溃,断电,断网,或直接关闭网页以上情形时。请在下次登录后自动点击非法数据修复菜单进行数据修复,修复过程请耐心等待2-4分钟.";//默认的内容区文字
	out.println(PG_CONTNET_TEXT);
%>
<%@ include file="/IncludeEnd.jsp"%>