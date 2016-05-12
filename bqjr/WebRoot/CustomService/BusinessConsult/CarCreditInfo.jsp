<%@page import="com.amarsoft.app.accounting.util.FeeFunctions"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ page import="com.amarsoft.app.accounting.product.*"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.*"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "汽车贷款"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessContract");

	//贷款比较所需条件
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
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数
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
		productManage.createTermObject(RPTtermID, simulationObject);//还款方式
		productManage.createTermObject(RATtermID, simulationObject);
		List<BusinessObject> DBFWFee=productManage.createTermObject("N300", simulationObject);//担保服务费
		for(BusinessObject BusinessObject1:DBFWFee){
			BusinessObject1.setAttributeValue("AMOUNT", "555");
			
		}
		List<BusinessObject> CFee=productManage.createTermObject("C300", simulationObject);//印花税
		for(BusinessObject BusinessObject_C300:CFee){
			BusinessObject_C300.setAttributeValue("AMOUNT", "300");
			
		}
		List<BusinessObject> YBFee=productManage.createTermObject("YB100", simulationObject);//延保费
		for(BusinessObject BusinessObject_C300:YBFee){
			BusinessObject_C300.setAttributeValue("AMOUNT", "111");
			
		} 
		List<BusinessObject> QTFee=productManage.createTermObject("QT100", simulationObject);//其他费
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
		bom.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, depositAccount);//插入
		
	
	}
	
		
	
%>
<%/*~END~*/%>

	<%
	//获得页面参数	：
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));

	if(sSerialNo==null) sSerialNo="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CarCreditInfo";//模型编号
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);//交易定义详情模板
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
		{"true","","Button","保存","保存记录","saveBusinessObjectToSession(\'"+simulationObject.getObjectType()+"\')",sResourcesPath},
		{"false","","Button","返回","返回","goBack()",sResourcesPath},
		{"true","","Button","贷款咨询","贷款咨询","",sResourcesPath}
	};
	sButtons[2][5]="runTransaction2('0020','"+simulationObject.getObjectType()+"','"+simulationObject.getObjectNo()+"','"+simulationObject.getString("PutoutDate")+"')";
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------定义按钮事件------------------------------------
	function selectOpponentName()
	{
		sBusinessType = getItemValue(0,0,"BusinessType");
		if(typeof(sBusinessType) == "undefined" || sBusinessType == "")
		{
			alert("请先选择产品类型!");
			return;
		}

		sParaString = "BusinessType"+","+sBusinessType;
		//设置返回参数 
		//setObjectValue("SelectBusinessInfo",sParaString,"@ProductId@0@ProductName@1",0,0,"");
		
		var sEntInfoValue2=setObjectValue("SelectDistributorLoadInfo0","","@productName@1",0,0,"");
    	sEntInfoValue2=sEntInfoValue2.split('@');
    	sProductID=sEntInfoValue2[0];        //经销商关联的产品代码
    	sProductName=sEntInfoValue2[1];      //产品名称
    	sFloatingManner=sEntInfoValue2[2];   //浮动方式
    	sInterestRate=sEntInfoValue2[3];     //利率类型
    	sFloatingRange=sEntInfoValue2[4];    //浮动幅度
    	var productID = getItemValue(0,0,"ProductID");
    	var CustomerID = getItemValue(0,0,"CustomerID");
    	var DealerName = getItemValue(0,0,"DealerName");
    	var Vendor = getItemValue(0,0,"Vendor");
    	OpenComp("LoanTitleInfo","/CreditManage/CreditApply/CarCreditInfo.jsp","ProductID="+productID+"&CustomerID="+CustomerID+"&DealerName="+DealerName+"&Vendor="+Vendor,"_self");
    	

	}
	
	function runTransaction2(transcode,documenttype,documentno,transDate){
		var returnValue = PopPage("/Accounting/LoanSimulation/RunTransaction.jsp?TransCode="+transcode+"&DocumentType="+documenttype+"&DocumentNo="+documentno+"&TransDate="+transDate+"&ToInheritObj=y","","resizable=yes;dialogWidth=30;dialogHeight=30;dialogLeft=400;dialogTop=200;center:yes;status:no;statusbar:no");
		if(returnValue==0) alert("交易执行成功！");
		PopPage("/Accounting/LoanSimulation/PaymentScheduleList.jsp?","","");
		reloadSelf();
	}
	
	function saveRecord()
	{
		initSerialNo();
		as_save("myiframe0");
	}
	
	// 返回交易列表
	function goBack()
	{
		//OpenPage("/BusinessManage/CollectionManage/TransferDealManagerList.jsp","_self","");
	}
	
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			//设置贷款类型
			setItemValue(0,0,"CreditType","1");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "Car_Credit_Info";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
       
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	//保存
	function saveBusinessObjectToSession(businessObjectType,parentObjectType,parentObjectNo){
		if(businessObjectType=="jbo.app.BUSINESS_PUTOUT"){
			var r = checkSave();
			if(r==1){
				return;
			}
		}	
		var colCount = DZ[0][1].length;//列数
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
		//空行不保存，再次刷新后无空行出现
		var returnValue = PopPage("/Accounting/LoanSimulation/BusinessObjectAction.jsp?"+paraStr,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
		if(returnValue=="true"){
			alert("保存成功！");
			if(businessObjectType=="jbo.app.BUSINESS_PUTOUT"){
				parent.tt();
			}		
			reloadSelf();
		}
		else alert("保存失败！");
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
