<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ������ϵ���������������¿��ҳ��
	 */
%><%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%/*~BEGIN~�ɱ༭��*/%>
	<%
	//�������
	String sSerialNo = "";
	String sBusinessSerialNo = "";

	//����������	
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
