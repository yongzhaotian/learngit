<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	// 获得页面参数
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	CurARC.setAttribute(request.getSession().getId()+"city", sSNo);
	
	//定义变量：查询结果集
	ASResultSet rs = null;
	String sSql = "";
	String sUserId = CurUser.getUserID();
	
	sSql = "update user_info set attribute8=:Attribute8 where userid=:UserID";
	Sqlca.executeSQL(new SqlObject(sSql).setParameter("Attribute8", sSNo).setParameter("UserID", sUserId));

%>

<script type="text/javascript">
	
	
	function initRow(){
		window.close();
    }
	
	$(document).ready(function(){
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
