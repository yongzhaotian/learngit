<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
 	/* 
 		ҳ��˵���� ͨ�����鶨������strip���ҳ��ʾ��
 	*/
 	//����strip���飺
 	//������0.�Ƿ���ʾ, 1.���⣬2.�߶ȣ�3.���ID��4.URL��5����������6.�¼�
	String sStrips[][] = {
		{"true","����List" ,"500","ExampleList","/FrameCase/ExampleList.jsp","",""},
		{"true","����Info" ,"500","ExampleInfo","/FrameCase/ExampleInfo.jsp","ExampleId=2012081700000001",""},
	};
 	String sButtons[][] = {
 			{"true","","Button","��ť1","��ť1","aaa()",sResourcesPath,"btn_icon_edit"},
 			{"true","","Button","��ť2","��ť2","bbb()",sResourcesPath,"btn_icon_help"},
 	};
%><%@include file="/Resources/CodeParts/Strip05.jsp"%>
<script type="text/javascript">
	function aaa(){
		alert(1);
	}
	
	function bbb(){
		alert(2);
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>