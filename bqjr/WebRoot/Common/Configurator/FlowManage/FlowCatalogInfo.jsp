<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    ����ģ����Ϣ����
	 */
	String PG_TITLE = "����ģ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	FlowNo�����̱��
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	if(sFlowNo==null) sFlowNo="";
   	
   	String sTempletNo = "FlowCatalogInfo";
   	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sFlowNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	function saveRecord(){
       var sAAEnabled = getItemValue(0,getRow(),"AAEnabled");
		if(sAAEnabled == "1"){ //�Ƿ������Ȩ����
			sAAPolicyName = getItemValue(0,getRow(),"AAPolicyName");
			if (typeof(sAAPolicyName)=="undefined" || sAAPolicyName.length==0){
				alert("��ѡ����Ȩ������"); 
				return;
			}
		}else{
			//������д����Ȩ������Ϊ���ַ���
			setItemValue(0,0,"AAPolicy","");
			setItemValue(0,0,"AAPolicyName",""); 
		}
		
		if(beforeSave() == false && bIsInsert){
			alert("�����̱���Ѿ���ռ��,�������µı��");
			return;
		}
		bIsInsert = false;
       as_save("myiframe0","");
	}
    
	function saveRecordAndAdd(){
       var sAAEnabled = getItemValue(0,getRow(),"AAEnabled");
		if(sAAEnabled == "1"){ //�Ƿ������Ȩ����
			sAAPolicyName = getItemValue(0,getRow(),"AAPolicyName");
			if (typeof(sAAPolicyName)=="undefined" || sAAPolicyName.length==0){
				alert("��ѡ����Ȩ������"); 
				return;
			}
		}else{
			//������д����Ȩ������Ϊ���ַ���
			setItemValue(0,0,"AAPolicy","");
			setItemValue(0,0,"AAPolicyName",""); 
		}
       as_save("myiframe0","newRecord()");        
	}
	
	/*~[Describe=�����������Ψһ��;InputParam=;OutPutParam=�Ƿ��м�¼;]~*/
    function beforeSave()
    {
    	var flowNo  = getItemValue(0,getRow(),"FlowNo");
    	
		var sPara = "FlowNo=" + flowNo + ", TableName=FLOW_CATALOG";
		var hasRecord =  RunJavaMethodSqlca("com.amarsoft.app.als.process.action.FlowNoUniqueCheck","insertUniqueCheck",sPara);
		if (hasRecord == "true"){
			return false;
		}
    }
    
	function newRecord(){
        OpenComp("FlowCatalogInfo","/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","","_self","");
	}

	function goBack(){
		AsControl.OpenView("/Common/Configurator/FlowManage/FlowCatalogList.jsp","","_self");
	}
	
	/*~[Describe=������Ȩ����ѡ�񴰿�;InputParam=��;OutPutParam=��;]~*/
	function getPolicyID(){
		var sParaString = "Today"+",<%=StringFunction.getToday()%>";
		setObjectValue("SelectPolicy",sParaString,"@AAPolicy@0@AAPolicyName@1",0,0,"");
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