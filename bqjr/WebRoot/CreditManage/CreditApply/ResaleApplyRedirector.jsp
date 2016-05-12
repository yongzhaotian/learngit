<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	ASResultSet rs=null;
	String sSql = "";
	String sBusinessType = "";
		
	sSql = " select BusinessType from Business_Apply where SerialNo =:SerialNo";
	sBusinessType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));	
%>


<script type="text/javascript">
	OpenPage("/CreditManage/CreditApply/ResaleView.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","_self","");
</script>
<%@ include file="/IncludeEnd.jsp"%>
