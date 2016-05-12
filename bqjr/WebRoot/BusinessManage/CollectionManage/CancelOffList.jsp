<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CancelOffList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=true;//设置可多选

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","核销","核销","viewAndEdit()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">	

	function viewAndEdit(){
		var sSerialnos = getItemValueArray(0,"LoanSerialno");//获取选中的多条记录ID			
		if (typeof(sSerialnos)=="undefined" || sSerialnos.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		//获取借据号
		var idstring = sSerialnos.toString();
		var re =/,/g; 
		idstring = idstring.replace(re,"@");
		var str=new Array();
		str=idstring.split("@");
		
		var Loan="";
		var TransactionLoan="";
		var j=0;
		var transactionCode ="0080";
		var relativeObjectType = "jbo.app.ACCT_LOAN";
		var relativeObjectNo = "";
		var transactionDate="";
		var objectType="TransactionApply";
		var returnValue ="";
		var transactionSerialNo="";
		if(confirm("您真的想核销该信息吗？")){
			for(i=0;i<str.length;i++){
				LoanSerialno=str[i];
				relativeObjectNo = LoanSerialno;
				
				returnValue = RunMethod("LoanAccount","CreateTransaction",objectType+","+transactionCode+","+relativeObjectType+","+relativeObjectNo+","+transactionDate+",<%=CurUser.getUserID()%>");
				if(returnValue.substring(0,5) != "true@") {
					alert("借据"+LoanSerialno+"核销失败！错误原因-"+returnValue);
					continue;
				}
				
				returnValue = returnValue.split("@");
				transactionSerialNo = returnValue[1];
				if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
					alert("借据"+LoanSerialno+"核销失败！错误原因-"+returnValue);
					continue;
				}
				if(j==0){
					Loan += LoanSerialno;
					TransactionLoan += transactionSerialNo;		
				}else{
					Loan += "@"+LoanSerialno;
					TransactionLoan += "@"+transactionSerialNo;
				}
				j++;
			
			}
			
			var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.CancelOffList","updateLoanInfo","Loan="+Loan+",TransactionLoan="+TransactionLoan);
			if(sReturn=="SUCCESS"){
				alert("核销成功!");
				reloadSelf();
			}	
		} 
	}
	


	$(document).ready(function(){
		showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>