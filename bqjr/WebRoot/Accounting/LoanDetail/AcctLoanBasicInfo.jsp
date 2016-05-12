<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
		String PG_TITLE = "借据基本信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

		String templetFilter="1=1";
		String templetNo;
		//获得组件参数
		
		//获得页面参数
		String SerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));//借据编号
		if(SerialNo == null)SerialNo = "";

		String sTemplete = "ACCT_LOAN";
	    ASDataObject doTemp = new ASDataObject(sTemplete,Sqlca);
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      //设置为Freeform风格
		dwTemp.ReadOnly = "1"; //设置为只读
		
		//将模版应用于Datawindow
		templetNo=sTemplete;
		dwTemp.setHarborTemplate(DWExtendedFunctions.getDWDockHTMLTemplate(sTemplete, Sqlca));
		
		Vector vTemp = dwTemp.genHTMLDataWindow(SerialNo);
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

		String sButtons[][] = {
		};
	%> 

<%@include file="/Resources/CodeParts/Info05.jsp"%>

<script language=javascript>
	function afterLoad()
	{
		calcLoanRateTermID();
		calcRPTTermID();
	}
	/*~[Describe=利率信息;InputParam=无;OutPutParam=无;]~*/
	function calcLoanRateTermID(){
		var sLoanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
		if(typeof(sLoanRateTermID) == "undefined" || sLoanRateTermID.length == 0) return;
		var currency = getItemValue(0,getRow(),"CurrencyCode");
		var sPutoutDate = getItemValue(0,getRow(),"PutOutDate");
		var sMaturityDate = getItemValue(0,getRow(),"MaturityDate");
		var termMonth = RunMethod("BusinessManage","GetUpMonths",sPutoutDate+","+sMaturityDate);

		OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","Currency="+currency+"&ToInheritObj=y&termMonth="+termMonth+"&Status=1&ObjectNo="+"<%=SerialNo%>"+"&ObjectType="+"<%=BUSINESSOBJECT_CONSTATNTS.loan%>"+"&TempletNo=RateSegmentView&TermObjectType="+"<%=BUSINESSOBJECT_CONSTATNTS.loan_rate_segment%>"+"&TermID="+sLoanRateTermID,"RatePart","");
	}
	/*~[Describe=还款方式信息;InputParam=无;OutPutParam=无;]~*/
	function calcRPTTermID(){
		var sRPTTermID = getItemValue(0,getRow(),"RPTTermID");
		if(typeof(sRPTTermID) == "undefined" || sRPTTermID.length == 0) return;
		OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","ToInheritObj=y&Status=1&ObjectNo=<%=SerialNo%>&ObjectType=<%=BUSINESSOBJECT_CONSTATNTS.loan%>&TempletNo=RPTSegmentView&TermObjectType=<%=BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment%>&TermID="+sRPTTermID,"RPTPart","");
	}
	
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	afterLoad();
</script>	


<%@ include file="/IncludeEnd.jsp"%>
