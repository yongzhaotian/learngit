<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%@ page import="com.amarsoft.app.accounting.web.*"%>
<%@ page import="com.amarsoft.app.accounting.product.*"%>
<%@ page import="com.amarsoft.app.accounting.businessobject.*"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  	--ygwang	2010.03
		Tester:
		Content: �����Ҫ��Ϣ
		Input Param:
			productID�� ��Ʒ���
			productVersion����Ʒ�汾
		Output param:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	
	BusinessObject simulationObject = (BusinessObject)session.getAttribute("SimulationObject_Loan");
	if(simulationObject==null) simulationObject = (BusinessObject)session.getAttribute("SimulationObject_BusinessPutOut");

	//����Ƚ���������
	String simulationSchemeCount=(String)session.getValue("SimulationSchemeCount");
	if(simulationSchemeCount==null){
		session.putValue("SimulationSchemeCount","1");
		simulationSchemeCount="1";
	}
	
	String productID =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductID")));
	String productVersion =  DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductVersion")));
	if(productID==null)productID="";
	if(productVersion==null)productVersion="";
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����
	ProductManage productManage = new ProductManage(Sqlca);
	if(productID!=null&&productID.length()>0&&(productVersion==null||productVersion.length()==0)){
		productVersion=ProductConfig.getProductNewestVersionID(productID);
	}
	
	if((!productID.equals(simulationObject.getString("BusinessType"))||!productVersion.equals(simulationObject.getString("ProductVersion")))
			&&productID!=null&&productID.length()>0){
		simulationObject.setAttributeValue("BusinessType",productID);
		simulationObject.setAttributeValue("ProductID",productID);
		simulationObject.setAttributeValue("ProductVersion",productVersion);
		simulationObject.setAttributeValue("ProductName",ProductConfig.getProductName(productID));
		simulationObject.setAttributeValue("BusinessTypeName",ProductConfig.getProductName(productID));
		productManage.createTermObject(simulationObject);
	}
	if(productID==null||productID.length()==0){
		productID=simulationObject.getString("BusinessType");
		productVersion = simulationObject.getString("ProductVersion");
	}
	if(productID!=null&&productID.length()>0){
		productManage.initBusinessObject(simulationObject);
	}
	String rightType="";
	if(simulationObject!=null&&BUSINESSOBJECT_CONSTATNTS.loan.equals(simulationObject.getObjectType()))
		rightType="ReadOnly";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String displayTempletFilter="BusinessPutout";
	if(simulationObject!=null){
		if(BUSINESSOBJECT_CONSTATNTS.loan.equals(simulationObject.getObjectType()))
			displayTempletFilter="Loan";
	}
	String displayTemplet = "LoanSimulationBasicInfo";
	ASDataObject doTemp = new ASDataObject(displayTemplet,"(colAttribute is null or colAttribute like '%"+displayTempletFilter+"%')",Sqlca);
	//����DataWindow����
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="2";
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	if(rightType!=null&&rightType.equals("ReadOnly")){
		dwTemp.ReadOnly = "1";
	}
	else dwTemp.ReadOnly = "0";
	
	//����datawindow����
	ASValuePool valuePool=new ASValuePool();
	valuePool.setAttribute("ProductID", productID);
	valuePool.setAttribute("ProductVersion", productVersion);
	DWExtendedFunctions.exinitASDataObject(dwTemp, CurPage, valuePool, Sqlca,CurUser);
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
			{"true","","Button","����","�����¼","saveBusinessObjectToSession(\'"+simulationObject.getObjectType()+"\')",sResourcesPath},
	};
	if(rightType!=null&&rightType.equals("ReadOnly")){
		sButtons[0][0]="false";
	}
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	// ѡ��ҵ��Ʒ��
	function selectBusinessType(){
		var sReturn = setObjectValue("SelectLoanType","","@BusinessType@0@BusinessTypeName@1",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" ) return;
		var productID = sReturn.split("@")[0];

		OpenComp("LoanTitleInfo","/Accounting/LoanSimulation/LoanBasicInfo.jsp","ProductID="+productID+"&ProductVersion=","_self");
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
		}
    }
	
	function afterLoad()
	{
		calcLoanRateTermID("LoanSimulation");
		calcRPTTermID("LoanSimulation");
		viewTermList("LoanSimulation","FIN","FINPart");
		viewTermList("LoanSimulation","SPT","SPTPart");
		viewTermList("LoanSimulation","FEE","FEEPart");
	}
	function checkSave(){
		var businessType= getItemValue(0,getRow(),"BusinessType");
		var currency= getItemValue(0,getRow(),"BusinessCurrency");
		var putOutDate= getItemValue(0,getRow(),"PutOutDate");
		var maturityDate= getItemValue(0,getRow(),"Maturity");
		var businessSum= getItemValue(0,getRow(),"BusinessSum");
		var repriceType= getItemValue(0,getRow(),"RepriceType");
		var loanRateTermID= getItemValue(0,getRow(),"LoanRateTermID");
		var rptTermID= getItemValue(0,getRow(),"RPTTermID");
		var termMonth= getItemValue(0,getRow(),"TermMonth");
		//��ֵ��������
		parent.putOutDate=putOutDate;
		if(typeof(businessType) == "undefined"||businessType==null||businessType.length==0){
			alert("ҵ��Ʒ�ֱ���!");
			return 1;
		}
		if(typeof(currency) == "undefined"||currency==null||currency.length==0){
			alert("���ֱ���!");
			return 1;
		}		
		if(typeof(putOutDate) == "undefined"||putOutDate==null||putOutDate.length==0){
			alert("�ſ��ձ���!");
			return 1;
		}
		if(typeof(businessSum) == "undefined"||businessSum==null||businessSum<=0){
			alert("�ſ������!");
			return 1;
		}
		if(typeof(maturityDate) == "undefined"||maturityDate==null||maturityDate.length==0){
			alert("�����ձ���!");
			return 1;
		}		
		if(typeof(loanRateTermID) == "undefined"||loanRateTermID==null||loanRateTermID.length==0){
			alert("�������ͱ���!");
			return 1;
		}
		if(typeof(rptTermID) == "undefined"||rptTermID==null||rptTermID.length==0){
			alert("���ʽ��ʽ����!");
			return 1;
		}
		if(typeof(termMonth) == "undefined"||rptTermID==null||rptTermID.length==0){
			alert("���ʽ��ʽ����!");
			return 1;
		}
	}
	
</script>
<%/*~END~*/%>

<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/LoanSimulation/js/basicinfo.js"> </script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/js/loan/common.js"> </script>
<script type="text/javascript" src="<%=sWebRootPath%>/Accounting/LoanSimulation/js/businessobject.js"> </script>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>
	<%=DWExtendedFunctions.setDataWindowValues(simulationObject,simulationObject, dwTemp,Sqlca) %>
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	bCheckBeforeUnload=false;
	my_load(2,0,'myiframe0');
	afterLoad();
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>