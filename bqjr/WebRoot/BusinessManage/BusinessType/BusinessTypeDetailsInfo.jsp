<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: lwang 20140220 
		Tester:
		Describe:��Ʒ�Ļ�����Ϣ
		Input Param:
			SerialNo:
		Output Param:

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ʒ�Ļ�����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	
	//���ҳ�����
	String sTypeNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("typeNo"));	
	String sTemp    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("temp"));	
	//��Ʒ����
	String sProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));
	String sSubProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubProductType"));
	if(null == sProductType) sProductType = "";
	String sSerialNo = sTypeNo;
	if(sTemp==null) sTemp="";
	if(null == sSubProductType) sSubProductType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo =null;
	sTempletNo = "BusinessTypeDetailsInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sTemp.equals("1")){
        doTemp.setReadOnly("", true);
	}
	
	//add �ֽ������
	doTemp.setReadOnly("productType",true);
	if("020".equals(sProductType)){ 
		doTemp.setVisible("productCategoryID,shoufuRatioType,shoufuRatio",false);
		doTemp.setVisible("MONTHADDSERVICERATE",true);
		doTemp.setRequired("productCategoryID,shoufuRatioType,shoufuRatio",false);
		doTemp.setVisible("Attribute4",true);//�ⶥ����
		doTemp.setRequired("Attribute4",true);
		
	}
	//���ݲ�Ʒ���Ͳ�ͬѡ��ͬ�Ĳ�Ʒ������
	if(sProductType.equals("020")){//�ֽ��
		doTemp.setDDDWSql("SubProductType", "select itemno , itemname from code_library where codeno='SubProductType' and itemno in ('1','2','3')");
	}else if( sProductType.equals("030") && "".equals(sSubProductType) ){//���Ѵ�
		doTemp.setDDDWSql("SubProductType", "select itemno , itemname from code_library where codeno='SubProductType' and itemno in ('0','4','5')");
	}else if( sProductType.equals("030") && "7".equals(sSubProductType) ){//ѧ�����Ѵ�
		doTemp.setReadOnly("SubProductType", true);
		doTemp.setDDDWSql("SubProductType", "select itemno , itemname from code_library where codeno='SubProductType' and itemno = '7' ");
	}
	doTemp.setHTMLStyle("SalesFormula", "onChange=\"javascript:parent.selectSalesFormula()\";style={background=\"#EEEEff\"}");
	doTemp.setCheckFormat("monthlyInterestRate,EFFECTIVEANNUALRATE,baseRate,CUSTOMERSERVICERATES,MANAGEMENTFEESRATE", "13");
	doTemp.setCheckFormat("lowPrincipal,tallPrincipal,shoufuRatio", "5");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	doTemp.setLimit("EFFECTIVEANNUALRATE",6);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
		{"true","","Button","����","����","saveRecord()",sResourcesPath},
	};
	if(sTemp.equals("1")){
		sButtons[0][3]="����";
		sButtons[0][4]="����";
		sButtons[0][5]="back()";
	}
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		selectRateFormula();
		var sTypeNo  = getItemValue(0,getRow(),"TypeNo");
		var sUnique = RunMethod("Unique","uniques","business_type,count(1),typeNo='"+sTypeNo+"'");
		if(bIsInsert && sUnique=="1.0"){
			alert("�ò�Ʒ����Ѿ���ռ��,�������µı��");
			return;
		}
		updateTerm();//�����������
		bIsInsert = false;
	    as_save("myiframe0");
	    selectSalesFormula();
	    selectShoufuType();
	}
	
	/*~[Describe=������ѡ��ѡ����Ʒ����;InputParam=��;OutPutParam=��;]~*/
	function selectProductCategoryMulti() {
		var sRetVal = setObjectValue("SelectProductCategoryMulti", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("��ѡ����Ʒ���룡");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		var sCTypeIds = "";
		var SCTypeNames = "";
		for (var i=0;i<sTypeArry.length;i=i+2) {
			sCTypeIds += sTypeArry[i] + ",";
			SCTypeNames += sTypeArry[i+1] + ",";
		}
		setItemValue(0, 0, "productCategory", sCTypeIds.substring(0, sCTypeIds.length-1));  //��Ʒ����ID
		setItemValue(0, 0, "productCategoryID", SCTypeNames.substring(0, SCTypeNames.length-1));//��Ʒ��������
		return;
	}
	
   function checkTypeNo(sTypeNo){
    	var sTypeNo =getItemValue(0,getRow(),"TypeNo");
    	 var strExp=/^[A-Za-z0-9]+$/;
		 if(strExp.test(sTypeNo)){
		    return true;
		}else{
			alert("��Ʒ������������ֻ���ĸ��");
		    return false;
		}
    }
	
	//�����������
	function updateTerm(){
		var sterm  = getItemValue(0,getRow(),"term");
		var sTypeNo  = getItemValue(0,getRow(),"TypeNo");
		var sObjectNo = sTypeNo+"-V1.0";//������Ʒ������
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT17");//�ȶϢ
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RAT002");//�̶�����
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N100");//�˻������
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N200");//�ͻ������
		
		//����
		var baseRate = getItemValue(0,getRow(),"baseRate");//��Ʒִ��������Ĭ��%
		var ratereturn = RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+baseRate+",PRODUCT_TERM_PARA,String@paraid@ExecuteRate@String@termid@RAT002@String@ObjectNo@"+sObjectNo);//��Ʒ������
		
		//����Ӷ�����
		var sSalesFormula = getItemValue(0,getRow(),"SalesFormula");//Ӷ����㷽ʽ
		if(sSalesFormula=="01"){//������
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,YJ100");//Ӷ��
			var SALESCOMMISSION = getItemValue(0,getRow(),"SALESCOMMISSION");//���� % 
			if(typeof(SALESCOMMISSION)=="undefined" || SALESCOMMISSION.length==0 || SALESCOMMISSION=="_CANCEL_" ) {
				alert("��������ɱ�����");
				return;
			}
			//���㷽ʽ
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@02,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@YJ100@String@ObjectNo@"+sObjectNo);//���㷽ʽ(������*����)
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+SALESCOMMISSION+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@YJ100@String@ObjectNo@"+sObjectNo);//Ӷ�����
		}else if(sSalesFormula=="02"){//����� Ԫ
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,YJ100");//Ӷ��
			var TCPrice = getItemValue(0,getRow(),"TCPrice");//��� Ԫ
			if(typeof(TCPrice)=="undefined" || TCPrice.length==0 || TCPrice=="_CANCEL_" ) {
				alert("��������ɽ�");
				return;
			}
			//���㷽ʽ
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@YJ100@String@ObjectNo@"+sObjectNo);//���㷽ʽ(�̶����)
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+TCPrice+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@YJ100@String@ObjectNo@"+sObjectNo);//Ӷ����
		}
	
		//��������
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA001");//�����ཻ��
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA002");//�����ձ��
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA004");//��ǰ����
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA005");//�����ཻ��
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,PS001");//����δ�����������
		
		//���÷���
		var sManageRate = getItemValue(0,getRow(),"MANAGEMENTFEESRATE");//���˻��������
		var termsManageRate = parseFloat(sManageRate)*parseInt(sterm, 10);//ȫ���˻�����ѷ���
		var sCustomRate = getItemValue(0,getRow(),"CUSTOMERSERVICERATES");//�ͻ��������
		var termsCustomRate = parseFloat(sCustomRate)*parseInt(sterm, 10);//ȫ�̿ͻ��������
		
		if(typeof(sManageRate)=="undefined" || sManageRate=="" || sManageRate=="_CANCEL_" || typeof(sCustomRate)=="undefined" || sCustomRate=="" || sCustomRate=="_CANCEL_") {
			alert("��ȷ���˻�������ʺͲ���������ֵ����Ч������");
			
			//����Ϊ��ȥ����Ʒ����
			if(parseFloat(sManageRate)<=0.0){
				RunMethod("ProductManage","UpdateProductTerm","deleteTermFromProduct,<%=sTypeNo%>,V1.0,N100");
			}
			if(parseFloat(sCustomRate)<=0.0){
				RunMethod("ProductManage","UpdateProductTerm","deleteTermFromProduct,<%=sTypeNo%>,V1.0,N200");
			}
			return;
		}
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+termsManageRate+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N100@String@ObjectNo@"+sObjectNo);//�˻��������
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+termsCustomRate+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N200@String@ObjectNo@"+sObjectNo);//�ͻ��������
	}
	
	function back(){
		AsControl.OpenView("/BusinessManage/Products/ProductTypesDetailsInfo1.jsp","","_self");
	}
	
	/*~[Describe=��Ч������EIP;InputParam=��;OutPutParam=��;]~*/
	function selectRateFormula() {
		var rateFormula  = getItemValue(0,getRow(),"rateFormula");//���ʼ��㷽ʽ1:��Ч������ 2���¹�����
		
			setItemDisabled(0,getRow(),"EFFECTIVEANNUALRATE",false);//��Ч������EIP
			setItemDisabled(0,getRow(),"MONTHLYPROPORTION",true);//�¹�����
			
			var baseRate_  = getItemValue(0,getRow(),"baseRate");//��Ʒ��׼����
			var baseRate = parseFloat(baseRate_);
			
			if(isNaN(baseRate)){
				baseRate = 0.000;
			}
			var nMonthRate = baseRate/12;			//��Ʒ������
			var term_  = getItemValue(0,getRow(),"term");//����
			var nLoanTerm = parseInt(term_, 10);
			
			setItemValue(0, 0, "monthlyInterestRate", nMonthRate);  //��Ʒ������
			
			if(typeof(term_)=="undefined" || term_.length==0||typeof(baseRate)=="undefined" || baseRate.length==0 || baseRate=="_CANCEL_" ){
				alert("������д��׼���ʺ����ޣ�");
				return;
			}
			
			if(nMonthRate<=0.0){
				MonthRatio2 = 1/nLoanTerm;
			}else{
				//��Ʒ�����ʵó����¹�2
				var MonthRatio2 = ((nMonthRate/100)*(Math.pow((1+nMonthRate/100),nLoanTerm)))/(Math.pow((1+nMonthRate/100),nLoanTerm)-1);
			}
			
			//eip���ʵó����¹�����1
			var baseRateEIP  = getItemValue(0,getRow(),"EFFECTIVEANNUALRATE");//��Ч������EIP
			var nMonthRateEIP = parseFloat(baseRateEIP)/12;					//EIP������
			
			if(typeof(baseRateEIP)=="undefined" || baseRateEIP.length==0){
				alert("������ЧEIR�����ʣ�");
				return;
			}
			if(nMonthRateEIP<nMonthRate ){
				alert("��ЧEIR�����ʲ���С�ڻ������ʣ�");
				setItemValue(0, 0, "EFFECTIVEANNUALRATE", ""); 
				return;
			}
			
			var MonthRatio1 = ((nMonthRateEIP/100)*(Math.pow((1+nMonthRateEIP/100),nLoanTerm)))/(Math.pow((1+nMonthRateEIP/100),nLoanTerm)-1);
			var MANAGEMENTFEES  = getItemValue(0,getRow(),"MANAGEMENTFEES");//���˻������ռ��
			
			var manageMentFeeRate = (parseFloat(MonthRatio1)-parseFloat(MonthRatio2))*parseFloat(MANAGEMENTFEES);//���˻��������
			var CUSTOMERSERVICERATES = (parseFloat(MonthRatio1)-parseFloat(MonthRatio2))*(1-parseFloat(MANAGEMENTFEES)*0.01)*100;//���˿ͻ�����ѷ���
			
			if(parseFloat(MANAGEMENTFEES)=="100.0"){
				manageMentFeeRate = 0.00;
				alert("���˻������ռ��Ϊ100ʱ�²������ѷ���Ϊ0,��ȷ���Ƿ�������ã�");
			}
			if(nMonthRateEIP==nMonthRate){
				manageMentFeeRate = 0.00;
				CUSTOMERSERVICERATES = 0.00;
				alert("��ЧEIR�����ʵ��ڻ�������ʱ,�²������ѷ���,���˻�����ѷ���Ϊ0,��ȷ���Ƿ�������ã�");
			}
			if(typeof(MANAGEMENTFEES)=="undefined" || MANAGEMENTFEES.length==0){
				alert("����д���˻������ռ�ȣ�");
				return;
			}
			
			setItemValue(0, 0, "MANAGEMENTFEESRATE", manageMentFeeRate.toFixed(3));  //�»��������
			setItemValue(0, 0, "CUSTOMERSERVICERATES", CUSTOMERSERVICERATES.toFixed(3));  //���˿ͻ�����ѷ���
			
			var shoufuType = getItemValue(0, 0, "shoufuRatioType");
			var shoufu = getItemValue(0, 0, "shoufuRatio");
			if(shoufuType == "1" || shoufuType == "2"){
				if(shoufu > 100){
					alert("�׸�����(%)���ܴ���100�����飡");
					setItemValue(0, 0, "shoufuRatio", ""); 
					return;
				}
			}
		
	}
	
	function selectSalesFormula(){
		var sSalesFormula=getItemValue(0,getRow(),"SalesFormula");
		if(typeof(sSalesFormula)=="undefined" || sSalesFormula.length==0){
			hideItem(0, 0, "TCPrice");
		}
		if(sSalesFormula=="01"){
			hideItem(0, 0, "TCPrice");
			showItem(0, 0, "SALESCOMMISSION");
		}
		if(sSalesFormula=="02"){
			hideItem(0, 0, "SALESCOMMISSION");
			showItem(0, 0, "TCPrice");
		}
	}
    
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼	
			bIsInsert = true;
		}
		selectSalesFormula();
		selectShoufuType();
		setItemValue(0, 0, "inputOrgName", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"INPUTORG","<%=CurOrg.orgID %>");
		setItemValue(0,0,"INPUTUSER", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"INPUTTIME", "<%=StringFunction.getToday()%>");
		setItemValue(0, 0, "updateOrgName", "<%=CurOrg.orgName %>");
		setItemValue(0,0,"UPDATEORG","<%=CurOrg.orgID %>");
		setItemValue(0,0,"UPDATEUSER", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UPDATETIME", "<%=StringFunction.getToday()%>");
	}
	
	function selectShoufuType() {
		
		var shoufuType = getItemValue(0, 0, "shoufuRatioType");
		//setItemValue(0, 0, "shoufuRatio", "");
		if (shoufuType == 3 || shoufuType == 4) {
			setItemHeader(0, 0, "shoufuRatio", "�׸���Ԫ��");
		} else {
			setItemHeader(0, 0, "shoufuRatio", "�׸�������%��������Ʒ�۸�");
		}
	}
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
$(document).ready(function(){
	AsOne.AsInit();
	showFilterArea();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
});
	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
