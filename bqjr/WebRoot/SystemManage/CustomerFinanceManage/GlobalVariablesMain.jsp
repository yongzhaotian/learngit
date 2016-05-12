<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	//CCS-769 关于全局变量修改为BIB设置的事宜 update huzp 20150520
	String PG_TITLE = "BIB设置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;BIB设置&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请稍后";//默认的内容区文字
	String PG_LEFT_WIDTH = "1";//默认的treeview宽度
	%>

	<%@include file="/Resources/CodeParts/Main04.jsp"%>


	<script type="text/javascript">
		//myleft.width=1;
		//AsControl.OpenView("/SystemManage/CustomerFinanceManage/GlobalVariablesInfo.jsp","","right","");
	/******************************CCS-769 关于全局变量修改为BIB设置的事宜add huzp 20150527************/
		var org="<%=CurUser.getOrgID()%>"; 	
		if(org=="11"){//根据登录人员部门机构判断显示出不同的BIB界面。11为审核部门人员。做前期BIB设置
			myleft.width=1;
			AsControl.OpenView("/SystemManage/CustomerFinanceManage/GlobalVariablesInfo.jsp","","right","");
		}else if (org=="10"){//根据登录人员部门机构判断显示出不同的BIB界面。10为风控部门人员。做后期BIB设置
			myleft.width=1;
			AsControl.OpenView("/SystemManage/CustomerFinanceManage/GlobalVariablesLateInfo.jsp","","right","");
		}
	/******************************end******************************************************/	
		
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	