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
	
	//����ֵת���ɿ��ַ���
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	
		
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
    System.out.println("-------�ƶ�Pos��-------"+sStorePosid);
    
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CarCashNewLoanApplyInfo";
	
	//����ģ�����������ݶ���	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//�����������ѯ�����
	ASResultSet rs = null;
	String sCreditId = "";
	String sCreditPerson = "";
	//���ñ��䱳��ɫ
	//doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	//���ͻ����ͷ����ı�ʱ��ϵͳ�Զ������¼�����Ϣ
	doTemp.setReadOnly("ProductName",true);
	//doTemp.appendHTMLStyle("CertID"," onChange=\"javascript:parent.getCustomerName()\" ");//update CCS-445 �ֽ����������Ϊ�������֤�ž�����
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//�����ŵ�
    if(sNo == null) sNo = "";
	
	//�ŵ��ַ
	String sCity = Sqlca.getString(new SqlObject("select city from store_info si where si.identtype='01' and si.sno=:sno").setParameter("sno", sNo));
	//��ȡ���չ�˾
    String InsuranceNo=Sqlca.getString(new SqlObject("select sp.ins_serialno from bq_insurance_info sp,insurancecity_info ii "+
    			"where sp.ins_serialno = ii.insuranceno and sp.ins_status = '1' and ii.cityno='"+sCity+"' and ii.subproducttype='3'"));
	if(InsuranceNo==null) InsuranceNo="";
	//��ȡ��������Ϣ
	//add by phe 2015/05/14 CCS-344 �����˲������޷�������г���
    String sSql="select sp.serialno as SerialNo, sp.serviceprovidersname as ServiceProvidersName "+
	            "from Service_Providers sp,ProvidersCity pc where sp.customertype1 = '06' and pc.ProductType = '3' "+
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
    //end by phe 2015/05/14
	
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
		var sCustomerName = getItemValue(0,0,"CustomerName");//�ͻ�����
		var sCertID = getItemValue(0,0,"CertID");//���֤��
		var sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName.trim()+","+sCertID.trim());
		if(sReturn == "Null"){//����ͻ������ڣ�������
				//alert("����ԭ�򣬺�ͬ����ʧ�ܣ�������¼�룡");
			alert("�ÿͻ��״����ҹ�˾�������룬�������복���ֽ����");
				reloadSelf();
				return;
		}
		//update CCS-445 �ֽ����������Ϊ�������֤�ž�����
		var sProductName = getItemValue(0,0,"ProductName");//��Ʒ����
		if("undefined" == typeof(sProductName) || sProductName.length==0 || null == sProductName)
		{
			alert("��ѡ���Ʒ��");
			return;
		}
		
		initSerialNo();
		//end
		as_save("myiframe0",sPostEvents);
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
		// ������У�����֤����
	    isCardNo();
	    var sIdentifiedID = getItemValue(0,getRow(),"CertID");
		if(typeof(sIdentifiedID)=="undefined" || sIdentifiedID.length==0){
			setItemValue(0,0,"CertID","");
			return;
		}else{
			 checkIDAge();
		}
		var sProductID = getItemValue(0,0,"ProductID");//��Ʒ����
		 //add by phe 2015/03/31 CCS-572 PRM-254 ��˶ϵͳ���������۴���Ϊ�Լ�����Ա����
	     if(!checkUserNotCustomer()){
	    	 return;
	     }
		
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
	
	//��֤�������18-55
	function checkIDAge(){
		var sIdentifiedID = getItemValue(0,getRow(),"CertID");
		if(typeof(sIdentifiedID)=="undefined" || sIdentifiedID.length==0){
			alert("���֤���벻��Ϊ�գ�");
			return false;
		}else{
			var myDate = new Date();
			var thisYear = myDate.getFullYear();
			var thisMonth = myDate.getMonth()+1;
			var thisDay = myDate.getDate();
			var age = myDate.getFullYear() - sIdentifiedID.substring(6,10)-1;
			if(sIdentifiedID.substring(10,12)<thisMonth || sIdentifiedID.substring(10,12) == thisMonth && sIdentifiedID.substring(12,14)<= thisDay){
				age++;
			}
			if((age>55) || (age<18)){
				alert("�ͻ����������18��55֮��");
				return false;
			}
		}
		return true;
	}
	
	/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		sObjectType = "<%=sObjectType%>";		
		top.returnValue = sObjectNo+"@"+sObjectType;
		top.close();
	}

	/*~[Describe=;InputParam=��;OutPutParam=��;]~*/
	function ProductSum(){
		setItemValue(0, 0, "ProductName", "");
		setItemValue(0, 0, "Periods", "");
		setItemValue(0, 0, "MonthRepayment", "");
		setItemValue(0, 0, "EventName", "");
		setItemValue(0, 0, "BusinessType", "");
		setItemValue(0, 0, "EventID", "");
	}
	function chkTotalSumValue() {
		var sTotalSum = ''+getItemValue(0,getRow(),"BusinessSum");

		if (sTotalSum.length<=0) {
			alert("����������");
			return "false";
		}
		if (parseFloat(sTotalSum)<0.0) {
			alert("������Ϊ��������ȷ�ϣ�"); 
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
		var	sSum = getItemValue(0,0,"BusinessSum");
		//var sCustomerID = getItemValue(0,0,"CustomerID");
		//var sBusinessSum = getItemValue(0,0,"BusinessSum");
		//add CCS-445 �ֽ����������Ϊ�������֤�ž�����
		var sCertID = getItemValue(0,getRow(),"CertID");
		var sCustomerName = getItemValue(0,getRow(),"CustomerName");
		
		/***** begin  CCS-1112 �������ʱ��������ѯ  update huzp 20151020 *****/
		
		var args = "colId="+sCertID+",colName="+sCustomerName;
		var str = RunJavaMethodSqlca("com.amarsoft.app.billions.GetNameByID","getCustomerName",args);
		var idAndName  =str.split("@");
		var sCustomerID =idAndName[0];
		var sMaxTerm =idAndName[1];

//		var sCustomerID = RunMethod("���÷���", "GetColValue", "RESCASHACCESSCUSTOMER,CUSTOMERID,CERTID='"+sCertID+"' and CUSTOMERNAME = '"+sCustomerName+"'");
//		var sMaxTerm = RunMethod("���÷���", "GetColValue", "RESCASHACCESSCUSTOMER,TERM,CERTID='"+sCertID+"' and CUSTOMERNAME = '"+sCustomerName+"'");
		 /***** end **********************/
		setItemValue(0,0,"CustomerID",sCustomerID);
		//end
		 if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0 || "Null" == sCustomerID || null == sCustomerID || "" == sCustomerID)
	     {
		     alert("�ͻ��������������ֽ�������飡");
		     return;
		 }
		 if (typeof(sSum)=="undefined" || sSum=="_CLEAR_" || sSum.length==0) {
	    	 alert("����������");
			   return;
	     }
		 /***** begin  CCS-1112 ����Ƿ�ɹ�����������ֽ����ѯ  update huzp 20151020 *****/
		
// var sCustomerID = RunMethod("���÷���", "GetColValue", "RESCASHACCESSCUSTOMER,CUSTOMERID,CERTID='"+sCertID+"' and CUSTOMERNAME = '"+sCustomerName+"'");

		 var IsCount=RunMethod("BusinessManage","IsCountCustomer",sCustomerName+","+sCertID);
		 if(IsCount > 0)
		 {
			 alert("�ͻ��Ѿ��ɹ�����������ֽ��,�����ٴ����룡");
			 return;
		 }
		 /***** end **********************/
		 
		 var sAmountLimit=RunMethod("BusinessManage","GetMaxAmount",sCustomerName+","+sCertID);
		 if(sSum > sAmountLimit)
		    {
			    alert("�����ͻ������޶");
			    return;
			}
		 //add by phe 2015/03/31 CCS-572 PRM-254 ��˶ϵͳ���������۴���Ϊ�Լ�����Ա����
	     if(!checkUserNotCustomer()){
	    	 return;
	     }
		
		//alert("sAmountLimit="+sAmountLimit);
		//var returnVall1=RunMethod("BusinessManage","GetAllCarProduct",sAmountLimit);
		
		
		sParaString = "MaxAmount,"+sSum+","+"MaxTerm,"+sMaxTerm+","+"SNo,<%=sNo%>";;
		//���÷��ز��� 
		//serialno@eventname@productid@productname@TypeNo@TypeName@Term
		setObjectValue("GetAllCarProduct",sParaString,"@ProductName@1@BusinessType@0@Periods@5",0,0,""); 
		var sCreditCycle = getItemValue(0,0,"CreditCycle");//�Ƿ�Ͷ��
		var sBugPayPkgind = getItemValue(0,0,"BugPayPkgind");//�Ƿ������Ļ������
		//����һ��ÿ�»�������
		if(!(typeof(sCreditCycle)=="undefined" || sCreditCycle.length==0 || typeof(sBugPayPkgind)=="undefined" || sBugPayPkgind.length==0)){
			getMonthPayment();
		}
	}
	//�Ƿ�Ͷ������������ÿ�»����  add by phe
	function getMonthPayment(){
		var sBusinessType = getItemValue(0,0,"BusinessType");//��ȡ��Ʒ����
		var sBusinessSum = getItemValue(0,0,"BusinessSum");//������
		var sPeriods = getItemValue(0,0,"Periods");//��������
		var sCreditCycle = getItemValue(0,0,"CreditCycle");//�Ƿ�Ͷ��
		var sBugPayPkgind = getItemValue(0,0,"BugPayPkgind");//�Ƿ������Ļ������
		var sInsuranceNo = "<%=InsuranceNo%>";//���չ�˾

		//var sCount = RunMethod("���÷���", "GetColValue", "product_term_library,count(1),subtermtype = 'A12' and status='1' and  ObjectNo ='"+sBusinessType+"-V1.0'");
		
		if(typeof(sBusinessSum)=="undefined" || sBusinessSum.length==0){
			alert("��Ʒ����Ϊ�գ�");
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
		if(parseFloat(sBusinessSum) < 0){
			 alert("������������0��");
			 return;
			}else{
				if(parseFloat(parseInt(sBusinessSum,10))<parseFloat(sBusinessSum)){
					alert("������Ĳ����Ϊ����������");
					return;
				}
				var sMonthPayment=RunMethod("PublicMethod","GetMonthPayment",sBusinessSum+","+sBusinessType+","+sPeriods+","+sCreditCycle+","+sBugPayPkgind);
				
				var MonthPaymentBefore = parseFloat(sMonthPayment);
				var MonthPaymentAfter = fix(MonthPaymentBefore);
				setItemValue(0,getRow(),"MonthRepayment",MonthPaymentAfter+"");
				//end
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
	//end by phe
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		var sApplyType = "<%=sApplyType%>";
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
			// ҵ����Դ
			setItemValue(0,getRow(),"SureType","PC");
			// ���չ�˾���
			setItemValue(0,getRow(),"InsuranceNo","<%=InsuranceNo%>");
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
			
			if(sApplyType=="CarCashLoanApply"){
				setItemValue(0,0,"ProductID","020");
				//hideItem(0,0,"ProductID");
				setItemValue(0,0,"SubProductType","3");
				setItemDisabled(0,0,"SubProductType","true");
				showItem(0,0,"SubProductType");
				
			}else{
				setItemValue(0,0,"ProductID","020");
			}
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
	}
	
	
	</script>
	
	<script type="text/javascript">
//���֤������У��
function isCardNo()  
{
	var card = getItemValue(0,getRow(),"CertID");
	//alert("==================="+card);
	if(typeof(card)=="undefined" || card.length==0){
		alert("���֤���벻��Ϊ�գ�");
		setItemValue(0,0,"CertID","");
		return;
	}
	checkIdcard(card);
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
			setItemValue(0,0,"CertID","");
			return Errors[4];
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
				setItemValue(0,0,"CertID","");
				return Errors[0]; 
		        
			}else{ 
				alert(Errors[2]);
				setItemValue(0,0,"CertID","");
				return Errors[2];  
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
					setItemValue(0,0,"CertID","");
					return  Errors[3]; 
		        }
			}else{
				alert(Errors[2]);
				setItemValue(0,0,"CertID","");
				return Errors[2]; 
		    }
			break;
		default:
		    alert(Errors[1]);
		    setItemValue(0,0,"CertID","");
			return  Errors[1]; 

			break;
		}	 
}

	//�������֤�����ȡ�ͻ����Ƽ��ͻ����
	function getCustomerName()
	{
		var sCertID = getItemValue(0,getRow(),"CertID");
		var sCustomerName = RunMethod("���÷���", "GetColValue", "CUSTOMER_INFO,CUSTOMERNAME,CERTID='"+sCertID+"'");
		var sCustomerID = RunMethod("���÷���", "GetColValue", "CUSTOMER_INFO,CUSTOMERID,CERTID='"+sCertID+"'");
		if("Null" == sCustomerName || null == sCustomerName || "" == sCustomerName || "undefined" == sCustomerName || "Null" == sCustomerID || null == sCustomerID || "" == sCustomerID || "undefined" == sCustomerID)
		{
			alert("�ͻ���Ϣ�����ڣ�����!");
			setItemValue(0,0,"CustomerName","");
			setItemValue(0,0,"CustomerID","");
		}else
		{
			setItemValue(0,0,"CustomerName",sCustomerName);
			setItemValue(0,0,"CustomerID",sCustomerID);
		}
	}
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