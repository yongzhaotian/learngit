<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --���������������ʽ���
			δ�õ��������ֶ���ʱ���أ������Ҫ��չʾ������
		Input Param:
        	TypeNo��    --���ͱ��
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������������ʽ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("DistributorFlowLoadInfo",Sqlca);
    
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","����","����","saveRecordAndBack()",sResourcesPath}
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //��¼��ǰ��ѡ���еĴ����
    var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		bIsInsert = false;
	    as_save("myiframe0");
	}

    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndBack()
	{
        window.close();
	}
    
    function getRegionCode(){
    	var sEntInfoValue=setObjectValue("SelectServiceProvidersInfo","","@customerName@2",0,0,"");
    	if(typeof(sEntInfoValue)=="undefined" || sEntInfoValue.length==0){
			alert("��ѡ��һ�������̣�");  
			return;
		}
    	sEntInfoValue=sEntInfoValue.split('@');
    	sCustomerID=sEntInfoValue[0];             // �����̱��
    	sServiceProvidersType=sEntInfoValue[1];   //���������� 
    	entErpriseName=sEntInfoValue[2];          //����������
    	 if(sServiceProvidersType=="������"){
 	    	sServiceProvidersType="2";
 	    }else if(sServiceProvidersType=="�����̼���"){
 	    	sServiceProvidersType="1";
 	    }
    	setItemValue(0, 0, "customerID", sCustomerID);
    	setItemValue(0, 0, "serviceProvidersType", sServiceProvidersType);
    	setItemValue(0, 0, "customerName", entErpriseName);
//    	var fBankName= RunMethod("GetElement","GetElementValue","bankName,account_Information,relativeSerialno='"+sCustomerID+"' and accountType=01"); //�����ʽ�ſ��֧������
//    	var sBankName =RunMethod("GetElement","GetElementValue","bankName,account_Information,relativeSerialno='"+sCustomerID+"' and accountType=02");//�����ʽ��տ��֧������
//    	var fAccountNo =RunMethod("GetElement","GetElementValue","accountNo,account_Information,relativeSerialno='"+sCustomerID+"' and accountType=01");//�����ʽ�ſ���ʺ�
//    	var sAccountNo =RunMethod("GetElement","GetElementValue","accountNo,account_Information,relativeSerialno='"+sCustomerID+"' and accountType=02");//�����ʽ�ſ� �����ʺ�
//    	setItemValue(0, 0, "loanBranchName", fBankName);
//    	setItemValue(0, 0, "repaymentBranchName", sBankName);
//    	setItemValue(0, 0, "loanBankAccount", fAccountNo);
//    	setItemValue(0, 0, "repaymentBankAccount", sAccountNo);
    }
    
    function getRegionCode1(){
    	var sCustomerID=getItemValue(0,getRow(),"customerID");
    	if(typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert("����ѡ����Ӧ�ľ����̣�");  
			return;
		}
    	var sEntInfoValue1=setObjectValue("SelectDistributorLoadInfo2", "customerID,"+sCustomerID, "@bondSum@4", 0, 0, "");
    	if(typeof(sEntInfoValue1)=="undefined" || sEntInfoValue1.length==0){
			alert("��ѡ��һ����ȣ�");  
			return;
		}
    	sEntInfoValue1=sEntInfoValue1.split('@');
    	sQuotaID=sEntInfoValue1[0];       //�����̶�ȵĶ��Э����
    	sBondSum=sEntInfoValue1[4];      //������ȣ����ö�ȣ�
    	sQuotaMoney=sEntInfoValue1[5];   //��Ƚ��
    	setItemValue(0, 0, "quotaID", sQuotaID);
//    	setItemValue(0, 0, "bondSum", sBondSum);
//    	setItemValue(0, 0, "quotaMoney", sQuotaMoney);
    }
    
    function getRegionCode2(){
    	var sEntInfoValue2=setObjectValue("SelectDistributorLoadInfo3","","@productName@1",0,0,"");
    	if(typeof(sEntInfoValue2)=="undefined" || sEntInfoValue2.length==0){
			alert("��ѡ��һ����Ʒ��");  
			return;
		}
    	sEntInfoValue2=sEntInfoValue2.split('@');
    	sBusinessType=sEntInfoValue2[0];        //�����̹����Ĳ�Ʒ����
    	sProductName=sEntInfoValue2[1];      //��Ʒ����
    	sFloatingManner=sEntInfoValue2[2];   //������ʽ
    	sInterestRate=sEntInfoValue2[3];     //��������
    	sFloatingRange=sEntInfoValue2[4];    //��������
    	setItemValue(0, 0, "BusinessType", sBusinessType);
//    	setItemValue(0, 0, "floatingManner", sFloatingManner);
//    	setItemValue(0, 0, "interestRate", sInterestRate);
//    	setItemValue(0, 0, "floatingRange", sFloatingRange);
    }
   
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0, 0, "creditAttribute", "0003");
			setItemValue(0, 0, "productID", "060");
			setItemValue(0, 0, "quotaStatus", "01");
			//��ʼ���汾
			setItemValue(0,0,"productVersion","V1.0");
			setItemValue(0,0,"serialNo",getSerialNo("business_contract", "serialNo", " "));
			setItemValue(0, 0, "inputOrgName", "<%=CurOrg.orgName %>");
			setItemValue(0,0,"inputOrgID","<%=CurOrg.orgID %>");
			setItemValue(0,0,"inputUserID", "<%=CurUser.getUserID()%>");
			setItemValue(0,0,"inputDate", "<%=StringFunction.getToday()%>");
			setItemValue(0,0,"updateOrgName", "<%=CurOrg.orgName%>");
			setItemValue(0,0,"updateUserID", "<%=CurUser.getUserID() %>");
			setItemValue(0,0,"updateOrgID","<%=CurOrg.orgID %>");
			setItemValue(0,0,"updateDate", "<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
