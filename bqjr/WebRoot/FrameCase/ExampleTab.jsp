<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%
	/* 
	ҳ��˵���� ͨ�����鶨������Tab���ҳ��ʾ��
	*/
	//����tab���飺
	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	String sTabStrip[][] = {
		{"true", "List", "/FrameCase/ExampleList.jsp", ""},
		{"true", "Info", "/FrameCase/ExampleInfo.jsp", "ExampleId=2013012300000001"},
		{"true", "Tab", "/FrameCase/ExampleTab.jsp", ""},
		{"true", "Blank", "/Blank.jsp", ""},
	};
%><%@ include file="/Resources/CodeParts/Tab01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>