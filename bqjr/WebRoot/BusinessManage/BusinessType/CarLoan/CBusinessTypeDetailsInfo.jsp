<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: lwang 20140220 
		Tester:
		Describe:��Ʒ����ҳ��
		Input Param:
			SerialNo:
		Output Param:

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ʒ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
    String sTempletNo ="";
	//���ҳ�����
	String sTypeNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("typeNo"));	
	String sCurItemID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("curItemID"));	
	if(sCurItemID==null) sCurItemID="";
    if(sTypeNo==null) sTypeNo="";
    ARE.getLog().debug("sTypeNo="+sTypeNo+"&sCurItemID="+sCurItemID);
%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	if(sCurItemID.equals("02")){
		sTempletNo = "CBusinessTypeDetailsInfo1";
	}else{
		sTempletNo = "CBusinessTypeDetailsInfo";
	}
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	if(sCurItemID.equals("02")){//��������
		doTemp.setDefaultValue("monthcalculationMethod", "01");
		doTemp.setLimit("contractConditions", 1000);//��ͬ�����������Ϊ��������500�֡�

	}else{//��������
		doTemp.setLimit("contractConditions", 2000);//��ͬ�����������Ϊ��������1000�֡�
		doTemp.setHTMLStyle("whetherDiscount","onChange=\"javascript:parent.checkDiscount()\"");
		doTemp.setUnit("dealerDiscount,ManufacturersRate", "%");
		//doTemp.setHTMLStyle("securityChargeMode", "onChange=\"javascript:parent.setFeeUnit()\"");	
	}
	doTemp.setHTMLStyle("PenaltyMode", "onChange=\"javascript:parent.selectPenaltyMode()\"");
	doTemp.setHTMLStyle("rateType", "onChange=\"javascript:parent.checkFloatingManner()\"");
	doTemp.setReadOnly("calculationType", true);
	//doTemp.setColumnEvent("whetherDiscount", "onChange", "javascript:parent.checkDiscount()");
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sTypeNo);
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
		if(vI_all("myiframe0")){
			insertTerm();
			bIsInsert = false;
			if(!checkDiscountRate())	return;
			
			as_save("myiframe0");
		   
		}
		
	}
	function checkFloatingManner(){//��鸡����ʽ
		var sRateType = getItemValue(0,0,"rateType");//��������
		var sComponentName="<%=sCurItemID%>";
		//var sFloatingManner = getItemValue(0,0,"floatingManner");//������ʽ
		if(sRateType=="1"){
			setItemRequired(0,0,"floatingManner",true);
		}	
		if(sRateType=="0"){
			setItemDisabled(0,0,"floatingManner",true);
		}
		if(sComponentName=="01"){
			if(sRateType=="2"){
				setItemRequired(0,0,"dealerLiXiTime",true);
			}
		}
		
	}
	function checkDiscount(){
		var sDiscount = getItemValue(0,0,"whetherDiscount");
		
		if("1"==sDiscount){
			setItemValue(0,0,"discountType", "0");
			setItemRequired(0,0,"discountType",true);
			setItemRequired(0,0,"dealerDiscount",true);
			setItemRequired(0,0,"ManufacturersRate",true);
		}else if("0"==sDiscount){
			setItemValue(0,0,"discountType", "");
			setItemValue(0,0,"dealerDiscount", "");
			setItemValue(0,0,"ManufacturersRate", "");
			setItemDisabled(0,0,"discountType",true);
			setItemReadOnly(0,0,"dealerDiscount",true);
			setItemReadOnly(0,0,"ManufacturersRate",true);	
		}
	}
	function checkDiscountRate(){
		var whetherDiscount = getItemValue(0,0,"whetherDiscount");
		if(whetherDiscount=="1"){
			var dealerDiscount = getItemValue(0,0,"dealerDiscount");//���������ֱ���
			if(typeof(dealerDiscount)=="undefined"||dealerDiscount==""){
				dealerDiscount = 0;
			}
			
			var ManufacturersRate = getItemValue(0,0,"ManufacturersRate");//�������ֱ���
			if(typeof(ManufacturersRate)=="undefined"||ManufacturersRate==""){
				ManufacturersRate = 0;
			}
			var sPara = "attribute1="+dealerDiscount+",attribute2="+ManufacturersRate;
			var sRateSum = RunJavaMethodSqlca("com.amarsoft.proj.action.JSgetDoubleSum","getDiscountRateSum",sPara);
			if(sRateSum=="false"||sRateSum=="Null"||sRateSum=="null"||sRateSum==""){
				alert("���������ֱ����볧�����ֱ���֮�ͱ���Ϊ100������������");
				return false;
			}else{
				return true;
			}
		}else{
			return true;
		}
		
	}
	function  setFeeUnit(){//���õ�λ
		var securityChargeMode = getItemValue(0,0,"securityChargeMode");
		if("0"==securityChargeMode){//0 ������  1 �����
			//setItemUnit(0,0,"securityServices","%");		
		alert(1);
		setItemUnit("CBusinessTypeDetailsInfo",0300,"securityServices","%");

		}
	
		/* feeWay  fee
		stampMethods   stampTax
		mepaymentChargeMode  repaymentInsurance */
	}
	function setItemUnit(dwname,rowindex,fieldName,unit){
		if(!isNaN(dwname))dwname = "myiframe" + dwname;
		var dwindex = dwname.substring(8);
		var sColIndex = getColIndexFromName(fieldName);
		var oSpanInput = document.getElementById("Unit_" + sColIndex);
		oSpanInput.innerHTML = unit;
	}

	//ѡ����ǰ�������ȡ��ʽ
	function selectPenaltyMode(){
		var sPenaltyMode  =getItemValue(0,0,"PenaltyMode");//��ǰ�������ȡ��ʽ

		if(sPenaltyMode=="0"){//������
			setItemRequired(0,0,"penaltyProportion",true);//��ǰ��������
			setItemRequired(0,0,"penaltyAmount",false);//��ǰ�������
			setItemReadOnly(0,0,"penaltyAmount",true);//��ǰ�������
		}else if(sPenaltyMode=="1"){//�����
			setItemRequired(0,0,"penaltyAmount",true);//��ǰ�������
			setItemRequired(0,0,"penaltyProportion",false);//��ǰ��������
			setItemReadOnly(0,0,"penaltyProportion",true);//��ǰ��������
		}else{
			setItemRequired(0,0,"penaltyProportion",false);//��ǰ��������
			setItemRequired(0,0,"penaltyAmount",false);//��ǰ�������
		}
	}
	
	//�����������
	function insertTerm(){
		var sObjectNo = "<%=sTypeNo%>"+"-V1.0";
		var sComponentName="<%=sCurItemID%>";
		var RPTTerm = getItemValue(0, 0, "monthcalculationMethod");//�¹����㷽ʽ
		var ratType = getItemValue(0, 0, "rateType");//��������
		var SPTTerm = getItemValue(0, 0, "discountType");//��Ϣ����
		var FINRate = getItemValue(0, 0, "principalPenaltyBasis");//��Ϣ��������
		var FINTerm = getItemValue(0, 0, "penaltyRate");//��Ϣ����
		var FINFloat = getItemValue(0, 0, "floatingRate");//��Ϣ��������/������
		var sChargeTime = getItemValue(0, 0, "chargeTime");//�����׸�ʱ��
		var securityChargeMode = getItemValue(0, 0, "securityChargeMode");//�����������ȡ��ʽ
		var securityServices = getItemValue(0, 0, "securityServices");//���������
		var feeWay = getItemValue(0, 0, "feeWay");//��������ȡ��ʽ
		var fee = getItemValue(0, 0, "fee");//������
		var mepaymentChargeMode = getItemValue(0, 0, "mepaymentChargeMode");//����շ���ȡ��ʽ
		var repaymentInsurance = getItemValue(0, 0, "repaymentInsurance");//����շ�
		var PenaltyMode = getItemValue(0, 0, "PenaltyMode");//��ǰ�������ȡ��ʽ
		var penaltyProportion = getItemValue(0, 0, "penaltyProportion");//��ǰ��������
		var penaltyAmount = getItemValue(0, 0, "penaltyAmount");//��ǰ�������
		
		//��Ϣ����
		if(typeof(SPTTerm) != "undefined" || SPTTerm != ""){
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,"+SPTTerm);
		}
		
		//��������
		var RATTerm = "";
		if(ratType=="0"){//�̶�����
			 RATTerm = "RAT002";
		}else if(ratType=="1"){//��������
			 RATTerm = "RAT001";
		}else if(ratType=="2"){//�̶����
			 RATTerm = "RAT004";
		}
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,"+RATTerm);
		if(RATTerm=="RAT001"){//����
			var sFloatType = getItemValue(0, 0, "floatingManner");//������ʽ
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+sFloatType+",PRODUCT_TERM_PARA,String@paraid@RateFloatType@String@termid@RAT001@String@ObjectNo@"+sObjectNo);//������ʽ
		}
		
		//�¹����㷽ʽ
		if(sComponentName=="02"){//��������
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,RPT18");//�ȸ��ȶϢ
		}else{//��������
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,"+RPTTerm);
		}
		
		//��Ϣ
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,FIN003");
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+FINRate+",PRODUCT_TERM_PARA,String@paraid@BaseRate@String@termid@FIN003@String@ObjectNo@"+sObjectNo);//��Ϣ��׼����
		if(FINTerm=="0"){//����������
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@0,PRODUCT_TERM_PARA,String@paraid@RateFloatType@String@termid@FIN003@String@ObjectNo@"+sObjectNo);//����������
		}else if(FINTerm=="1"){
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@1,PRODUCT_TERM_PARA,String@paraid@RateFloatType@String@termid@FIN003@String@ObjectNo@"+sObjectNo);//������������
		}
		
		/*~~~~~~~~~~~~~~~~~ ���� ~~~~~~~~~~~~*/
		//��ǰ����ΥԼ��
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,A200");
		if(PenaltyMode=="0"){//������
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@A200@String@ObjectNo@"+sObjectNo);//���㷽ʽ(�������*����)
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+penaltyProportion+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@A200@String@ObjectNo@"+sObjectNo);//�������
		}else if(PenaltyMode=="1"){//���̶����
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@A200@String@ObjectNo@"+sObjectNo);//���㷽ʽ�̶����
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+penaltyAmount+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@A200@String@ObjectNo@"+sObjectNo);//������
		}
		
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N300");//���������
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N400");//������
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,C300");//ӡ��˰
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,N500");//����շ�
		//RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,YB100");//�ӱ���
		//RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,QT100");//������
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+sChargeTime+",PRODUCT_TERM_PARA,String@paraid@FeePayDateFlag@String@termid@N300@String@ObjectNo@"+sObjectNo);//����������ո�ʱ��
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+sChargeTime+",PRODUCT_TERM_PARA,String@paraid@FeePayDateFlag@String@termid@N400@String@ObjectNo@"+sObjectNo);//�������ո�ʱ��
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+sChargeTime+",PRODUCT_TERM_PARA,String@paraid@FeePayDateFlag@String@termid@C500@String@ObjectNo@"+sObjectNo);//ӡ��˰�ո�ʱ��
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+sChargeTime+",PRODUCT_TERM_PARA,String@paraid@FeePayDateFlag@String@termid@N500@String@ObjectNo@"+sObjectNo);//����շ��ո�ʱ��

		if(securityChargeMode=="0"){//��������
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N300@String@ObjectNo@"+sObjectNo);//���㷽ʽ
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+securityServices+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N300@String@ObjectNo@"+sObjectNo);//����
		}else if(securityChargeMode=="1"){//���̶����
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N300@String@ObjectNo@"+sObjectNo);//���㷽ʽ
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+securityServices+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@N300@String@ObjectNo@"+sObjectNo);//���ý��
		}
		
		if(feeWay=="0"){//��������
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N400@String@ObjectNo@"+sObjectNo);//���㷽ʽ
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+fee+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N400@String@ObjectNo@"+sObjectNo);//����
		}else if(feeWay=="1"){//���̶����
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N400@String@ObjectNo@"+sObjectNo);//���㷽ʽ
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+fee+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@N400@String@ObjectNo@"+sObjectNo);//���ý��
		}
		
		if(mepaymentChargeMode=="0"){//��������
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N500@String@ObjectNo@"+sObjectNo);//���㷽ʽ
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+repaymentInsurance+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N400@String@ObjectNo@"+sObjectNo);//���㷽ʽ
		}else if(mepaymentChargeMode=="1"){//���̶����
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N400@String@ObjectNo@"+sObjectNo);//���㷽ʽ
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+repaymentInsurance+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@N500@String@ObjectNo@"+sObjectNo);//���㷽ʽ
		}
		
		/* ���������������ޣ�ת�������ѡ���ֵ����˰[VAT]������������ */
		if(sComponentName=="02"){
			var salvageAddedMode = getItemValue(0, 0, "salvageAddedMode");//��ֵ����˰��ȡ��ʽ
			var salvageAdded = getItemValue(0, 0, "salvageAdded");//��ֵ����˰��VAT�����/����
			var resaleFeePayDate = getItemValue(0, 0, "resaleFeePayDate");//ת����������ȡʱ��
			var resaleFeesWay = getItemValue(0, 0, "resaleFeesWay");//ת����������ȡ��ʽ
			var resaleFees = getItemValue(0, 0, "resaleFees");//ת��������
			
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,R100");//ת��������
			RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,R200");//��ֵ����˰[VAT]
			
			if(salvageAddedMode=="0"){//��������
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N500@String@ObjectNo@"+sObjectNo);//���㷽ʽ
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+salvageAdded+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N400@String@ObjectNo@"+sObjectNo);//���㷽ʽ
			}else if(salvageAddedMode=="1"){//���̶����
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N400@String@ObjectNo@"+sObjectNo);//���㷽ʽ
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+salvageAdded+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@N500@String@ObjectNo@"+sObjectNo);//���㷽ʽ
			}
			
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+resaleFeePayDate+",PRODUCT_TERM_PARA,String@paraid@FeePayDateFlag@String@termid@N500@String@ObjectNo@"+sObjectNo);//����շ��ո�ʱ��

			if(resaleFeesWay=="0"){//��������
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@03,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N500@String@ObjectNo@"+sObjectNo);//���㷽ʽ
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+resaleFees+",PRODUCT_TERM_PARA,String@paraid@FeeRate@String@termid@N400@String@ObjectNo@"+sObjectNo);//���㷽ʽ
			}else if(resaleFeesWay=="1"){//���̶����
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@01,PRODUCT_TERM_PARA,String@paraid@FeeCalType@String@termid@N400@String@ObjectNo@"+sObjectNo);//���㷽ʽ
				RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+resaleFees+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@N500@String@ObjectNo@"+sObjectNo);//���
			}
			
		}
		
		//��������
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA001");//�����ཻ��
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA002");//�����ձ��
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA004");//��ǰ����
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,TRA005");//�����ཻ��
		RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=sTypeNo%>,V1.0,PS001");//����δ�����������
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
		var sComponentName="<%=sCurItemID%>";
		if(sComponentName=="01"){
			setItemValue(0,0,"calculationType", "1");
		}else{
			setItemValue(0,0,"calculationType", "0");
			setItemValue(0,0,"monthcalculationMethod","01");
			setItemValue(0,0,"dealerLiXiTime", "1");
		}
		setItemValue(0,0,"dealerPaymentTime", "1");
		
		setItemValue(0,0,"inputOrg", "<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"inputUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"inputTime", "<%=StringFunction.getToday()%>");
		setItemValue(0,0,"updateOrg", "<%=CurOrg.getOrgName()%>");
		setItemValue(0,0,"updateUser", "<%=CurUser.getUserName()%>");
		setItemValue(0,0,"updateTime", "<%=StringFunction.getToday()%>");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
