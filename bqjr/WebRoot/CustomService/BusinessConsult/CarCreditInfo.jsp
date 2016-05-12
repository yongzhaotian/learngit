<%@page import="com.amarsoft.app.accounting.util.FeeFunctions"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ page import="com.amarsoft.app.accounting.product.*"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.*"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	
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
	String DealerName =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DealerName")));
	String Vendor =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Vendor")));
	String productVersion =  "V1.0";
	if(productID==null)productID="";
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����
	ProductManage productManage = new ProductManage(Sqlca);
	
	if(!productID.equals(simulationObject.getString("ProductID"))&&productID!=null&&productID.length()>0){
		simulationObject.setAttributeValue("BusinessType",productID);
		simulationObject.setAttributeValue("CustomerID",CustomerID);
		simulationObject.setAttributeValue("ProductID",productID);
		simulationObject.setAttributeValue("BusinessCurrency","01");
		simulationObject.setAttributeValue("BusinessSum","10000.00");
		simulationObject.setAttributeValue("ProductVersion",productVersion);
		simulationObject.setAttributeValue("ProductName",ProductConfig.getProductName(productID));
		simulationObject.setAttributeValue("BusinessTypeName",ProductConfig.getProductName(productID));
		productManage.createTermObject(simulationObject);
	}
	if(productID==null||productID.length()==0){
		productID=simulationObject.getString("BusinessType");
		//productVersion = simulationObject.getString("ProductVersion");
	}
	if(productID!=null&&productID.length()>0){
		productManage.initBusinessObject(simulationObject);
	}
	String rightType="";
	if(simulationObject!=null&&BUSINESSOBJECT_CONSTATNTS.loan.equals(simulationObject.getObjectType()))
		rightType="ReadOnly";
	
	String objectType = "jbo.app.BUSINESS_CONTRACT";
	String objectNo = simulationObject.getObjectNo();
	if(productID != null && productID.length()>0){
		
		//AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		String RPTtermID="RPT17";
		String RATtermID="RAT001";
		productManage.createTermObject(RPTtermID, simulationObject);//���ʽ
		productManage.createTermObject(RATtermID, simulationObject);
		List<BusinessObject> DBFWFee=productManage.createTermObject("N300", simulationObject);//���������
		for(BusinessObject BusinessObject1:DBFWFee){
			BusinessObject1.setAttributeValue("AMOUNT", "555");
			
		}
		List<BusinessObject> CFee=productManage.createTermObject("C300", simulationObject);//ӡ��˰
		for(BusinessObject BusinessObject_C300:CFee){
			BusinessObject_C300.setAttributeValue("AMOUNT", "300");
			
		}
		List<BusinessObject> YBFee=productManage.createTermObject("YB100", simulationObject);//�ӱ���
		for(BusinessObject BusinessObject_C300:YBFee){
			BusinessObject_C300.setAttributeValue("AMOUNT", "111");
			
		} 
		List<BusinessObject> QTFee=productManage.createTermObject("QT100", simulationObject);//������
		for(BusinessObject BusinessObject_QTFee:QTFee){
			BusinessObject_QTFee.setAttributeValue("AMOUNT", "100");
		} 
		
		AbstractBusinessObjectManager bom=new DefaultBusinessObjectManager(Sqlca);
		
		BusinessObject depositAccount =new BusinessObject(BUSINESSOBJECT_CONSTATNTS.loan_accounts,bom);
		depositAccount.setAttributeValue("objectno", simulationObject.getObjectNo());
		depositAccount.setAttributeValue("ObjectType", simulationObject.getObjectType());
		depositAccount.setAttributeValue("accounttype", "01");
		depositAccount.setAttributeValue("accountno", "987654321");
		depositAccount.setAttributeValue("accountcurrency", "01");
		depositAccount.setAttributeValue("accountname", "dkzx");
		depositAccount.setAttributeValue("accountflag", "1");
		depositAccount.setAttributeValue("PRI", "1");
		depositAccount.setAttributeValue("status", "0");
		bom.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, depositAccount);//����
		
	
	}
	
		
	
%>
<%/*~END~*/%>

	<%
	//���ҳ�����	��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));

	if(sSerialNo==null) sSerialNo="";
	
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CarCreditInfo";//ģ�ͱ��
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//���׶�������ģ��
	

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
		{"true","","Button","������ѯ","������ѯ","",sResourcesPath}
	};
	sButtons[2][5]="runTransaction2('0020','"+simulationObject.getObjectType()+"','"+simulationObject.getObjectNo()+"','"+simulationObject.getString("PutoutDate")+"')";
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------���尴ť�¼�------------------------------------
	function selectOpponentName()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");
		if(typeof(sBusinessType) == "undefined" || sBusinessType == "")
		{
			alert("����ѡ���Ʒ����!");
			return;
		}

		sParaString = "BusinessType"+","+sBusinessType;
		//���÷��ز��� 
		//setObjectValue("SelectBusinessInfo",sParaString,"@ProductId@0@ProductName@1",0,0,"");
		
		var sEntInfoValue2=setObjectValue("SelectDistributorLoadInfo0","","@productName@1",0,0,"");
    	sEntInfoValue2=sEntInfoValue2.split('@');
    	sProductID=sEntInfoValue2[0];        //�����̹����Ĳ�Ʒ����
    	sProductName=sEntInfoValue2[1];      //��Ʒ����
    	sFloatingManner=sEntInfoValue2[2];   //������ʽ
    	sInterestRate=sEntInfoValue2[3];     //��������
    	sFloatingRange=sEntInfoValue2[4];    //��������
    	var productID = getItemValue(0,0,"ProductID");
    	var CustomerID = getItemValue(0,0,"CustomerID");
    	var DealerName = getItemValue(0,0,"DealerName");
    	var Vendor = getItemValue(0,0,"Vendor");
    	OpenComp("LoanTitleInfo","/CreditManage/CreditApply/CarCreditInfo.jsp","ProductID="+productID+"&CustomerID="+CustomerID+"&DealerName="+DealerName+"&Vendor="+Vendor,"_self");
    	

	}
	
	function runTransaction2(transcode,documenttype,documentno,transDate){
		var returnValue = PopPage("/Accounting/LoanSimulation/RunTransaction.jsp?TransCode="+transcode+"&DocumentType="+documenttype+"&DocumentNo="+documentno+"&TransDate="+transDate+"&ToInheritObj=y","","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("����ִ�гɹ���");
		PopPage("/Accounting/LoanSimulation/PaymentScheduleList.jsp?","","");
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
	
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			//���ô�������
			setItemValue(0,0,"CreditType","1");
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

	//����
	function saveBusinessObjectToSession(businessObjectType,parentObjectType,parentObjectNo){
		if(businessObjectType=="jbo.app.BUSINESS_PUTOUT"){
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
		paraStr+="&BusinessObjectType="+businessObjectType+"&ColNames="+colnames;
		//���в����棬�ٴ�ˢ�º��޿��г���
		var returnValue = PopPage("/Accounting/LoanSimulation/BusinessObjectAction.jsp?"+paraStr,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
		if(returnValue=="true"){
			alert("����ɹ���");
			if(businessObjectType=="jbo.app.BUSINESS_PUTOUT"){
				parent.tt();
			}		
			reloadSelf();
		}
		else alert("����ʧ�ܣ�");
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
