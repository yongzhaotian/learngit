<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.7
		Tester:
		Content: �������Ŷ������
		Input Param:
			ObjectType����������
			ApplyType����������
			PhaseType���׶�����
			FlowNo�����̺�
			PhaseNo���׶κ�		
		Output param:
		History Log: zywei 2005/07/28
					 zywei 2005/07/28 �����Ŷ������ҳ�浥������
					 jgao1 2009/10/21 ���Ӽ������Ŷ�ȣ��Լ�ѡ��ͻ����ͱ�CreditLineApplyCreationInfo.jsp��ʱ���Data����
					 xswang 2015/06/01 CCS-713 ��ͬ�е��ŵ���תΪ�����ŵ�
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ŷ���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//����������	���������͡��������͡��׶����͡����̱�š��׶α��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	String subProductType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubProductType"));//ѧ�����Ѵ�����
	
	String initSERIALNO = "";
	String initCertID =  "";
	String initCustomerID = "";
	String initCustomerName = "";
	String initMobileTelephone = "";
	String initWorkCorp = "";
	String initSelfMonthIncome = "";
	String initRelativeType = "";
	String initKinshipName = "";
	String initKinshipTel = "";
	String initContactrelation = "";
	String initOtherContact = "";
	String initContactTel = "";
	String initInteriorCode = "";
	/*****************update huzp ����ʽ�ᵥ�����޸� begin*******************/
	String switch_status = Sqlca.getString(new SqlObject("select t.switch_status from SYSTEM_SWITCH t where t.switch_type ='PRETRIAL_ENABLE'"));
	if("1".equals(switch_status)){
		 initSERIALNO = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SERIALNO"));
		 initCertID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CertID"));
		 initCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
		 initCustomerName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName"));
		 initMobileTelephone = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MobileTelephone"));
		 initWorkCorp = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("WorkCorp"));
		 initSelfMonthIncome = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelfMonthIncome"));
		 initRelativeType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelativeType"));
		 initKinshipName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("KinshipName"));
		 initKinshipTel = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("KinshipTel"));
		 initContactrelation = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Contactrelation"));
		 initOtherContact = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OtherContact"));
		 initContactTel = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ContactTel"));
		 initInteriorCode = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InteriorCode"));
	}
	/*****************end*********************************************/
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(subProductType == null) subProductType = "";
	
	/*****************update huzp ����ʽ�ᵥ�����޸� begin*******************/
	if("1".equals(switch_status)){
		if(initSERIALNO == null) initSERIALNO = "";	
		if(initCertID == null) initCertID = "";
		if(initCustomerID == null) initCustomerID = "";	
		if(initCustomerName == null) initCustomerName = "";
		if(initMobileTelephone == null) initMobileTelephone = "";
		if(initWorkCorp == null) initWorkCorp = "";	
		if(initSelfMonthIncome == null) initSelfMonthIncome = "";
		if(initRelativeType == null) initRelativeType = "";	
		if(initKinshipName == null) initKinshipName = "";
		if(initKinshipTel == null) initKinshipTel = "";
		if(initContactrelation == null) initContactrelation = "";	
		if(initOtherContact == null) initOtherContact = "";
		if(initContactTel == null) initContactTel = "";	
		if(initInteriorCode == null) initInteriorCode = "";	
	}
	/*****************end*********************************************/

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
    //�����ŵ�
    //String sNo = CurARC.getAttribute(request.getSession().getId()+"city");
	// add by xswang 2015/06/01 CCS-713 ��ͬ�е��ŵ���תΪ�����ŵ�
	//String sNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
	String sNo = CurUser.getAttribute8();
	// end by xswang 2015/06/01
	
    if(sNo == null) sNo = "";
    System.out.println("-------�ŵ�-------"+sNo);
    String sStorePosid = Sqlca.getString(new SqlObject("select storeposid from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
    if(sStorePosid == null) sStorePosid = "";
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CreditNewStuPosApplyCreationInfo";
	
	//����ģ�����������ݶ���	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//�����������ѯ�����
	ASResultSet rs = null;
	String sCreditId = "";
	String sCreditPerson = "";
	//���ñ��䱳��ɫ
	//doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	//���ͻ����ͷ����ı�ʱ��ϵͳ�Զ������¼�����Ϣ
	//doTemp.appendHTMLStyle("CustomerType"," onClick=\"javascript:parent.clearData()\" ");
	doTemp.setReadOnly("ProductID",true);//add �ֽ������
	
	/*****************update huzp ����ʽ�ᵥ�����޸� begin*******************/
	if("0".equals(switch_status)){
		doTemp.setReadOnly("CustomerName",false);
		doTemp.setReadOnly("CertID",false);
	}
	/*****************************************************************/
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//�����ŵ�
    if(sNo == null) sNo = "";
	
	//�ŵ��ַ
	String sCity = Sqlca.getString(new SqlObject("select city from store_info si where si.identtype='01' and si.sno=:sno").setParameter("sno", sNo));
	//��ȡ���չ�˾
    String InsuranceNo=Sqlca.getString(new SqlObject("select sp.ins_serialno from bq_insurance_info sp,insurancecity_info ii "+
    			"where sp.ins_serialno = ii.insuranceno and sp.ins_status = '1' and ii.cityno='"+sCity+"' and ii.subproducttype='"+subProductType+"'"));
	if(InsuranceNo==null) InsuranceNo="";
	//��ȡ��������Ϣ
    String sSql="select sp.serialno as SerialNo, sp.serviceprovidersname as ServiceProvidersName "+
    			"from Service_Providers sp,ProvidersCity pc where sp.customertype1 = '06' and pc.ProductType = '"+subProductType+"' "+
    			"and pc.serialno=sp.serialno and sp.loaner = '010' and pc.areacode='"+sCity+"'";
    rs=Sqlca.getASResultSet(sSql);
    if(rs.next()){
   	 sCreditId = DataConvert.toString(rs.getString("SerialNo"));//�����˱��
   	 sCreditPerson = DataConvert.toString(rs.getString("ServiceProvidersName"));//����������
   	
		//����ֵת���ɿ��ַ���
		if(sCreditId == null) sCreditId = "";
		if(sCreditPerson == null) sCreditPerson = "";
    }
    rs.getStatement().close();
    
	
	//���ñ���ʱ�����������ݱ�Ķ���
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+") + !WorkFlowEngine.InitializeCLInfo(#SerialNo,#BusinessType,#CustomerID,#CustomerName,#InputUserID,#InputOrgID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","ȷ��","ȷ���������Ŷ������","doCreation()",sResourcesPath},
			{"true","","Button","����","�����������Ŷ������","doReset()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ���������Ŷ������","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		InsertCustomer();
		initSerialNo();

		var sCustomerName = getItemValue(0,0,"CustomerName");//�ͻ�����
		var sCertID = getItemValue(0,0,"CertID");//���֤��
		var sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName.trim()+","+sCertID.trim());
		if(sReturn == "Null"){//����ͻ������ڣ�������
				alert("����ԭ�򣬺�ͬ����ʧ�ܣ�������¼�룡");
				reloadSelf();
				return;
		}
		as_save("myiframe0",sPostEvents);
		/***************begin update huzp CCS-1334,����ʽ�ᵥ*******************************/
		if("1"=="<%=switch_status%>"){
			RunMethod("���÷���", "UpdateColValue", "Pretrial_Info,STATE,004,SERIALNO='"+"<%=initSERIALNO%>"+"'");
		}
		/***************end*******************************/


	}
	
	//�����µĿͻ���Ϣ��customer_info��ind_info����
	function InsertCustomer(){
		var sCustomerName = getItemValue(0,0,"CustomerName");//�ͻ�����
		var sCertID = getItemValue(0,0,"CertID");//���֤��
		//var sCustomerID = getItemValue(0,0,"CustomerID");//�ͻ�ID
		var sCustomerType = "0310";//�ͻ����ͣ����˿ͻ���
		var sCertType = "Ind01";//֤�����ͣ����֤��
		var sStatus = "01";
		var sCustomerOrgType = "0310";
		var sHaveCustomerType = sCustomerType;//
		//�жϵ�ǰ�ͻ��Ƿ����
		var sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName.trim()+","+sCertID.trim());
			if(sReturn == "Null"){//����ͻ������ڣ�������
				var sParam = "";
				/*****************update huzp ����ʽ�ᵥ�����޸� begin*******************/
					if("1"=="<%=switch_status%>"){
						var ssReturn="<%=initCustomerID%>";//��Ԥ����洫���Ŀͻ���ţ���Ϊͬ�����������ٴ�ȡ��
						/*****************end*******************/
						setItemValue(0,0,"CustomerID",ssReturn);//�ͻ�ID
						sParam = ssReturn+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
				                 ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+sHaveCustomerType+",<%=initMobileTelephone%>,<%=initWorkCorp%>,<%=initSelfMonthIncome%>,<%=initRelativeType%>,<%=initKinshipName%>,<%=initKinshipTel%>,<%=initContactrelation%>,<%=initOtherContact%>,<%=initContactTel%>";
				     
				        var sReturnCID = RunMethod("CustomerManage","AddCustomerAction",sParam);
						if (sReturn.length == 8) setItemValue(0,0,"CustomerID",sReturnCID);//�ͻ�ID */
			    	} else {
			    		var ssReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getCustomerId",null);
						setItemValue(0,0,"CustomerID",ssReturn);//�ͻ�ID
						 sParam = ssReturn+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
				                 ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+sHaveCustomerType;
				        var sReturnCID = RunMethod("CustomerManage","AddCustomerAction",sParam);
						if (sReturn.length == 8) setItemValue(0,0,"CustomerID",sReturnCID);//�ͻ�ID */
			    	}	
			}else{
				if("1"=="<%=switch_status%>"){
					/*****************update huzp ����ʽ�ᵥ�����޸� begin*******************/
					var sParam = "CustomerID=" +sReturn+",WorkCorp="+'<%=initWorkCorp%>'+",MobileTelephone="+'<%=initMobileTelephone%>'+",SelfMonthIncome="+'<%=initSelfMonthIncome%>'+",KinshipName="+'<%=initKinshipName%>'+",KinshipTel="+'<%=initKinshipTel%>'+",RelativeType="+'<%=initRelativeType%>'+",Contactrelation="+'<%=initContactrelation%>'+",OtherContact="+'<%=initOtherContact%>'+",ContactTel="+'<%=initContactTel%>' ;
					RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateIndInfoAction", "updateIndInfo", sParam);
		        	/*****************end*******************/
					setItemValue(0,0,"CustomerID",sReturn);//�ͻ�ID
				}else{
					setItemValue(0,0,"CustomerID",sReturn);//�ͻ�ID
					RunMethod("���÷���", "UpdateColValue", "IND_INFO,TEMPSAVEFLAG,1,CUSTOMERID='"+sReturn+"'");     
				}	
	        }
			//ѧ����Ϣ�ж� add by dyh 20150609
		var customerId = getItemValue(0,0,"CustomerID");
		RunJavaMethodSqlca("com.amarsoft.proj.action.CheckCustomerInfo", "checkStuCusExists", "customerId="+customerId);
		
	}
	
    /*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script type="text/javascript">

	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
		var sStore = RunMethod("���÷���", "GetColValue", "Store_info,SNO||' '||sName,sno='<%=sNo%>'");
		if(!confirm("��ǰ��¼�����ŵ�Ϊ��\n\r"+sStore+"\n\r�Ƿ�ȷ���ڸ��ŵ귢�����룿")){
			return;
		}
		//���ƺ�ͬ������ģʽ��Ϊ�� add by phe
		var sOperatorMode = getItemValue(0,0,"OperatorMode");
		var sOPERATEMODE=RunMethod("BusinessManage", "selectStoreModel","<%=sNo%>");
		var sEmployeeType=RunMethod("BusinessManage", "selectEmployeeType","<%=CurUser.getUserID()%>");
		if(typeof(sOperatorMode)=="undefined" || sOperatorMode=="_CLEAR_" || sOperatorMode.length==0){
	    	 if(sOPERATEMODE.length==0||typeof(sOPERATEMODE)=="undefined"||sOPERATEMODE==null){
				 alert("����ģʽΪ�գ������ŵ�ģʽ��");
	    	 }else if(sEmployeeType.length==0||typeof(sEmployeeType)=="undefined"||sEmployeeType==null){
	    		 alert("����ģʽΪ�գ������������ͣ�");
	    	 }else{
	    		 alert("����ģʽΪ�գ������������ͼ��ŵ�ģʽ��");
	    	 }
			   return;
	     }
		//���Ʋ�Ʒ���Ʋ���Ϊ��
		var sProductName= getItemValue(0,0,"ProductName");
	     if(typeof(sProductName)=="undefined" || sProductName=="_CLEAR_" || sProductName.length==0){
	    	 alert("�������Ϊ�գ�");
			   return;
	     }
	     
		
		//����У��ͻ�����
		if(!checkName()){
			return;
		}
		// ������У�����֤����
	    if(!isCardNo()){
	    	return;
	    }
		// add by phe 2015/03/31 CCS-572 PRM-254 ��˶ϵͳ���������۴���Ϊ�Լ�����Ա����
		if(!checkUserNotCustomer()){
			return;
		}
	    //update CCS-364 ��������-�����֤�ͻ��������κ�У��
	    //add CCS-229(�������������֤���룬�ٴ�������ʱ�����ֲ�ͬ������������û��У�飬Ҳû�д����Ͽͻ���Ӧ���ϡ�δ���Ƿ����֣�����У�顣)
	    /* if(!CheckCustomerName())
		{
			return;
		} */
		//end
		//end
		var sProductID = getItemValue(0,0,"ProductID");//��Ʒ����
		if(sProductID=="020"){
			/* var sCustomerID = getItemValue(0,0,"CustomerID");//�ͻ�ID
			if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
				alert("�ͻ�δ��ԤԼ�ֽ��׼��ͻ������У�");
				return;
			} */
			checkType();
		}else{
			var BusinessType = getItemValue(0,0,"BusinessType");//��ƷID
			// �ж�Ͷ���Ƿ����ѡ��
		    var creditCycle = getItemValue(0, 0, "CreditCycle");
		    if (creditCycle != "1") {		// ûѡ��Ͷ����ʱ�򣬲��ж�Ͷ�����Ƿ����ѡ��
		    	var res = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckCreditCycle", "checkNecessity", "businessType=" + BusinessType);
		    	if (res == "1") {
		    		alert("�ò�Ʒ����ѡ��Ͷ����");
		    		return;
		    	}
		    } 
			
			saveRecord("doReturn()");
			
			//��ͬ�ܷ�թƭƽ̨����һ������ add by lgq 20151029
			var sCertID = getItemValue(0,0,"CertID");//���֤��
			var sSerialNo = getItemValue(0,0,"SerialNo"); //��ͬ���
			//RunMethod("PublicMethod","CallScoreTaskPort",sCertID+","+sSerialNo);
			//RunJavaMethod("com.amarsoft.app.billions.CallScoreTaskPort","ThreadCallPort",
					//"CertID="+sCertID+","+"SerialNo="+sSerialNo);
			
			$.ajax({
				type:"post",
				url: sWebRootPath+"/servlet/scoreTask",
				data: {"SerialNo" : sSerialNo,"CertID" : sCertID},
				timeout: 4000,
				async: true,
				success: function(msg){
				     //alert( "Data Saved: " + msg );
				},
				error:function(msg){
					//alert("��ʱ��");
				}

			})
		}
	}
	
	/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		sObjectType = "<%=sObjectType%>";		
		//CCS-381 PRM-95 ��˶ϵͳ������������Э������ҳ��
		top.returnValue = sObjectNo+"@"+sObjectType;
		top.close();
	}
	/*~[Describe=;InputParam=��;OutPutParam=��;]~*/
	function product(){
		setItemValue(0, 0, "ProductName", "");
		setItemValue(0, 0, "Periods", "");
		setItemValue(0, 0, "BusinessType", "");
		setItemValue(0, 0, "MonthRepayment", "");
	}
	/*~[Describe=;InputParam=��;OutPutParam=��;]~*/
	function ProductSum(){
		setItemValue(0, 0, "ProductName", "");
		setItemValue(0, 0, "Periods", "");
		setItemValue(0, 0, "BusinessType", "");
		setItemValue(0, 0, "MonthRepayment", "");
		if(getItemValue(0,getRow(),"Shoufuratio")==""||typeof(getItemValue(0,getRow(),"Shoufuratio"))=="undefined" || getItemValue(0,getRow(),"Shoufuratio")=="_CLEAR_" || getItemValue(0,getRow(),"Shoufuratio").length==0 ){
			return;
		}
		inputDpsMnt();
	}
	/*~[Describe=�����׸�����;InputParam=��;OutPutParam=��;]~*/
	function inputDpsMnt(){
		var sTotalSum_ = '0'+getItemValue(0,getRow(),"ProductSum");//��Ʒ�ܼ۸�
		var sPaymentSum_ = '0'+getItemValue(0,getRow(),"PaymentSum");//�׸����
		var sShoufuratio = '0'+getItemValue(0,getRow(),"Shoufuratio");//�׸�����

		
		var sTotalSum=parseFloat(sTotalSum_);
		var sPaymentSum=parseFloat(sPaymentSum_);
		

		// У����Ʒ�ܼ۸������Ƿ���ȷ
		if(chkTotalSumValue()!="true") {
			setItemValue(0, 0, "Shoufuratio", "");//�׸�����
			setItemValue(0, 0, "PaymentSum", "");//�׸����
			return;
		}

		if(sPaymentSum<0.0) {
			alert("��������ڵ���0���׸���");
			setItemValue(0, 0, "Shoufuratio", "");//�׸�����
			setItemValue(0, 0, "PaymentSum", "");//�׸����
			return;
		
		}else if(sPaymentSum>sTotalSum){
			alert("�׸���ܴ���Ʒ�ܼ۸�");
			setItemValue(0, 0, "Shoufuratio", "");//�׸�����
			setItemValue(0, 0, "PaymentSum", "");//�׸����
			return;
		}
		setItemValue(0, 0, "Shoufuratio", (sPaymentSum/sTotalSum*100).toFixed(2));//�׸�����
		setItemValue(0, 0, "PaymentSum", sPaymentSum);//�׸����
		setItemValue(0, 0, "ProductName", "");
		setItemValue(0, 0, "Periods", "");
		setItemValue(0, 0, "BusinessType", "");
		setItemValue(0, 0, "MonthRepayment", "");
	}
	/*~[Describe=�����׸����;InputParam=��;OutPutParam=��;]~*/
	function inputDownPay(){
		var sTotalSum_ = '0'+getItemValue(0,getRow(),"ProductSum");//��Ʒ�ܼ۸�
		var sPaymentSum_ = '0'+getItemValue(0,getRow(),"PaymentSum");//�׸����
		var sShoufuratio = '0'+getItemValue(0,getRow(),"Shoufuratio");//�׸�����
		
		var sTotalSum=parseFloat(sTotalSum_);
		var sPaymentSum=parseFloat(sPaymentSum_);
		
		
		// У����Ʒ�ܼ۸������Ƿ���ȷ
		if(chkTotalSumValue()!="true") {
			setItemValue(0, 0, "Shoufuratio", "");//�׸�����
			setItemValue(0, 0, "PaymentSum", "");//�׸����
			return;
		}
		
		if(parseFloat(sShoufuratio)<0.0) {
			alert("��������ڵ���0���׸�������");
			setItemValue(0, 0, "Shoufuratio", "");//�׸�����
			setItemValue(0, 0, "PaymentSum", "");//�׸����
			return;
		}else if(parseFloat(sShoufuratio)>100.0){
			alert("�׸��������ܴ���100��");
			setItemValue(0, 0, "Shoufuratio", "");//�׸�����
			setItemValue(0, 0, "PaymentSum", "");//�׸����
			return;
		}
		
		setItemValue(0, 0, "PaymentSum", (sTotalSum*parseFloat(sShoufuratio)*0.01).toFixed(0));//�׸����
		setItemValue(0, 0, "ProductName", "");
		setItemValue(0, 0, "Periods", "");
		setItemValue(0, 0, "BusinessType", "");
		setItemValue(0, 0, "MonthRepayment", "");
	}
	
	function chkTotalSumValue() {
		var sTotalSum = ''+getItemValue(0,getRow(),"ProductSum");

		if (sTotalSum.length<=0) {
			alert("��������Ʒ��");
			return "false";
		}
		if (parseFloat(sTotalSum)<0.0) {
			alert("��Ʒ���Ϊ��������ȷ�ϣ�"); 
			 return "false";
		}
		return "true";
	}
	/*~[Describe=��˶ϵͳ���������۴���Ϊ�Լ�����Ա����;InputParam=��;OutPutParam=��;]~*/
	function checkUserNotCustomer(){
		  //add by phe 2015/03/31 CCS-572 PRM-254 ��˶ϵͳ���������۴���Ϊ�Լ�����Ա����
		 var sCustomerName = getItemValue(0,0,"CustomerName");
		 var sCertID = getItemValue(0,0,"CertID");
		  
	     var sCount = RunMethod("BusinessManage", "selectUserCerttype", '<%=CurUser.getUserID() %>');
			if(sCount=="0.0"){
				alert("��֪ͨOA���û���������֤�ţ�Ȼ���������!");
				return false;
			}
			var sUserNameAndCertID = RunMethod("BusinessManage", "selectUserNameAndCertID", '<%=CurUser.getUserID() %>');
			var sUserNameAndCertIDs=sUserNameAndCertID.split("@");
			if(sUserNameAndCertIDs[0]==sCustomerName&&sUserNameAndCertIDs[1]==sCertID){
				alert("�޷�Ϊ�Լ��ύ���룡");
				return false;
			}
			return true;
			//end by phe 2015/03/31
	}
	
	/*~[Describe=�������ѽ��ڲ�Ʒѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectProductID()
	{
		var	sProductID = getItemValue(0,0,"ProductID");
		var	sSubProductType = getItemValue(0,0,"SubProductType");
		var	sProductSum = getItemValue(0,0,"ProductSum");//��Ʒ���
		var sPaymentSum = getItemValue(0,0,"PaymentSum");
		var sShoufuratio1 = getItemValue(0,0,"Shoufuratio");
		var sCertID = getItemValue(0,0,"CertID");
		var sProductCategory = getItemValue(0,0,"ProductCategory");
		var sCustomerName = getItemValue(0,0,"CustomerName");

		var sSum = sProductSum-sPaymentSum;
	//   alert("Sum:"+sSum+"ProductSum:"+sProductSum+"PaymentSum:"+sPaymentSum+"Shuofuratio:"+sShoufuratio1);
	     if (typeof(sProductSum)=="undefined" || sProductSum=="_CLEAR_" || sProductSum.length==0 
	     || typeof(sShoufuratio1)=="undefined" || sShoufuratio1=="_CLEAR_" || sShoufuratio1.length==0
	     || typeof(sProductCategory)=="undefined" || sProductCategory=="_CLEAR_" || sProductCategory.length==0
	     /* || typeof(sCertID)=="undefined" || sCertID=="_CLEAR_" || sCertID.length==0
	     || typeof(sProductCategory)=="undefined" || sProductCategory=="_CLEAR_" || sProductCategory.length==0
	     || typeof(sCustomerName)=="undefined" || sCustomerName=="_CLEAR_" || sCustomerName.length==0 */
	     || typeof(sPaymentSum)=="undefined" || sPaymentSum=="_CLEAR_" || sPaymentSum.length==0) {
	    	 alert("�������Ϊ�գ�");
			   return;
	     }	
	  // add by phe 2015/03/31 CCS-572 PRM-254 ��˶ϵͳ���������۴���Ϊ�Լ�����Ա����
	     if(!checkUserNotCustomer()){
	    	 return;
	     }
		sParaString = "ProductID"+","+sProductID+",SubProductType,"+sSubProductType+","+"Sum"+","+sSum+","+"ProductSum"+","+sProductSum+","+"PaymentSum"+","+sPaymentSum+","+"ProductCategory"+","+sProductCategory+","+"Shoufuratio"+","+sShoufuratio1+",SNo,<%=sNo%>";
		//���÷��ز��� 
		var result = setObjectValue("SelectStuPosInfo",sParaString,"@BusinessType@0@ProductName@1@Periods@2",0,0,""); 
		var arr = new Array();
		arr = result.split("@");
		if(arr.length>0){
			var uploadFlag = arr[3];
			setItemValue(0,0,"uploadFlag",uploadFlag);
		}
		var sCreditCycle = getItemValue(0,0,"CreditCycle");//�Ƿ�Ͷ��
		var sBugPayPkgind = getItemValue(0,0,"BugPayPkgind");//�Ƿ������Ļ������
		if(!(typeof(sCreditCycle)=="undefined" || sCreditCycle.length==0 || typeof(sBugPayPkgind)=="undefined" || sBugPayPkgind.length==0)){
			getMonthPayment();
		}
	}
	
	//ѡ���Ʒ����ʱ����ʾ��Ӧ���ı���
	function checkType(){
		if(!isCardNo()){
			return;
		}
		
		var sProductId = getItemValue(0,0,"ProductId");
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sIdentityId   = getItemValue(0,0,"CertID");
		
		
		if(sProductId=="020" && sCustomerName =="" && sIdentityId ==""){
		   alert("����д�ͻ����Ƽ����֤�ţ�");  	
		}
		//�ж��Ƿ����18�꣬С��55��
		if(typeof(sIdentityId)=="undefined" || sIdentityId.length==0 ){
		}else{
		var myDate=new Date(); 
	   var thisYear = myDate.getFullYear(); 
	   var thisMonth = myDate.getMonth()+1; 
	   var thisDay = myDate.getDate(); 
	   var age = myDate.getFullYear() - sIdentityId.substring(6, 10) - 1;
	   if (sIdentityId.substring(10, 12) < thisMonth || sIdentityId.substring(10, 12) == thisMonth && sIdentityId.substring(12, 14) <= thisDay) { 
		   age++; 
		 }
        if((age>55)||(age<18)){
        	alert("�ͻ����������18��55֮��");
        	return;
        }
        
		}
		if(sProductId=="020" && sCustomerName !="" && sIdentityId !=""){//����ǡ�ԤԼ�ֽ���� ��֤�ͻ���Ϣ
		   //��ѯԤԼ�ֽ��׼��ͻ�����
		   ssReturn = RunMethod("BusinessManage","CustomerNameInfo",sCustomerName+","+sIdentityId);
		   if(ssReturn == "Null"){
			   alert("�ͻ�δ��ԤԼ�ֽ��׼��ͻ������У�");
			   return;
		   }
		}
		
		//��ȡ�ͻ�ID
		var sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName+","+sIdentityId);
			
	    //���ÿͻ�ID
	    if(sReturn == "Null"){
	    }else{
	    	//�ѿͻ��ţ����֤������ֻ��
	    	setItemReadOnly(0,0,"CustomerName",true);
	    	setItemReadOnly(0,0,"CertID",true);
	    	//�Ѳ�ѯ�Ŀͻ�ID���õ�CustomerID��
	        setItemValue(0,0,"CustomerID",sReturn);
	    }
		
	}
