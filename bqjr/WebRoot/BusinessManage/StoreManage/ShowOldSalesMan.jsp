<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* ҳ��˵��: ʾ������ҳ�� */
	String PG_TITLE = "ԭ���۴���չʾ ";

	// ���ҳ�����
	String oldSNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OldSNO"));
	String newSNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("NewSNO"));
	String oldSalesManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("oldSalesManager"));
	String newSalesManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("newSalesManager"));
	if(oldSalesManager == null) oldSalesManager = "";
	if(newSalesManager == null) newSalesManager = "";
	if(oldSNO == null) oldSNO = "";
	if(newSNO == null) newSNO = "";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "StoreSalesmanList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause+=" and SType is null";
	doTemp.multiSelectionEnabled=true;
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(oldSNO);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","ȷ��","ȷ��","saveRecord()",sResourcesPath},
		{"false","","Button","���沢����","���沢�����б�","saveAndGoBack()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ�� ","goBack()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">

/*~[Describe=������ѡ��ѡ��������Ա;InputParam=��;OutPutParam=��;]~*/
	
	function saveRecord(sPostEvents){
		var sSalesNos = getItemValueArray(0, "SALESMANNO");
		if (typeof(sSalesNos)=="undefined" || sSalesNos.length==0 || sSalesNos=="") {
			alert("������ѡ��һ����¼��");
			return;
		}
		sSalesNo=sSalesNos.toString();
		var re=/,/g;
		sSalesNo=sSalesNo.replace(re, "@");
		var count=RunMethod("GetElement","GetElementValue","count(serialno),storerelativesalesman,SNo='<%=oldSNO%>' and SType is null");
		if(parseInt(count)==sSalesNos.length){
			if(confirm("��ȷ��ת�Ƹ��ŵ������е����۴�����")){
				//���ŵꡢԭ���۴��������۾��� 
				var sParam = "sNo=<%=oldSNO%>,ewNo=<%=newSNO%>,salesmanNos="+sSalesNo+",salesManager=<%=oldSalesManager%>,newSalesManager=<%=newSalesManager%>,userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>";
				var reValue=RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon","updateUserInfo",sParam);
				if(reValue=="SUCESS"){
					alert("ת�Ƴɹ���");
				}
				self.close();
			}
		}else {
			//���ŵꡢԭ���۴��������۾��� 
			var sParam = "sNo=<%=oldSNO%>,ewNo=<%=newSNO%>,salesmanNos="+sSalesNo+",salesManager=<%=oldSalesManager%>,newSalesManager=<%=newSalesManager%>,userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>";
			var reValue=RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon","updateUserInfo",sParam);
			if(reValue=="SUCESS"){
				alert("ת�Ƴɹ���");
			}
			self.close();
		}

	}
	
	function saveAndGoBack(){
		self.close();
	}
	
	function goBack(){
		
		//AsControl.OpenView("/BusinessManage/StoreManage/StoreList.jsp", "", "_self","");
		top.close();
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID%>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTDATE","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");

		bIsInsert = false;
	}
	
	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
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
