<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jiangyuanlin 2015 06 01
		Tester:
		Describe: 还款计划表修正复核界面
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "还款计划表修正复核"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sDoWhere  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("doWhere"));	
	if(sDoWhere==null) sDoWhere="";	
	String BusinessDate = SystemConfig.getBusinessDate();
	
	String sHeaders[][] = { 							
			{"serialno","申请流水号"},
			{"contractSerialno","合同号"},
			{"customerId","客户编号"},
			{"customerName","客户姓名"},
			{"statusName","状态"},
			{"status","状态"},
			{"applicant","销售员ID"},
			{"applicantName","销售员姓名"},
			{"inputeBy","申请人ID"},
			{"inputeByName","申请人"},
			{"applicantDate","申请时间"},
			{"approver","审批人"},
			{"approverName","审批人"},
			{"approverDate","审批时间"}
		   }; 

	String sSql ="select r.serialno as serialno,r.contract_serialno as contractSerialno,r.customer_id as customerId, "
		    +" r.customer_name as customerName,r.applicant as applicant,getusername(r.applicant) as applicantName,  "
			+"r.inpute_by as inputeBy,getusername(r.inpute_by) as inputeByName, r.applicant_date as applicantDate, "
		    +" r.status as status ,decode(r.status,'1','待审批','2','审批中','3','已审批',4,'拒绝')  as statusName,r.approver as approver ,getusername(r.approver) as approverName,r.approver_date as approverDate "
		    +" from Acct_Payment_Reversion r "
		    +" ";
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);
	 doTemp.setHeader(sHeaders);	
	 doTemp.setKey("serialNo", true);
	 doTemp.setVisible("serialno,status,approver,inputeBy", false);
	 doTemp.setCheckFormat("applicantDate,approverDate", "3");
	 doTemp.setHTMLStyle("applicantDate,approverDate"," style={width:140px} "); 
	 doTemp.setColumnAttribute("contractSerialno,customerId,customerName,status,applicant,applicantName,applicantDate,approver,approverDate","IsFilter","1");
	 
	 doTemp.setDDDWCodeTable("status", "2,审核中,3,已审核,4,拒绝");
	 
	 doTemp.setFilter(Sqlca, "0010", "status", "Operators=EqualsString;");
     doTemp.setFilter(Sqlca, "0020", "contractSerialno", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0031", "applicant", "Operators=EqualsString;");
	 doTemp.setFilter(Sqlca, "0030", "applicantName", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0040", "customerId", "Operators=EqualsString;");
	 doTemp.setFilter(Sqlca, "0041", "customerName", "Operators=EqualsString,BeginsWith;");
	 doTemp.setFilter(Sqlca, "0050", "applicantDate", "Operators=EqualsString,BeginsWith;");
	 
	 
	 doTemp.parseFilterData(request,iPostChange);
	 
	 doTemp.multiSelectionEnabled=true;
	 for(int k=0; k<doTemp.Filters.size(); k++){
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
	 if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and r.status='2' ";
	 
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(10);
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//新增参数传递：2013-5-9
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
				{"true","","Button","预览","预览","view()",sResourcesPath},
				{"true","","Button","同意","同意","approver(3)",sResourcesPath},
				{"true","","Button","拒绝","拒绝","approver(4)",sResourcesPath},
				{"true","","Button","导出EXCEL","导出EXCEL","exportExcel()",sResourcesPath},

			};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function approver(submitType){
		var sSerialNo = getItemValueArray(0,"serialno");
// 		sSerialNoS = sSerialNoS.split(",");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		var status = getItemValueArray(0,"status");
		for(var j=0;j<status.length;j++){
			if(status[j]!="2"){
				alert("选择的项中有已审批或拒绝的申请，请重新选择！");
				return;
			}
		}
		if(!confirm("您真的确定执行审批选中的申请吗")){
			return;
		}
		var userId = '<%=CurUser.getUserID() %>';
		var revisionSerialnos ="userId="+userId+",submitType="+submitType+",revisionSerialnos=";
		for(var i=0;i<sSerialNo.length;i++){
			revisionSerialnos+= sSerialNo[i]+"|";
		}
		 revisionSerialnos = revisionSerialnos.substring(0,revisionSerialnos.length-1)
		 RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.PayMentRevisionSchedule","approver",revisionSerialnos);
		 if(submitType==3){
		  alert("审批通过！");
		 }else if(submitType==4){
		  alert("操作成功！");
		 }
		 reloadSelf();
	}
	
	function view(){
		var sSerialNo = getItemValueArray(0,"serialno");
		var contractSerialno = getItemValueArray(0,"contractSerialno");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length!=1){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		var sCompID = "CreditTab";
		var sCompURL = "/BusinessManage/QueryManage/PayMentRevisionScheduleView.jsp";
		var sParamString = "revisionSerialNo="+sSerialNo+"&ObjectNo="+contractSerialno;
		openComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	
	function exportExcel(){
		amarExport("myiframe0");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
// 	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

