<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    ����ģ��Ŀ¼����
	 */
	String PG_TITLE = "����ģ��Ŀ¼����";
	
	//����������	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if(sModelNo==null) sModelNo="";
	
	String sTempletNo = "EvaluateCatalogInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	if (!sModelNo.equals("")){
		doTemp.setReadOnly("ModelNo",true);
	}else{
		doTemp.setRequired("ModelNo",true);
	}
	
 	//filter��������
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","���沢����","�����޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
		{"true","","Button","ת����������","ת����������","my_formatIF()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0","self.close();");
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
        OpenComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","","_self","");
	}

	function my_formatIF(){
		try{
			var sValue = getItemValue(0,getRow(),"TransformMethod");
			sValue = sValue.replace(/\r\nif/g,"if"); 
			sValue = sValue.replace(/if/g,"\r\nif"); 
			sValue = sValue.replace("\r\n",""); 
			setItemValue(0,getRow(),"TransformMethod",sValue);	
		} catch(e){}	
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
		    bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>