//�Ƿ�Ͷ������������ÿ�»����
	function getMonthPayment(){
		var sBusinessType = getItemValue(0,0,"BusinessType");//��ȡ��Ʒ����
		var sProductSum = getItemValue(0,0,"ProductSum");//��Ʒ���
		var sPaymentSum = getItemValue(0,0,"PaymentSum");//�׸����
		var sPeriods = getItemValue(0,0,"Periods");//��������
		var sCreditCycle = getItemValue(0,0,"CreditCycle");//�Ƿ�Ͷ��
		var sBugPayPkgind = getItemValue(0,0,"BugPayPkgind");//�Ƿ������Ļ������
		var sInsuranceNo = "<%=InsuranceNo%>";//���չ�˾

		if(typeof(sProductSum)=="undefined" || sProductSum.length==0){
			alert("��Ʒ����Ϊ�գ�");
			return;
		}
		if(typeof(sPaymentSum)=="undefined" || sPaymentSum.length==0){
			alert("�׸�����Ϊ�գ�");
			setItemValue(0,0,"CreditCycle","");
			return;
		}
		if(typeof(sBusinessType)=="undefined" || sBusinessType.length==0){
			alert("����ѡ���Ʒ��");
			return;
		}
		
		//�жϸò�Ʒ�Ƿ��������Ļ����������
		if(sBugPayPkgind=="1"){
			var sRe = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckBugPayPkgind", "checkSuiXinHuan", "businessType="+sBusinessType);
			if(sRe == 0){
				alert("�ò�Ʒδ������ȡ���Ļ���������ã�");
				setItemValue(0,0,"BugPayPkgind","0");
			}
		}
		
		//����Ƿ����Ͷ��
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CheckCreditCycle", "CreditCycle", "businessType="+sBusinessType+",insuranceNo="+sInsuranceNo);
		if(sCreditCycle=="1"&&sReturn!="true"){//������Ͷ��
				
			if(sReturn=="false@BusinessType"){
				alert("��Ʒ����Ϊ��!");
			}else if(sReturn=="false@product"){
				alert("��Ʒδ�������շѣ�����Ͷ��!");
			}else if(sReturn=="false@InsuranceNo"){
				alert("�ó���û�б��չ�˾������Ͷ��!");
			}else if(sReturn=="false@InsuranceFee"){
				alert("���չ�˾δ�������շѣ�����Ͷ��!");
			}else if(sReturn=="false@InsuranceFeeAll"){
				alert("���չ�˾ֻ�ܹ���һ����Ч���շ�!");
			}
			/*ͬһ����Ʒȫ������ͬһ����,���Ա��չ�˾����Ҫ���ñ��շ�
			else if(sReturn=="false@ProductInsurance"){
				alert("��Ʒδ�����뵱ǰ���չ�˾��Ӧ�ı��շѣ�����Ͷ��!");
			}*/
			else{
				alert("��Ʒ���߱��չ�˾�������շ��쳣������Ͷ��������!");
			}
			setItemValue(0,0,"CreditCycle","2");
		}
		
		sCreditCycle = getItemValue(0,0,"CreditCycle");//�ٴλ�ȡ�Ƿ�Ͷ��
		if(parseFloat(sProductSum) > 0 && parseFloat(sPaymentSum) >=0){
			 if(parseFloat(sPaymentSum)-parseFloat(sProductSum)>0){
				alert("�׸����ܴ�����Ʒ���!");
				return;
			}else{
				var sBusinessSum = parseFloat(sProductSum)-parseFloat(sPaymentSum);//�����
				if(parseFloat(parseInt(sBusinessSum,10))<parseFloat(sBusinessSum)){
					alert("��Ʒ�����׸����Ĳ����Ϊ����������");
					return;
				}
				var sMonthPayment=RunMethod("PublicMethod","GetMonthPayment",sBusinessSum+","+sBusinessType+","+sPeriods+","+sCreditCycle+","+sBugPayPkgind);
				
				var MonthPaymentBefore = parseFloat(sMonthPayment);
				var MonthPaymentAfter = fix(MonthPaymentBefore);
				setItemValue(0,getRow(),"MonthRepayment",MonthPaymentAfter+"");
				//end
			}
		}
	}
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function doReset(){
		reloadSelf();
	}
	/*~[Describe=С����λ;InputParam=��;OutPutParam=��;]~*/
	function fix(d) {
		var temp = d * 10;
		var value1 = Math.ceil(parseFloat(temp));//��λȡ��
		var finalyvalue = parseFloat(value1)/10;
		if(d==parseInt(d,10)){
			finalyvalue = d;
		}
		return finalyvalue;
	}
							
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼	
			//֤������(���֤)
			setItemValue(0,0,"CertType","Ind01");
			//���Ѵ���ͬ��ʶ
			setItemValue(0,0,"CreditAttribute","0002");
			//��ͬ״̬:060�·���
			setItemValue(0,0,"ContractStatus","060");
			//�ر�״̬��
			setItemValue(0,0,"LandmarkStatus","1");
			//�ŵ�
			setItemValue(0,getRow(),"Stores","<%=sNo%>");
			//�ŵ����� add by clhuang 2015/06/25 CCS-658 PRM-309 ���۴���쵥ʱ�����ŵ깦���Լ���ѡ���ŵ���������
			var sName = RunMethod("���÷���", "GetColValue", "Store_info,sname,sno='<%=sNo%>'");  
			setItemValue(0,getRow(),"StoresName",sName);
			// ���չ�˾���
			setItemValue(0,getRow(),"InsuranceNo","<%=InsuranceNo%>");
			// ҵ����Դ
			setItemValue(0,getRow(),"SureType","PC");
			//�������
			setItemValue(0,0,"OperateOrgID","<%=CurUser.getOrgID()%>");
			//������
			setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");
			//��������
			setItemValue(0,0,"OperateDate","<%=StringFunction.getToday()%>");
			//�Ǽǻ���
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			//�Ǽ���
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			//�Ǽ�����			
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss")%>");
			//��������
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			//�ݴ��־
			setItemValue(0,0,"TempSaveFlag","1");//�Ƿ��־��1���ǣ�2����
			//�ͻ�����Ĭ��Ϊ���˿ͻ�
			setItemValue(0,0,"CustomerType","0310");
			setItemValue(0,0,"CreditID","<%=sCreditId%>");
			setItemValue(0,0,"CreditPerson","<%=sCreditPerson%>");
			//edit by pli �ں�ͬ��Ϣ�г�ʼ����Ʒ�������Ʒ�����ͣ���Ӧ����ֱ�Ϊ��ProductType��SubProductType	 --Strat--
			setItemValue(0,0,"ProductID","030");
			setItemValue(0,0,"SubProductType","<%=subProductType%>");
			//edit by pli �ں�ͬ��Ϣ�г�ʼ����Ʒ�������Ʒ�����ͣ���Ӧ����ֱ�Ϊ��BusinessType��SubProductType --End--
			
			//�������ģʽ��ֵ
			//var sSalesexecutive=getItemValue(0,getRow(),"Salesexecutive");
			//alert(<%=sNo%>+"====="+<%=CurUser.getUserID()%>);
			var sOPERATEMODE=RunMethod("BusinessManage", "selectStoreModel","<%=sNo%>");
			var sEmployeeType=RunMethod("BusinessManage", "selectEmployeeType","<%=CurUser.getUserID()%>");
			//alert(sOPERATEMODE+"====="+sEmployeeType);
			//alert(sOPERATEMODE+"======="+sEmployeeType);
			//CCS-447
			if(sOPERATEMODE=='03'&&sEmployeeType=='02'){
				setItemValue(0,getRow(),"OperatorMode","01");//����ALDI
			}
			if(sOPERATEMODE=='02'&&sEmployeeType=='02'){
				setItemValue(0,getRow(),"OperatorMode","02");//��ͨALDI
			}
			if(sOPERATEMODE=='01'&&sEmployeeType=='02'){
				setItemValue(0,getRow(),"OperatorMode","04");//�쳣
			}
			if(sOPERATEMODE=='04'&&sEmployeeType=='02'){
				setItemValue(0,getRow(),"OperatorMode","05");//add by phe 20150319 CCS-543 ����ALDI
			}
            if(sEmployeeType=='01'){
				setItemValue(0,getRow(),"OperatorMode","03");//��ͨ
				//�ƶ�Pos��
				setItemValue(0,getRow(),"PosNo","<%=sStorePosid%>");
			}
            /*****************update huzp ����ʽ�ᵥ�����޸� begin*******************/
			if("1"=="<%=switch_status%>"){

            setItemValue(0,getRow(),"CertID","<%=initCertID%>");//���֤��
			setItemValue(0,getRow(),"CustomerName","<%=initCustomerName%>");//�ͻ�����
			}
			/*****************end*********************************************/

		}
		
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo()  
	{
		var sTableName = "BUSINESS_CONTRACT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//��ʼ���汾
		setItemValue(0,getRow(),"ProductVersion","V1.0");						
		//��ȡ��ˮ��
		// ��ȡ�ͻ����
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);	// RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getContractId","serialNo="+sCustomerID);//getSerialNo("Customer_Info","CustomerID","");;//
		//����ˮ�������Ӧ�ֶ�
		
		// ��ͬ��
		var sCustomerID = getItemValue(0,0,"CustomerID");//�ͻ�ID
		var sContractId = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getContractId","serialNo="+sCustomerID);
		setItemValue(0,getRow(),sColumnName,sContractId);
		setItemValue(0, 0, "ApplySerialNo", sSerialNo);
        /*****************update huzp ����ʽ�ᵥ�����޸� begin*******************/
		if("1"=="<%=switch_status%>"){
        setItemValue(0, 0, "PretrialSerialNo", "<%=initSERIALNO%>");
		setItemValue(0, 0, "InteriorCode", "<%=initInteriorCode%>");
		}
		/*****************end*********************************************/

	}
	
	
	</script>
	
	<script type="text/javascript">
