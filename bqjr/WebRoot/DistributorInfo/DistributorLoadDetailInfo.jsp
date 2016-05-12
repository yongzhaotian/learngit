<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   --fbkang 
		Tester:
		Content:    --借款信息
			未用到的属性字段暂时隐藏，如果需要请展示出来。
		Input Param:
        	TypeNo：    --类型编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "借款信息 "; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("serialNo"));
	String sBusinessType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("businessType"));
	String sQuotaID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("quotaID"));
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("customerID"));
	if(sCustomerID == null) sCustomerID = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sBusinessType == null) sBusinessType = "";
	if(sQuotaID == null) sQuotaID = "";
	
	//定义变量：查询结果集
	ASResultSet rs = null;
	String sBondSum="", sQuotaMoney="";
	String sFloatingManner="",sInterestRate="",sFloatingRange=""; //浮动方式,利率类型,浮动幅度
	String sLoanBranchName="",sLoanBranch="",sLoanBankAccount="";//放款
	String sOpenBranch="",sRepaymentBank="",sRepaymentNo="";//收款
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sTempletNo = "DistributorLoadDetailInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	System.out.println("sQuotaID="+sQuotaID+",sBusinessType="+sBusinessType+",sCustomerID="+sCustomerID);
	String sSql="select  bondSum, quotaMoney from business_contract  where  CreditAttribute ='0003' and productid='040' and quotaID=:quotaID";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("quotaID",sQuotaID));
	if(rs.next()){
		sBondSum = DataConvert.toString(rs.getDouble("bondSum"));
		sQuotaMoney = DataConvert.toString(rs.getDouble("quotaMoney"));
				
		//将空值转化成空字符串
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
						
		//将空值转化成空字符串
		if(sFloatingManner == null) sFloatingManner = "";
		if(sInterestRate == null) sInterestRate = "";	
		if(sFloatingRange == null) sFloatingRange = "";	
	}
	rs.getStatement().close();
	
	sSql="select getBankName(OpenBranch) as OpenBranch,getitemname('BankCode',bankName) as bankName,accountNo from account_information where accountType='01' and relativeSerialNo =:relativeSerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("relativeSerialNo",sCustomerID));
	if(rs.next()){
		sLoanBranchName = DataConvert.toString(rs.getString("OpenBranch"));//  放款开户支行
		sLoanBranch = DataConvert.toString(rs.getString("bankName"));      //  放款开户行
		sLoanBankAccount = DataConvert.toString(rs.getString("accountNo"));//  放款开户帐号
						
		//将空值转化成空字符串
		if(sLoanBranchName == null) sLoanBranchName = "";
		if(sLoanBranch == null) sLoanBranch = "";	
		if(sLoanBankAccount == null) sLoanBankAccount = "";	
	}
	rs.getStatement().close();
	
	sSql="select getBankName(OpenBranch) as OpenBranch,getitemname('BankCode',bankName) as bankName,accountNo from account_information where accountType='02' and relativeSerialNo =:relativeSerialNo";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("relativeSerialNo",sCustomerID));
	if(rs.next()){
		sOpenBranch = DataConvert.toString(rs.getString("OpenBranch"));//  收款开户支行
		sRepaymentBank = DataConvert.toString(rs.getString("bankName"));// 收款开户行
		sRepaymentNo = DataConvert.toString(rs.getString("accountNo"));//  收款开户帐号
								
		//将空值转化成空字符串
		if(sOpenBranch == null) sOpenBranch = "";
		if(sRepaymentBank == null) sRepaymentBank = "";	
		if(sRepaymentNo == null) sRepaymentNo = "";	
	}
	rs.getStatement().close();
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp =dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>

