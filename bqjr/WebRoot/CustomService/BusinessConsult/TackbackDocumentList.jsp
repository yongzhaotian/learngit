<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String sMatchType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MatchType"));
	String sInputDate =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputDate"));
	String sflag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("flag"));
	String sBusinessDate=SystemConfig.getBusinessDate();
	
	if(sMatchType == null) sMatchType="";
	if(sInputDate == null) sInputDate="";
	if(sflag == null) sflag="";
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "TackbackFileList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	if(!"02".equalsIgnoreCase(sflag)){
		doTemp.WhereClause +=" and  flag is null ";
	}else{
		doTemp.WhereClause +=" and  flag ='02' ";
	}
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sInputDate+","+sMatchType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  ����  ����  �ر�  ��ʱ�ر�  ȡ���ر�
		{"false","","Button","�ֹ�ƥ��","�ֹ�ƥ��","newRecord()",sResourcesPath},
		{"false","","Button","�ֹ�����","�ֹ�����","manualLeave()",sResourcesPath},
	};
	if ("1".equals(sMatchType)) sButtons[0][0] = "true";
	if ("3".equals(sMatchType)) sButtons[1][0] = "true";
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	function newRecord(){
		var Serialno = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(Serialno) == "undefined" || Serialno.length == 0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		var rpyNam = getItemValue(0,getRow(),"RPYNAM");
		if(rpyNam == "�������������װ��½��ڷ������޹�˾" || rpyNam == "��̩�����������ι�˾" || rpyNam == "�����п츶ͨ��������Ƽ��������޹�˾"){
			alert("��/��������Ϊ��"+rpyNam+"���Ŀͻ�����������ֹ�ƥ��");
			return;
		}
		
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/BankLinkInfo.jsp","SerialNo="+Serialno,"_self","");
	}
	
	function manualLeave(){
		var sSerialno = getItemValue(0,getRow(),"SERIALNO");
		var sUpdateDate = getItemValue(0,getRow(),"UPDATEDATE");
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
		var sTrsAmtC = getItemValue(0,getRow(),"TRSAMTC");
		var sUpdateUserID = getItemValue(0,getRow(),"UPDATEUSERID");
		var sUpdateOrgID = getItemValue(0,getRow(),"UPDATEORGID");
				
		var sCurOrg = "<%=CurOrg.orgID %>";
		var sCurUser = "<%=CurUser.getUserID()%>";
		
		if (typeof(sSerialno) == "undefined" || sSerialno.length == 0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("��ȷ�Ϸ���ñʽ�����")){
							
			var sDepositsAmt = RunMethod("BusinessManage","CustomerDeposits",sCustomerID);
			if(sDepositsAmt=="Null" || typeof(sDepositsAmt)=="undefined" || sDepositsAmt.length==0 || "<%=sBusinessDate%>"==sUpdateDate){
				var sParaString = sCustomerID+","+sUpdateDate+","+sUpdateUserID+","+sUpdateOrgID+","+sCurOrg+","+sCurUser+","+sTrsAmtC+","+sSerialno;
				
				var sReturn = RunMethod("BusinessManage","BankLinkChange",sParaString);
				if(sReturn == "success"){
					alert("����ɹ�");
				}
				reloadSelf();
			}else{
				
				if(sTrsAmtC > sDepositsAmt){
					alert("�ý��������˻���������������������");
					return;
				}
				
				var sParaString = sCustomerID+","+sUpdateDate+","+sUpdateUserID+","+sUpdateOrgID+","+sCurOrg+","+sCurUser+","+sTrsAmtC+","+sSerialno;
				
				var sReturn = RunMethod("BusinessManage","BankLinkChange",sParaString);
				if(sReturn == "success"){
					alert("����ɹ�");
				}
				reloadSelf();
			}
				
		}
	}
	
	function deleteRecord(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/RetailManage/RetailInfoTab.jsp","RSerialNo="+sSerialNo,"_blank","");
		reloadSelf();
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//ʹ��ObjectViewer����ͼ001��Example��
	}

	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>