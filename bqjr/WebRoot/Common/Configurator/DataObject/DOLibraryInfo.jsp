<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ���ݶ�������
	 */
	String PG_TITLE = "���ݶ�������"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));
	String sColIndex =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ColIndex"));

	if(sDoNo==null) sDoNo="";
	if(sColIndex==null) sColIndex="";
	
	String sTempletNo = "DOLibraryInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if (!sDoNo.equals("")) {
 	  	doTemp.setRequired("DoNo",false);
		doTemp.setReadOnly("DoNo",true);
	}
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//��������¼�
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateDOUpdateTime("+StringFunction.getTodayNow()+","+CurUser.getUserID()+","+sDoNo+")");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDoNo+","+sColIndex);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
	    as_save("myiframe0");        
	}
	
	function saveRecordAndReturn(){
	    as_save("myiframe0","doReturn('Y');");
	}
    
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"DoNo");
       parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
           setItemValue(0,0,"DoNo","<%=sDoNo%>");            
            setItemValue(0,0,"ColKey","0");
            setItemValue(0,0,"ColVisible","1");
            setItemValue(0,0,"ColReadOnly","0");
            setItemValue(0,0,"ColRequired","0");
            setItemValue(0,0,"ColSortable","1");
            setItemValue(0,0,"ColCheckItem","0");
            setItemValue(0,0,"ColTransferBack","0");
            setItemValue(0,0,"IsForeignKey","0");
            setItemValue(0,0,"IsInUse","1");
            setItemValue(0,0,"ColColumnType","1");
            setItemValue(0,0,"ColCheckFormat","1");
            setItemValue(0,0,"ColAlign","1");
            setItemValue(0,0,"ColEditStyle","1");            
            setItemValue(0,0,"ColType","String");
            setItemValue(0,0,"ColUpdateable","1");
            setItemValue(0,0,"ColLimit","0");
            setItemValue(0,0,"IsFilter","0");
            bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>