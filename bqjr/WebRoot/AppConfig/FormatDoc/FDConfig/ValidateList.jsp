<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "验证规则列表";
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
		{"true","All","Button","新增","新增一条记录","newRecord()","","","","btn_icon_add"},
		{"true","","Button","删除","删除","deleteRecord()","","","","btn_icon_delete"},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
	    AsControl.OpenView("/AppConfig/PageMode/FormatDoc/ValidateInfo.jsp","Dono=<%=sDono%>","rightdown","");
	}
	
	function deleteRecord(){
		if(confirm('确实要删除该条记录?')){
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