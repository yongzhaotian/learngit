<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "��֤�����б�";
	String sDono=CurPage.getParameter("Dono");
 	if(sDono == null) sDono = "";
	ASDataObject doTemp = new ASDataObject("ValidateList");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1"; 
	dwTemp.ReadOnly = "1";
	dwTemp.setPageSize(15);

	Vector vTemp = dwTemp.genHTMLDataWindow(sDono);
 	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		{"true","All","Button","����","����һ����¼","newRecord()","","","","btn_icon_add"},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()","","","","btn_icon_delete"},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
	    AsControl.OpenView("/AppConfig/PageMode/FormatDoc/ValidateInfo.jsp","Dono=<%=sDono%>","rightdown","");
	}
	
	function deleteRecord(){
		if(confirm('ȷʵҪɾ��������¼?')){
			as_delete(0,'getresult()');
		}
	}
	
	function mySelectRow(){
		var serialno = getItemValue(0,getRow(),"Serialno");
		if(typeof(serialno)=="undefined" || serialno.length==0) {
		}else{
			AsControl.OpenView("/AppConfig/PageMode/FormatDoc/ValidateInfo.jsp","Serialno="+serialno,"rightdown"); 
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	mySelectRow();
</script>
<%@ include file="/IncludeEnd.jsp"%>