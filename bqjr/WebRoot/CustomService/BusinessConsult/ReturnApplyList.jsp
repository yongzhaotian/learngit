<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "�˻�����ҳ��";
    //�������
    String sTempletNoType="";
    String sBusinessDate=SystemConfig.getBusinessTime();
    String sSystemDate = SystemConfig.getBusinessDate();
    
	//���ҳ�����
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	if(sApplyType==null) sApplyType="";
	
	if(sApplyType.equals("Y001")){//�˻�����
		sTempletNoType="ReturnApplyList";
	}
	if(sApplyType.equals("Y002")){//����ȡ��
		sTempletNoType="InsureCancelApplyList";
	}
	if(sApplyType.equals("Y003")){//���ս�����
		sTempletNoType="InsureApplyList";
	}
	if(sApplyType.equals("Y004")){//��ǰ��������
		sTempletNoType="BeginRepayList";
	}
	if(sApplyType.equals("Y005")){//�˿�����
		sTempletNoType="RefundRepayList";
	}
	if(sApplyType.equals("Y006")){//�����˺ű������
		sTempletNoType="ChargeApplyList";
	}
	if("Y007".equals(sApplyType)){ //�����ļ���ѯ
		sTempletNoType = "BankLinkInfo";
	}
	if("Y010".equals(sApplyType)){ //�����ļ���ѯ
		sTempletNoType = "WithholdFileQuery";
	}
	if("Y011".equals(sApplyType)){ //�����ļ���ѯ
		sTempletNoType = "SendFileQuery";
	}
	if("Y012".equals(sApplyType)){ //�ٴδ�������
		sTempletNoType = "WithholdApproveList";
	}
	if("Y013".equals(sApplyType)){ //�˿������ѯ
		sTempletNoType="RefundRepayList";
	}
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = sTempletNoType;//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	if(sApplyType.equals("Y013")){
		doTemp.setFilter(Sqlca, "0030", "customername", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "0040", "inputuserid", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "0050", "inputdate", "Operators=EqualsString,BeginsWith;"); 
	}
	doTemp.parseFilterData(request,iPostChange);
	
	if(!doTemp.haveReceivedFilterCriteria()) {
	  if(sApplyType.equals("Y013")){
			doTemp.WhereClause = " where status in ('1','3')";
		}else{
			doTemp.WhereClause = " where 1=2";
		}
	}
	if ( "Y010".equals(sApplyType)) {
		String dateFormat = "";
		String dataParam = "";
		String tip = "";
		if ("Y010".equals(sApplyType)) {
			dateFormat = "yyyy/MM/dd";
			dataParam = "��������";
			tip = "1990/01/01";
		}
		doTemp.WhereClause = " where 1 = 1";
		doTemp.setFilter(Sqlca, "0001", "InputDate", "Operators=EqualsString,BeginsWith;");
		doTemp.setCheckFormat("InputDate", "3");
		doTemp.parseFilterData(request, iPostChange);
		String tmp = "";
		for (int k = 0; k < doTemp.Filters.size(); k++) {
			
			if (("0001").equals(doTemp.getFilter(k).sFilterID)) {
				tmp = doTemp.Filters.get(k).sFilterInputs[0][1];
				if (tmp == null || "".equals(tmp)) {
					doTemp.WhereClause += " and 1 = 2";
				} else {
					boolean flag = true;
					SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
					sdf.setLenient(false);
					try {
						sdf.parse(tmp);
					} catch (Exception e) {
						flag = false;
					}
					if (!flag) {
						%>
							<script type="text/javascript">
								alert("Ϊ�˲�ѯ����������<%=dataParam %>(��ʽ��<%=tip %>)��ʽ������ȷ��");
							</script>
						<%
						doTemp.WhereClause += " and 1 = 2";
					}
				}
			}
		}
	}
	
	//System.out.println("sApplyType="+sApplyType);
	if(sApplyType.equals("Y004")){
		boolean flag = false;
		for(int k = 0; k < doTemp.Filters.size(); k++){
			if(doTemp.Filters.get(k).sFilterInputs[0][1] != null 
					&& (("al.putoutno").equals(doTemp.getFilter(k).sFilterColumnID))){
				flag = true;
				break;
			}
			if(doTemp.Filters.get(k).sFilterInputs[0][1] != null 
					&& (("at.inputtime").equals(doTemp.getFilter(k).sFilterColumnID))){
				flag = true;
				break;
			}
		}
		//System.out.println("flag="+flag);
		if(!flag && doTemp.haveReceivedFilterCriteria()) {
			%>
			<script type="text/javascript">
				alert("Ϊ�˲�ѯ������������ͬ��/����ʱ��(��ʽ��1990/01/01)����¼��һ�");
			</script>
			<%
			doTemp.WhereClause+=" and 1=2";
		}	
	}
	
	if("Y011".equals(sApplyType)){ //�����ļ���ѯ
		doTemp.WhereClause = " where 1 = 1";
		doTemp.setFilter(Sqlca, "0001", "CONTRACTSERIALNO", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "0002", "CUSTOMERID", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "0003", "CUSTOMERNAME", "Operators=EqualsString,BeginsWith;");
		doTemp.setFilter(Sqlca, "0004", "WITHHOLDDATE", "Operators=EqualsString,BeginsWith;");
		doTemp.parseFilterData(request, iPostChange);
		
		if (doTemp.haveReceivedFilterCriteria()) {
			 
			 //�������ѯ����
			 boolean flag = true;
			 for (int k=0; k<doTemp.Filters.size(); k++) {
				if((("0001").equals(doTemp.getFilter(k).sFilterID)
						|| ("0002").equals(doTemp.getFilter(k).sFilterID)
						|| ("0003").equals(doTemp.getFilter(k).sFilterID)
						|| ("0004").equals(doTemp.getFilter(k).sFilterID))
						&& doTemp.Filters.get(k).sFilterInputs[0][1] != null) {
					flag = false;
					break;
				}
			 }
			 
			 if(flag){
				%>
					<script type="text/javascript">
						alert("��ͬ���롢�ͻ����롢�ͻ����ơ��������ڱ�������һ��!");
					</script>
				<%
				doTemp.WhereClause += " and 1 = 2";
			 }
			 
			 /* for (int k=0; k<doTemp.Filters.size(); k++) {
				if((("0001").equals(doTemp.getFilter(k).sFilterID)
						|| ("0002").equals(doTemp.getFilter(k).sFilterID)
						|| ("0003").equals(doTemp.getFilter(k).sFilterID)
						|| ("0004").equals(doTemp.getFilter(k).sFilterID))
						&& doTemp.Filters.get(k).sFilterInputs[0][1] != null) {
					flag = false;
					break;
				}
			 } */
		} else {
			doTemp.WhereClause = " where 1 = 2";
		}
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(15);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{(sApplyType.equals("Y001")?"true":"false"),"","Button","ȷ���˻�","ȷ���˻�","saveRecord()",sResourcesPath},
		{(sApplyType.equals("Y002")?"true":"false"),"","Button","ȷ�ϱ���ȡ��","ȷ�ϱ���ȡ��","InsureCancel()",sResourcesPath},
		{(sApplyType.equals("Y003")?"true":"false"),"","Button","ȷ�ϱ��ս�","ȷ�ϱ��ս�","InsureApply()",sResourcesPath},
		{(sApplyType.equals("Y004")?"true":"false"),"","Button","ȷ����ǰ����","ȷ����ǰ����","BeginRepay()",sResourcesPath},
		{(sApplyType.equals("Y004")?"true":"false"),"","Button","ȡ����ǰ����","ȡ����ǰ����","cancelRepay()",sResourcesPath},
		{(sApplyType.equals("Y005")?"true":"false"),"","Button","ȷ���˿�","ȷ���˿�","Refund()",sResourcesPath},
		{(sApplyType.equals("Y005")?"true":"false"),"","Button","�ܾ��˿�","�ܾ��˿�","CancelRefund()",sResourcesPath},
		/* {(sApplyType.equals("Y006")?"true":"false"),"","Button","ȷ���յ������˺ű������","ȷ���յ������˺ű������","UpdateWithhold()",sResourcesPath},
		 */
		 {(sApplyType.equals("Y006")?"true":"false"),"","Button","�����˺ű������","�����˺ű������","withholdChange()",sResourcesPath},
		 {(sApplyType.equals("Y007")?"true":"false"),"","Button","�ļ�����","ȷ�ϱ��","queryDocument()",sResourcesPath},
		 {(sApplyType.equals("Y007")?"true":"false"),"","Button","����Excel","����Excel","exportAll()","","","",""},
		 {(sApplyType.equals("Y010")?"true":"false"),"","Button","�����ļ�����","�����ļ�����","WithholdDetails()","","","",""},
		 {((sApplyType.equals("Y012") && (CurUser.hasRole("1039")||CurUser.hasRole("1036")||CurUser.hasRole("1051")||CurUser.hasRole("1052")))?"false":"false"),"","Button","ȷ��","ȷ��","affirmWithhold()","","","",""},
		 {((sApplyType.equals("Y012") && (CurUser.hasRole("1039")||CurUser.hasRole("1036")||CurUser.hasRole("1051")||CurUser.hasRole("1052")))?"false":"false"),"","Button","ȡ��","ȡ��","cancelWithhold()","","","",""},
	};
    
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function check(val){
		
		if (val != null && val != "") {
			var a = /^(\d{4})-(\d{2})-(\d{2})$/
			if (!a.test(val)) { 
				alert("���ڸ�ʽ����ȷ!") 
				return false 
			} 
			else {
				return true;
			}
		} 
	} 
	<%/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/%>
	function exportAll(){
		amarExport("myiframe0");
	}

	<%/*~[Describe=�ٴδ�������ȷ��;InputParam=��;OutPutParam=��;]~*/%>
	function affirmWithhold(){
		var sSerialNo = getItemValue(0,getRow(),"serialno");
		var sStatus = getItemValue(0,getRow(),"status");
		var sInputDate = getItemValue(0,getRow(),"inputdate");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(sStatus == "2" || sStatus == "3"){
			alert("������������ͨ������ȡ��");
			return;
		}
		
		if("<%=sSystemDate%>"!=sInputDate){
			alert("��������벻��������");
			return;
		}
		
		sApproveDate="<%=sBusinessDate%>";
		sApproveUserID="<%=CurUser.getUserID()%>";
		sApproveOrgID="<%=CurOrg.orgID %>";
		
		var sReturnValue=RunMethod("BusinessManage","UpdateAffirmWithhold",sApproveDate+","+sApproveUserID+","+sApproveOrgID+","+sSerialNo);
		if(sReturnValue=="1.0"){
			alert("ȷ�ϳɹ�");
		}else{
			alert("ȷ��ʧ��");
		}
		reloadSelf();
	}
	
	<%/*~[Describe=ȡ���ٴδ�������;InputParam=��;OutPutParam=��;]~*/%>
	function cancelWithhold(){
		var sSerialNo = getItemValue(0,getRow(),"serialno");
		var sStatus = getItemValue(0,getRow(),"status");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(sStatus == "2" || sStatus == "3"){
			alert("������������ͨ������ȡ��");
			return;
		}
		
		sApproveDate="<%=sBusinessDate%>";
		sApproveUserID="<%=CurUser.getUserID()%>";
		sApproveOrgID="<%=CurOrg.orgID %>";
		
		var sReturnValue=RunMethod("BusinessManage","UpdateCancelWithhold",sApproveDate+","+sApproveUserID+","+sApproveOrgID+","+sSerialNo);
		if(sReturnValue=="1.0"){
			alert("ȡ���ɹ�");
		}else{
			alert("ȡ��ʧ��");
		}
		reloadSelf();
	}
	
	// ��ѯ�ļ�
	function queryDocument() {
		sInputDate = getItemValue(0,getRow(),"InputDate");
		sFlag = getItemValue(0,getRow(),"flag");
		//alert(sFlag);
		AsControl.PopView("/CustomService/BusinessConsult/QueryDocTreeView.jsp", "InputDate="+sInputDate+"&flag="+sFlag, "");
	}
	
	// ��ѯ�����ļ�����
	function WithholdDetails() {
		sFlag = getItemValue(0,getRow(),"Flag");
		sInputDate = getItemValue(0,getRow(),"InputDate");
		AsControl.PopView("/CustomService/BusinessConsult/WithholdFileQuery.jsp", "InputDate="+sInputDate+"&Flag="+sFlag, "");
	}
	
	function saveRecord()
	{
		var sSerialNo =getItemValue(0,getRow(),"serialno");

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		 
		
		var sApproveDate = getItemValue(0,getRow(),"approvedate");
		
		if (typeof(sApproveDate)=="undefined" || sApproveDate.length==0)
		{
			//�Ƿ�����ԥ����
			var sReturn=RunMethod("BusinessManage","HesitateDay",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ�ѳ�����ԥ����,�����˻�");
				return;
			} 
			
			//��ȡ��ͬ��ݺš�ԭ������Ϣ
			var sLoanSerialNo = RunMethod("PublicMethod","GetColValue","SerialNo,ACCT_LOAN,String@PutOutNo@"+sSerialNo);//��ͬ��ݺ�
			if(typeof(sLoanSerialNo)=="undefined" || sLoanSerialNo.length==0){
				alert("ϵͳ�����쳣��");
				return;
			}else{
				sLoanSerialNo = sLoanSerialNo.split("@")[1];
			}
			
			var sTransReturn = RunMethod("���÷���","GetColValue","ACCT_TRANSACTION,SerialNo,documentserialno='"+sSerialNo+"' and relativeobjectno='"+sLoanSerialNo+"' " );//������ˮ��
			var sTransSerialNo = sTransReturn;
			var returnValue = runTransaction(sLoanSerialNo,sTransSerialNo);
			if(returnValue){
				sReturn=RunMethod("BusinessManage","UpdateRefundContractStatus",sSerialNo);
				sApproveDate="<%=sBusinessDate%>";
				sApproveUserID="<%=CurUser.getUserID()%>";
				sApproveOrgID="<%=CurOrg.orgID %>";
				var sReturnValue=RunMethod("BusinessManage","UpdateRefundCargoApply",sApproveDate+","+sApproveUserID+","+sApproveOrgID+","+sSerialNo);
				if(sReturn=="1.0" && sReturnValue=="1.0"){
					 if(sSerialNo){
						var sUserID = "<%=CurUser.getUserID()%>";
						var policyNo = RunMethod("BusinessManage","GetLatstPolicy",sSerialNo);
						//��̨ץȡ���ݴ���
						//RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateMinanSerialNo", "httpPostPolicyno","policyno="+policyNo+",updateBy="+sUserID);//�˻���ͬʱ�˱�
					} 
					alert("ȷ�ϳɹ�");
				}else{
					alert("ȷ��ʧ��");
				}
			}
		}else{
			alert("���˻�����������ͨ��");
		}
		reloadSelf();
		
	}
	
	//ǿ���˿�
	<%-- function returnTransaction(sLoanSerialNo,sTransSerialNo){
		var objectType = "";
		var transactionCode = "4030";
		var relativeObjectType = "<%=BUSINESSOBJECT_CONSTATNTS.transaction%>";
		
		var relativeObjectNo = sTransSerialNo;
		var transactionDate = "<%=SystemConfig.getBusinessDate()%>";

		//��������ͬʱ����������Ϣ
		var returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>,2");
		if(returnValue.substring(0,5) != "true@") {
			alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
			return;
		}
		//ִ�н���
		var transactionSerialNo = returnValue.split("@")[1];	
		var returnTransValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,N");
		if(typeof(returnTransValue)=="undefined"||returnTransValue.length==0||returnTransValue.split("@")[0]=="false"){
			//�������ִ��ʧ����ɾ��������Ϣ�͵�����Ϣ
			RunMethod("LoanAccount","DeleteAcctTransPayment",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			RunMethod("LoanAccount","DeleteAcctTransaction",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			alert("ϵͳ�����쳣��");
			return false;
		}
		return true;		
	} --%>
	
	function runTransaction(sLoanSerialNo,sTransSerialNo){
		var objectType = "";
		var transactionCode = "4015";
		var relativeObjectType = "<%=BUSINESSOBJECT_CONSTATNTS.transaction%>";
		
		var relativeObjectNo = sTransSerialNo;
		var transactionDate = "<%=SystemConfig.getBusinessDate()%>";

		//��������ͬʱ����������Ϣ
		var returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>,2");
		if(returnValue.substring(0,5) != "true@") {
			alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
			return;
		}
		//ִ�н���
		var transactionSerialNo = returnValue.split("@")[1];	
		var returnTransValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,N");
		if(typeof(returnTransValue)=="undefined"||returnTransValue.length==0||returnTransValue.split("@")[0]=="false"){
			//�������ִ��ʧ����ɾ��������Ϣ�͵�����Ϣ
			var documentserialno = RunMethod("PublicMethod","GetColValue","documentserialno,ACCT_TRANSACTION,String@transcode@4015@String@SerialNo@"+transactionSerialNo+"@String@relativeobjectno@"+sLoanSerialNo);
			RunMethod("PublicMethod","DeleteAcctPaymentValue",documentserialno);//"acct_trans_payment,SerilNo,"
			RunMethod("PublicMethod","DeleteColValue",transactionSerialNo);//"ACCT_TRANSACTION,SerialNo,"
			alert("ϵͳ�����쳣��");
			return false;
		}
		var message=returnValue.split("@")[1];	
		return true;		
	}
	
	
	//����ȡ��
	function InsureCancel(){
		var sSerialNo = getItemValue(0,getRow(),"ApplySerialNo");

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		//�޸Ĵ���״̬
		
		
		
	}
	
	
	//���ս�
	function InsureApply(){
		var sSerialNo = getItemValue(0,getRow(),"ApplySerialNo");//

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
	
		
	}
	//�����˺����� add by cliu 2013/05/20 begin
	function withholdChange(){
    	//���������ˮ��
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	var sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo"); //add by yzhang9  ��ȡ��ͬ��� CCS-444 
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		 sCompID = "ChargeApplyInfo";
		sCompURL = "/InfoManage/QuickSearch/ChargeApplyInfo.jsp";
		//sCompURL = "/SystemManage/SynthesisManage/ChangeCustomerInfo.jsp";
		sParamString = "SerialNo="+sSerialNo+"&ContractSerialNo="+sContractSerialNo;// add by yzhnag 9  CCS-444 ����ͬ��Ŵ����¸�ҳ��  ��������ProductID 
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
    }
	//�����˺����� add by cliu 2013/05/20 end 
	
	/* //�����˺ű��
	function UpdateWithhold(){
		var sSerialNo = getItemValue(0,getRow(),"CustomerID");//������
		var sNewAccountName = getItemValue(0,getRow(),"NewAccountName");//�´����˻�����
		var sNewAccount = getItemValue(0,getRow(),"NewAccount");//�´����˻��˺�
		var sNewBankName = getItemValue(0,getRow(),"NewBankName");//�´����˻�������

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
			//2.���´����˺�
			sReturn = RunMethod("BusinessManage","UpdateReplace",sSerialNo+","+sNewAccountName+","+sNewAccount+","+sNewBankName);
			//alert("======"+sReturn);
			if(sReturn=="1.0"){
				alert("�����˺Ÿ�����ɣ�");
			}else{
				alert("�����˺��޷����£����飡");
			}

	} */
	
	//��ǰ����
	function BeginRepay(){
		var sSerialno = getItemValue(0,getRow(),"Serialno");
		var sContractSerialNo=getItemValue(0,getRow(),"PutoutNo");//��ͬ��� 
		var sTransStatus = getItemValue(0,getRow(),"TransStatus");//����״̬
		var sAdvanceHesitateDate1=RunMethod("BusinessManage","BusinessHesitateDate",sContractSerialNo);//��ȡ��ԥ������
		var sAdvanceHesitateDate=parseInt(sAdvanceHesitateDate1);
		var sReturn1=RunMethod("BusinessManage","ApproveHesitateDay",sContractSerialNo+","+sSerialno+","+sAdvanceHesitateDate);
		if (typeof(sSerialno)=="undefined" || sSerialno.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		if(sTransStatus!="0"){
			alert("ֻ������״̬Ϊ�����е������������и��˲�������");
			return;
		}
		
		var sApproveDate = getItemValue(0,getRow(),"ApproveDate");
		
		if (typeof(sApproveDate)=="undefined" || sApproveDate.length==0)
		{
			sApproveDate="<%=sBusinessDate%>";
			sApproveUserID="<%=CurUser.getUserID()%>";
			sApproveOrgID="<%=CurOrg.orgID %>";
			
			var sReturn=RunMethod("BusinessManage","UpdatePrePaymentApply",sApproveDate+","+sApproveUserID+","+sApproveOrgID+","+sSerialno);
		
			if(sReturn=="1.0"){
				if(sReturn1!=0){
				RunMethod("BusinessManage","UpdateIswaver",sContractSerialNo);//����ԥ�ڱ�־	
				}else{
				RunMethod("���÷���", "UpdateColValue", "Business_Contract,Iswaver,,SerialNo='"+sContractSerialNo+"'");//����ԥ�ڱ�־Ϊ��
				}
				alert("ȷ�ϳɹ�");
			}else{
				alert("ȷ��ʧ��,����");
			}
		}else{
			alert("����ǰ���������Ѿ�����ͨ��");
		}
		reloadSelf();
	}
	
	//ȡ����ǰ����
	function cancelRepay(){
		var sSerialno = getItemValue(0,getRow(),"Serialno");//������ˮ��
		var sLoanSerialNo = getItemValue(0,getRow(),"LoanSerialNo");//��ݺ�
		var sTransStatus = getItemValue(0,getRow(),"TransStatus");//����״̬
		var sTransDate = getItemValue(0,getRow(),"TransDate");//��������
		var sContractSerialNo=getItemValue(0,getRow(),"PutoutNo");//��ͬ��� 
		if (typeof(sSerialno)=="undefined" || sSerialno.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if(sTransStatus!="0" && sTransStatus!="3"){
			alert("ֻ������״̬Ϊ�����л�������ͨ�������������ȡ������");
			return;
		}
		
		if(sTransDate<="<%=SystemConfig.getBusinessDate()%>"){
			alert("��ǰ��������С��ϵͳ���ڣ����������ò�������");
			return;
		}

		var sReturn=RunMethod("BusinessManage","CancelPrePaymentApply",sLoanSerialNo+","+sSerialno);

		if(sReturn=="Success"){	
			RunMethod("���÷���", "UpdateColValue", "Business_Contract,Iswaver,,SerialNo='"+sContractSerialNo+"'");//��ǰ����ȡ�����ͬ��ԥ�ڱ�־��� 
			alert("ȡ���ɹ�");
		}else{
			alert("ȡ��ʧ��,����");
		}
		reloadSelf();
	}
	
	//ȷ���˿�
	function Refund(){
		var sCustomerID = getItemValue(0,getRow(),"customerid");
		var sReturnAmt = getItemValue(0,getRow(),"returnamt");
		var sStatus = getItemValue(0,getRow(),"status");
		var sSerailNo = getItemValue(0,getRow(),"serialno");

		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if (typeof(sStatus)=="undefined" || sStatus.length==0)
		{
			alert("����״̬Ϊ��!");  //��ѡ��һ����¼��
			return;
		}
		if(sStatus!="1"){
			alert("�������е��˿����ȷ���˿�!");
			return;
		}
		var sReturn=RunMethod("BusinessManage","CustomerDeposits",sCustomerID);
		
		if(parseFloat(sReturn)<parseFloat(sReturnAmt)){
			alert("�˿������Ԥ������,�����˿�");
			return;
		}	
		
		var sApproveDate = getItemValue(0,getRow(),"approvedate");
		
		if (typeof(sApproveDate)=="undefined" || sApproveDate.length==0)
		{
			sApproveDate="<%=sBusinessDate%>";
			sApproveUserID="<%=CurUser.getUserID()%>";
			sApproveOrgID="<%=CurOrg.orgID %>";
			
			var sResult=RunMethod("BusinessManage","UpdateRefundApply",sApproveDate+","+sApproveUserID+","+sApproveOrgID+","+sCustomerID);
			var sUpdateReturn=RunMethod("BusinessManage","UpdateDepositsAmount",sCustomerID+","+sReturnAmt);
		
			if(sResult=="1.0" && sUpdateReturn=="1.0"){	
				alert("ȷ�ϳɹ�");
				var sSerialNo = getSerialNo("BATCH_ADVANCE_LOG","SERIALNO","");
				var lastDeposits = sReturn;
				RunMethod("���÷���", "UpdateColValue", "refund_deposits,status,2, serialno='"+sSerailNo+"'");
				var sReturnnow=RunMethod("BusinessManage","CustomerDeposits",sCustomerID);
				RunMethod("BusinessManage","InsertAdvanceLog",sSerialNo+",<%=sBusinessDate%>,"+sCustomerID+","+lastDeposits+","+sReturnnow);
			}else{
				alert("ȷ��ʧ��,����");
			}
		}else{
			alert("���˿��Ѿ�����ͨ��");
		}
		reloadSelf();
	}
	
	
	//ȡ���˿�
	function CancelRefund(){
		if(!confirm("�Ƿ�ȷ�Ͼܾ��˿�")){
			return;
		}
		var sCustomerID = getItemValue(0,getRow(),"customerid");
		var sStatus = getItemValue(0,getRow(),"status");

		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		if (typeof(sStatus)=="undefined" || sStatus.length==0)
		{
			alert("����״̬Ϊ��!");  //��ѡ��һ����¼��
			return;
		}
		if(sStatus!="1"){
			alert("�������е��˿����ȡ���˿�!");
			return;
		}
		var sApproveDate = getItemValue(0,getRow(),"approvedate");
		
		if (typeof(sApproveDate)=="undefined" || sApproveDate.length==0)
		{
			sApproveDate="<%=sBusinessDate%>";
			sApproveUserID="<%=CurUser.getUserID()%>";
			sApproveOrgID="<%=CurOrg.orgID %>";
			
			var sResult=RunMethod("BusinessManage","CancelRefundApply",sApproveDate+","+sApproveUserID+","+sApproveOrgID+","+sCustomerID);
		
			if(sResult=="1.0"){	
				alert("ȡ���ɹ�");
			}else{
				alert("ȡ��ʧ��,����");
			}
		}else{
			alert("���˿���ȡ��");
		}
		reloadSelf();
	}


	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();//��ѯ����չ������
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>