//���֤������У��
function isCardNo()  
{
	var card = getItemValue(0,getRow(),"CertID");
	//var flag=true;
	//alert("==================="+card);
	if(card!=""||card.length!=0){
	if(!checkIdcard(card)){
		return false;
		//flag=false;
	}
	return true;
	}else{
		alert("���֤����Ϊ�գ�");
		return false;
	}
}

//���֤
function checkIdcard(idcard){ 
		var Errors=new Array( 
							"��֤ͨ��!", 
							"���֤����λ������!", 
							"���֤����������ڳ�����Χ���зǷ��ַ�!", 
							"���֤����У�����!", 
							"���֤�����Ƿ�!" 
							); 
		var area={11:"����",12:"���",13:"�ӱ�",14:"ɽ��",15:"���ɹ�",21:"����",22:"����",23:"������",31:"�Ϻ�",32:"����",33:"�㽭",34:"����",35:"����",36:"����",37:"ɽ��",41:"����",42:"����",43:"����",44:"�㶫",45:"����",46:"����",50:"����",51:"�Ĵ�",52:"����",53:"����",54:"����",61:"����",62:"����",63:"�ຣ",64:"����",65:"�½�",71:"̨��",81:"���",82:"����",91:"����"} 
							 
		var idcard,Y,JYM; 
		var S,M; 
		var idcard_array = new Array(); 
		idcard_array     = idcard.split(""); 
		//alert(area[parseInt(idcard.substr(0,2))]);
		
		//�������� 
		if(area[parseInt(idcard.substr(0,2))]==null){
			alert(Errors[4]); 
			//setItemValue(0,0,"CertID","");
			//return Errors[4];
			return false;
		}
		 
		//��ݺ���λ������ʽ���� 
		
		switch(idcard.length){
		case 15: 
			if((parseInt(idcard.substr(6,2))+1900) % 4 == 0 || ((parseInt(idcard.substr(6,2))+1900) % 100 == 0 && (parseInt(idcard.substr(6,2))+1900) % 4 == 0 )){ 
				ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;//���Գ������ڵĺϷ��� 
			}else{ 
				ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;//���Գ������ڵĺϷ��� 
			} 
		 
			if(ereg.test(idcard)){
				alert(Errors[0]);
				//setItemValue(0,0,"CertID","");
				//return Errors[0]; 
				return true;
		        
			}else{ 
				alert(Errors[2]);
				//setItemValue(0,0,"CertID","");
				//return Errors[2];  
				return false;
			}
			break; 
		case 18: 
			//18λ��ݺ����� 
			//�������ڵĺϷ��Լ��  
			//��������:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9])) 
			//ƽ������:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8])) 
			if ( parseInt(idcard.substr(6,4)) % 4 == 0 || (parseInt(idcard.substr(6,4)) % 100 == 0 && parseInt(idcard.substr(6,4))%4 == 0 )){ 
				ereg=/^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//����������ڵĺϷ���������ʽ 
			}else{
				ereg=/^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//ƽ��������ڵĺϷ���������ʽ 
			} 
			if(ereg.test(idcard)){//���Գ������ڵĺϷ��� 
				//����У��λ 
				S  =  (parseInt(idcard_array[0]) + parseInt(idcard_array[10])) * 7 
					+ (parseInt(idcard_array[1]) + parseInt(idcard_array[11])) * 9 
					+ (parseInt(idcard_array[2]) + parseInt(idcard_array[12])) * 10 
					+ (parseInt(idcard_array[3]) + parseInt(idcard_array[13])) * 5 
					+ (parseInt(idcard_array[4]) + parseInt(idcard_array[14])) * 8 
					+ (parseInt(idcard_array[5]) + parseInt(idcard_array[15])) * 4 
					+ (parseInt(idcard_array[6]) + parseInt(idcard_array[16])) * 2 
					+  parseInt(idcard_array[7]) * 1  
					+  parseInt(idcard_array[8]) * 6 
					+  parseInt(idcard_array[9]) * 3 ; 
				Y    = S % 11; 
				M    = "F"; 
				JYM  = "10X98765432"; 
				M    = JYM.substr(Y,1);//�ж�У��λ 
				if(M == idcard_array[17]){
					return  Errors[0];		//���ID��У��λ 
				}else{
					alert(Errors[3]);
					//setItemValue(0,0,"CertID","");
					//return  Errors[3]; 
					return false;
		        }
			}else{
				alert(Errors[2]);
				//setItemValue(0,0,"CertID","");
				//return Errors[2]; 
				return false;
		    }
			break;
		default:
		    alert(Errors[1]);
		    //setItemValue(0,0,"CertID","");
			//return  Errors[1]; 
			return false;

			break;
		}	 

}
/*~[Describe=������֤;InputParam=��;OutPutParam=��;]*/
/* function checkName(obj){
	var sName=getItemValue(0,getRow(),"CustomerName");
	if(typeof(sName) == "undefined" || sName.length==0 ){
		alert("����������Ϊ��!");
		obj.focus();
		return false;
	}else{
	if(/\s+/.test(sName)){
		alert("�������пո�����������");
		obj.focus();
		return false;
	}
	//�������������Ļ�����ĸ
	if(!(/^[\u4e00-\u9fa5]+|[a-zA-Z]+$/.test(sName))){
		    if(!(/^([\u4e00-\u9fa5]+|[a-zA-Z]+)��([\u4e00-\u9fa5]+|[a-zA-Z]+)$/.test(sName))){
			alert("��������Ƿ�");
			obj.focus();
			return false;
		    }
		}
	//add CCS-229(�������������֤���룬�ٴ�������ʱ�����ֲ�ͬ������������û��У�飬Ҳû�д����Ͽͻ���Ӧ���ϡ�δ���Ƿ����֣�����У�顣)
	if(!CheckCustomerName())
	{
		obj.focus();
		return false;
	}
	//end
	 }
	}
 */
 
 function checkName(){
		var sName=getItemValue(0,getRow(),"CustomerName");
		if(typeof(sName) == "undefined" || sName.length==0 ){
			alert("����������Ϊ��!");
			//obj.focus();
			return false;
		}else{
		if(/\s+/.test(sName)){
			alert("�������пո�����������");
			//obj.focus();
			return false;
		}
		//�������������Ļ�����ĸ
		if(!(/^[\u4e00-\u9fa5]+|[a-zA-Z]+$/.test(sName))){
			    if(!(/^([\u4e00-\u9fa5]+|[a-zA-Z]+)��([\u4e00-\u9fa5]+|[a-zA-Z]+)$/.test(sName))){
				alert("��������Ƿ�");
				//obj.focus();
				return false;
			    }
			    
			}
		//add CCS-229(�������������֤���룬�ٴ�������ʱ�����ֲ�ͬ������������û��У�飬Ҳû�д����Ͽͻ���Ӧ���ϡ�δ���Ƿ����֣�����У�顣)
		/* if(!CheckCustomerName())
		{
			//obj.focus();
			return false;
		} */
		//end
		 }
		return true;
		}

 	//update CCS-364 ��������-�����֤�ͻ��������κ�У��
	//add CCS-229(�������������֤���룬�ٴ�������ʱ�����ֲ�ͬ������������û��У�飬Ҳû�д����Ͽͻ���Ӧ���ϡ�δ���Ƿ����֣�����У�顣)
	function CheckCustomerName()
	{
		var c_return = true;
		var iCertID = getItemValue(0,getRow(),"CertID");
		var iCustomerName = getItemValue(0,getRow(),"CustomerName");
		var rCustomerName = RunMethod("���÷���","GetColValue","Customer_Info,CustomerName,CertID='"+iCertID+"'");
		if(null == rCustomerName || "Null" == rCustomerName || "undefined" == rCustomerName) rCustomerName = "";
		if(null == iCustomerName || "Null" == iCustomerName || "undefined" == iCustomerName) iCustomerName = "";

		if("" != rCustomerName && "" != iCustomerName && iCustomerName!=rCustomerName)
		{
			alert("�ͻ����������֤����ԭ�����ͻ�������һ�£�����");
			c_return = false;
		}
		return c_return;
	}
	//end
	//end

</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>