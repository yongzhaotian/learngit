<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	// ���ҳ���������
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("serialNo"));
	if(sSerialNo==null) sSerialNo="";

	/* 
	--ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��--
	*/
	//����tab���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	String sTabStrip[][] = {
		{"true", "����������", "/CustomerManage/CooperationCustomerManage/LoanManInfo1.jsp", "serialNo="+sSerialNo+"&temp=modify"},
		{"true", "��������", "/CustomerManage/CooperationCustomerManage/RepaymentChannelList1.jsp", "serialNo="+sSerialNo},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
