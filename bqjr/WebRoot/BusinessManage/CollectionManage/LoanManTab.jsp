<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	// ���ҳ���������
	String sLoanNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanNo"));
	if(sLoanNo==null) sLoanNo="";

	/* 
	--ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��--
	*/
	//����tab���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	String sTabStrip[][] = {
		{"true", "����������", "/BusinessManage/CollectionManage/LoanManInfo.jsp", "LoanNo="+sLoanNo},
		{"true", "��������", "/BusinessManage/CollectionManage/RepaymentChannelList.jsp", "LoanNo="+sLoanNo},
		{"true", "��������", "/BusinessManage/CollectionManage/LoanManCityList.jsp", "LoanNo="+sLoanNo},
		{"true", "���Ӻ�ͬģ��", "/BusinessManage/CollectionManage/LoanManEDocList.jsp", "LoanNo="+sLoanNo},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
