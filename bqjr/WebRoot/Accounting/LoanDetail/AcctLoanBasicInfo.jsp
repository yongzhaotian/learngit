<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
		String PG_TITLE = "��ݻ�����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>

		String templetFilter="1=1";
		String templetNo;
		//����������
		
		//���ҳ�����
		String SerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));//��ݱ��
		if(SerialNo == null)SerialNo = "";

		String sTemplete = "ACCT_LOAN";
	    ASDataObject doTemp = new ASDataObject(sTemplete,Sqlca);
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      //����ΪFreeform���
		dwTemp.ReadOnly = "1"; //����Ϊֻ��
		
		//��ģ��Ӧ����Datawindow
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
	/*~[Describe=������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function calcLoanRateTermID(){
		var sLoanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
		if(typeof(sLoanRateTermID) == "undefined" || sLoanRateTermID.length == 0) return;
		var currency = getItemValue(0,getRow(),"CurrencyCode");
		var sPutoutDate = getItemValue(0,getRow(),"PutOutDate");
		var sMaturityDate = getItemValue(0,getRow(),"MaturityDate");
		var termMonth = RunMethod("BusinessManage","GetUpMonths",sPutoutDate+","+sMaturityDate);

		OpenComp("BusinessTermView","/Accounting/LoanDetail/LoanTerm/BusinessTermView.jsp","Currency="+currency+"&ToInheritObj=y&termMonth="+termMonth+"&Status=1&ObjectNo="+"<%=SerialNo%>"+"&ObjectType="+"<%=BUSINESSOBJECT_CONSTATNTS.loan%>"+"&TempletNo=RateSegmentView&TermObjectType="+"<%=BUSINESSOBJECT_CONSTATNTS.loan_rate_segment%>"+"&TermID="+sLoanRateTermID,"RatePart","");
	}
	/*~[Describe=���ʽ��Ϣ;InputParam=��;OutPutParam=��;]~*/
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
