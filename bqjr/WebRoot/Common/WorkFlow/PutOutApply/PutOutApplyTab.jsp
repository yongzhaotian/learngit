<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	// ���ҳ���������
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sTemp =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	if(sTemp==null) sTemp="";
	if(sCustomerID==null) sCustomerID="";
	if(sObjectNo==null) sObjectNo="";

	/* 
	--ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��--
	*/
	//����tab���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	String sTabStrip[][] = {
		{"true", "��ͬ��Ϣ", "/Common/WorkFlow/PutOutApply/PutOutCreditInfo.jsp", "ObjectNo="+sObjectNo+"&temp="+sTemp},
		{"true", "�ͻ���Ϣ", "/Common/WorkFlow/PutOutApply/PutOutCustomerInfo.jsp", "CustomerID="+sCustomerID},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
