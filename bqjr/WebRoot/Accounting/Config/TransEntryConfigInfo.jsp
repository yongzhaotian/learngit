<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "��Ʒ�¼��������"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//�������
	String sSortID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SortID"));//��¼���
	String sTransID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TransID"));//���ױ��
	String inputparatemplete =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Inputparatemplete"));//�÷�¼ģ��
    if(sSortID==null) sSortID="";
    if(sTransID==null) sTransID="";
    if(inputparatemplete==null) inputparatemplete="";
    
	ASDataObject doTemp = new ASDataObject("TransEntryConfigInfo",Sqlca);//��¼ģ������
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTransID+","+sSortID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","�����¼","saveRecord()",sResourcesPath},
	};
	%> 
	
	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>

	function saveRecord(){
		as_save("myiframe0","parent.reloadSelf(1)");
	}
	
	function getSumScript(){
		//selectMore("SumScriptEnable","SelectSumScript");
		var inputparatemplete = "<%=inputparatemplete%>";
		if(inputparatemplete=="" || inputparatemplete.length==0){
			//alert("���ȶ���ý�������ģ�壡");
			inputparatemplete = "DefaultDoNo";
		}
		var sReturn = AsControl.OpenView("/Accounting/Config/SelectDoNoList.jsp","Inputparatemplete="+inputparatemplete,"_blank","dialogWidth=700px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn) == "undefined" || sReturn.length == 0 || sReturn == '_CANCEL_' || sReturn == '_CLEAR_') return;
		setItemValue(0,0,"SumScript",sReturn);
		
	}

	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼
			setItemValue(0,0,"TransID","<%=sTransID%>");	
		}
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