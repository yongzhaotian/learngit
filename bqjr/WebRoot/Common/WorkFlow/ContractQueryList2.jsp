<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: ��ͬ��Ϣ���ٲ�ѯ
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ״̬��ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ͬ״̬��ѯ&nbsp;&nbsp;";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	//����������	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//����sSql�������ݶ���

	String sTempletNo = "ContractQueryList2"; //ģ����
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	/**update tangyb 20150430 ���۴���¼�������ͬ״̬��ѯ���Ӳ�ѯ�������Ż���ѯ����  start**/
	doTemp.setKeyFilter("bu.SerialNo"); //���� SerialNo ==> bu.SerialNo
	//��������ʱ��Ϊ�����ؼ�
	doTemp.setCheckFormat("inputdate", "3");
	
	Map<String, String> roleClauseMap = new HashMap<String, String>();
	//�ŵ���г��о���ά���������۾�����ϼ�ȡ�� edit by Dahl 2015-3-20
	//roleClauseMap.put("1003", " stores in (SELECT SNO FROM STORE_INFO SI, WHERE CITYMANAGER IN (SELECT ATTR3 FROM BASEDATASET_INFO WHERE TYPECODE='CityCode' AND ATTRSTR2 IN (SELECT ACBI.ATTR1 FROM BASEDATASET_INFO ACBI WHERE TYPECODE='AreaCode' AND ATTR3='"+CurUser.getUserID()+"'))) ");
	//roleClauseMap.put("1003", " stores in (SELECT sno FROM store_info si ,user_info ui WHERE si.salesmanager=ui.userId AND ui.superid IN (SELECT ATTR3 FROM BASEDATASET_INFO WHERE TYPECODE='CityCode' AND ATTRSTR2 IN (SELECT ACBI.ATTR1 FROM BASEDATASET_INFO ACBI WHERE TYPECODE='AreaCode' AND ATTR3='"+CurUser.getUserID()+"'))) ");
	roleClauseMap.put("1003", " bu.stores in (SELECT sno FROM store_info si ,user_info ui WHERE si.salesmanager=ui.userId AND ui.superid IN (SELECT ATTR3 FROM BASEDATASET_INFO WHERE TYPECODE='CityCode' AND ATTRSTR2 IN (SELECT ACBI.ATTR1 FROM BASEDATASET_INFO ACBI WHERE TYPECODE='AreaCode' AND ATTR3='"+CurUser.getUserID()+"'))) ");
	//roleClauseMap.put("1004", " stores in (select sno from store_info where citymanager='"+CurUser.getUserID()+"') ");
	//roleClauseMap.put("1004", " stores in (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1004", " bu.stores in (select sno from store_info si ,user_info ui where si.salesmanager=ui.userId and ui.superid='"+CurUser.getUserID()+"') ");
	//roleClauseMap.put("1005", " stores in (select sno from store_info where salesmanager='"+CurUser.getUserID()+"') ");
	roleClauseMap.put("1005", " bu.stores in (select sno from store_info where salesmanager='"+CurUser.getUserID()+"') ");
	//roleClauseMap.put("1006", " SALESEXECUTIVE='"+ CurUser.getUserID() +"' ");
	roleClauseMap.put("1006", " bu.SALESEXECUTIVE='"+ CurUser.getUserID() +"' ");
	/**update tangyb 20150430 ���۴���¼�������ͬ״̬��ѯ���Ӳ�ѯ�������Ż���ѯ����  end**/
	List roleList = CurUser.getRoleTable();
	String sRoleWhereClause = "";
	boolean isBaimingdan = false;
	for (int i=0; i<roleList.size(); i++) {
		String sAndOr = "".equals(sRoleWhereClause)? " and ( ": " or ";
		if (roleClauseMap.containsKey(roleList.get(i))) {
			sRoleWhereClause += sAndOr + roleClauseMap.get(roleList.get(i));
		}
		if("1005".equals(roleList.get(i))){
			isBaimingdan = true;
		}
	}
	if(isBaimingdan){
		doTemp.WhereClause +=   " and (bu.isbaimingdan <> '1' or bu.isbaimingdan is null) ";
	}
	
	if (!"".equals(sRoleWhereClause)) {
		doTemp.WhereClause += sRoleWhereClause + ")";
	}
	
	//���ɲ�ѯ��
	doTemp.setDDDWSql("contractStatus", "select itemno,itemname from code_library where codeno='ContractStatus' and itemno in ('010','020','050','060','070','080','090','100','110','160','210') and IsInUse = '1' ");
	doTemp.setFilter(Sqlca, "0011", "contractStatus", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0020", "SerialNo", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0050", "CustomerID", "Operators=EqualsString;");
	doTemp.setFilter(Sqlca, "0070", "CustomerName", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0080", "CertID", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0100", "SNO", "Operators=EqualsString,BeginsWith;");
	doTemp.setFilter(Sqlca, "0060", "inputdate", "Operators=EqualsString,BeginsWith;");
	//doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			/**add tangyb 20150430 ��ӡ����顱ҳ�水ť start**/
			{"true","","Button","��ͬ����","��ͬ����","detailButtOnclick()",sResourcesPath},
			/**add tangyb 20150430 ��ӡ����顱ҳ�水ť end**/
			
			{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","�����˺ű��","�����˺ű��","withholdChange()",sResourcesPath},
			//{((CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","�����ٴδ���","�����ٴδ���","",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","�˿��ѯ","��ѯ�˿��ѯ��Ϣ","RefundFind()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","�������֤������","�������֤������","CreditSettle()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","����ȡ������","����ȡ������","insureCancel()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036") || CurUser.hasRole("1039"))?"true":"false"),"","Button","���ս�����","���ս�����","insureApply()",sResourcesPath},
			//{"true","","Button","���Ӻ�ͬ����","���Ӻ�ͬ����","viewApplyReport()",sResourcesPath},
			//{"true","","Button","������Э�����","������Э�����","creatThirdTable()",sResourcesPath},
			//{"true","","Button","Ӱ���ͬ����","Ӱ���ͬ����","imageManage()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","��ǰ�����ѯ","��ѯ��ǰ������Ϣ","SelectPrepayment()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036"))?"true":"false"),"","Button","�ֹ�¼�뻹��","�ֹ�¼�뻹��","PayManualRecord()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036"))?"true":"false"),"","Button","ȷ���ֹ�¼�뻹��","ȷ���ֹ�¼�뻹��","affirm('0050','�ֹ�¼�뻹��')",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036"))?"true":"false"),"","Button","�����ձ��","�����ձ������","LoanAfterChange()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036"))?"true":"false"),"","Button","ȷ�ϻ����ձ��","ȷ�ϻ����ձ��","affirm('2012','�����ձ������')",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","���ʽ���","���ʽ�������","PaymentMethodChange()",sResourcesPath},
			//{"true","","Button","ȷ�ϻ��ʽ���","ȷ�ϻ��ʽ���","affirm('2011','���ʽ�������')",sResourcesPath},
			//{"true","","Button","�˻�����","�˻�����","returnApply()",sResourcesPath},
			//{"true","","Button","���ü���","���ü�������","feeWaive()",sResourcesPath},
			//{"true","","Button","�����¼�","�����¼�����","newFeeEvent()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","��ӡ����С��ʿ","��ӡ����С��ʿ","printRemind()",sResourcesPath},
			//{((CurUser.hasRole("1035") || CurUser.hasRole("1036")||CurUser.hasRole("1039"))?"true":"false"),"","Button","��ӡ������","��ӡ������","printApprove()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=��ӡ������;InputParam=��;OutPutParam=��;]~*/
	function creatThirdTable(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID=getItemValue(0,getRow(),"CustomerID");
		var sObjectType = "ThirdSettle";
		//var sTempSaveFlag = getItemValue(0,getRow(),"TempSaveFlag");
		var xx = RunMethod("PublicMethod","GetColValue","TempSaveFlag,business_contract,String@SerialNo@"+sObjectNo);
		var sTempSaveFlag = xx.split("@")[1];
		sExchangeType = "";
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "TS");
	    var sProductID =getItemValue(0,getRow(),"ProductID");
		 if(null == sProductID) sProductID = "";
		var sCTempSaveFlag = RunMethod("BusinessManage","TempSaveFlag",sCustomerID);
		 if (typeof(sTempSaveFlag)=="undefined" || sTempSaveFlag.length==0 || sTempSaveFlag == "1" || typeof(sCTempSaveFlag)=="undefined" || sCTempSaveFlag.length==0 || sCTempSaveFlag == "1"){
			alert("�ͻ���������Ϣδ���棬�뱣c����Ϣ���ٴ�ӡ�����");
			return;
		}else{ 
			//������֪ͨ���Ƿ��Ѿ�����
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //δ���ɳ���֪ͨ��
				if(sProductID=='020'){
					PopPage("/FormatDoc/CashLoanReport/04.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
				}else{
				//���ɳ���֪ͨ��	
					PopPage("/FormatDoc/Report17/04.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
				}
				}
			//��ü��ܺ�ĳ�����ˮ��
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//ͨ����serverlet ��ҳ��
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			
		}
	}

	/*~[Describe=�鿴��ͬ����;InputParam=��;OutPutParam=SerialNo;]~*/
	function detailButtOnclick()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
    		sCompURL = "/Common/WorkFlow/ContractDetailInfo.jsp";
    		sParamString = "ObjectNo="+sSerialNo;
    		
    		var left = (window.screen.availWidth-800)/2;
    		var top = (window.screen.availHeight-400)/2;
    		var features ='left='+left+',top='+top+',width=800,height=400';
    		var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll=no;status=no,menubar=no,'+features;
    		
    		AsControl.PopPage(sCompURL,sParamString,style);
		}

	}
	
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}

	}
	
	function CreditSettle(){
		sObjectNo =getItemValue(0,getRow(),"SerialNo");	
		sObjectType = "CreditSettle";
		sContractStatus = getItemValue(0,getRow(),"ContractStatus");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if(sContractStatus!='160'){
			alert("�ñʺ�ͬδ���壡");
			return;
		} 
		sCompID = "CreditSettleApplyInfo";
		sCompURL = "/InfoManage/QuickSearch/CreditSettleApplyInfo.jsp";
		//sCompURL = "/SystemManage/SynthesisManage/ChangeCustomerInfo.jsp";
		sParamString = "SerialNo="+sObjectNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
	}
 
    //�˿��ѯ
    function RefundFind(){
    	//������
    	sCustomerID =getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
    	var sReturn=RunMethod("BusinessManage","CustomerDeposits",sCustomerID);
		if(sReturn<=0 || sReturn=="Null"){
			alert("�ÿͻ�����ûԤ���,�����˿�");
			return;
		}		
		
		sCompID = "RefundApplyList";
		sCompURL = "/InfoManage/QuickSearch/RefundApplyList.jsp";
		popComp(sCompID,sCompURL,"CustomerID="+sCustomerID,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

    }
    
    //�����˺ű��
    function withholdChange(){
    	//������
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	//�ͻ�����
    	sCustomerName = getItemValue(0,getRow(),"CustomerName");
    	sCustomerID = getItemValue(0,getRow(),"CustomerID");//�ͻ���
    	//���֤��
    	sCertID = getItemValue(0,getRow(),"CertID");
    	//�ֻ���
    	sMobilePhone = getItemValue(0,getRow(),"MobilePhone");
    	//�����˻�����
    	sReplaceName = getItemValue(0,getRow(),"ReplaceName");
    	//�����˺�
    	sReplaceAccount = getItemValue(0,getRow(),"ReplaceAccount");
    	//�����˻�������
    	sOpenBank = getItemValue(0,getRow(),"OpenBank");
    	
    	//alert("---11111--"+sSerialNo+"-----"+sCustomerName+"---"+sCertID+"----"+sMobileTelephone+"-----"+sReplaceName+"-----"+sReplaceAccount+"-----"+sOpenBank);
    	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else if (confirm("ȷ���Ѿ��յ��ͻ���Ȩ�ĸ��Ļ����������˻���Ȩ�飿"))
    	{			
			 var count = RunMethod("BusinessManage","CheckChangeBusiness",sSerialNo);
			if(count > 0){
				alert("��ǰ�ͻ���ͬ������;�Ĵ����˻���������������ٴη��������룡");
				return;
			}else{
				sReturn = RunMethod("BusinessManage","InsertChangeInfo",sSerialNo+","+sMobilePhone);
				if( sReturn == "success"){
					alert("��������ѷ����뵽�ͻ���Ϣ��ѯ�н��д����˻����������");
				}
			}		 
		} 
		/*  sCompID = "ChargeApplyInfo";
		sCompURL = "/InfoManage/QuickSearch/ChargeApplyInfo.jsp";
		//sCompURL = "/SystemManage/SynthesisManage/ChangeCustomerInfo.jsp";
		sParamString = "SerialNo="+sSerialNo+"&CustomerID="+sCustomerID+"&CustomerName="+sCustomerName+"&CertID="+sCertID+"&MobileTelephone="+sMobileTelephone+"&ReplaceName="+sReplaceName+"&ReplaceAccount="+sReplaceAccount+"&OpenBank="+sOpenBank;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
     */
     
    }
    
    //����ȡ������
    function insureCancel(){
    	//������
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	//�ͻ�����
    	sCustomerName = getItemValue(0,getRow(),"CustomerName");
    	//�ͻ����
    	sCustomerID = getItemValue(0,getRow(),"CustomerID");
    	//���֤��
    	sCertID = getItemValue(0,getRow(),"CertID");

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		sCompID = "InsureCancelApplyInfo";
		sCompURL = "/InfoManage/QuickSearch/InsureCancelApplyInfo.jsp";
		sParamString = "SerialNo="+sSerialNo+"&CustomerName="+sCustomerName+"&CustomerID="+sCustomerID+"&CertID="+sCertID;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=500px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

    }
    
    //���ս�����
    function insureApply(){
    	//������
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
    	//�ͻ�����
    	sCustomerName = getItemValue(0,getRow(),"CustomerName");
    	//�ͻ����
    	sCustomerID = getItemValue(0,getRow(),"CustomerID");
    	//���֤��
    	sCertID = getItemValue(0,getRow(),"CertID");

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		sCompID = "InsureApplyInfo";
		sCompURL = "/InfoManage/QuickSearch/InsureApplyInfo.jsp";
		sParamString = "SerialNo="+sSerialNo+"&CustomerName="+sCustomerName+"&CustomerID="+sCustomerID+"&CertID="+sCertID;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=500px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");

    }
    
    /*~[Describe= �鿴���Ӻ�ͬ;InputParam=��;OutPutParam=��;]~*/
    function viewApplyReport(){
    	//������
    	var sObjectNo = getItemValue(0,getRow(),"SerialNo");
    	var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "AS");
    	//var sObjectType = getItemValue(0,getRow(),"ProductID");
    	var sObjectType = "ApplySettle";
    	
    	/*if (typeof(sObjectNO)=="undefined" || sObjectNO.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else{
			var sSerialno = RunMethod("BusinessManage","getApplyReport",sObjectNO+","+sObjectType);
			if(typeof(sSerialno)=="undefined" || sSerialno.length==0 || sSerialno == "Null") {
				alert("���Ӻ�ͬδ���ɣ�");
				return;
			} 	
			OpenComp("ViewEDOC","/Common/EDOC/EDocView.jsp","SerialNo="+sSerialno,"_blank",OpenStyle);
		}*/

    	//������֪ͨ���Ƿ��Ѿ�����
		var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
	
		if (sReturn == "false"){ //δ���ɳ���֪ͨ��
			//���ɳ���֪ͨ��	
			PopPage("/FormatDoc/Report17/03.jsp?DocID=7006&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		    //alert("δ���ɵ��Ӻ�ͬ,����!");
		    //return;
		}
		//��ü��ܺ�ĳ�����ˮ��
		var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
		//ͨ����serverlet ��ҳ��
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
		//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
		OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
		
    	
    }
    
    /*~[Describe=Ӱ�����;InputParam=��;OutPutParam=��;]~*/
    function imageManage(){
        var sObjectNo   = getItemValue(0,getRow(),"SerialNo");
        if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
            alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return;
        }
     //var param = "ObjectType=Business&ObjectNo="+sObjectNo+"&RightType=100";
     //AsControl.PopView( "/ImageManage/ImageView.jsp", param, "" );
     
   var param = "ObjectType=Business&TypeNo=20&ObjectNo="+sObjectNo;
   AsControl.PopView( "/ImageManage/ImageViewNew.jsp", param, "" );
    }
    
    /*~[Describe=��ǰ�����ѯ;InputParam=��;OutPutParam=SerialNo;]~*/
	function SelectPrepayment()
	{
		//��ȡ��ͬ�ţ����֤��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCertID =getItemValue(0,getRow(),"CertID");	
		sCustomerID =getItemValue(0,getRow(),"CustomerID");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			 var sReturn=RunMethod("BusinessManage","PrepaymentLoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ��������ǰ����");
				return;
			}
			
			 var sReturn=RunMethod("BusinessManage","PrepaymentLoanCount1",sCustomerID);
				if(sReturn>0){
					alert("�ÿͻ����������ں�ͬ,��������ǰ����");
					return;
				}
			AsControl.OpenView("/CustomService/BusinessConsult/PaymentApplyDlog.jsp","SerialNo="+sSerialNo+"&CertID="+sCertID,"_blank","dialogWidth=200px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//AsControl.OpenView("/CustomService/BusinessConsult/PaymentApplyDlog.jsp","SerialNo="+sSerialNo+"&CertID="+sCertID,"_blank",OpenStyle);
		}

	}
    
	/*~[Describe=�������뽻��ȷ��;InputParam=��;OutPutParam=SerialNo;]~*/
	function affirm(transactionCode,messageError)
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		var transactionSerialNo=RunMethod("BusinessManage","TransactionSerialno",transactionCode+","+sSerialNo);
		if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
			alert("�ú�ͬ��������δ��Ч��"+messageError);
			return;
		}else{
			//�����ձ���뻹�ʽ���У��
			if (transactionCode=='2011' || transactionCode=='2012'){
				var sReturn=RunMethod("BusinessManage","getCheckReturn",transactionSerialNo);
				if(sReturn!='true'){
					alert("�ú�ͬ��������δ��Ч��"+messageError);
					return;
				}
			}
			
			//�ֹ�¼�뻹����˿�У��
			if (transactionCode=='0050' || transactionCode=='0110'){
				var sReturn=RunMethod("BusinessManage","getPayCheckReturn",transactionSerialNo);
				if(sReturn!='true'){
					alert("�ú�ͬ��������δ��Ч��"+messageError);
					return;
				}
			}
			
			if(confirm("��ȷ���Ƿ������Ч����"))
			{
				var returnValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,N");
				if(typeof(returnValue)=="undefined"||returnValue.length==0){
					alert("ϵͳ�����쳣��");
					return;
				}
				var message=returnValue.split("@")[1];
				alert(message);
				reloadSelf();
			}			
		}
	}	
	
	/*~[Describe= ���������¼�;InputParam=��;OutPutParam=SerialNo;]~*/
	function newFeeEvent()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ������������");
				return;
			}
			
			var sReturn=RunMethod("BusinessManage","SelectCarLoan",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ�������������������ò���");
				return;
			}
			popComp("PaymentDateChange","/BusinessManage/QueryManage/BusinessFeeEvent.jsp","SerialNo="+sSerialNo,"dialogWidth=600px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		}

	}	
	
	
	/*~[Describe= �ֹ�¼�뻹��;InputParam=��;OutPutParam=SerialNo;]~*/
	function PayManualRecord()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{	
			var sReturn=RunMethod("BusinessManage","CarLoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ�������ֹ�¼�뻹��");
				return;
			}
			
			var transactionDate="";
			var transactionCode ="0050";
			
			var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			var relativeObjectNo = sLoanSerialno;
				

			var TransSerialno = RunMethod("LoanAccount","GetExistApplyFlag",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			if(typeof(TransSerialno) == "undefined" || TransSerialno.length == 0 || TransSerialno=="Null")
			{
				//modify end
				var objectType="TransactionApply";
				var returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>");
				if(returnValue.substring(0,5) != "true@") {
					alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
					return;
				}
				returnValue = returnValue.split("@");
				var transactionSerialNo = returnValue[1];
				if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
					alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
					return;
				}
				
				RunMethod("BusinessManage","DeleteFlowObject",transactionSerialNo);
				RunMethod("BusinessManage","DeleteFlowTask",transactionSerialNo);
				
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else{
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+TransSerialno;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				
			}
			reloadSelf();
		}

	}
	
	/*~[Describe= ���ü�������;InputParam=��;OutPutParam=SerialNo;]~*/
	function feeWaive()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCustomerName=getItemValue(0,getRow(),"CustomerName");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
		var s=setObjectValue("SelectFeeWaive","serialno,"+sLoanSerialno,"@"+sOrgID+"@0@"+sOrgName+"@1",0,0,"");
		
	}
	
	/*~[Describe= �˻�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function returnApply()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		sCustomerName = getItemValue(0,getRow(),"CustomerName");
		sBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			//�Ƿ����Ѵ�
		   var sResult=RunMethod("BusinessManage","LoanProductType",sSerialNo);
			if(sResult==0){
				alert("�ñʺ�ͬ�������Ѵ���Ʒ���������˻�����");
				return;
			} 
			
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ�������˻�����");
				return;
			}
			//�Ƿ�����ԥ����
			var sReturn=RunMethod("BusinessManage","HesitateDay",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ�ѳ�����ԥ����,�������˻�����");
				return;
			}  
			
			var sLoanSerialNo = RunMethod("PublicMethod","GetColValue","SerialNo,ACCT_LOAN,String@PutOutNo@"+sSerialNo);
			
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			//У���Ƿ����δ��ɵĽ���
			var allowApplyFlag = RunMethod("LoanAccount","GetAllowApplyFlag","00,"+relativeObjectType+","+sLoanSerialNo);
			if(allowApplyFlag != "true"){
				return "��ҵ���Ѿ�����һ��δ��Ч�Ľ��׼�¼��������ͬʱ���룡";
			}
			 
			sCompID = "BusinessRefundCargo";
			sCompURL = "/InfoManage/QuickSearch/BusinessRefundCargo.jsp";
			sParamString = "SerialNo="+sSerialNo+"&CustomerName="+sCustomerName+"&BusinessSum="+sBusinessSum+"&";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
					
			reloadSelf();
		}

	} 
	
	/*~[Describe= �����ձ��;InputParam=��;OutPutParam=SerialNo;]~*/
	function LoanAfterChange()
	{
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ�����������ձ��");
				return;
			}
			
			var transactionDate="";
			var transactionCode ="2012";
			
			
			var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			var relativeObjectNo = sLoanSerialno;

			var TransSerialno = RunMethod("LoanAccount","GetExistApplyFlag",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			if(typeof(TransSerialno) == "undefined" || TransSerialno.length == 0 || TransSerialno=="Null")
			{
				//modify end
				var objectType="TransactionApply";
				var returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>");
				if(returnValue.substring(0,5) != "true@") {
					alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
					return;
				}
				returnValue = returnValue.split("@");
				var transactionSerialNo = returnValue[1];
				if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
					alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
					return;
				}
				
				RunMethod("BusinessManage","DeleteFlowObject",transactionSerialNo);
				RunMethod("BusinessManage","DeleteFlowTask",transactionSerialNo);
				
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else{
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+TransSerialno;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				
			}
			reloadSelf();
		}

	}
	
	/*~[Describe= ��ӡ����С��ʿ;InputParam=��;OutPutParam=SerialNo;]~*/
	function printRemind(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		//add CCS-291 �ֽ�����������顢����С��ʿ��������ʾ��
		var sProductID = getItemValue(0,getRow(),"ProductID");
		var sDocID = "7005";
		var sUrl="/FormatDoc/Report17/01.jsp";
		if("020"==sProductID)
		{
			sDocID = "L005";
			sUrl="/FormatDoc/CashLoanReport/01.jsp";
		}
		//end
		sObjectType = "CreditSettle";
		sExchangeType = "";
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "CS");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			//������֪ͨ���Ƿ��Ѿ�����
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //δ���ɳ���֪ͨ��
				//���ɳ���֪ͨ��	
				PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			}
			//��ü��ܺ�ĳ�����ˮ��
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//ͨ����serverlet ��ҳ��
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			
		}	
	}
	
	/*~[Describe=��ӡ���������;InputParam=��;OutPutParam=��;]~*/
	function printApprove(){
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		//add CCS-291 �ֽ�����������顢����С��ʿ��������ʾ��
		var sProductID = getItemValue(0,getRow(),"ProductID");
		var sDocID = "7003";
		var sUrl="/FormatDoc/Report14/ApproveReport.jsp";
		if("020"==sProductID)
		{
			sDocID = "L003";
			sUrl="/FormatDoc/CashLoanReport/02.jsp";
		}
		//end
		sObjectType = "ApproveSettle";
		sExchangeType = "";
		var sSerialNo = getSerialNo("FORMATDOC_RECORD", "SerialNo", "AS");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			//������֪ͨ���Ƿ��Ѿ�����
			var sReturn = PopPageAjax("/FormatDoc/GetReportFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			if (sReturn == "false"){ //δ���ɳ���֪ͨ��
				//���ɳ���֪ͨ��	
				PopPage(sUrl+"?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Method=4&FirstSection=1&EndSection=0&rand="+randomNumber(),"myprint10","dialogWidth=10;dialogHeight=1;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
			}
			//��ü��ܺ�ĳ�����ˮ��
			var sEncryptSerialNo = PopPageAjax("/PublicInfo/EncryptSerialNoAction.jsp?EncryptionType=MD5&SerialNo="+sObjectNo);
			//ͨ����serverlet ��ҳ��
			var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";	
			//+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType  add by cdeng 2009-02-17	
			OpenPage("/FormatDoc/POPreviewFile.jsp?EncryptSerialNo="+sEncryptSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
			
		}
	}
	
	/*~[Describe= ���ʽ���;InputParam=��;OutPutParam=SerialNo;]~*/
	function PaymentMethodChange()
	{
		//��ͬ���
    	sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		
		//��ͬ״̬
    	sContractStatus = getItemValue(0,getRow(),"ContractStatus");
    	//��ͬ״̬Ϊ�ѷ�����ѽ��塢�Ѻ���ʱ�����������ʽ���
    	if(sContractStatus=="010" || sContractStatus=="110" || sContractStatus=="150"){
    		alert("�ú�ͬ���������ʽ���");
    		return;
    	}
		
		var sReturn=RunMethod("BusinessManage","getCarLoanStatus",sSerialNo);
		if(sReturn!="true"){
			alert("�ú�ͬ���������ʽ���");
			return;
		}
		
		sCompID = "RepaymentChangeInfo";
		sCompURL = "/InfoManage/QuickSearch/RepaymentChangeInfo.jsp";
		sParamString = "SerialNo="+sSerialNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=700px;dialogHeight=560px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    
		//AsControl.OpenView("/InfoManage/QuickSearch/RepaymentChangeInfo.jsp","SerialNo="+sSerialNo,"_blank","dialogWidth=650px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		<%-- //���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			var sReturn=RunMethod("BusinessManage","LoanCount",sSerialNo);
			if(sReturn==0){
				alert("�ñʺ�ͬ���������ʽ���");
				return;
			}
			
			var transactionDate="";
			var transactionCode ="2011";
			
			var sLoanSerialno = RunMethod("BusinessManage","SelLoanSerialno",sSerialNo);
			var relativeObjectType = "jbo.app.ACCT_LOAN";
			var relativeObjectNo = sLoanSerialno;
			
			var TransSerialno = RunMethod("LoanAccount","GetExistApplyFlag",transactionCode+","+relativeObjectNo+","+relativeObjectType);
			if(typeof(TransSerialno) == "undefined" || TransSerialno.length == 0 || TransSerialno=="Null")
			{
				//modify end
				var objectType="TransactionApply";
				var returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>");
				if(returnValue.substring(0,5) != "true@") {
					alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
					return;
				}
				returnValue = returnValue.split("@");
				var transactionSerialNo = returnValue[1];
				if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
					alert("��������ʧ�ܣ�����ԭ��-"+returnValue);
					return;
				}
				
				RunMethod("BusinessManage","DeleteFlowObject",transactionSerialNo);
				RunMethod("BusinessManage","DeleteFlowTask",transactionSerialNo);
				
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&TransCode="+transactionCode+"&";
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			}else{
				sCompID = "CreditTab";
				sCompURL = "/Accounting/Transaction/LoanTransactionInfo.jsp";
				sParamString = "ObjectType=Transaction&ObjectNo="+TransSerialno;
				OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
				
			}
			reloadSelf();
		} --%>

	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>