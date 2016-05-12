<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
	<%
	String PG_TITLE = "资产转让协议详情页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得页面参数	：
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//协议编号
	String sRelaSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelaSerialNo"));//申请流水号
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	
	if(sTransferType==null) sTransferType="";
	if(sSerialNo==null) sSerialNo="";
	if(sRelaSerialNo==null) sRelaSerialNo="";
	if(sApplyType==null) sApplyType="";

	
	// 通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("TransferDealSelectInfo",Sqlca);//交易定义详情模板
	
	doTemp.setReadOnly("IsFlag,RivalName,CreditMan,RivalNo", true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly="0";
	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sRelaSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存","SaveRecord()",sResourcesPath},
		{"true","","Button","汇总 ","汇总","ComputeSum()",sResourcesPath},
		{"false","","Button","返回","返回","goBack()",sResourcesPath},
	};
	
	if(!"0010".equals(sTransferType)){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
	}
	%> 

<%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>

	// 返回交易列表
	function goBack()
	{
		self.close();
	}
	
	function SaveRecord()
	{
		if("" =="<%=sRelaSerialNo%>"){
			as_save("myiframe0","updateGroupInfo()");
		}else{
			as_save("myiframe0");
		}
	}
	
	function updateGroupInfo(){
		var sSerialNo = getItemValue(0,0,"SerialNo");
		var userID = "<%=CurUser.getUserID()%>";
		RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AddProperTySelectInfo","updateGroupInfo","RelaSerialNo="+"<%=sSerialNo%>"+",ObjectNo="+sSerialNo+",UserID="+userID);
	}
	
	function ComputeSum(){
		var sSerialNo = getItemValue(0,0,"SerialNo");
		var DealSum = getItemValue(0,0,"DealSum");
		var ApplyNo =  getItemValue(0,0,"SerialNo");
		if(typeof(DealSum)=="undefined"||DealSum==""){
			alert("请输入转让金额");
			return;
		}
		var count = RunMethod("公用方法","GetColValue","DEALCONTRACT_REATIVE,COUNT(*),SERIALNO='"+ApplyNo+"'");
		if(typeof(count)!="undefined"&&parseInt(count)==0){
			alert("请在下方导入合同信息");	
			return ;
		}
		var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AddProperTySelectInfo","updateSelectInfo","RelaSerialNo="+sSerialNo+",BusinessSum="+DealSum);
		sReturn = sReturn.split("@");
		if(sReturn[0]=="success"){
			setItemValue(0,0,"TotalSum",sReturn[1]);
			setItemValue(0,0,"TotalNum",sReturn[2]);
			//setItemValue(0,0,"TransferRate",sReturn[3]);
			alert("汇总成功");
		}else{
			alert(sReturn);
		}
		
	}
	
	function initPage(){
		var sSerialNo = getItemValue(0,0,"SerialNo");
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealImportList.jsp","SerialNo="+"<%=sSerialNo%>"+"&RelaSerialNo="+sSerialNo,"rightdown","");
	}
	
	function initRow(){
		as_add("myiframe0");
		if("" =="<%=sRelaSerialNo%>"){
			var sSerialNo = getSerialNo("TRANSFER_GROUP","SERIALNO");
			setItemValue(0,0,"SerialNo",sSerialNo);
			var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AddProperTySelectInfo","getAgreementInfo","RelaSerialNo="+"<%=sSerialNo%>");
			sReturn = sReturn.split("@");
			setItemValue(0,0,"RivalNo",sReturn[1]);
			setItemValue(0,0,"IsFlag",sReturn[2]);
			setItemValue(0,0,"RivalSerialNo",sReturn[3]);
			setItemValue(0,0,"RivalName",sReturn[4]);
			setItemValue(0,0,"CreditMan",sReturn[5]);
			setItemValue(0,0,"TrustCompaniesSerialNo",sReturn[6]);
			setItemValue(0,0,"EffectiveDate",sReturn[7]);
			setItemValue(0,0,"MaturityDate",sReturn[8]);
			
			setItemValue(0,0,"InterestRate",sReturn[9]);
			setItemValue(0,0,"IsTransfer",sReturn[10]);
			setItemValue(0,0,"TransferType",sReturn[11]);
			setItemValue(0,0,"DealStatus",sReturn[12]);
			setItemValue(0,0,"ActualDate",sReturn[13]);
			setItemValue(0,0,"IsRight",sReturn[14]);
			setItemValue(0,0,"AssetType",sReturn[15]);
			setItemValue(0,0,"TransferRate",sReturn[16]);
			
			setItemValue(0,0,"ManageRate",sReturn[17]);
			setItemValue(0,0,"RightsMade",sReturn[18]);
			setItemValue(0,0,"ApplyType","<%=sApplyType%>");
			setItemValue(0,0,"SignDate",sReturn[19]);
			
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}else{
			setItemValue(0,0,"UpdateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
	}
	
</script>	

<script language=javascript>
$(document).ready(function(){
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
	initPage();
});
</script>	

<%@ include file="/IncludeEnd.jsp"%>
