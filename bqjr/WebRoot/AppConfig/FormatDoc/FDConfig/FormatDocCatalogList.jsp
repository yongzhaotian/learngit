<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
	String PG_TITLE = "��ʽ������Ŀ¼�б�";
	String sTypeNo = CurPage.getParameter("SubTypeNo");
	if(sTypeNo == null) sTypeNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("FDCatalogList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sTypeNo);

	String sButtons[][] = {
		{"true","","Button","����","����","add()","","","","btn_icon_add"},
		{"true","","Button","����","����","edit()","","","","btn_icon_detail"},
		{"true","","Button","����","����","copy()","","","","btn_icon_detail"},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete"},
		{"true","","Button","���涨��","���涨��","viewDef()","","","","btn_icon_detail"},
		{"true","","Button","�����������","�����������","viewPara()","","","","btn_icon_detail"},
		{"true","","Button","��д���鱨��","��д���鱨��","newFormatDoc()","","","",""},
		{"true","","Button","�鿴���鱨��","�鿴���鱨��","viewFormatDoc()","","","",""},
		{"true","","Button","������������","������������","exportOfflineDoc()","","","",""},
		{"true","","Button","����PDF","����PDF","exportDocToPdf()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/as_formatdoc.js"></script>
<script type="text/javascript">
 	function add(){
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocCatalogInfo.jsp",'',"dialogWidth=600px;dialogHeight=500px;resizable=yes;maximize:yes;help:no;status:no;");
	 	reloadSelf();
 	}
 	
 	function edit(){
	 	if(getRow()==-1){
			alert('û��ѡ�п��õ���');
			return;
	 	}
	 	var sDocID=getItemValue(0,getRow(),'DocID');
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocCatalogInfo.jsp",'DocID=' + sDocID,"dialogWidth=600px;dialogHeight=500px;resizable=yes;maximize:yes;help:no;status:no;");
	 	reloadSelf();
 	}
 	
 	function copy(){
		if(getRow()==-1){
			alert('û��ѡ�п��õ���');
			return;
		}
		if(!confirm("��ȷ��Ҫ���Ƹ�����¼���������������")) return;
		var sDocID=getItemValue(0,getRow(),'DocID');
		var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.formatdoc.action.FormatDocCatalogAction", "copy", "DocID="+sDocID);
		if(sReturn){
			if(sReturn == "SUCCESS"){
				reloadSelf();
			}else{
				alert(sReturn);
			}
		}else{
			alert("����ʧ�ܣ�");
		}
	}
 	
 	function deleteRecord(){
 		if(confirm('ȷʵҪɾ����?')){
 			var sDocID=getItemValue(0,getRow(),'DocID');
 			var sReturn = RunJavaMethodTrans("com.amarsoft.app.awe.config.formatdoc.action.FormatDocCatalogAction", "delete", "DocID="+sDocID);
 			if(sReturn && sReturn == "SUCCESS"){
 				reloadSelf();
 			}else{
 				alert("����ʧ�ܣ�");
 			}
 		}
 	}

 	//�鿴���涨��
 	function viewDef(){
	 	if(getRow()==-1){
			alert('û��ѡ�п��õ���');
			return;
	 	}
	 	var sDocID=getItemValue(0,getRow(),'DocID');
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocDefList.jsp",'DocID=' + sDocID,"");
 	}
 	
	//�鿴�����������
 	function viewPara(){
	 	if(getRow()==-1){
			alert('û��ѡ�п��õ���');
			return;
	 	}
	 	var sDocID=getItemValue(0,getRow(),'DocID');
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/FormatDocParaList.jsp",'DocID=' + sDocID,"");
 	}
	
	//---------------------------��ʽ������Ĺ��ܲ���---------------------------
 	function newFormatDoc(){
		var sDocID = "D001";
		var sObjectNo = "2011022400000008"; //����ҵ��
		var sObjectType = "CreditApply";
		fillFormatDocWithOpen(sDocID,sObjectNo,sObjectType);
	}
	
	function viewFormatDoc(){
		var sDocID = "D001";
		var sObjectNo = "2011022400000008"; //����ҵ��
		var sObjectType = "CreditApply";
		//������
		var sReturn = productFormatDoc(sDocID,sObjectNo,sObjectType);
		//�ٲ鿴
		if(typeof(sReturn)!='undefined' && sReturn!="" && sReturn != "FAILED"){
			previewFormatDoc(sDocID,sObjectNo,sObjectType);
		}				
	}
	
	function exportOfflineDoc(){
		var sDocID = "D001";
		var sObjectNo = "2011022400000008"; //����ҵ��
		var sObjectType = "CreditApply";
		exportOfflineFormatDoc(sDocID,sObjectNo,sObjectType);
	}
	
	function exportDocToPdf(){
		var sDocID = "D001";
		var sObjectNo = "2011022400000008"; //����ҵ��
		var sObjectType = "CreditApply";
		exportToPdf(sDocID,sObjectNo,sObjectType);
	}
	//---------------------------------------------------------------------------------
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>