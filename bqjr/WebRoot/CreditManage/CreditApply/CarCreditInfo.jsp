<%@page import="com.amarsoft.app.accounting.util.FeeFunctions"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ page import="com.amarsoft.app.accounting.product.*"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.*"%>
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


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	//���ҳ�����	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";

	//����������������͡��ͻ��š������̡���Ʒ���͡����̡����ڲ�Ʒ����
	String CreditType = "",CustomerID = "",DealerName = "",ProductID = "",Vendor = "",ProductName = "";
	//����������������ޣ��£��������ͺš��������г�ָ���ۡ��ӱ���
	String CreditMonth = "",CarModel = "",CarStatus = "",DirectPrice = "",Premiums = "";
	//��������������������ý�����ҵ�����ա���������˰����Ϣ��
	String AllocationSum = "",Maturity = "",RevenueTax = "",PutoutDate = "",ssSno="",sSname="",sServiceprovidersID = "",sServiceprovidersname="",sGenusgroup="",sCarfactoryid="",sCarfactory="";
	//������������շѡ������ۼۡ������ܼ�/���������/����շ�/������/�����ܼ�/ÿ�·���/�׸����/������/β����/�»�����
	double InsureSum = 0.0,VehiclePrice = 0.0,CarTotal = 0.0,AssureService=0.0,Premium=0.0,ProcedureFee=0.0,CostTotal = 0.0,MonthCost = 0.0,PaymentSum = 0.0,PaymentTotal=0.0,BusinessSum=0.0,FinalPaymentSum=0.0,MonthrePayment=0.0;
	//������������������β����������ɽ��´�����ծ���������
	int PaymentRate = 0,FinalPayment = 0;
	double PaycostTotal = 0.0;//Ӧ�����úϼ�
	//�����������ѯ�����
	ASResultSet rs = null;
	
	//�������������ҵ����֡�����ҵ�����ա�������ˮ�š���ݺ�
	String sOldBusinessCurrency = "",sOldMaturity = "",sRelativeSerialNo = "",dOldSerialNo = "",sSno="",ssSname="",sCreditId="",sCreditPerson="",sCity="",sAttr2="";
		

	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessContract");

	//����Ƚ���������
	String simulationSchemeCount=(String)session.getValue("SimulationSchemeCount");
	if(simulationSchemeCount==null){
		session.putValue("SimulationSchemeCount","1");
		simulationSchemeCount="1";
	}
	
	String productID =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductID")));
	CustomerID =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID")));
	//String Vendor =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Vendor")));
	//String paraStr =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("paraStr")));
	String productVersion =  "V1.0";
	if(productID==null)productID="";
	if(CustomerID==null)CustomerID="";


	 
    //�����ŵ�
    //String sNo = CurARC.getAttribute(request.getSession().getId()+"city");
    // add by xswang 2015/06/01 CCS-713 ��ͬ�е��ŵ���תΪ�����ŵ�
    //String sNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
    String sNo = CurUser.getAttribute8();
	// end by xswang 2015/06/01

    if(sNo == null) sNo = "";
    System.out.println("-------�����ŵ�-------"+sNo);
    String sSql = "";
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
	String sTempletNo = "CarCreditInfo";//ģ�ͱ��
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//���׶�������ģ��
	doTemp.setReadOnly("DirectPrice,CarTotal,CostTotal,MonthCost,PaymentSum,PaymentTotal,BusinessSum,BusinessRate,FinalPaymentSum,MonthrePayment", true);
	doTemp.setHTMLStyle("Premiums,AllocationSum,RevenueTax,InsureSum,VehiclePrice", "onChange=\"javascript:parent.countCarTotal()\"");//�ӱ���+�����������ý��+��������˰+���շ�+�����ۼ�=�����ܼ�
	doTemp.setHTMLStyle("AssureService,Premium,ProcedureFee","onChange=\"javascript:parent.countCostTotal()\"");
	doTemp.setHTMLStyle("CreditMonth","onChange=\"javascript:parent.countMonthCost()\"");
	doTemp.setHTMLStyle("PaymentRate","onChange=\"javascript:parent.countPayment()\"");
	doTemp.setHTMLStyle("FinalPayment","onChange=\"javascript:parent.FinalPaymentSum()\"");
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
		{"false","","Button","���ò�ѯ����","���ԭ�в�ѯ����","reset()",sResourcesPath},
		{"false","","Button","���ɻ���ƻ�","����ƻ��鿴","",sResourcesPath}
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
	function selectOpponentName()
	{
		var sSerialNo = "<%=sServiceprovidersID%>";//�����̱��
		var sEntInfoValue2=setObjectValue("SelectDistributorLoadInfo0","SerialNo,"+sSerialNo,"@productName@1",0,0,"");
		if(typeof(sEntInfoValue2)=="undefined" || sEntInfoValue2=="" || sEntInfoValue2=="_CANCEL_" ) return;
		if(sEntInfoValue2=="_CLEAR_"){
			setItemValue(0,0,"ProductID","");
	    	setItemValue(0,0,"ProductVersion",""); 
	    	setItemValue(0,0,"ProductName","");
	    	setItemValue(0,0,"CreditApr","");
	    	setItemValue(0,0,"MonthrePayment","");
		}else{
	    	sEntInfoValue2=sEntInfoValue2.split('@');
	    	sProductID=sEntInfoValue2[0];        //�����̹����Ĳ�Ʒ����
	    	sProductName=sEntInfoValue2[1];      //��Ʒ����
	    	sFloatingManner=sEntInfoValue2[2];   //������ʽ
	    	sInterestRate=sEntInfoValue2[3];     //��������
	    	sFloatingRange=sEntInfoValue2[4];    //��������
	    	setItemValue(0,0,"ProductID",sProductID);
	    	setItemValue(0,0,"ProductVersion","V1.0"); 
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
		setItemValue(0,0,"CreditType","01");
		//����������
		setItemValue(0,0,"DealerName","<%=sServiceprovidersname%>");
		//����
		setItemValue(0,0,"Vendor","<%=sCarfactory%>");

		
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			//���ô�������
			bIsInsert = true;
		}
		setItemValue(0,0,"CreditType","01");
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
	
	//���㳵���ܼ�
	function countCarTotal(){
		var DirectPrice = getItemValue(0,0,"DirectPrice");
		var Premiums = getItemValue(0,0,"Premiums");
		var AllocationSum = getItemValue(0,0,"AllocationSum");
		var RevenueTax = getItemValue(0,0,"RevenueTax");
		var InsureSum = getItemValue(0,0,"InsureSum");
		var VehiclePrice = getItemValue(0,0,"VehiclePrice");
		if(DirectPrice==null||DirectPrice=="") DirectPrice=0;
		if(Premiums==null||Premiums=="") Premiums=0;
		if(AllocationSum==null||AllocationSum=="") AllocationSum=0;
		if(RevenueTax==null||RevenueTax=="") RevenueTax=0;
		if(InsureSum==null||InsureSum=="") InsureSum=0;
		if(VehiclePrice==null||VehiclePrice=="") VehiclePrice=0;
		if(DirectPrice<VehiclePrice){
			alert("�����ۼ۲��ó����г�ָ���ۣ�");
			return;
		}
		//���㳵���ܼ�
		var sPara = "attribute1="+Premiums+",attribute2="+AllocationSum+",attribute3="+RevenueTax+",attribute4="+InsureSum+",attribute5="+VehiclePrice;
		var CarTotal = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","countCarTotal",sPara);
		if(CarTotal=="Null"||CarTotal=="null"||CarTotal==""){
			setItemValue(0,0,"CarTotal","");
		}else{
			setItemValue(0,0,"CarTotal",CarTotal);
		}
		
	}
	
	//��������ܼ�
	function countCostTotal(){
		var AssureService = getItemValue(0,0,"AssureService");
    	var Premium = getItemValue(0,0,"Premium");
    	var ProcedureFee = getItemValue(0,0,"ProcedureFee");
    	if(AssureService==null||AssureService=="") AssureService=0;
    	if(Premium==null||Premium=="") Premium=0;
    	if(ProcedureFee==null||ProcedureFee=="") ProcedureFee=0;
    	//��������ܼ�
		var sPara = "attribute1="+AssureService+",attribute2="+Premium+",attribute3="+ProcedureFee+",attribute4=0,attribute5=0";
		var CostTotal = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","countCarTotal",sPara);
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
	
	//�����׸����׸��ϼơ����������������
	function countPayment(){
		var PaymentRate = getItemValue(0,0,"PaymentRate");
		if(typeof(PaymentRate)=="undefined"||PaymentRate==""){
			return;
		}
		var CarTotal = getItemValue(0,0,"CarTotal");
		if(typeof(CarTotal)=="undefined"||CarTotal==""){
			return;
		}
		var sPara = "attribute1="+PaymentRate+",attribute2="+CarTotal;
		var sReturnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","countPayment",sPara);
		if(typeof(PaymentRate)=="undefined"||PaymentRate==""){
			return;
		} else{
			var PaymentSum = sReturnValues.split("@")[0];
			var BusinessRate = sReturnValues.split("@")[1];
	    	var BusinessSum = sReturnValues.split("@")[2]; 
	    	setItemValue(0,0,"PaymentSum",PaymentSum);
	    	setItemValue(0,0,"PaymentTotal",PaymentSum);
	    	setItemValue(0,0,"BusinessRate",BusinessRate);
	    	setItemValue(0,0,"BusinessSum",BusinessSum);
	    	FinalPaymentSum();
		}  	
	}
	
	//����β����
	function FinalPaymentSum(){
		var BusinessSum = getItemValue(0,0,"BusinessSum");
		if(typeof(BusinessSum)=="undefined"||BusinessSum==""){
			return;
		}
		var FinalPayment = getItemValue(0,0,"FinalPayment");
		if(typeof(FinalPayment)=="undefined"||FinalPayment==""){
			return;
		}
		var sPara = "attribute1="+BusinessSum+",attribute2="+FinalPayment;
		var sReturnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","FinalPaymentSum",sPara);
		if(typeof(sReturnValues)=="undefined"||sReturnValues==""){
			return;
		}else{
			setItemValue(0,0,"FinalPaymentSum",sReturnValues);
		}
	}
	
	//���ڲ�Ʒ���ʱ����ճ���
	function cleanCarModel(){
		setItemValue(0,0,"CarModel","");
		setItemValue(0,0,"DirectPrice","");
		countCarTotal();		
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
		var FinalPayment = getItemValue(0,0,"FinalPayment");
		var FinalPaymentSum = getItemValue(0,0,"FinalPaymentSum");
		var BuinsessSum = getItemValue(0,0,"BusinessSum");
		var CreditApr = getItemValue(0,0,"CreditApr");
		if(typeof(FinalPayment) == "undefined" || FinalPayment == "") FinalPayment = 0;
		if(typeof(FinalPaymentSum) == "undefined" || FinalPaymentSum == "") FinalPaymentSum = 0;
		if(typeof(BuinsessSum) == "undefined" || BuinsessSum == "") BuinsessSum = 0;
		if(typeof(CreditApr) == "undefined" || CreditApr == "") CreditApr = 0;
		
		var sPara ="typeNo="+sTypeNo+",term="+sTerm+",rate="+CreditApr+",financeAmount="+BuinsessSum+",finalPayment="+FinalPayment+",finalPaymentSum="+FinalPaymentSum;
		//��ȡ��Ʒ�����ġ��¹����㷽ʽ����������ÿ�»�����
		var sReurnValues = RunJavaMethodSqlca("com.amarsoft.proj.action.GetMonthPayment","getMonthPayment",sPara);
		if(typeof(sReurnValues)=="undefined"||sReurnValues=="") return;
		setItemValue(0,0,"MonthrePayment",sReurnValues);
	}
	
	function PMT (ir, np, pv, fv ) {
		 /*
		 ir - interest rate per month
		 np - number of periods (months)
		 pv - present value
		 fv - future value (residual value)
		 type - 0 or 1 need to implement that
		 */
		 pmt = ( ir * ( pv * Math.pow ( (ir+1), np ) + fv ) ) / ( ( ir + 1 ) * ( Math.pow ( (ir+1), np) -1 ) );
		 return pmt;
		}
	
	/* �¹����㺯��
	 [in]princ : �ܼ�
	 [in]dp:  �׸��ٷֱ� (�� : 20% -> dp=20 )
	 [in]term: �������� (�� : 5�� -> term=5*12)
	 [out]pmt: �¹���� */
	 
	 function PMT(princ,dp,term)
	 {
	     princ = price*(1-dp/100);
	     intRate = ir/100/ 12;
	     months = term * 12;
	     pmt = Math.floor((princ*intRate)/(1-Math.pow(1+intRate,(-1*months)))*100)/100;
	     return pmt;
	 }
	
	//���¶�Ӧ��ֵ
	function beforeSave(){
		var ProductID = getItemValue(0,0,"ProductID");
    	var CustomerID = getItemValue(0,0,"CustomerID");
    	var DealerName = getItemValue(0,0,"DealerName");
    	var Vendor = getItemValue(0,0,"Vendor");
		var ProductName = getItemValue(0,0,"ProductName");
    	var CreditMonth = getItemValue(0,0,"CreditMonth");
    	var CarModel = getItemValue(0,0,"CarModel");
    	var CarStatus = getItemValue(0,0,"CarStatus");
		var DirectPrice = getItemValue(0,0,"DirectPrice");
    	var Premiums = getItemValue(0,0,"Premiums");
    	var Maturity = getItemValue(0,0,"Maturity");
    	var AllocationSum = getItemValue(0,0,"AllocationSum");
		var RevenueTax = getItemValue(0,0,"RevenueTax");
    	var PutoutDate = getItemValue(0,0,"PutoutDate");
    	var InsureSum = getItemValue(0,0,"InsureSum");
    	var VehiclePrice = getItemValue(0,0,"VehiclePrice");
		var CarTotal = getItemValue(0,0,"CarTotal");
    	var AssureService = getItemValue(0,0,"AssureService");
    	var Premium = getItemValue(0,0,"Premium");
    	var ProcedureFee = getItemValue(0,0,"ProcedureFee");
		var CostTotal = getItemValue(0,0,"CostTotal");
    	var MonthCost = getItemValue(0,0,"MonthCost");
    	var PaymentSum = getItemValue(0,0,"PaymentSum");
    	var PaymentRate = getItemValue(0,0,"PaymentRate");
		var PaymentTotal = getItemValue(0,0,"PaymentTotal");
    	var BusinessSum = getItemValue(0,0,"BusinessSum");
    	var BusinessRate = getItemValue(0,0,"BusinessRate");
    	var CreditType = getItemValue(0,0,"CreditType");
    	var FinalPaymentSum = getItemValue(0,0,"FinalPaymentSum");
		var FinalPayment = getItemValue(0,0,"FinalPayment");
    	var MonthrePayment = getItemValue(0,0,"MonthrePayment");
    	var PrinciPal = getItemValue(0,0,"PrinciPal");
    	var Interest = getItemValue(0,0,"Interest");
		var FinalInterest = getItemValue(0,0,"FinalInterest");
    	var PaycostTotal = getItemValue(0,0,"PaycostTotal");
    	var RepaymentDate = getItemValue(0,0,"RepaymentDate");
    	
    	/* +"&RevenueTax="+RevenueTax+"&PutoutDate="+PutoutDate+"&InsureSum="+InsureSum+"&"
		+"VehiclePrice="+VehiclePrice+"&CarTotal="+CarTotal+"&AssureService="+AssureService+"&Premium="+Premium+"&ProcedureFee="+ProcedureFee+"&CostTotal="+CostTotal+"&MonthCost="+MonthCost+"&PaymentSum="+PaymentSum+"&"
		+"PaymentRate="+PaymentRate+"&PaymentTotal="+PaymentTotal+"&BusinessSum="+BusinessSum+"&FinalPaymentSum="+FinalPaymentSum+"&FinalPayment="+FinalPayment+"&MonthrePayment="+MonthrePayment+"&PrinciPal="+PrinciPal+"&Interest="+Interest+"&"
		+"FinalInterest="+FinalInterest+"&PaycostTotal="+PaycostTotal+"&RepaymentDate="+RepaymentDate;
		 
    	*/
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
<%=DWExtendedFunctions.setDataWindowValues(simulationObject,simulationObject, dwTemp,Sqlca) %>
	AsOne.AsInit();
	bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
