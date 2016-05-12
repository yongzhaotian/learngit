<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  xjzhao 2009/12/29
		Tester:
		Describe:
		Input Param:
				ObjectNo 对象编号
				ObjectType 对象类型
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "跨行转账列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String readOnlyStr = "ToInheritObj=Y&RightType=ReadOnly&";
	
	//获得组件参数：对象类型、对象编号
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag")); //类型 0 经办 、1 复核
	String sFlowStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowStatus"));
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID"));
	if(sFlag == null)sFlag = "";
	if(sFlowStatus == null)sFlowStatus = "";
	if(sOrgID == null)sOrgID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//用sSql生成数据窗体对象
	String sTempletNo = "TransferDealList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo, sTempletFilter, Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	//增加过滤器	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sOrgID+","+sFlowStatus);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径
	String sButtons[][] = {
		{"false","","Button","新增","新增划款支付","newRecord()",sResourcesPath},
		{"false","","Button","取消支付","取消支付","deleteRecord()",sResourcesPath},
		{"false","","Button","详情","详情","view()",sResourcesPath},
		{"true","","Button","划款状态查询","划款状态查询","select()",sResourcesPath},
		{"false","","Button","提交复核","提交复核","doSubmit()",sResourcesPath},
		{"false","","Button","执行划款","执行划款","Send()",sResourcesPath},
		{"false","","Button","退回","退回","doNo()",sResourcesPath},
		{"false","","Button","取消放款","取消放款","flushCommitment()",sResourcesPath},
	};
	if("0".equals(sFlag))
	{
		sButtons[2][0] = "true";
		if("01".equals(sFlowStatus))
		{
			sButtons[0][0] = "true";
			sButtons[4][0] = "true";
			readOnlyStr = "";
		}
		else if("03".equals(sFlowStatus))
		{
			sButtons[3][0] = "true";
		}
		else if("04".equals(sFlowStatus))
		{
			sButtons[4][0] = "true";
			readOnlyStr = "";			
		}
	}
	else if("1".equals(sFlag))
	{
		sButtons[2][0] = "true";
		if("02".equals(sFlowStatus))
		{
			sButtons[3][0] = "true";
			sButtons[5][0] = "true";
			sButtons[6][0] = "true";
		}
		else if("03".equals(sFlowStatus))
		{
			sButtons[3][0] = "true";
		}
	}
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	/*~[Describe=新增;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		popComp("TransferDealInfo","/Accounting/Transaction/Inter-bankPaymentInfo.jsp","Type=0","");
		reloadSelf();
	}
	
	/*~[Describe=同意;InputParam=无;OutPutParam=无;]~*/
	function Send()
	{
		alert("划款执行待开发!");
	}
	
	/*~[Describe=查询;InputParam=无;OutPutParam=无;]~*/
	function select()
	{
		alert("划款状态查询待开发!");
	}
	
	/*~[Describe=查看详情;InputParam=无;OutPutParam=无;]~*/
	function view()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo"); //帐号流水号
		var sStatus = getItemValue(0,getRow(),"Status"); //账户状态
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			popComp("TransferDealInfo","/Accounting/Transaction/Inter-bankPaymentInfo.jsp","<%=readOnlyStr%>SerialNo="+sSerialNo,"dialogWidth=50;dialogHeight=50;");
			reloadSelf();
		}
	}
    
	/*~[Describe=删除;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
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
	
	
	/*~[Describe=提交复核;InputParam=无;OutPutParam=无;]~*/
	function doSubmit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		var sReturn = RunMethod("BusinessManage","UpdateTransferStatus",sSerialNo+",02");
		if(parseInt(sReturn) == 1)
		{
			alert("提交成功！");
			reloadSelf();
		}
	}
	
	/*~[Describe=退回;InputParam=无;OutPutParam=无;]~*/
	function doNo()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		var sReturn = RunMethod("BusinessManage","UpdateTransferStatus",sSerialNo+",04");
		if(parseInt(sReturn) == 1)
		{
			alert("提交成功！");
			reloadSelf();
		}
	}

	//放款冲账
	function flushCommitment(){
		var putoutNo = getItemValue(0,getRow(),"ObjectNo");
		var objectType = getItemValue(0,getRow(),"ObjectType");
		if(objectType=="BusinessPutout"){
			var serialNo = RunMethod("PutOutManage","SelectLoanSerialNo",putoutNo+","+contractSerialNo);
			if(typeof(serialNo)=="undefined"||serialNo.length==0){
				alert("请选择一条记录");
				return;
			}
			var sResult = RunMethod("LoanAccount","FlushCommitment",serialNo+",<%=CurUser.getUserID()%>");
			if(sResult=="true"){
				alert("放款冲账成功");
				reloadSelf();
			}else{
				alert(sResult);
				return;
			}
		}else{
			return;
		}
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>