<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
 	/* 
 		ҳ��˵���� ͨ�����鶨������strip���ҳ��ʾ��
 	*/
 	String sDoNo = CurPage.getParameter("DONO");
	if(sDoNo==null) sDoNo = "";
 	//����strip���飺
 	//������0.�Ƿ���ʾ, 1.���⣬2.�߶ȣ�3.���ID��4.URL��5����������6.�¼�
	String sStrips[][] = {
		{"true","ģ��Ŀ¼��Ϣ" ,"300","OWCatalogInfo","/AppConfig/PageMode/DWConfig/ObjectModelCatalogInfo.jsp","DONO="+sDoNo,""},
		{"true","ģ�嶨����Ϣ" ,"600","OWLibList","/AppConfig/PageMode/DWConfig/ObjectModelLibraryList.jsp","DONO="+sDoNo,""},
	};
 	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/Strip05.jsp"%>
<script type="text/javascript">	
	setDialogTitle("��ʾģ������");
	//$("#ConditonMap1Tab3").click();
	document.getElementById("ConditonMap1Tab3").click();
</script>
<%@ include file="/IncludeEnd.jsp"%>