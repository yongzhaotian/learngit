<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "�Ա�ǩҳ��ʽ��ʾ��";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ExampleList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","openRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function openRecord(sExampleID){
		var sParas = "";
		if(sExampleID) sParas = "ExampleId="+sExampleID;
		
		if(typeof parent.addTabItem == "function"){
			var text;
			if(sExampleID) text = "���顾"+sExampleID+"��";
			else text = "����";
			parent.addTabItem(text, "/FrameCase/ExampleInfo.jsp", sParas);
		}else{
			AsControl.OpenView("/FrameCase/ExampleInfo.jsp", sParas, "_self","");
		}
	}
	
	function viewAndEdit(){
		var sExampleID = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleID)=="undefined" || sExampleID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		openRecord(sExampleID);
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>