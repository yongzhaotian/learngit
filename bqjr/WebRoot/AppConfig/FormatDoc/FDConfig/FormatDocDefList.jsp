<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%
 	String sDocID = CurPage.getParameter("DocID");
 	if(sDocID == null) sDocID = "";

	ASObjectModel doTemp = new ASObjectModel("FDDefList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "0";
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(sDocID);

	String sButtons[][] = {
		{"true","","Button","����","����","add()","","","",""},
		{"true","","Button","����","����","as_save('myiframe0')","","","",""},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete"},
		{"true","","Button","Ԥ��ģ���ļ�","Ԥ��ģ���ļ�","preview_model()","","","",""},
		{"true","","Button","����ģ���ļ�","����ģ���ļ�","downloadModel()","","","",""},
		{"true","","Button","�ϴ�ģ���ļ�","�ϴ�ģ���ļ�","uploadModel()","","","",""},
		{"false","","Button","��֤����","��֤����","validatorDialog()","","","",""},
	};
%><%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	setDialogTitle("����ڵ㶨��");
 	function add(){
	 	as_add("myiframe0");
	 	//����Ĭ��ֵ
	 	setItemValue(0,getRow(),'DocID','<%=sDocID%>');
 	}
 	function deleteRecord(){
 		if(confirm('ȷʵҪɾ����?')){
 			as_delete("myiframe0");
 		}
 	}
 	//Ԥ��ģ���ļ�
 	function preview_model(){
		if(getRow()==-1){
			alert('û��ѡ�п��õ���');
			return;
		}
	 	var sUrl = getItemValue(0,getRow(),'HtmlFileName');
	 	if(!sUrl){
	 		alert('����дģ���ļ���');
	 		return;
	 	}
	 	
	 	AsControl.OpenView(sUrl,'','');
 	}
 	//����ģ���ļ�
 	function downloadModel(){
	 	if(getRow()==-1){
			alert('û��ѡ�п��õ���');
			return;
	 	}
	 	var sJspFileName=getItemValue(0,getRow(),'JspFileName');
	 	var sHtmlFileName=getItemValue(0,getRow(),'HtmlFileName');
	 	OpenPage("/AppConfig/FormatDoc/FDConfig/DownloadModelFile.jsp?JspFileName="+sJspFileName+"&HtmlFileName="+sHtmlFileName,"");
 	}
 	//�ϴ�ģ���ļ�
 	function uploadModel(){
	 	if(getRow()==-1){
			alert('û��ѡ�п��õ���');
			return;
	 	}
	 	var sDirID = getItemValue(0,getRow(),'DirID');
	 	AsControl.PopView("/AppConfig/FormatDoc/FDConfig/UploadModelFile.jsp","DocID=<%=sDocID%>&DirID="+sDirID,"dialogWidth=600px;dialogHeight=200px;");
 	}
	//��֤����
 	function validatorDialog(){
	 	var sDono=getItemValue(0,getRow(),"DocID")+"@"+getItemValue(0,getRow(),"DirID");
	 	if(getRow()==-1){
			alert('û��ѡ�п��õ���');
		 	return;
	 	}
	 	AsControl.OpenView("/AppConfig/FormatDoc/FDConfig/ValidateEditFrame.jsp","Dono="+sDono,"");
 	}
</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>