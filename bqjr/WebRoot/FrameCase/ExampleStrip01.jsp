<%@ page contentType="text/html; charset=GBK"%><%@
include file="/IncludeBegin.jsp"%><%
 	/* 
 		ҳ��˵���� ͨ�����鶨������strip���ҳ��ʾ��
 	*/
 	//����strip���飺
 	//������0.�Ƿ���ʾ, 1.���⣬2.URL��3��������
	String sTabStrip[][] = {
		{"true", "����List", "/FrameCase/ExampleList.jsp", ""},
		{"true", "����Info", "/FrameCase/ExampleInfo.jsp", "ExampleId=2012081700000001"},
		{"true", "����List", "/FrameCase/ExampleList.jsp", ""},
	};
%><%@include file="/Resources/CodeParts/Strip01.jsp"%>
<%@ include file="/IncludeEnd.jsp"%>