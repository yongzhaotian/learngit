<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "ҵ�������ϸ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>//20100803 ltma
%>


<%	
	String termID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TermID"));
	if(termID == null)
	{
		termID = "";
	}
	String parentTermID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentTermID"));
	if(parentTermID == null) 
	{
		parentTermID = "";
	}
	String termType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TermType"));
	if(termType == null)
	{
		termType = Sqlca.getString("select TermType from PRODUCT_TERM_LIBRARY where TermID = '"+parentTermID+"' ");
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
	String sTempletNo = "TermSetSegmentInfo";
	String sTempletFilter = "1=1";
	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//���ɶ��ҳ��
	dwTemp.setHarborTemplate(DWExtendedFunctions.getDWDockHTMLTemplate(sTempletNo,sTempletFilter,Sqlca));

	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setEvent("AfterInsert","!ProductManage.CreateSegTerm(#TermID,"+parentTermID+","+objectType+","+objectNo+")+!ProductManage.ImportSegTermParameter(#TermID,"+parentTermID+","+objectType+","+objectNo+")");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(termID+","+parentTermID+","+objectType+","+objectNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String parameterCount = Sqlca.getString("select count(*) from PRODUCT_TERM_PARA where TermID = '"+termID+"'");
	
%>
<%
	String sButtons[][] = {
		{"true","","Button","����","����","saveRecord()",sResourcesPath},
	};
%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>


<script language=javascript>

	function saveRecord(){
	    var termID = getItemValue(0,getRow(),"TermID");
	    var sortNo = getItemValue(0,getRow(),"SortNo");
	    if(typeof(sortNo)=="undefined" || sortNo.length==0){
	    	return ;
	    }
	    if(typeof(termID)=="undefined" || termID.length==0){
	    	var parentTermID = getItemValue(0,getRow(),"ParentTermID");
	    	termID=parentTermID+"-"+sortNo;
	    	setItemValue(0,0,"TermID",termID);
	    }
		var sReturn = RunMethod("PublicMethod","GetColValue","1,PRODUCT_TERM_LIBRARY,String@ObjectNo@<%=objectNo%>~String@ObjectType@<%=objectType%>~String@TermID@"+termID);
		if(sReturn =="1"){
			alert("���α���ظ�����ȷ�ϣ�");
			return;
		}
		if(confirm('ȷ��������')){//20100806 ltma:�������ݿⱣ��ʱ�����޸���ȷ��
			as_save("myiframe0","open_self();");
		}
	}
	
	function open_self(){
		var termID = getItemValue(0,getRow(),"TermID");
		var parentTermID = getItemValue(0,getRow(),"ParentTermID");
		AsControl.OpenView("/Accounting/Config/TermSetSegmentInfo.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&TermID="+termID+"&ParentTermID="+parentTermID,"_self",OpenStyle);
	}

	function initRow(){
		if (getRowCount(0)==0) {//���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			setItemValue(0,0,"TermType","<%=termType%>");
			setItemValue(0,0,"ObjectType","<%=objectType%>");
			setItemValue(0,0,"ObjectNo","<%=objectNo%>");
			setItemValue(0,0,"ParentTermID","<%=parentTermID%>");
		}
	<%if(termID!=null&&termID.length()>0){%>
		AsControl.OpenView("/Accounting/Config/TermItemList.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&TermID=<%=termID%>","ParameterList","");
		<%if(Integer.parseInt(parameterCount)>0){%>
			frames['myiframe0'].document.getElementById('ContentFrame_TermParaView').style.display="";
			AsControl.OpenView("/Accounting/Config/TermParaView.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&TermID=<%=termID%>","TermParaView","");
		<%}%>
	<%}%>
		
    }
</script>


<script language=javascript>
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>
