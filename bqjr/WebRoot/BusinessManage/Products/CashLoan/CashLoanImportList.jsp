<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "交叉现金贷活动维护";
	//获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	String sEventStatus =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EventStatus"));//活动状态
	if(sEventStatus==null) sEventStatus="";
	
	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("CashLoanRelativeList",Sqlca);
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","导入","导入","ContractImport()",sResourcesPath},
		{"true","","Button","客户详情","客户详情","viewtab()",sResourcesPath},
	};

	//未开始的活动
	if("01".equals(sEventStatus))
	{
		sButtons[0][0] = "true";
	}

%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~合同工详情~*/
	function viewtab(){
		var sCustomerID = getItemValue(0,getRow(),"CUSTOMERID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenComp("CustomerInfo","/CustomerManage/CustomerInfo.jsp","CustomerID="+sCustomerID+"&RightType=ReadOnly","_blank","");
	}
	
	function ContractImport(){
		var serialNo = "<%=sSerialNo%>";
		var sReturn  = RunMethod("公用方法","GetColValue","BUSINESS_CASHLOAN_RELATIVE,count(*),EVENTSERIALNO='"+serialNo+"'");
		if(typeof(sReturn)!="undefined"&&parseInt(sReturn)>0){
			if(!confirm("已存在客户数据，是否重新导入？")){
				return;
			}
		}
		//文件上传
		AsControl.PopView("/BusinessManage/Products/CashLoan/CashLoanImportInfo.jsp", "ObjectNo="+serialNo, "dialogWidth=450px;dialogHeight=250px;resizable=no;scrollbars=no;status:no;maximize:no;help:no;");
		reloadSelf();
	}
	
	$(document).ready(function(){
		hideFilterArea();
		AsOne.AsInit();
		init();
		my_load_show(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>