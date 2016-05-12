<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "催收任务逾期合同列表界面";
	//获得页面参数
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	
	if(sCustomerID==null) sCustomerID="";
	

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ConsumeOverDuelContractList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setHTMLStyle("CUSTOMERID", "style={width:80px}");
	doTemp.setHTMLStyle("CustomerName","style={width:100px} ");  
	doTemp.setHTMLStyle("BusinessSum","style={width:80px} ");  
	doTemp.setHTMLStyle("PayinteAmt","style={width:80px} ");  
	doTemp.setHTMLStyle("BUSINESSNAME","style={width:100px} ");  
	doTemp.setHTMLStyle("company","style={width:100px} ");  
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		  {"true","","Button","合同详情","合同详情","contractDetail()",sResourcesPath},
		  {"false","","Button","案件延期","案件延期","yanDate()",sResourcesPath},
		  {"false","","Button","再次代扣","再次代扣","BatchLasCore()",sResourcesPath}
	};
	
	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	//再次代扣
	function BatchLasCore(){
		var sPayinteAmt = getItemValue(0,getRow(),"PayinteAmt");//逾期余额
		var sPutoutNo = getItemValue(0,getRow(),"PutoutNo");//合同号
		var sSerialNo = getSerialNo("Batch_las_core","SerialNo","");//生成流水号
		var myDate = "<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>";//获取日期
		
		if (typeof(sPutoutNo)=="undefined" || sPutoutNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("你确定要发起代扣吗？")){
			//查询该笔合同还款方式是否是代扣
			var sRepaymentWay=RunMethod("BusinessManage","GetRepaymentWay",sPutoutNo);
			if(sRepaymentWay==1){//代扣
				//查询合同是否做过代扣
				var flag=RunMethod("BusinessManage","SelectBatchLasCore",myDate+","+sPutoutNo);
			     //alert("-----"+flag);
				if(flag =="Null"){
					//执行插入方法
					RunMethod("BusinessManage","InsertBatchLasCore",myDate+","+sSerialNo+","+sPutoutNo+","+"jbo.app.ACCT_LOAN"+","+sPayinteAmt);
					alert("发起代扣完成！");
				}else{
					alert("此合同今天已发起过代扣，请检查！");
				}
			
			}else{//非代扣
				alert("此合同还款方式是非代扣，无法发起代扣！");
			}
			
			reloadSelf();//刷新
		}
	}
	

	//add  wlq  案件是否延期    20140725  --
	function yanDate(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sCaseDelay = getItemValue(0,getRow(),"CaseDelay");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(sCaseDelay=="2"){
			if(confirm("你确定要延期吗？")){
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,CaseDelay='1',serialno='"+sSerialNo+"'");
				reloadSelf();
			}
		}else{
			if(confirm("你确定不用延期吗？")){
				RunMethod("ModifyNumber","GetModifyNumber","business_contract,CaseDelay='2',serialno='"+sSerialNo+"'");
				reloadSelf();
			}
		}	
	}
	
    //合同详情
	function contractDetail(){
		var sSerialNo = getItemValue(0,getRow(),"PutoutNo");
		sObjectType="BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}
	

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
