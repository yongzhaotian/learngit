<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:		ygwu
		Tester:
		Describe: 	��ͬ����
		Input Param:
		Output Param:
		
		HistoryLog:
					2014/03/21�鿴��ͬ��Ϣ
	 */
	%>
<%/*~END~*/%>

<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%>
<%
	/* 
	--ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��--*/
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	
	//����tab���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	String sTabStrip[][] = {
		{"true", "��ͬ����", "/CreditManage/CreditApply/CreditView.jsp", "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&RightType=ReadOnly"},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>
