<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 担保关系智能搜索详情上下框架页面
	 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%/*~BEGIN~可编辑区*/%>
	<%
	//定义变量
	String sSerialNo = "";
	String sBusinessSerialNo = "";

	//获得组件参数	
	sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	sBusinessSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessSerialNo"));
	%>
<%/*~END~*/%>
<script type="text/javascript">	
    var sObjectType="Customer";
	AsControl.OpenView("/CreditManage/CreditPutOut/AssureInfo.jsp","SerialNo=<%=sSerialNo%>"+"&ObjectType="+sObjectType,"rightup","");
	AsControl.OpenView("/CreditManage/CreditPutOut/AssureContractList.jsp","SerialNo=<%=sBusinessSerialNo%>","rightdown","");
</script>	
<%@ include file="/IncludeEnd.jsp"%>