<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
			{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
		    };
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //记录当前所选择行的代码号
    var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		insertTermPara();
		bIsInsert = false;
	    as_save("myiframe0");
	}
   
	function insertTermPara(){
		var sBusinessType = getItemValue(0,getRow(),"BusinessType");//产品代码
		var RPTTermID = getItemValue(0,getRow(),"repaymentWay");//还款方式
		var sObjectNo = getItemValue(0,getRow(),"serialNo");//对象编号
		var sTermObjectNo = sBusinessType+"-V1.0";
		var repaymentDate = getItemValue(0,getRow(),"repaymentDate");//默认还款日DefaultDueDay
		var sObjectType = "jbo.app.BUSINESS_CONTRACT";
		
	  	//还款方式
		RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+repaymentDate+",PRODUCT_TERM_PARA,String@paraid@DefaultDueDay@String@termid@RPT01@String@ObjectNo@"+sTermObjectNo);//默认还款日
		RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,RPT01,"+sObjectType+","+sObjectNo);
		//利率 
		var interestRate = getItemValue(0,getRow(),"interestRate");//利率类型
		var baseRate = getItemValue(0,getRow(),"benchmarkInterestRates");//基准利率
		var executeYearRate = getItemValue(0,getRow(),"executeYearRate");//执行年利率
		 if(interestRate=="0"){//固定利率
			RATTermID="RAT002";
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+RATTermID+","+sObjectType+","+sObjectNo);
			RunMethod("PublicMethod","UpdateColValue","String@BUSINESSRATE@"+executeYearRate+",ACCT_RATE_SEGMENT,String@ratetermid@RAT002@String@ObjectNo@"+sObjectNo);//执行年利率
		}else if(interestRate=="1"){//浮动利率
			RATTermID="RAT001";
			//创建单据对象
			RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+RATTermID+","+sObjectType+","+sObjectNo);
			RunMethod("PublicMethod","UpdateColValue","String@BASERATE@"+baseRate+",ACCT_RATE_SEGMENT,String@ratetermid@RAT001@String@ObjectNo@"+sObjectNo);//基准利率
			RunMethod("PublicMethod","UpdateColValue","String@BUSINESSRATE@"+executeYearRate+",ACCT_RATE_SEGMENT,String@ratetermid@RAT001@String@ObjectNo@"+sObjectNo);//执行年利率
			/* RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+baseRate+",PRODUCT_TERM_PARA,String@paraid@BaseRate@String@termid@RAT001@String@ObjectNo@"+sTermObjectNo);//基准利率
			RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+executeYearRate+",PRODUCT_TERM_PARA,String@paraid@ExecuteRate@String@termid@RAT001@String@ObjectNo@"+sTermObjectNo);//执行年利率*/ 
		} 
		
		//罚息 固定为浮动罚息
		 if(interestRate=="0"){//固定利率
			 var FINTermID= "FIN005";
		 }else if(interestRate=="1"){//浮动利率
			var FINTermID= "FIN003";
		 	//取产品罚息浮动幅度、浮动方式
		    var FinFloatType =RunMethod("GetElement","GetElementValue","penaltyRate,business_type,typeno='"+sBusinessType+"' and creditattribute=0003");//罚息计算方式
		    var FinFloat =RunMethod("GetElement","GetElementValue","floatingRate,business_type,typeno='"+sBusinessType+"' and creditattribute=0003");//罚息幅度
		 	if(FinFloatType=="0"){//按比例
		 		executeYearRate = parseFloat(baseRate)*0.01+parseFloat(baseRate)*0.01*parseFloat(FinFloat);
		 	}if(FinFloatType=="1"){//按浮动点
		 		executeYearRate =(parseFloat(baseRate)+parseFloat(FinFloat))*0.01;
		 	}
		 }
		
		//删除原有对象罚息信息
		RunMethod("PublicMethod","deleteratesegment",FINTermID+","+sObjectType+","+sObjectNo);
		RunMethod("ProductManage","initObjectWithProduct","initObjectWithProduct,"+FINTermID+","+sObjectType+","+sObjectNo);//罚息
		RunMethod("PublicMethod","UpdateColValue","String@BASERATE@"+baseRate+",ACCT_RATE_SEGMENT,String@ratetermid@"+FINTermID+"@String@ObjectNo@"+sObjectNo);//基准利率
		RunMethod("PublicMethod","UpdateColValue","String@BUSINESSRATE@"+executeYearRate+",ACCT_RATE_SEGMENT,String@ratetermid@"+FINTermID+"@String@ObjectNo@"+sObjectNo);//执行年利率
		//费用
		var fee = getItemValue(0,getRow(),"fee");//手续费
		<%-- RunMethod("PublicMethod","UpdateColValue","String@DEFAULTVALUE@"+fee+",PRODUCT_TERM_PARA,String@paraid@FeeAmount@String@termid@N400@String@ObjectNo@"+sTermObjectNo);//费用金额
		RunMethod("LoanAccount","CreateFee","N400,"+sObjectType+","+sObjectNo+",<%=CurUser.getUserID()%>"); --%>
		
		//放款账户信息关联合同
		var AccountNo = getItemValue(0,0,"loanBankAccount");//开户帐号(放款)
		var AccountallName = getItemValue(0,0,"sCustomerName");//经销商名称(户名)
		var loanBranchName = getItemValue(0,0,"loanBranchName");//开户支行(放款)
		RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+AccountallName+"@String@accountno@"+AccountNo);
		RunMethod("PublicMethod","UpdateColValue","String@OBJECTTYPE@"+sObjectType+",acct_deposit_accounts,String@accountname@"+AccountallName+"@String@accountno@"+AccountNo);
		//还款款账户信息关联合同
		var paymentAccountNo = getItemValue(0,0,"repaymentBankAccount");//开户帐号(还款款)
		var AccountallName = getItemValue(0,0,"sCustomerName");//经销商名称(户名)
		var loanBranchName = getItemValue(0,0,"repaymentBranchName");//开户支行(还款款)
		RunMethod("PublicMethod","UpdateColValue","String@OBJECTNO@"+sObjectNo+",acct_deposit_accounts,String@accountname@"+AccountallName+"@String@accountno@"+paymentAccountNo);
		RunMethod("PublicMethod","UpdateColValue","String@OBJECTTYPE@"+sObjectType+",acct_deposit_accounts,String@accountname@"+AccountallName+"@String@accountno@"+paymentAccountNo);
		
		
	}
    
    
    //取基准利率
    function GetBaseRate(){
    	var baseRateType = "010";//人行利率
    	var rateUnit = "02";//月
    	var currency = "01";
    	var baseRateGrade = getItemValue(0,getRow(),"term");//期限
    	var interestRate = getItemValue(0,getRow(),"interestRate");//利率类型
    	var floatingManner = getItemValue(0,getRow(),"floatingManner");//浮动方式
    	var floatingRange = getItemValue(0,getRow(),"floatingRange");//浮动幅度
    	CalcMaturity();//到期日
    	var executeYearRate = "";//执行年利率
    	var sReturn = RunMethod("PublicMethod","GetColValue","RATEVALUE,RATE_INFO,String@ratetype@010@String@rateunit@02@String@currency@01@String@term@12");
    	sReturn = sReturn.split("@");
    	if(sReturn[1].substr(0,8)==0 || sReturn[1].substr(0,8).length==0){
    		alert("请检查是否已经维护基准利率！");
    		return;
    	}
    	var baseRate = sReturn[1].substr(0,8);
    	setItemValue(0,getRow(),"benchmarkInterestRates",baseRate);
    	
    	if(interestRate=="0"){//固定利率
    		executeYearRate =parseFloat(baseRate)*0.01
    	}else{
    		if(floatingManner=="0"){//按比例浮动
    			executeYearRate =parseFloat(baseRate)*0.01+parseFloat(baseRate)*0.01*parseFloat(floatingRange);
    		}else{
    			executeYearRate =(parseFloat(baseRate)+parseFloat(floatingRange))*0.01;
    		}
    	}
    	setItemValue(0,getRow(),"executeYearRate",executeYearRate);
    }
    
    /*~[Describe=计算到期日;InputParam=无;OutPutParam=无;]~*/
	function CalcMaturity(){
		var sPutOutDate = getItemValue(0,getRow(),"PutOutDate");//起息日
    	var sTermMonth = getItemValue(0,getRow(),"term");//期限
    	
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


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
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
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0, 0, "relativeSerialno", "<%=sSerialNo %>");
			bIsInsert = true;
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
