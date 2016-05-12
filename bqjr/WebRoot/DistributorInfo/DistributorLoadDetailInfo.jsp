<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --�����Ϣ
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
	String PG_TITLE = "�����Ϣ "; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//���ҳ�����
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("serialNo"));
	String sBusinessType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("businessType"));
	String sQuotaID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("quotaID"));
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("customerID"));
	if(sCustomerID == null) sCustomerID = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sBusinessType == null) sBusinessType = "";
	if(sQuotaID == null) sQuotaID = "";
	
	//�����������ѯ�����
	ASResultSet rs = null;
	String sBondSum="", sQuotaMoney="";
	String sFloatingManner="",sInterestRate="",sFloatingRange=""; //������ʽ,��������,��������
	String sLoanBranchName="",sLoanBranch="",sLoanBankAccount="";//�ſ�
	String sOpenBranch="",sRepaymentBank="",sRepaymentNo="";//�տ�
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String sTempletNo = "DistributorLoadDetailInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	System.out.println("sQuotaID="+sQuotaID+",sBusinessType="+sBusinessType+",sCustomerID="+sCustomerID);
	String sSql="select  bondSum, quotaMoney from business_contract  where  CreditAttribute ='0003' and productid='040' and quotaID=:quotaID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("quotaID",sQuotaID));
	if(rs.next()){
		sBondSum = DataConvert.toString(rs.getDouble("bondSum"));
		sQuotaMoney = DataConvert.toString(rs.getDouble("quotaMoney"));
				
		//����ֵת���ɿ��ַ���
		if(sBondSum == null) sBondSum = "";
		if(sQuotaMoney == null) sQuotaMoney = "";		
	}
	rs.getStatement().close(); 
	
	sSql="select floatingManner,rateType ,floatingRange  from  business_type bt where bt.CreditAttribute = '0003' and typeno=:typeno";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("typeno",sBusinessType));
	if(rs.next()){
		sFloatingManner = DataConvert.toString(rs.getString("floatingManner"));
		sInterestRate = DataConvert.toString(rs.getString("rateType"));
		sFloatingRange = DataConvert.toString(rs.getString("floatingRange"));
						
		//����ֵת���ɿ��ַ���
		if(sFloatingManner == null) sFloatingManner = "";
		if(sInterestRate == null) sInterestRate = "";	
		if(sFloatingRange == null) sFloatingRange = "";	
	}
	rs.getStatement().close();
	
	sSql="select getBankName(OpenBranch) as OpenBranch,getitemname('BankCode',bankName) as bankName,accountNo from account_information where accountType='01' and relativeSerialNo =:relativeSerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("relativeSerialNo",sCustomerID));
	if(rs.next()){
		sLoanBranchName = DataConvert.toString(rs.getString("OpenBranch"));//  �ſ��֧��
		sLoanBranch = DataConvert.toString(rs.getString("bankName"));      //  �ſ����
		sLoanBankAccount = DataConvert.toString(rs.getString("accountNo"));//  �ſ���ʺ�
						
		//����ֵת���ɿ��ַ���
		if(sLoanBranchName == null) sLoanBranchName = "";
		if(sLoanBranch == null) sLoanBranch = "";	
		if(sLoanBankAccount == null) sLoanBankAccount = "";	
	}
	rs.getStatement().close();
	
	sSql="select getBankName(OpenBranch) as OpenBranch,getitemname('BankCode',bankName) as bankName,accountNo from account_information where accountType='02' and relativeSerialNo =:relativeSerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("relativeSerialNo",sCustomerID));
	if(rs.next()){
		sOpenBranch = DataConvert.toString(rs.getString("OpenBranch"));//  �տ��֧��
		sRepaymentBank = DataConvert.toString(rs.getString("bankName"));// �տ����
		sRepaymentNo = DataConvert.toString(rs.getString("accountNo"));//  �տ���ʺ�
								
		//����ֵת���ɿ��ַ���
		if(sOpenBranch == null) sOpenBranch = "";
		if(sRepaymentBank == null) sRepaymentBank = "";	
		if(sRepaymentNo == null) sRepaymentNo = "";	
	}
	rs.getStatement().close();
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp =dwTemp.genHTMLDataWindow(sSerialNo);
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
		insertTermPara();
		bIsInsert = false;
	    as_save("myiframe0");
	}
   
	function insertTermPara(){
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");//��Ʒ����
		var RPTTermID = getItemValue(0,getRow(),"repaymentWay");//���ʽ
		var sObjectNo = getItemValue(0,getRow(),"serialNo");//������
		var sTermObjectNo = sBusinessType+"-V1.0";
		var repaymentDate = getItemValue(0,getRow(),"repaymentDate");//Ĭ�ϻ�����DefaultDueDay
		var sObjectType = "jbo.app.BUSINESS_CONTRACT";
		
	  	//���ʽ
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+repaymentDate+",PRODUCT_TERM_PARA,String@paraid@DefaultDueDay@String@termid@RPT01@String@ObjectNo@"+sTermObjectNo);//Ĭ�ϻ�����
		RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,RPT01,"+sObjectType+","+sObjectNo);
		//���� 
		var interestRate = getItemValue(0,getRow(),"interestRate");//��������
		var baseRate = getItemValue(0,getRow(),"benchmarkInterestRates");//��׼����
		var executeYearRate = getItemValue(0,getRow(),"executeYearRate");//ִ��������
		 if(interestRate=="0"){//�̶�����
			RATTermID="RAT002";
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+RATTermID+","+sObjectType+","+sObjectNo);
			RunMethod("PublicMethod","UpdateColValue","String@BUSINESSRATE@"+executeYearRate+",ACCT_RATE_SEGMENT,String@ratetermid@RAT002@String@ObjectNo@"+sObjectNo);//ִ��������
		}else if(interestRate=="1"){//��������
			RATTermID="RAT001";
			//�������ݶ���
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+RATTermID+","+sObjectType+","+sObjectNo);
			RunMethod("PublicMethod","UpdateColValue","String@BASERATE@"+baseRate+",ACCT_RATE_SEGMENT,String@ratetermid@RAT001@String@ObjectNo@"+sObjectNo);//��׼����
			RunMethod("PublicMethod","UpdateColValue","String@BUSINESSRATE@"+executeYearRate+",ACCT_RATE_SEGMENT,String@ratetermid@RAT001@String@ObjectNo@"+sObjectNo);//ִ��������
			/* RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+baseRate+",PRODUCT_TERM_PARA,String@paraid@BaseRate@String@termid@RAT001@String@ObjectNo@"+sTermObjectNo);//��׼����
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+executeYearRate+",PRODUCT_TERM_PARA,String@paraid@ExecuteRate@String@termid@RAT001@String@ObjectNo@"+sTermObjectNo);//ִ��������*/ 
		} 
		
		//��Ϣ �̶�Ϊ������Ϣ
		 if(interestRate=="0"){//�̶�����
			 var FINTermID= "FIN005";
		 }else if(interestRate=="1"){//��������
			var FINTermID= "FIN003";
		 	//ȡ��Ʒ��Ϣ�������ȡ�������ʽ
		    var FinFloatType =RunMethod("GetElement","GetElementValue","penaltyRate,business_type,typeno='"+sBusinessType+"' and creditattribute=0003");//��Ϣ���㷽ʽ
		    var FinFloat =RunMethod("GetElement","GetElementValue","floatingRate,business_type,typeno='"+sBusinessType+"' and creditattribute=0003");//��Ϣ����
		 	if(FinFloatType=="0"){//������
		 		executeYearRate = parseFloat(baseRate)*0.01+parseFloat(baseRate)*0.01*parseFloat(FinFloat);
		 	}if(FinFloatType=="1"){//��������
		 		executeYearRate =(parseFloat(baseRate)+parseFloat(FinFloat))*0.01;
		 	}
		 }
		
		//ɾ��ԭ�ж���Ϣ��Ϣ
		RunMethod("PublicMethod","deleteratesegment",FINTermID+","+sObjectType+","+sObjectNo);
		RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+FINTermID+","+sObjectType+","+sObjectNo);//��Ϣ
		RunMethod("PublicMethod","UpdateColValue","String@BASERATE@"+baseRate+",ACCT_RATE_SEGMENT,String@ratetermid@"+FINTermID+"@String@ObjectNo@"+sObjectNo);//��׼����
		RunMethod("PublicMethod","UpdateColValue","String@BUSINESSRATE@"+executeYearRate+",ACCT_RATE_SEGMENT,String@ratetermid@"+FINTermID+"@String@ObjectNo@"+sObjectNo);//ִ��������
		//����
		var fee = getItemValue(0,getRow(),"fee");//������
		<%-- RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+fee+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@N400@String@ObjectNo@"+sTermObjectNo);//���ý��
		RunMethod("LoanAccount","CreateFee","N400,"+sObjectType+","+sObjectNo+",<%=CurUser.getUserID()%>"); --%>
		
		//�ſ��˻���Ϣ������ͬ
		var AccountNo = getItemValue(0,0,"loanBankAccount");//�����ʺ�(�ſ�)
		var AccountallName = getItemValue(0,0,"sCustomerName");//����������(����)
		var loanBranchName = getItemValue(0,0,"loanBranchName");//����֧��(�ſ�)
		RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+AccountallName+"@String@accountno@"+AccountNo);
		RunMethod("PublicMethod","UpdateColValue","String@OBJECTTYPE@"+sObjectType+",acct_deposit_accounts,String@accountname@"+AccountallName+"@String@accountno@"+AccountNo);
		//������˻���Ϣ������ͬ
		var paymentAccountNo = getItemValue(0,0,"repaymentBankAccount");//�����ʺ�(�����)
		var AccountallName = getItemValue(0,0,"sCustomerName");//����������(����)
		var loanBranchName = getItemValue(0,0,"repaymentBranchName");//����֧��(�����)
		RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+AccountallName+"@String@accountno@"+paymentAccountNo);
		RunMethod("PublicMethod","UpdateColValue","String@OBJECTTYPE@"+sObjectType+",acct_deposit_accounts,String@accountname@"+AccountallName+"@String@accountno@"+paymentAccountNo);
		
		
	}
    
    
    //ȡ��׼����
    function GetBaseRate(){
    	var baseRateType = "010";//��������
    	var rateUnit = "02";//��
    	var currency = "01";
    	var baseRateGrade = getItemValue(0,getRow(),"term");//����
    	var interestRate = getItemValue(0,getRow(),"interestRate");//��������
    	var floatingManner = getItemValue(0,getRow(),"floatingManner");//������ʽ
    	var floatingRange = getItemValue(0,getRow(),"floatingRange");//��������
    	CalcMaturity();//������
    	var executeYearRate = "";//ִ��������
    	var sReturn = RunMethod("PublicMethod","GetColValue","RATEVALUE,RATE_INFO,String@ratetype@010@String@rateunit@02@String@currency@01@String@term@12");
    	sReturn = sReturn.split("@");
    	if(sReturn[1].substr(0,8)==0 || sReturn[1].substr(0,8).length==0){
    		alert("�����Ƿ��Ѿ�ά����׼���ʣ�");
    		return;
    	}
    	var baseRate = sReturn[1].substr(0,8);
    	setItemValue(0,getRow(),"benchmarkInterestRates",baseRate);
    	
    	if(interestRate=="0"){//�̶�����
    		executeYearRate =parseFloat(baseRate)*0.01
    	}else{
    		if(floatingManner=="0"){//����������
    			executeYearRate =parseFloat(baseRate)*0.01+parseFloat(baseRate)*0.01*parseFloat(floatingRange);
    		}else{
    			executeYearRate =(parseFloat(baseRate)+parseFloat(floatingRange))*0.01;
    		}
    	}
    	setItemValue(0,getRow(),"executeYearRate",executeYearRate);
    }
    
    /*~[Describe=���㵽����;InputParam=��;OutPutParam=��;]~*/
	function CalcMaturity(){
		var sPutOutDate = getItemValue(0,getRow(),"PutOutDate");//��Ϣ��
    	var sTermMonth = getItemValue(0,getRow(),"term");//����
    	
		if(typeof(sTermMonth)== "undefined" || sTermMonth.length == 0 || typeof(sPutOutDate)=="undefined" || sPutOutDate.length == 0) {
			return ;
		}
		if(sTermMonth !=0){
		   sLoanTermFlag ="020";
		   sMaturity = RunMethod("BusinessManage","CalcMaturity",sLoanTermFlag+","+sTermMonth+","+sPutOutDate);
		   setItemValue(0,getRow(),"borrowingEndDate",sMaturity);
		   setItemValue(0,getRow(),"Maturity",sMaturity);
		}
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	
	function initRow(){
		setItemValue(0, 0, "bondSum", "<%=sBondSum %>");
		setItemValue(0, 0, "quotaMoney", "<%=sQuotaMoney %>");
		setItemValue(0, 0, "floatingManner", "<%=sFloatingManner %>");
		setItemValue(0, 0, "interestRate", "<%=sInterestRate %>");
		setItemValue(0, 0, "floatingRange", "<%=sFloatingRange %>");
		setItemValue(0, 0, "loanBranchName", "<%=sLoanBranchName %>");
		setItemValue(0, 0, "loanBranch", "<%=sLoanBranch %>");
		setItemValue(0, 0, "loanBankAccount", "<%=sLoanBankAccount %>");
		setItemValue(0, 0, "openBranch", "<%=sOpenBranch %>");
		setItemValue(0, 0, "repaymentBank", "<%=sRepaymentBank %>");
		setItemValue(0, 0, "repaymentNo", "<%=sRepaymentNo %>");
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0, 0, "relativeSerialno", "<%=sSerialNo %>");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
