<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Frame00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-6
		Tester:
		Describe: 
		Input Param:
			ObjectType: 对象类型(业务阶段)。
			ObjectNo: 对象编号（申请/批复/合同流水号）。
			ContractType: 合同类型
				010 一般担保信息
				020 最高额担保合同
		Output Param:
			ObjectType: 对象类型(业务阶段)。
			ObjectNo: 对象编号（申请/批复/合同流水号）。
			ContractType: 担保类型
				010 一般担保信息
				020 最高额担保合同
		HistoryLog:
			2005-08-07 王业罡  整合页面，将担保合同列表的展现都在一个页面中实现
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Frame02;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Frame02.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Frame03;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	<%
		String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
		String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		String sContractType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractType"));	
	%>
		OpenPage("/CreditManage/CreditPutOut/AssureList.jsp","rightup","");
		OpenPage("/Blank.jsp?TextToShow=请在上方列表中选择一条担保合同信息","rightdown","");
	</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
