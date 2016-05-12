<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 查询代码对应名称
		Input Param:
			CodeType：字段名称
			ItemNo : 选中的值
		Output Param:
		HistoryLog:   
			
	 */
	%>
<%/*~END~*/%> 

<%	
    String  sReturnValue = "";
	ASResultSet rs = null;
	//定义变量 
	
	//获取页面参数：
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sProductType   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductType"));
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	if(sProductType == null) sProductType = "";
	
		rs = Sqlca.getASResultSet("select itemname from code_library where codeno='AreaCode' and exists (select AreaCode from ProvidersCity where ProvidersCity.AreaCode=code_library.itemno and SerialNo='"+sSerialNo+"' and ProductType='"+sProductType+"')");
		while (rs.next()){
			sReturnValue+=","+rs.getString("itemname");
		}
		rs.getStatement().close();
	 ARE.getLog().debug("名字"+sReturnValue);
		
	if(!"".equals(sReturnValue))
	 	sReturnValue = sReturnValue.substring(1);
%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%@ include file="/IncludeEndAJAX.jsp"%>