<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "�鿴�������";

	// ���ҳ�����
	//��ͬ���
	String serialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("serialNo"));
	//ģ����
	String sTempletNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sTempletNo"));
	if(serialNo==null) serialNo="";
	if(sTempletNo==null) sTempletNo = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(serialNo);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
