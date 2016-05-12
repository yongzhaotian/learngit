<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* --ҳ��˵��: ʾ������ҳ��-- */
	String PG_TITLE = "ʾ������ҳ��";

	// ���ҳ�����
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String sActionType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ActionType"));
	if(sFlowNo==null) sFlowNo= "";
	if(sPhaseNo==null) sPhaseNo = "";
	if(sActionType==null) sActionType = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "AuditModelInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if (sPhaseNo.length()>0) 
		doTemp.WhereClause += " and FlowNo='"+sFlowNo+"' and PhaseNo="+sPhaseNo;	// �鿴����
	else
		doTemp.WhereClause += " and FlowNo='' and PhaseNo=''";	// ����
	
	// ����ֻ����
	if ("ViewDetail".equals(sActionType))
		doTemp.setReadOnly("PHASENO", false);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	<%/*~[Describe=���������Ƿ��Ѿ�����;]~*/%>
	function checkIsExists() {
		var sPhaseNo = getItemValue(0, 0, "PHASENO");
		if (typeof(sPhaseNo)=='undefined' || sPhaseNo.length==0) {
			return;
		}
		sPhaseNo = sPhaseNo.replace(/[^0-9]+/gi,'');
		setItemValue(0, 0, "PHASENO", sPhaseNo);
		if (sPhaseNo.length<=0) {
			return;
		}
		var sPhaseNo1 = RunMethod("���÷���", "GetColValue", "Flow_Model,PhaseNo,FlowNo='<%=sFlowNo%>' and PhaseNo='"+sPhaseNo.replace(/[^0-9]+/gi,'')+"'");
		//alert(sPhaseNo1+"|"+typeof(sPhaseNo1));
		if (sPhaseNo1!="Null" && sPhaseNo1.length>0) {
			alert("�ý׶��Ѿ����ڣ����������룡");
			setItemValue(0, 0, "PHASENO", "");
		}
		return;
	}
	
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	function goBack(){
		AsControl.OpenView("/SystemManage/CarManage/AuditModelList.jsp","FlowNo=<%=sFlowNo%>","_self");
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		setItemValue(0, 0, "INPUTUSER", "<%=CurUser.getUserID() %>");
		setItemValue(0, 0, "INPUTTIME", "<%=DateX.format(new Date(), "yyyy/MM/dd HH:MM:SS") %>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0, 0, "UPDATEUSER", "<%=CurUser.getUserID() %>");
		setItemValue(0, 0, "UPDATETIME", "<%=DateX.format(new Date(), "yyyy/MM/dd HH:MM:SS") %>");
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0, 0, "FLOWNO", "<%=sFlowNo %>");
			setItemValue(0, 0, "INPUTUSER", "<%=CurUser.getUserID() %>");
			setItemValue(0, 0, "INPUTTIME", "<%=DateX.format(new Date(), "yyyy/MM/dd HH:MM:SS") %>");
			
			setItemValue(0, 0, "UPDATEUSER", "<%=CurUser.getUserID() %>");
			setItemValue(0, 0, "UPDATETIME", "<%=DateX.format(new Date(), "yyyy/MM/dd HH:MM:SS") %>");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
