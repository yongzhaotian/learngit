<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
<%
	/*
		Author:   
		Tester:
		Content: 
		Input Param:
				 ObjectType��
				 ObjectNo��
		Output param:
		History Log: xswang 2015/06/01 CCS-713 ��ͬ�е��ŵ���תΪ�����ŵ�
	 */
	%>
<%/*~END~*/%>


	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	String sSql="",ssSno="",sSname="",sServiceprovidersname="",sServiceprovidersID="",sGenusgroup="",sCarfactoryid="",sCarfactory="";
	ASResultSet rs = null;
	
	//���ҳ�����	��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//�������������ҵ����֡�����ҵ�����ա�������ˮ�š���ݺ�
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "",dOldSerialNo = "",sSno="",ssSname="",sCreditId="",sCreditPerson="",sCity="",sAttr2="";
			
	if(sSerialNo==null) sSerialNo="";
	%>
	<%/*~END~*/%>

	<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
	<% 
		BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
		if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessContract");

		//����Ƚ���������
		String simulationSchemeCount=(String)session.getValue("SimulationSchemeCount");
		if(simulationSchemeCount==null){
			session.putValue("SimulationSchemeCount","1");
			simulationSchemeCount="1";
		}
		
		String productID =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductID")));
		String CustomerID =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID")));
		//String Vendor =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Vendor")));
		//String paraStr =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("paraStr")));
		String productVersion =  "V1.0";
		if(productID==null)productID="";
		if(CustomerID==null)CustomerID="";
		%>
	<%/*~END~*/%>

<%
//�����ŵ�
// add by xswang 2015/06/01 CCS-713 ��ͬ�е��ŵ���תΪ�����ŵ�
//String sNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
String sNo = CurUser.getAttribute8();
// end by xswang 2015/06/01

if(sNo == null) sNo = "";
System.out.println("-------�����ŵ�-------"+sNo);
sSql = "";
sSql="select sno,sname from store_info where sno = :sno and  identtype = '01'";
rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sNo));
if(rs.next()){
	 sSno = DataConvert.toString(rs.getString("sno"));//�ŵ�
	 sSname = DataConvert.toString(rs.getString("sname"));
	//����ֵת���ɿ��ַ���
	if(sSno == null) sSno = "";
	if(sSname == null) sSname = "";
	
}
rs.getStatement().close();


String sCityName = "" ;//����������
//���������
sSql="select si.city as city,getitemname('AreaCode',si.city) as cityName,si.sno as sno,si.sname as sname,sp.serialNo as serviceprovidersID, sp.serviceprovidersname as serviceprovidersname,sp.genusgroup as genusgroup,sp.carfactoryid as carfactoryid,sp.carfactory as carfactory from store_info si,service_providers sp where si.rserialno=sp.serialno and si.identtype='02' and sp.customertype1='07' and si.sno=:sno";
rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sno",sNo));
if(rs.next()){
	 ssSno = DataConvert.toString(rs.getString("sno"));//չ�����
	 ssSname = DataConvert.toString(rs.getString("sname"));//չ������
	 sServiceprovidersID = DataConvert.toString(rs.getString("serviceprovidersID"));//�����̱��
	 sServiceprovidersname = DataConvert.toString(rs.getString("serviceprovidersname"));//����������
	 sGenusgroup = DataConvert.toString(rs.getString("genusgroup"));//��������
	 sCarfactoryid = DataConvert.toString(rs.getString("carfactoryid"));//��������ID
	 sCarfactory = DataConvert.toString(rs.getString("carfactory"));//������������
	 sCity = DataConvert.toString(rs.getString("city"));//����
	 sCityName = DataConvert.toString(rs.getString("cityName"));//����
}
rs.getStatement().close();

