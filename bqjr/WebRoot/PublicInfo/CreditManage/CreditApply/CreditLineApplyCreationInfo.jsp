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
	String sNo = Sqlca.getString(new SqlObject("select attribute8 from user_info  where userid=:UserID").setParameter("UserID", CurUser.getUserID()));
	
    if(sNo == null) sNo = "";
    System.out.println("-------�ŵ�-------"+sNo);
    
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CreditLineApplyCreationInfo";
	
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
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//�����ŵ�
    if(sNo == null) sNo = "";
	
	//�ŵ��ַ
	String sCity = Sqlca.getString(new SqlObject("select city from store_info si where si.identtype='01' and si.sno=:sno").setParameter("sno", sNo));
	//��ȡ��������Ϣ
    String sSql="select sp.serialno as SerialNo,sp.serviceprovidersname as ServiceProvidersName "+
				" from Service_Providers sp where sp.customertype1='06' and sp.city like '%"+sCity+"%'";
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

		as_save("myiframe0",sPostEvents);
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
			var ssReturn = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getCustomerId","tableName=IND_INFO,colName=CUSTOMERID");
			setItemValue(0,0,"CustomerID",ssReturn);//�ͻ�ID
            sParam = ssReturn+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
                     ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+sHaveCustomerType;

			var sReturnCID = RunMethod("CustomerManage","AddCustomerAction",sParam);
			if (sReturn.length == 8) setItemValue(0,0,"CustomerID",sReturnCID);//�ͻ�ID */
        } else {
        	setItemValue(0,0,"CustomerID",sReturn);//�ͻ�ID
        }
		
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
		// ������У�����֤����
	    isCardNo();
		var sProductID = getItemValue(0,0,"ProductID");//��Ʒ����
		if(sProductID=="020"){
			/* var sCustomerID = getItemValue(0,0,"CustomerID");//�ͻ�ID
			if(typeof(sCustomerID) == "undefined" || sCustomerID == ""){
				alert("�ͻ�δ��ԤԼ�ֽ��׼��ͻ������У�");
				return;
			} */
			checkType();
		}else{
			saveRecord("doReturn()");
		}
	}
	
	/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		sObjectType = "<%=sObjectType%>";		
		top.returnValue = sObjectNo+"@"+sObjectType;
		top.close();
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
			return;
		}

		if(sPaymentSum<0.0) {
			alert("��������ڵ���0���׸���");
			return;
		
		}else if(sPaymentSum>sTotalSum){
			alert("�׸���ܴ���Ʒ�ܼ۸�");
			return;
		}
		setItemValue(0, 0, "Shoufuratio", (sPaymentSum/sTotalSum*100).toFixed(2));//�׸�����
		setItemValue(0, 0, "PaymentSum", sPaymentSum);//�׸����
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
			return;
		}
		
		if(parseFloat(sShoufuratio)<0.0) {
			alert("��������ڵ���0���׸�������");
			return;
		}else if(parseFloat(sShoufuratio)>100.0){
			alert("�׸��������ܴ���100��");
			return;
		}
		
		setItemValue(0, 0, "PaymentSum", (sTotalSum*parseFloat(sShoufuratio)*0.01).toFixed(0));//�׸����
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
	
	/*~[Describe=�������ѽ��ڲ�Ʒѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectProductID()
	{
		var	sProductID = getItemValue(0,0,"ProductID");
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
	     || typeof(sCertID)=="undefined" || sCertID=="_CLEAR_" || sCertID.length==0
	     || typeof(sProductCategory)=="undefined" || sProductCategory=="_CLEAR_" || sProductCategory.length==0
	     || typeof(sCustomerName)=="undefined" || sCustomerName=="_CLEAR_" || sCustomerName.length==0
	     || typeof(sPaymentSum)=="undefined" || sPaymentSum=="_CLEAR_" || sPaymentSum.length==0) {
	    	 alert("�������Ϊ�գ�");
			   return;
	     }
		sParaString = "ProductID"+","+sProductID+","+"Sum"+","+sSum+","+"ProductSum"+","+sProductSum+","+"ProductCategory"+","+sProductCategory+","+"Shoufuratio"+","+sShoufuratio1+",SNo,<%=sNo%>";
		//���÷��ز��� 
		setObjectValue("SelectBusinessInfo",sParaString,"@BusinessType@0@ProductName@1@Periods@2",0,0,""); 
	}
	
	//ѡ���Ʒ����ʱ����ʾ��Ӧ���ı���
	function checkType(){
		isCardNo();
		
		var sProductId = getItemValue(0,0,"ProductId");
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sIdentityId   = getItemValue(0,0,"CertID");
		
		
		if(sProductId=="020" && sCustomerName =="" && sIdentityId ==""){
		   alert("����д�ͻ����Ƽ����֤�ţ�");  	
		}

		if(sProductId=="020" && sCustomerName !="" && sIdentityId !=""){//����ǡ�ԤԼ�ֽ���� ��֤�ͻ���Ϣ
		   //��ѯԤԼ�ֽ��׼��ͻ�����
		   ssReturn = RunMethod("BusinessManage","CustomerNameInfo",sCustomerName+","+sIdentityId);
		   //alert("------------------"+ssReturn);
		   if(ssReturn == "Null"){
			   alert("�ͻ�δ��ԤԼ�ֽ��׼��ͻ������У�");
			   return;
		   }
		}
		//��ȡ�ͻ�ID
		var sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName+","+sIdentityId);
		//alert("����ֵ��"+sReturn);
			
	    //���ÿͻ�ID
	    if(sReturn == "Null"){
	    	//��ȡ�ͻ���
			//var sSerialNo = RunJavaMethodSqlca("com.amarsoft.app.billions.GenerateSerialNo", "getCustomerId","tableName=IND_INFO,colName=CUSTOMERID");//getSerialNo("Customer_Info","CustomerID","");
			//setItemValue(0,getRow(),"CustomerID",sSerialNo);
	    }else{
	    	//�ѿͻ��ţ����֤������ֻ��
	    	setItemReadOnly(0,0,"CustomerName",true);
	    	setItemReadOnly(0,0,"CertID",true);
	    	//�Ѳ�ѯ�Ŀͻ�ID���õ�CustomerID��
	        setItemValue(0,0,"CustomerID",sReturn);
	    }

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
			setItemValue(0,0,"InputDate","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
			//��������
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			//�ݴ��־
			setItemValue(0,0,"TempSaveFlag","1");//�Ƿ��־��1���ǣ�2����
			//�ͻ�����Ĭ��Ϊ���˿ͻ�
			setItemValue(0,0,"CustomerType","0310");
			setItemValue(0,0,"CreditID","<%=sCreditId%>");
			setItemValue(0,0,"CreditPerson","<%=sCreditPerson%>");
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
				ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//����������ڵĺϷ���������ʽ 
			}else{
				ereg=/^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//ƽ��������ڵĺϷ���������ʽ 
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