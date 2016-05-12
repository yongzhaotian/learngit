<%@ page contentType="text/html; charset=GBK"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%@page import="com.amarsoft.are.ARE"%>
<%@page import="com.amarsoft.are.lang.DataElement"%>
<%@page import="com.amarsoft.oti.*"%>
<%@page import="com.amarsoft.are.jbo.*"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
	/* Author:   djia  2009.08.03
	 * Tester:
	 * Content: 到核心查询借据余额信息
	 * Input Param:
	 * 		SerialNo：借据号
	 * 		OrgID：机构代码
	 * Output param:
	 *      sReturn: 交易结果	 
	 * History Log: 
	 */
	%>
<%/*~END~*/%>


<% 	
	OTIManager manager = null;
	OTIConnection conn = null;
	OTITransaction trans = null;
    TXResult result = null;
	String sReturn = "";
	String sReturnValue="";
	
	//获得页面参数	
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); 		
	//将空值转化为空字符串
	if(sSerialNo == null) sSerialNo = "";
	
	try {
		manager = OTIManager.getManager();
		//获取连接
		conn = manager.getConnectionInstance("CoreBankingClient");
		conn.open();
		//获取交易
		ARE.getLog().trace("tradeNo:"+"Q002");
		trans = manager.getTransactionInstance("Q002");
		ARE.getLog().trace("paraWhere="+" SerialNo = '"+sSerialNo+"'");
		trans.initRequestBody("select R.SerialNo from jbo.oti.JYBody R where R.SerialNo = '"+sSerialNo+"'");
		
		//初始化报文头
		DataElement de	= null;
		BizObject bo = trans.getRequestHeader();
		
		de = bo.getAttribute("TradeNo");
		de.setValue("Q002");
		
		//发送交易
		result = conn.executeTransaction(trans);
		ARE.getLog().trace(result.toString());		
	}catch(TXException e){
		e.printStackTrace();
		ARE.getLog().debug(e);
		throw new Exception("错误，请检查与核心的交互连接。");
	}
	
	if(result.getStatus() == 0){
		//成功
		TXMessageBody responsBody = trans.getResponseBody();
		BizObject bo = null;
		if(responsBody != null)
			ARE.getLog().trace("反馈报文体长度："+responsBody.size());
			for(int i=0; i<responsBody.size();i++){
				//获取反馈报文体中的第i条记录
				bo = responsBody.getObject(i);
				String d = bo.getAttribute("Balance").getString();
				sReturn = "0@"+d;
			}
	}else{
		//失败
		sReturn = "1@"+result.getMessage();
	}

%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturn);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>