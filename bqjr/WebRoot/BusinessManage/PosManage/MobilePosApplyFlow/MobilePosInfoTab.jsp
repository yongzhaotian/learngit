<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	//  ��ȡҳ�����
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplySerialNo"));
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sMobilePosNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MOBLIEPOSNO"));
	
	if(sStatus == null) sStatus="";
	if(sSSerialNo == null) sSSerialNo="";
	if(sMobilePosNo == null) sMobilePosNo="";

	/* 
	ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��
	*/
	//����tab���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	String sTabStrip[][] = {
			
		{"true", "�ƶ�Pos������", "/BusinessManage/PosManage/MobilePosApplyFlow/MobilePosApplyInfoManager.jsp", "SSerialNo="+sSSerialNo+"&Status="+sStatus},
		{"true", "������Ʒ", "/BusinessManage/PosManage/MobilePosApplyFlow/ProductList.jsp", "MOBLIEPOSNO="+sMobilePosNo},
		{"true", "����������Ա", "/BusinessManage/PosManage/MobilePosApplyFlow/SalesManListForMobilePos.jsp", "SSerialNo="+sSSerialNo+"&SNo="+sSNo+"&MOBLIEPOSNO"+sMobilePosNo},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
