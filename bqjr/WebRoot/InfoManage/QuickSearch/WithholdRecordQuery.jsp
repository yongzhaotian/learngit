<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 发起再次代扣
		Input Param:
			ObjectType:
			ObjectNo:
			SerialNo：业务流水号
		Output Param:
			SerialNo：业务流水号
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "再次代扣申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sBusinessDate=SystemConfig.getBusinessDate();

	//获得页面参数

	//获得组件参数
	String sCustomerID = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID")));
	
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	     	
		String sTempletNo = "withholdRecordQuery"; //模版编号
	    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		
		//生成新的from
	//	doTemp.FromClause = "from (select '代扣' as path,substr(serialno, 17, 8) as customerid,inputdate,payamt,replaceaccount,OPENBANKNAME,REPLACENAME as PAYACCOUNTNAME, manageresultmessage as withholdresult,"+
	//						"'易办事' as Channel from import_file_ebu ife where not exists (select 1 from import_reconciliation_ebu ire where ife.serialno = ire.serialno)  "+
	//						"union all select '代扣' as path, substr(serialno, 17, 8) as customerid, inputdate, payamt,replaceaccount, OPENBANKNAME,REPLACENAME as PAYACCOUNTNAME, '交易成功' as withholdresult,"+
	//						" '易办事' as Channel  from import_file_ebu ife  where ife.managereturncode='0000' and exists (select 1 from import_reconciliation_ebu ire where ife.serialno = ire.serialno) "+
	//						"union all select '代扣' as path, substr(ifk.additioninformation, 1, 8) as customerid, ifk.inputdate, ifk.payamt, replaceaccount, "+
	//						"(select a.bankname from bankput_info a where a.bankno=trim(ifk.payopenbankid)) as OPENBANKNAME,PAYACCOUNTNAME, bankreturnremark as withholdresult, "+
	//						"'快付通' as Channel from import_file_kft ifk union all select '银企直连' as path, (case when (bli.customerid is not null and bli.updatedate is not null) then "+
    //                        "bli.customerid else bli.frmcod end) as customerid,(case when (bli.customerid is not null and bli.updatedate is not null) then "+
    //              			"bli.updatedate else bli.inputdate end)as inputdate, "+
	//						"bli.trsamtc as payamt, bli.rpyacc as replaceaccount, bli.rpybnk as OPENBANKNAME,rpynam as PAYACCOUNTNAME, "+
	//						"(case when (bli.customerid is not null and bli.updatedate is not null) then '手工匹配' else '系统导入' end) as withholdresult, '' as Channel from bank_link_info bli)";
		//生成查询框
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		
		
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
		dwTemp.setPageSize(16);  //服务器分页

		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		//{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
		{"true","","Button","导出EXCEL","导出EXCEL","EXCEL()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; 
	
	/*~[Describe= 保存;InputParam=无;OutPutParam=SerialNo;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}
		
		if(!vI_all("myiframe0")) return;
		as_save("myiframe0",sPostEvents);
	}
	
	//导出EXECL
	function EXCEL(){
		amarExport("myiframe0");
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0){//如当前无记录，则新增一条
			as_add("myiframe0");
		
			setItemValue(0, 0, "accountingorgid", "<%=CurOrg.orgID %>");
			setItemValue(0, 0, "digest", "<%=CurUser.getUserID()%>");
			setItemValue(0, 0, "payaccountorgid1", "<%=SystemConfig.getBusinessTime()%>");
			
			bIsInsert = true;
		}
	} 
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
		//initRow();
	});

</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
