<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%
	String PG_TITLE = "费用列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String businessType = "";
	String projectVersion = "";
	
	//获得组件参数	
	
	//获得页面参数
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String status = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("Status")));//状态
	String sTransCode = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("TransCode")));//交易编号
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sTransCode == null || "".equals(sTransCode)) sTransCode = " ";
	
	BusinessObject businessObject = AbstractBusinessObjectManager.getBusinessObject(sObjectType, sObjectNo,Sqlca);
	if(businessObject != null)
	{
		businessType = businessObject.getString("BusinessType");
		projectVersion = businessObject.getString("ProductVersion");
	}else
	{
		throw new Exception("对象【"+sObjectType+".+"+sObjectNo+"】不存在！");
	}
	

	//显示模版编号
	String sTempletNo = "AcctFeeList";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.WhereClause += " and Status in('"+status.replaceAll("@","','")+"')";
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "1"; //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo+","+businessObject.getObjectType());
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));
	

	//依次为：
			//0.是否显示
			//1.注册目标组件号(为空则自动取当前组件)
			//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
			//3.按钮文字
			//4.说明文字
			//5.事件
			//6.资源图片路径
	String sButtons[][] = {
			{"true", "All", "Button", "新增", "新增一条信息","createFee()",sResourcesPath},
			{"true", "All", "Button", "删除", "删除一条信息","deleteRecord()",sResourcesPath},
			{"true", "", "Button", "详情", "费用详情","viewFee()",sResourcesPath},
			{"false", "", "Button", "费用收取", "费用收取","FeeTransaction('3508')",sResourcesPath},
			{"false", "", "Button", "费用支付", "费用支付","FeeTransaction('3520')",sResourcesPath}
	};
	
	if(sObjectType.equals("PutOutApply")){
		sButtons[0][1]="false";
		sButtons[1][1]="false";
	}
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script language=javascript>
	/*~[Describe=新建费用;InputParam=无;OutPutParam=无;]~*/
	function createFee(){
		var returnValue = setObjectValue("SelectTermLibrary","TermType,FEE,ObjectType,Product,ObjectNo,<%=businessType+"-"+projectVersion%>,TransCode,<%=sTransCode%>","",0,0,"");
		if(typeof(returnValue)=="undefined" || returnValue=="" || returnValue=="_CANCEL_" || returnValue=="_CLEAR_") return;
		
		var sTermID = returnValue.split("@")[0];
		
		var sReturn = RunMethod("LoanAccount","CreateFee",sTermID+",<%=businessObject.getObjectType()%>,<%=sObjectNo%>,<%=CurUser.getUserID()%>");
		reloadSelf();
	}
	
	function viewFee(){
		var feeSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(feeSerialNo)=="undefined"||feeSerialNo.length==0){
			alert("请选择一条记录");
			return;
		}
		popComp("AcctFeeInfo","/Accounting/LoanDetail/LoanTerm/AcctFeeInfo.jsp","FeeSerialNo="+feeSerialNo,"");
		reloadSelf();
	}
	
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("确定删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=费用交易;InputParam=无;OutPutParam=无;]~*/
	function FeeTransaction(transCode){
		var feeSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(feeSerialNo) == "undefined" || feeSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		var transactionSerialNo = RunMethod("LoanAccount","CheckExistsTransaction","<%=BUSINESSOBJECT_CONSTATNTS.fee%>,"+feeSerialNo+","+transCode+"");
		if(typeof(transactionSerialNo)=="undefined" || transactionSerialNo.length==0||transactionSerialNo=="Null") {
			//创建不需要流程的交易
			var returnValue = RunMethod("LoanAccount","CreateTransaction",","+transCode+",<%=BUSINESSOBJECT_CONSTATNTS.fee%>,"+feeSerialNo+",,<%=CurUser.getUserID()%>,2");
			returnValue = returnValue.split("@");
			transactionSerialNo = returnValue[1];
			if(typeof(transactionSerialNo) == "undefined" || transactionSerialNo.length == 0){
				alert("创建交易{"+transCode+"}时失败！错误原因为："+returnValue);
				return;
			}
		}
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=Transaction&ObjectNo="+transactionSerialNo+"&ViewID=000";
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		if(confirm("请确认是否进行入账处理！"))
		{
			var returnValue = RunMethod("LoanAccount","RunTransaction2",transactionSerialNo+",<%=CurUser.getUserID()%>,Y");
			if(typeof(returnValue)=="undefined"||returnValue.length==0){
				alert("系统处理异常！");
				return;
			}
			var message=returnValue.split("@")[1];
			alert(message);
			reloadSelf();
		}
	}
	
	
	//初始化
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>