<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: 客户信息检查
		Input Param:
			                
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%

	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sItems         = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Items"));
	
	//out.println(sCustomerID+"@"+sItems+"@"+sSerialNoAll);
	String sSignalType = "",sSerialNo="",sReturnValue="";
	String Today=StringFunction.getToday();
	int num=Integer.parseInt(StringFunction.getSeparate(sItems,"@",1));
	try{
		Sqlca.executeSQL(new SqlObject("delete from RISK_SIGNAL where ObjectType='Customer' and ObjectNo=:ObjectNo ").setParameter("ObjectNo",sCustomerID));
		for (int j=1;j<=num;j++)
		{
			sSignalType= StringFunction.getSeparate(sItems,"@",j+1) ;
			sSerialNo = DBKeyHelp.getSerialNo("RISK_SIGNAL","SerialNo",Sqlca);
			String sNewSql = "insert into RISK_SIGNAL(ObjectType,ObjectNo,SerialNo,SignalType,InputOrgID,InputUserID,InputDate,UpdateDate) values('Customer',:ObjectNo,:SerialNo,:SignalType,:InputOrgID,:InputUserID,:InputDate,:UpdateDate) ";
			SqlObject so = new SqlObject(sNewSql);
			so.setParameter("ObjectNo",sCustomerID);
			so.setParameter("SerialNo",sSerialNo);
			so.setParameter("SignalType",sSignalType);
			so.setParameter("InputOrgID",CurUser.getOrgID());
			so.setParameter("InputUserID",CurUser.getUserID());
			so.setParameter("InputDate",Today);
			so.setParameter("UpdateDate",Today);
			Sqlca.executeSQL(so);
		}
		sReturnValue="true";
		out.println("修改预警信号风险提示成功！");
	}catch(Exception e){
		e.fillInStackTrace();
		sReturnValue="false";
	}
	
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
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>