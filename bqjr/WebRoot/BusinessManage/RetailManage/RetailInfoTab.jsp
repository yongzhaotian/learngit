<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	//  ��ȡҳ�����
	String sRSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RSerialNo"));
	String sModify =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Modify"));
	if(sModify == null) sModify = "";
	if(sRSerialNo == null) sRSerialNo = "";

	/* 
	ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��
	*/
	//����tab���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	String sTabStrip[][] = {
		//{"false", "List", "/BusinessManage/RetailManage/RetailList.jsp", ""},
		{"true", "����������", "/BusinessManage/ChannelManage/RetailApplyInfo.jsp", "RSerialNo="+sRSerialNo+"&Modify="+sModify},
		{"true", "�������ŵ���Ϣ", "/BusinessManage/RetailManage/RetailStoreList.jsp", "RSerialNo="+sRSerialNo},
		{"false", "Blank", "/Blank.jsp", ""},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
