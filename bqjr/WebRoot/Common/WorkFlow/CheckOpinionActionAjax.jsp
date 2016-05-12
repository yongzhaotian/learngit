<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-17
		Tester:
		Describe: 检查意见是否签署，一般在任务提交前检查
		Input Param:
			SerialNo:任务流水号
		Output Param:
		HistoryLog:zywei 2005/08/01
			
	 */
	%>
<%/*~END~*/%> 


<% 
	//获取参数：任务流水号
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sReturnValue="";
	SqlObject so = null;
	//将空值转化成空字符串
	if(sSerialNo == null) sSerialNo = "";
	
	//定义变量：SQL语句、意见详情
	String sSql = "",sPhaseOpinion = "";
	
	//根据任务流水号从流程意见记录表中查询签署的意见
	sSql = "select PhaseOpinion from FLOW_OPINION where SerialNo=:SerialNo ";
	so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo);
	sPhaseOpinion = Sqlca.getString(so);
	//将空值转化成空字符串
	if (sPhaseOpinion == null) {
		sPhaseOpinion = "";
	}else{ 
		sPhaseOpinion = "已经签署意见";//防止有回车传输出错
	}
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sPhaseOpinion);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>

<%@ include file="/IncludeEndAJAX.jsp"%>
