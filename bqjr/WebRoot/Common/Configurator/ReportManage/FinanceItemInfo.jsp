<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    �����Ŀ����
		Input Param:
                    ItemNo��    �����¼���
	 */
	String PG_TITLE = "�����Ŀ����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
	if(sItemNo==null) sItemNo="";

	String sTempletNo = "FinanceItemInfo"; //ģ����
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sItemNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndBack()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	function saveRecordAndBack(){
		if(beforeSave() == false && bIsInsert){
			alert("�ÿ�Ŀ����Ѿ���ռ��,�������µı��");
			return;
		}
		
		bIsInsert = false;	
        as_save("myiframe0","doReturn('Y');");
	}

	function saveRecordAndAdd(){
		if(beforeSave() == false && bIsInsert){
			alert("�ÿ�Ŀ����Ѿ���ռ��,�������µı��");
			return;
		}
		bIsInsert = false;	
		
        as_save("myiframe0","newRecord()");
	}
    
	/*~[Describe=�����������Ψһ��;InputParam=;OutPutParam=�Ƿ��м�¼;]~*/
    function beforeSave()
    {
    	var itemNo  = getItemValue(0,getRow(),"ItemNo");
		var sPara = "ItemNo=" + itemNo;
		var hasRecord =  RunJavaMethodSqlca("com.amarsoft.app.als.finance.report.ItemNoUniqueCheck","insertUniqueCheck",sPara);
		if (hasRecord == "true"){
			return false;
		}
    }
	
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ItemNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function newRecord(){
        OpenComp("FinanceItemInfo","/Common/Configurator/ReportManage/FinanceItemInfo.jsp","","_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
		    bIsInsert = true;
		}
		else{
			setItemReadOnly(0,0,"ItemNo",true);
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>