<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "�����б�"; // ��������ڱ��� <title> PG_TITLE </title>
%>

<%
	String parentTermID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentTermID"));
	if(parentTermID == null)
	{
		parentTermID = "";
	}
	String objectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(objectType == null)
	{
		objectType = "Term";
	}
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(objectNo == null)
	{
		objectNo = parentTermID;
	}
%>

<%
	ASDataObject doTemp = new ASDataObject("TermSetSegmentList",Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
	dwTemp.setEvent("AfterDelete","!ProductManage.DeleteTermParameter(#TermID,"+objectType+","+objectNo+")+!ProductManage.DeleteTermRelative(#TermID,"+parentTermID+","+objectType+","+objectNo+")");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(parentTermID+","+objectType+","+objectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
%>
<%
	String sButtons[][] = {
		{parentTermID.equals("")?"false":"true","","Button","��������","��������","newRecord()",sResourcesPath},
		{"true","","Button","�༭����","�༭����","viewAndEdit()",sResourcesPath},	
		{"true","","Button","ɾ������","ɾ������","deleteRecord()",sResourcesPath},	
	};
%> 


<%@include file="/Resources/CodeParts/List05.jsp"%>


<script language=javascript>

	function newRecord(){
		AsControl.OpenView("/Accounting/Config/TermSetSegmentInfo.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&ParentTermID=<%=parentTermID%>","_blank",OpenStyle);
		reloadSelf();
	}
	
	function deleteRecord(){
		var termID = getItemValue(0,getRow(),"TermID");
		if (typeof(termID)=="undefined" || termID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	function viewAndEdit(){
		var termID = getItemValue(0,getRow(),"TermID");
		if(typeof(termID)=="undefined" || termID==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       	AsControl.OpenView("/Accounting/Config/TermSetSegmentInfo.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&ParentTermID=<%=parentTermID%>&TermID="+termID,"_blank",OpenStyle);
		reloadSelf();
	}
	
</script>



<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');	
</script>	

<%@ include file="/IncludeEnd.jsp"%>
