<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "交易记录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	String objectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));//对象编号
	String objectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));//对象类型
	if(objectNo == null)objectNo = "";
	if(objectType == null)objectType = "";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "Acct_Transaction";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
    //增加过滤器	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(20);
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(objectNo+","+objectType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
			{"true", "", "Button", "交易详情", "交易详情","viewLoanRecord()",sResourcesPath},
			{"true", "", "Button", "分录详情", "分录详情","viewSubjectRecord()",sResourcesPath},
	};
	%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=查看及修改交易详情;InputParam=无;OutPutParam=无;]~*/
	function viewLoanRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		var sDocumentType = getItemValue(0,getRow(),"DocumentType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		if(typeof(sDocumentType)=="undefined" || sDocumentType.length==0) {
			alert("此类交易没有详情信息！")
		}else{
		   	OpenComp("TransactionInfo","/Accounting/Transaction/TransactionInfo.jsp","ObjectNo="+sSerialNo+"&ObjectType="+sObjectType+"&ToInheritObj=y","_blank","");	
		}
	}
	
	/*~[Describe=查看及修改分录详情;InputParam=无;OutPutParam=无;]~*/
	function viewSubjectRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else 
		{
		    OpenComp("LoanDetailList","/Accounting/LoanDetail/LoanDetailList.jsp","TransSerialNo="+sSerialNo,"_blank","");	
		}
	}
</script>


<script type="text/javascript">	



	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	

<%@ include file="/IncludeEnd.jsp"%>
