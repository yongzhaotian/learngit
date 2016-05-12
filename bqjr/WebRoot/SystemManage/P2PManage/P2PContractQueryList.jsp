<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: Dahl 2015-3-19
		Tester:
		Describe: p2p查询
		
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
	String PG_TITLE = "p2p查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String  sP2pType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("p2pType"));
	String sExport = "false";	//默认查询未导出的p2p合同，默认查询时才把未导出的p2p合同设置导出时间
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sTempletNo = "P2PContractQueryList"; //模版编号
    ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//doTemp.setKeyFilter("SerialNo");
	
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	
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
	
	ARE.getLog().debug("--------------------p2pType:"+sP2pType);
	
	if( "AirtualStore".equals(sP2pType) ){	//借钱么虚拟门店的p2p合同
		//doTemp.WhereClause += " and RI.RNO = '4403000471' ";
		doTemp.WhereClause += " and BC.SURETYPE = 'JQM' ";
	}else if( "EBuyFun".equals(sP2pType) ){	//”易佰分“的商户编号为“4403000403”
		//doTemp.WhereClause += " and RI.RNO = '4403000403' ";
		doTemp.WhereClause += " and BC.SURETYPE = 'EBF' ";
	}else{	//普通消费贷的p2p合同
		//doTemp.WhereClause += " and RI.RNO <> '4403000471' ";	//不包含借钱么虚拟门店的p2p合同。
		//doTemp.WhereClause += " and RI.RNO <> '4403000403' ";	//不包含”易佰分“的商户编号为“4403000403”
		doTemp.WhereClause += " and BC.SURETYPE = 'PC' ";
	}
	
	//P2P合同 排除 合同状态为：新发生，审核中，审批通过，超期未注册，已取消，已否决,已撤消
	doTemp.WhereClause += " and BC.ContractStatus not in ('060','070','080','090','100','010','210')";
	
	//默认导出签署日期为昨天16:00到今天16:00的p2p合同
	if(!doTemp.haveReceivedFilterCriteria()){
		doTemp.WhereClause += " and BCO.P2P_EXPORT_TIME is null ";
		sExport = "true";	//默认查询，设为true
	}
	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
			{"true","","Button","导出","导出Excel","ExportExcel()",sResourcesPath},
	};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">

	//导出excel
	function ExportExcel(){
		amarExport("myiframe0"); //导出Excel 
		//设置p2p合同的导出时间    add by Dahl 2015-3-19s
		var sExport = "<%=sExport%>";
		if( "true" == sExport ){	//默认查询才调用。
			RunJavaMethodSqlca("com.amarsoft.proj.action.P2PCredit", "updateP2pExportTime","p2pType=<%=sP2pType%>");
		
		}
	}
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

