<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    ������ģ��Ŀ¼��Ϣ����
	 */
	String PG_TITLE = "������ģ��Ŀ¼��Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	ModelNo��    �����¼���
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if(sModelNo==null) sModelNo="";

 	
 	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
 	String sTempletNo = "ClassifyCatalogInfo";//ģ�ͱ��
 	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0","");
	}
	function saveRecordAndBack(){
		as_save("myiframe0","doReturn('Y');");
	}

	function saveRecordAndAdd(){
		as_save("myiframe0","newRecord()");
	}
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ModelNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function newRecord(){
		OpenComp("ClassifyCatalogInfo","/Common/Configurator/ClassifyManage/ClassifyCatalogInfo.jsp","","_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>