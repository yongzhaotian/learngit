<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ʾ������ҳ��";

	//����������	�������š��������͡��������͡��׶����͡����̱�š��׶α�š�������ʽ����������
	String sEmpNo=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EmpNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
    
	if(sObjectType == null) sObjectType = "ForceBalanceApply";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "1010";	
	if(sFlowNo == null) sFlowNo = "ForceBalanceApplyFlow";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sEmpNo==null) sEmpNo="";

	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ForceBalanceInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(15); //��ҳ
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	
	String sButtons[][] = {
		{"true","","Button","ȷ��","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

	function initRow()
	{
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0,0,"USERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"ORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			}
	}
	
	function saveRecord(){
		  
		   var sTableName = "FORCECANCEL";//����
		   var sColumnName = "SERIALNO";//�ֶ���
		   var sPrefix = "";//ǰ׺
								
		   //��ȡ��ˮ��
	        var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		    var sObjectNo=getItemValue(0,getRow(),"PutoutNo");
			var sCustomerID=getItemValue(0, getRow(), "CustomerID");
			var sCustomerName=getItemValue(0,getRow(),"CustomerName");
			var sBusinessName=getItemValue(0,getRow(),"BUSINESSNAME");
			var sBusinessSum=getItemValue(0,getRow(),"BusinessSum");
			var sPayinteAmt=getItemValue(0,getRow(),"PayinteAmt");
			var sCPDDays=getItemValue(0,getRow(),"CPDDays");
			var sContractStatus=getItemValue(0,getRow(),"ContractStatus");
			var sSex=getItemValue(0,getRow(),"sex");
			var sCity=getItemValue(0,getRow(),"city");
			var sSalesExecutive=getItemValue(0,getRow(),"salesexecutive");
			var sStores=getItemValue(0,getRow(),"stores");
			var sInputDate="<%=StringFunction.getToday()%>";
		    RunMethod("WorkFlowEngine","InitializeFlow","<%=sObjectType%>,"+sObjectNo+",<%=sApplyType%>,<%=sFlowNo%>,<%=sPhaseNo%>,<%=CurUser.getUserID()%>,<%=CurOrg.orgID%>");
		    RunMethod("ForceCancel","InsertForceCancel",sSerialNo+","+sObjectNo+","+sCustomerID+","+sCustomerName+","+sBusinessName+","+sBusinessSum+","+sPayinteAmt+","+sCPDDays+","+sContractStatus+","+sSex+","+sCity+","+sSalesExecutive+","+sStores+","+sInputDate);
		    top.close();
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