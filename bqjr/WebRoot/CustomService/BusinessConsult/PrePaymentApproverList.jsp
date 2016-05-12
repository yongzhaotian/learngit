<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Describe: 提前还款审批列表页面
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "提前还款审批列表页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String BusinessDate=SystemConfig.getBusinessDate();
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	if(sDoWhere==null) sDoWhere="";	
	
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = { 
			{"serialNo","申请序列号"},
			{"contractSerialno","合同号"},
			{"customerId","客户id"},
			{"customerName","客户姓名"},
			{"executableDate","提前还款可执行日期"},
			{"status","交易状态"},
			{"statusName","交易状态"},
			{"payamt","应还总金额"},
			{"prepayprincipalAmt","提前还款本金金额"},
			{"prepayinteAmt","提前还款利息金额"},
			{"financeAmt","应还财务管理费"},
			{"customerAmt","应还客户管理费"},
			{"insuranceAmt","应还保险费"},
			{"stampDutyAmt","应还印花税"},
			{"prepayFactorageAmt","提前还款手续费"},
			{"bugpayamt","随心还服务费"},
			{"applayOrgName","申请机构"},
			{"applicantByName","申请人"},
			{"applicantDate","申请时间"},
			{"approverByName","审批人"},
			{"approverDate","审批时间"},
			{"approverOrgName","审批机构"},
			{"prepayFactorageFlag","是否收取提前还款手续费"}
		};
		String sql =" select pa.serialno as serialNo,pa.contract_serialno as contractSerialno,pa.customer_id as customerId,al.customerName as customerName ,pa.executable_date as executableDate,"
					+" nvl(t.transstatus,pa.status) as status ,"
					+" (case when nvl(t.transstatus,pa.status)='0' then '审批中' when nvl(t.transstatus,pa.status)='3' then '审批通过' when nvl(t.transstatus,pa.status)='1' then '已执行' when nvl(t.transstatus,pa.status)='4' then '已取消'  end) as statusName,pa.payamt as payamt, "
					+" pa.prepayprincipal_amt as prepayprincipalAmt,pa.prepayinte_amt as prepayinteAmt,pa.finance_amt as financeAmt,pa.customer_amt as customerAmt,pa.insurance_amt as insuranceAmt,pa.stamp_duty_amt as stampDutyAmt,"
					+" pa.prepay_factorage_amt as prepayFactorageAmt,pa.bugpayamt as bugpayamt, "
					+" getOrgName(pa.applay_orgid) as applayOrgName,getUserName(pa.applicant_by) as applicantByName,pa.applicant_date as applicantDate,getUserName(pa.approver_by) as approverByName,pa.approver_date as approverDate,"
					+" getOrgName(pa.approver_orgid) as approverOrgName, (case when pa.prepay_factorage_flag='0' then '否' when pa.prepay_factorage_flag='1' then '是' end) as prepayFactorageFlag "
					+" from prepayment_applay pa left join acct_loan al on al.serialno=pa.laon_serialno"
					+" left join acct_transaction t on pa.at_serialno =t.serialno  where 1=1 ";
		 ASDataObject doTemp = new ASDataObject(sql);
		 doTemp.setHeader(sHeaders);
		 doTemp.setVisible("customerId,serialNo,status", false);
		 doTemp.setKey("serialNo", true);
		 doTemp.setColumnAttribute("contractSerialno,customerName,status,applicantDate","IsFilter","1");
		 doTemp.setDDDWCodeTable("status", "0,审批中,1,已执行,3,审批通过,4,已取消");
	     doTemp.setFilter(Sqlca, "0020", "contractSerialno", "Operators=EqualsString,BeginsWith;");
		 doTemp.setFilter(Sqlca, "0031", "customerName", "Operators=EqualsString,BeginsWith;");
		 doTemp.setFilter(Sqlca, "0010", "status", "Operators=EqualsString;");
		 doTemp.setFilter(Sqlca, "0030", "applicantDate", "Operators=EqualsString,BeginsWith;");
		 
		 doTemp.parseFilterData(request,iPostChange);
		 int count = 0;
		 for(int k=0; k<doTemp.Filters.size(); k++){
			 if(doTemp.Filters.get(k).sFilterInputs[0][1] != null){
				 count ++;
			 }
		 }
		 for(int k=0; k<doTemp.Filters.size(); k++){
			 	if(count==1){
			 		if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && "0031".equals(doTemp.Filters.get(k).sFilterID)){
			 			%>
						<script type="text/javascript">
							alert("客户名称需和其他条件组合查询!");
						</script>
						<%
						doTemp.WhereClause+=" and 1=2";
						break;
			 		}
			 	}
				//输入的条件都不能含有%符号
				if(doTemp.Filters.get(k).sFilterInputs[0][1] != null && doTemp.Filters.get(k).sFilterInputs[0][1].contains("%")){
					%>
					<script type="text/javascript">
						alert("输入的条件不能含有\"%\"符号!");
					</script>
					<%
					doTemp.WhereClause+=" and 1=2";
					break;
				}
				
		 }
		if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and pa.status='0' ";
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "1"; //设置为可写
		dwTemp.setPageSize(15);
		//生成datawindow
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
			{"true","","Button","确认提前还款","确认提前还款","PrePaymentApprover()",sResourcesPath},
			{"true","","Button","取消提前还款","取消提前还款","cancelPrepayMent()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>
	
<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	<%/*~[Describe=提前还款申请;] ~*/%>
	function PrePaymentApprover(){
		var sSerialNo = getItemValue(0,getRow(),"serialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if(confirm("确认审批通过提前还款！")){
	    	var params = "orgid=<%=CurUser.getOrgID()%>,userId =<%=CurUser.getUserID()%>,serialNo="+sSerialNo;
	    	var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PaymentApply", "PrepayMentApprover", params);
	    	if(result!=null){
	    		alert(result.split("@")[1]);
	    		if(result.split("@")[0]=="success"){
	    			reloadSelf();
	    		}
	    	}	
		}
		
	}
	
	function cancelPrepayMent(){
		var sSerialNo = getItemValue(0,getRow(),"serialNo");
		var status =  getItemValue(0,getRow(),"status");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if(status == "0" || status == "3"){
			if(confirm("确认取消前还款！")){
		    	var params = "orgid=<%=CurUser.getOrgID()%>,userId =<%=CurUser.getUserID()%>,serialNo="+sSerialNo;
		    	var result = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PaymentApply", "cancelPrepayMent", params);
		    	if(result!=null){
		    		alert(result.split("@")[1]);
		    		if(result.split("@")[0]=="success"){
		    			reloadSelf();
		    		}else{
		    			reloadSelf();
		    		}
		    	}	
			}
		}else{
			alert("只有状态为审批中的才能取消！");  
			return;
		}
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
