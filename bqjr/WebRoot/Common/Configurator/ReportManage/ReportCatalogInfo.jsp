<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    ���񱨱�Ŀ¼��Ϣ����
		Input Param:
                    ModelNo��    �����¼���
	 */
	String PG_TITLE = "���񱨱�Ŀ¼��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if(sModelNo==null) sModelNo="";

	String sTempletNo = "ReportCatalogInfo"; //ģ����
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
	};

%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	function saveRecord()
	{
		if(beforeSave() == false && bIsInsert){
			alert("�ñ������Ѿ���ռ��,�������µı��");
			return;
		}
		bIsInsert = false;	
		as_save("myiframe0","");
		setItemReadOnly(0,0,"MODELNO",true);
	}
	
	/*~[Describe=�����������Ψһ��;InputParam=;OutPutParam=�Ƿ��м�¼;]~*/
    function beforeSave()
    {
    	var modelNo  = getItemValue(0,getRow(),"MODELNO");
		var sPara = "ModelNo=" + modelNo;
		var hasRecord =  RunJavaMethodSqlca("com.amarsoft.app.als.finance.report.ModelNoUniqueCheck","insertUniqueCheck",sPara);
		if (hasRecord == "true"){
			return false;
		}
    }

	function saveRecordAndBack(){
		as_save("myiframe0","doReturn('N');");        
	}

	function saveRecordAndAdd(){
		as_save("myiframe0","newRecord()");     
	}
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"MODELNO");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function newRecord(){
		OpenComp("ReportCatalogInfo","/Common/Configurator/ReportManage/ReportCatalogInfo.jsp","","_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			bIsInsert = true;
		}
		else{
			setItemReadOnly(0,0,"MODELNO",true);
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>