ARE.getLog().debug("======"+sCity+","+ssSno+","+ssSname+","+sServiceprovidersname+","+sGenusgroup+","+sCarfactoryid+","+sCarfactory);


	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CarLeaseInfo";//ģ�ͱ��
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//���׶�������ģ��
	doTemp.setReadOnly("DirectPrice,Cashdeposit,StartRent,SalvageSum,PaymentTotal,Appropriation,CostTotal,MonthCost,MonthRent", true);
	doTemp.setHTMLStyle("DirectPrice,Premiums,AllocationSum,RevenueTax,InsureSum,SalvageSum", "onChange=\"javascript:parent.countAppropriation()\"");
	doTemp.setHTMLStyle("AssureService,ProcedureFee,Stampduty,Premium,Vat,ResellFee","onChange=\"javascript:parent.countCostTotal()\"");
	doTemp.setHTMLStyle("CreditMonth","onChange=\"javascript:parent.countMonthCost()\"");
	doTemp.setHTMLStyle("SalvageRate","onChange=\"javascript:parent.SalvageSum()\"");
	doTemp.setHTMLStyle("ProductName","onChange=\"javascript:parent.cleanCarModel()\"");
	doTemp.setHTMLStyle("CreditApr,ProductID","onChange=\"javascript:parent.checkRate()\"");
	doTemp.setHTMLStyle("MonthrePayment","onClick=\"javascript:parent.countMonthrePayment()\"");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//{"true","","Button","����","����","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����¼","saveBusinessObjectToSession(\'"+simulationObject.getObjectType()+"\')",sResourcesPath},
		{"false","","Button","����","����","goBack()",sResourcesPath},
		{"true","","Button","�鿴����ƻ�","�鿴����ƻ�","",sResourcesPath},
	};
	sButtons[2][5]="runTransaction2('0020','"+simulationObject.getObjectType()+"','"+simulationObject.getObjectNo()+"','"+simulationObject.getString("PutoutDate")+"')";
	if((BusinessObject)session.getAttribute("SimulationObject_Loan") != null){
		sButtons[3][0] = "true";
	}
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------
	function selectOpponentNameOld()
	{
		sBusinessType = getItemValue(0,0,"CreditType");
		if(typeof(sBusinessType) == "undefined" || sBusinessType == "")
		{
			alert("����ѡ���Ʒ����!");
			return;
		}
		
		sParaString = "BusinessType"+","+sBusinessType; 
		//���÷��ز��� 
		setObjectValue("SelectBusinessInfo",sParaString,"@ProductId@0@ProductName@1",0,0,"");
	}
	function selectOpponentName()
	{
		var sSerialNo = "<%=sServiceprovidersID%>";//�����̱��
		var sEntInfoValue2=setObjectValue("SelectDistributorLoadInfo0","SerialNo,"+sSerialNo,"@productName@1",0,0,"");
		if(typeof(sEntInfoValue2)=="undefined" || sEntInfoValue2=="" || sEntInfoValue2=="_CANCEL_" ) return;
		if(sEntInfoValue2=="_CLEAR_"){
			setItemValue(0,0,"ProductID","");
	    	/* setItemValue(0,0,"ProductVersion","V1.0"); */
	    	setItemValue(0,0,"ProductName","");
	    	setItemValue(0,0,"CreditApr","");
		}else{
	    	sEntInfoValue2=sEntInfoValue2.split('@');
	    	sProductID=sEntInfoValue2[0];        //�����̹����Ĳ�Ʒ����
	    	sProductName=sEntInfoValue2[1];      //��Ʒ����
	    	sFloatingManner=sEntInfoValue2[2];   //������ʽ
	    	sInterestRate=sEntInfoValue2[3];     //��������
	    	sFloatingRange=sEntInfoValue2[4];    //��������
	    	setItemValue(0,0,"ProductID",sProductID);
	    	/* setItemValue(0,0,"ProductVersion","V1.0"); */
	    	setItemValue(0,0,"ProductName",sProductName);
	    	checkRate();
	    	countMonthrePayment();
		}
	}
	
	function runTransaction2(transcode,documenttype,documentno,transDate){
		var returnValue = PopPage("/Accounting/LoanSimulation/RunTransaction2.jsp?TransCode="+transcode+"&DocumentType="+documenttype+"&DocumentNo="+documentno+"&TransDate="+transDate+"&ToInheritObj=y","","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("����ִ�гɹ���");

		OpenComp("ACCT_LoanSimulationCashFlowTab","/Accounting/LoanSimulation/CashFlowTab.jsp","","");
		//reloadSelf();

		//PopPage("/Accounting/LoanSimulation/PaymentScheduleList.jsp?","","");
		reloadSelf();

	}
			
	function saveRecord()
	{
		initSerialNo();
		as_save("myiframe0");
	}
	
	// ���ؽ����б�
	function goBack()
	{
		//OpenPage("/BusinessManage/CollectionManage/TransferDealManagerList.jsp","_self","");
	}
	
	//�����ͺŴ���
	function selectCarCode(){
		var sTypeNo = getItemValue(0,0,"ProductID");
		if(typeof(sTypeNo) == "undefined" || sTypeNo == "")
		{
			alert("����ѡ����ڲ�Ʒ����!");
			return;
		}
		//���÷��ز��� 
		var sReturnValues = setObjectValue("SelectCarCodeInfo","TypeNo,"+sTypeNo,"",0,0,"");

		if(typeof(sReturnValues)=="undefined" || sReturnValues=="" || sReturnValues=="_CANCEL_" ) return;
		if(sReturnValues=="_CLEAR_"){
			setItemValue(0,0,"CarModel","");
			setItemValue(0,0,"DirectPrice","");	
		}else{
			sReturnValue = sReturnValues.split("@");
			var CarModel = sReturnValue[0];
			var DirectPrice =  sReturnValue[1];
			setItemValue(0,0,"CarModel",CarModel);
			setItemValue(0,0,"DirectPrice",DirectPrice);	
		}
	}
	
	function initRow()
	{
		//���ô�������
		setItemValue(0,0,"CreditType","02");
		//����������
		setItemValue(0,0,"DealerName","<%=sServiceprovidersname%>");
		//����
		setItemValue(0,0,"Vendor","<%=sCarfactory%>");
		
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			//���ô�������
			setItemValue(0,0,"CreditType","02");
			//����������
			setItemValue(0,0,"DealerName","<%=sServiceprovidersname%>");
			//����
			setItemValue(0,0,"Vendor","<%=sCarfactory%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "Car_Credit_Info";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
       
		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	//�����ܲ����
	function countAppropriation()
	{
		var DirectPrice = getItemValue(0,0,"DirectPrice");
		var Premiums = getItemValue(0,0,"Premiums");
		var AllocationSum = getItemValue(0,0,"AllocationSum");
		var RevenueTax = getItemValue(0,0,"RevenueTax");
		var InsureSum = getItemValue(0,0,"InsureSum");
		var SalvageSum = getItemValue(0,0,"SalvageSum");
		if(DirectPrice==null||DirectPrice=="") DirectPrice=0;
		if(Premiums==null||Premiums=="") Premiums=0;
		if(AllocationSum==null||AllocationSum=="") AllocationSum=0;
		if(RevenueTax==null||RevenueTax=="") RevenueTax=0;
		if(InsureSum==null||InsureSum=="") InsureSum=0;
		if(SalvageSum==null||SalvageSum=="") SalvageSum=0;
		
		//���㳵���ܼ�
		var sPara = "attribute1="+Premiums+",attribute2="+AllocationSum+",attribute3="+RevenueTax+",attribute4="+InsureSum+",attribute5="+DirectPrice+",attribute6="+SalvageSum;
		
		var Appropriation = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","countAppropriation",sPara);
		
		if(Appropriation=="Null"||Appropriation=="null"||Appropriation==""){
			setItemValue(0,0,"Appropriation","");
		}else{
			setItemValue(0,0,"Appropriation",Appropriation);
		}		
	}
	
	//��������ܼ�
	function countCostTotal(){
		var AssureService = getItemValue(0,0,"AssureService");//���������	AssureService
    	var ProcedureFee = getItemValue(0,0,"ProcedureFee");//������	ProcedureFee
    	var Stampduty = getItemValue(0,0,"Stampduty");//ӡ��˰	Stampduty
    	var Premium = getItemValue(0,0,"Premium");//����շ�	Premium
    	var Vat = getItemValue(0,0,"Vat");//VAT	Vat
    	var ResellFee = getItemValue(0,0,"ResellFee");//ת��������	ResellFee
    	if(AssureService==null||AssureService=="") AssureService=0;
    	if(ProcedureFee==null||ProcedureFee=="") ProcedureFee=0;
    	if(Stampduty==null||Stampduty=="") Stampduty=0;
    	if(Premium==null||Premium=="") Premium=0;
    	if(Vat==null||Vat=="") Vat=0;
    	if(ResellFee==null||ResellFee=="") ResellFee=0;
    	//��������ܼ�
		var sPara = "attribute1="+AssureService+",attribute2="+ProcedureFee+",attribute3="+Stampduty+",attribute4="+Premium+",attribute5="+Vat+",attribute6="+ResellFee;
		var CostTotal = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","sumCarTotal",sPara);
		if(CostTotal=="Null"||CostTotal=="null"||CostTotal==""){
			setItemValue(0,0,"CostTotal","0");
			countMonthCost();
		}else{
			setItemValue(0,0,"CostTotal",CostTotal);	
			countMonthCost();
		}	
	}
	
	//����ÿ�·���
	function  countMonthCost(){
		var CostTotal = getItemValue(0,0,"CostTotal");
		var CreditMonth = getItemValue(0,0,"CreditMonth");
		
		if(CostTotal==null||CostTotal=="") CostTotal=0;	
		//if(CreditMonth==null||CreditMonth=="") return;
		
		//ע������Ҫ������ֵ��ʵ��ֵ��ת��: 0	12   1	18   2	24   3	36   4	48   5	60 
		var sTerm = RunMethod("LoanAccount","TermConvert",CreditMonth);
		if(typeof(sTerm)=="undefined"||sTerm==""){
			return;
		}
		var sPara = "attribute1="+CostTotal+",attribute2="+sTerm;
		var MonthCost = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","countMonthCost",sPara);
		if(MonthCost=="Null"||MonthCost=="null"||MonthCost==""){
			setItemValue(0,0,"MonthCost","0");
		}else{			
			setItemValue(0,0,"MonthCost",MonthCost);
			}
	}
	

	//�����ֵ���
	function SalvageSum(){
		var DirectPrice = getItemValue(0,0,"DirectPrice");
		if(typeof(DirectPrice)=="undefined"||DirectPrice==""){
			return;
		}
		var SalvageRate = getItemValue(0,0,"SalvageRate");
		if(typeof(SalvageRate)=="undefined"||SalvageRate==""){
			return;
		}
		var sPara = "attribute1="+DirectPrice+",attribute2="+SalvageRate;
		var sReturnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","FinalPaymentSum",sPara);
		if(typeof(sReturnValues)=="undefined"||sReturnValues==""){
			return;
		}else{
			setItemValue(0,0,"SalvageSum",sReturnValues);
			countCarTotal();
		}
	}
	//���ڲ�Ʒ���ʱ����ճ���
	function cleanCarModel(){
		setItemValue(0,0,"CarModel","");
		setItemValue(0,0,"DirectPrice","");
		countAppropriation();
		SalvageSum();
	}
	//����������У��
	function checkRate(){	
		
		var sTypeNo = getItemValue(0,0,"ProductID");
		if(typeof(sTypeNo) == "undefined" || sTypeNo == "")
		{
			setItemValue(0,0,"CreditApr","");
			return;
		}
		var CreditMonth = getItemValue(0,0,"CreditMonth");
		
		//��ȡ��Ʒ�����ġ��Ƿ����֡������������͡������������͡�  
		var sReurnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.GetRelativeRateInfo","getRateInfo","typeNo="+sTypeNo);
		if(typeof(sReurnValues)=="undefined"||sReurnValues=="") return;
		
	    //�Ƿ����֣�whetherDiscount			TrueFalse                          �������ͣ�rateType		RateType1                    ��������:floatingManner			RateFloatType
		var whetherDiscount = sReurnValue.split("@")[0];//0	��     		1	��
		var rateType = sReurnValue.split("@")[1];//0	�̶�����				1	��������			2	�̶��������
		var floatingManner = sReurnValue.split("@")[2];//0	����������					1	��������
		//ȡ���޲����еġ��̶�����ֵ��������߹̶����ʡ������������ȡ���  ����Ϣ�ͻ��̶����ʡ�
		sReurnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.GetRelativeRateInfo","getRateInfoFromTerm","typeNo="+sTypeNo+",term="+CreditMonth);
		//�̶�����ֵ:loanFixedRate			��߹̶�����:highestFixedRate      			��������:floatingRate
		if(typeof(sReurnValues)=="undefined"||sReurnValues=="") return;
		var loanFixedRate = sReurnValue.split("@")[0];
		var highestFixedRate = sReurnValue.split("@")[1];
		var floatingRate = sReurnValue.split("@")[2];
		var discountFixedRate = sReurnValue.split("@")[3];
		
		if(whetherDiscount=="0"){//����Ϣ��Ʒ
			if(rateType=="2"){//��������ѡ��̶����������Ҫ���۾����ֹ�����������ʣ������ƴ������ʲ���С�ڲ�Ʒ������ز������ñ��еĹ̶�����ֵ��ͬʱ���ø�����߹̶����ʡ�
				var CreditApr = getItemValue(0,0,"CreditApr");
				if(CreditApr<loanFixedRate){
					alert("�������ʲ���С�ڲ�Ʒ������ز������ñ��еĹ̶�����ֵ");
					return;
				}
				if(CreditApr>highestFixedRate){
					alert("�������ʲ��ܸ��ڲ�Ʒ������ز������ñ��е���߹̶�����");
					return;
				}			
			}else{
				setItemReadOnly(0,0,"CreditApr",true);
				if(rateType=="0"){//����������Ϊ�̶����ʣ���ʾ��Ʒ������ز������ñ��еĹ̶�����ֵ��
					setItemValue(0,0,"CreditApr",loanFixedRate);
				}else if(rateType=="1"){//����������Ϊ��������ʱ�����������ҵ���Ӧ�Ļ�׼���ʣ�
					//ȡ���л�׼����  
					//����ת����
					/* Term��		1	6��-12�� (��12��)			2	12-36�� (��36��)				3	37-60�� (��60��)
						Term1��	0	12									1	18									2	24								3	36						4	48						5	60					*/
					var Term = "";
					if(CreditMonth=="0") Term = "1";
					if(CreditMonth=="1"||CreditMonth=="2"||CreditMonth=="3") Term = "2";
					if(CreditMonth=="4"||CreditMonth=="5") Term = "3";
					sReurnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.GetRelativeRateInfo","getRateInfoFromTerm","term="+Term);
					//��׼����:yearsInterestRate�������ʣ�   monthInterestRate�������ʣ�
					if(typeof(sReurnValues)=="undefined"||sReurnValues=="") return;
					var yearsInterestRate = sReurnValue.split("@")[0];
					var monthInterestRate = sReurnValue.split("@")[1];
					//��Ϊ���������������������=��׼����*��1+�������ȣ�����Ϊ�������㣬���������=��׼����+��������
						var sPara = "attribute1="+monthInterestRate+",attribute2="+floatingRate+"attribute3="+floatingManner;
						sReurnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","CountCreditApr",sPara);
						if(typeof(sReurnValues)=="undefined"||sReurnValues=="") return;
						setItemValue(0,0,"CreditApr",sReurnValues);
				}
			}
		}else if(whetherDiscount=="1"){//��Ϣ��Ʒ����Ϣ�ͻ��̶�����    discountFixedRate
			setItemValue(0,0,"CreditApr",discountFixedRate);
		}else{
			alert("�����Ʋ�Ʒ��������");
			setItemValue(0,0,"CreditApr","");
		}	
	}
	
	//�����¹�
	function countMonthrePayment(){
		var sTypeNo = getItemValue(0,0,"ProductID");
		if(typeof(sTypeNo) == "undefined" || sTypeNo == "")
		{
			setItemValue(0,0,"MonthrePayment","");
			return;
		}
		var CreditMonth = getItemValue(0,0,"CreditMonth");
		//ע������Ҫ������ֵ��ʵ��ֵ��ת��: 0	12   1	18   2	24   3	36   4	48   5	60 
		var sTerm = RunMethod("LoanAccount","TermConvert",CreditMonth);
		if(typeof(sTerm)=="undefined"||sTerm==""){
			return;
		}
		/* var FinalPayment = getItemValue(0,0,"FinalPayment");
		var FinalPaymentSum = getItemValue(0,0,"FinalPaymentSum"); */
		var BuinsessSum = getItemValue(0,0,"BusinessSum");
		var CreditApr = getItemValue(0,0,"CreditApr");
		if(typeof(FinalPayment) == "undefined" || FinalPayment == "") FinalPayment = 0;
		if(typeof(FinalPaymentSum) == "undefined" || FinalPaymentSum == "") FinalPaymentSum = 0;
		if(typeof(BuinsessSum) == "undefined" || BuinsessSum == "") BuinsessSum = 0;
		if(typeof(CreditApr) == "undefined" || CreditApr == "") CreditApr = 0;
		
		/* var sPara ="typeNo="+sTypeNo+",term="+sTerm+",rate="+CreditApr+",financeAmount="+BuinsessSum+",finalPayment="+FinalPayment+",finalPaymentSum="+FinalPaymentSum; */
		var sPara ="typeNo="+sTypeNo+",term="+sTerm+",rate="+CreditApr+",financeAmount="+BuinsessSum;
		//��ȡ��Ʒ�����ġ��¹����㷽ʽ����������ÿ�»�����
		var sReurnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.GetMonthPayment","getMonthPayment",sPara);
		if(typeof(sReurnValues)=="undefined"||sReurnValues=="") return;
		setItemValue(0,0,"MonthrePayment",sReurnValues);
	}
	//���¶�Ӧ��ֵ
	function beforeSave(){
 	
    	var DealerName = getItemValue(0,0,"DealerName");//������	DealerName
    	var Vendor = getItemValue(0,0,"Vendor");//����	Vendor
    	var ProductName = getItemValue(0,0,"ProductName");//���ڲ�Ʒ���� ProductName
    	var CreditMonth = getItemValue(0,0,"CreditMonth");//��������	CreditMonth
    	var CarModel = getItemValue(0,0,"CarModel");//�����ͺ�	CarModel
    	var CarStatus = getItemValue(0,0,"CarStatus");//����	CarStatus
    	var DirectPrice = getItemValue(0,0,"DirectPrice");//�г�ָ����	DirectPrice
    	var Premiums = getItemValue(0,0,"Premiums");//�ӱ���	Premiums
    	var AllocationSum = getItemValue(0,0,"AllocationSum");//�����������ý��	AllocationSum
    	var RevenueTax = getItemValue(0,0,"RevenueTax");//��������˰	RevenueTax
    	var InsureSum = getItemValue(0,0,"InsureSum");//�������շ�	InsureSum
    	var Cashdeposit = getItemValue(0,0,"Cashdeposit");//��֤��	Cashdeposit
    	var SalvageRate = getItemValue(0,0,"SalvageRate");//��ֵ����	SalvageRate
    	var StartRent = getItemValue(0,0,"StartRent");//�������	StartRent
    	var SalvageSum = getItemValue(0,0,"SalvageSum");//��ֵ���	SalvageSum
    	var PaymentTotal = getItemValue(0,0,"PaymentTotal");//�׸��ϼ�	PaymentTotal
    	var Appropriation = getItemValue(0,0,"Appropriation");//�ܲ����	Appropriation
    	var AssureService = getItemValue(0,0,"AssureService");//���������	AssureService
    	var ProcedureFee = getItemValue(0,0,"ProcedureFee");//������	ProcedureFee
    	var Stampduty = getItemValue(0,0,"Stampduty");//ӡ��˰	Stampduty
    	var Premium = getItemValue(0,0,"Premium");//����շ�	Premium
    	var Vat = getItemValue(0,0,"Vat");//VAT	Vat
    	var ResellFee = getItemValue(0,0,"ResellFee");//ת��������	ResellFee
    	var CostTotal = getItemValue(0,0,"CostTotal");//�����ܼ�	CostTotal
    	var MonthCost = getItemValue(0,0,"MonthCost");//ÿ�·���	MonthCost
    	var MonthRent = getItemValue(0,0,"MonthRent");//��������	MonthRent
    	var CreditApr = getItemValue(0,0,"CreditApr");//����������	CreditApr
    	 var MonthrePayment = getItemValue(0,0,"MonthrePayment");//�»�����	MonthrePayment

    	var sParaString = "";
    	sParaString = "&Maturity="+Maturity+"&Premium="+Premium+"&FinalPaymentSum="+FinalPaymentSum+"&Premiums="+Premiums+"&RevenueTax="+RevenueTax+"&InsureSum="+InsureSum+
    	"&AssureService="+AssureService+"&ProcedureFee="+ProcedureFee+"&BusinessSum="+BusinessSum+"&BusinessRate="+BusinessRate+"&CreditType="+CreditType+"&ProductID="+ProductID+"&CustomerID="+CustomerID;
		
    	return sParaString;
		
	}
	

	//����
	function saveBusinessObjectToSession(businessObjectType,parentObjectType,parentObjectNo){
		var sParaStr2=beforeSave();
		//return;

		if(businessObjectType=="jbo.app.BUSINESS_CONTRACT"){
			var r = checkSave();
			if(r==1){
				return;
			}
		}	

		var colCount = DZ[0][1].length;//����
		var paraStr = "RowCount="+getRowCount(0);
		var colnames="";
		for(var i=0;i<DZ[0][1].length;i++){
			var updateable=DZ[0][1][i][5];
			//alert(updateable+"--"+getColName(0,i));
			if(updateable==0) continue;
			colnames+=getColName(0,i)+",";
		}
		colnames = colnames.substring(0,colnames.length-1);
		for(var j=1;j<=getRowCount(0);j++){
			for(var i=0;i<colCount;i++){
				var updateable=DZ[0][1][i][5];
				if(updateable==0) continue;
				var value=getItemValueByIndex(0,j-1,i);
				if(typeof(value)=="undefined"||value==null || value.length==0||value=="null"||value=="Null") continue;
				paraStr += "&"+getColName(0,i)+j+"="+value;
			}
		}
		if(typeof(parentObjectType)=="undefined"||parentObjectType==null ||parentObjectType=="null"||parentObjectType=="Null") 
			parentObjectType="";
		if(typeof(parentObjectNo)=="undefined"||parentObjectNo==null ||parentObjectNo=="null"||parentObjectNo=="Null") 
			parentObjectNo="";
		paraStr+="&ParentObjectType="+parentObjectType;
		paraStr+="&ParentObjectNo="+parentObjectNo;
		paraStr+=sParaStr2;
		paraStr+="&BusinessObjectType="+businessObjectType+"&ColNames="+colnames;
		
		//���в����棬�ٴ�ˢ�º��޿��г���
		var returnValue = PopPage("/Accounting/LoanSimulation/BusinessObjectAction.jsp?"+paraStr,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
	
		if(returnValue=="true"){
			alert("����ɹ���");
			if(businessObjectType=="jbo.app.BUSINESS_CONTRACT"){
				parent.tt();
			}		
			reloadSelf();
		}
		else alert("����ʧ�ܣ�");
	}
	
	//��������
	function reset(){
		session.removeAttribute("SimulationObject_Loan");
		session.removeAttribute("SimulationObject_BusinessContract");
		reloadSelf();
	}
	
	
	</script>

<script language=javascript>	
	AsOne.AsInit();
	bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
