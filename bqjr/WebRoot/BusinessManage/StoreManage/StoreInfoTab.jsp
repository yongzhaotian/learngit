<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%

	//  ��ȡҳ�����
	String sSSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SSerialNo"));
	String sSNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SNo"));
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	String sFlag =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sFlag"));
	String sModify= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Modify"));
	
	if(sStatus == null) sStatus="";
	if(sSSerialNo == null) sSSerialNo="";
	if(sSNo == null) sSNo = ""; 
	if(sFlag == null) sFlag = ""; 
	if(sModify==null) sModify="";


	/* 
	ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��
	*/
	//����tab���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	String sTabStrip[][] = {
			{"true", "�ŵ�����", "/BusinessManage/StoreManage/StoreInfo.jsp", "SSerialNo="+sSSerialNo+"&SNo="+sSNo+"&Status="+sStatus+"&sFlag="+sFlag+"&Modify="+sModify},
			{"true", "������Ʒ", "/BusinessManage/StoreManage/ProductList.jsp", "SSerialNo="+sSSerialNo+"&SNo="+sSNo+"&sFlag="+sFlag},
			{"true", "����������Ա", "/BusinessManage/StoreManage/SalesManList.jsp", "SSerialNo="+sSSerialNo+"&SNo="+sSNo+"&sFlag="+sFlag},
			{"true", "�����ʼ��ŵ�", "/BusinessManage/StoreManage/PostStoreList.jsp", "SSerialNo="+sSSerialNo+"&SNo="+sSNo+"&sFlag="+sFlag},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
