<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "��Ʒ�¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","200");
	CurPage.setAttribute("DetailFrameInitialText","��ѡ��һ�ʼ�¼");
	
    //�������
	String sTransID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
	String inputparatemplete =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("attribute1"));
	if(sTransID==null) sTransID="";
    if(inputparatemplete==null) inputparatemplete="";
	
	ASDataObject doTemp = new ASDataObject("TransEntryConfigList",Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTransID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
	};
%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>

	function newRecord(){
		var transID = "<%=sTransID%>";
		AsControl.OpenView("/Accounting/Config/TransEntryConfigInfo.jsp","TransID="+transID+"&Inputparatemplete=<%=inputparatemplete%>&ToInheritObj=y","DetailFrame","");
	}

	function mySelectRow(){
		var transID = getItemValue(0,getRow(),"TransID");
		var sortID = getItemValue(0,getRow(),"SortID");
		if (typeof(transID) == "undefined" || transID.length == 0)	return;
		AsControl.OpenView("/Accounting/Config/TransEntryConfigInfo.jsp","TransID="+transID+"&SortID="+sortID+"&Inputparatemplete=<%=inputparatemplete%>&ToInheritObj=y","DetailFrame","");
	}
	
	/*~[Describe=ɾ��;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord(){
		var sortID = getItemValue(0,getRow(),"SortID");
		if (typeof(sortID)=="undefined" || sortID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("ȷ��ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	</script>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	var bHighlightFirst = true;
</script>	

<%@ include file="/IncludeEnd.jsp"%>