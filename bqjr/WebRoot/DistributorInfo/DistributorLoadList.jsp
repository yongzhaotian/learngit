<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 库存借款管理
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "库存借款管理 "; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "DistributorLoadList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	 doTemp.setColumnAttribute("entErpriseName,artificialNO","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//新增参数传递：2013-5-9
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
		{"true","","Button","新增经销商借款","新增经销商借款","newRecord()",sResourcesPath},
		{"true","","Button","查看/修改借款详情","查看/修改借款详情","modifyDetail()",sResourcesPath},	
		{"true","","Button","文件上传和扫描","文件上传和扫描","d()",sResourcesPath},
		//{"true","","Button","手续费代扣","手续费代扣","ena()",sResourcesPath},
		{"true","","Button","手续费代扣","手续费代扣","SelectFeeRecieve()",sResourcesPath},
		{"true","","Button","启用放款","启用放款","enableLoad()",sResourcesPath},
		{"true","","Button","记账","记账","KeepAccounts()",sResourcesPath}	
	};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">	
	//记账、测试用
	function KeepAccounts(){
		//var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectNo = getItemValue(0,getRow(),"serialNo");
		var productID = getItemValue(0,getRow(),"BusinessType");
		/* if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} */
		var sReturn = RunMethod("LoanAccount","RunTransaction3",productID+",,TRA001,<%=BUSINESSOBJECT_CONSTATNTS.business_contract%>,"+sObjectNo+",<%=CurUser.getUserID()%>,");
		if(typeof(sReturn)=="undefined"||sReturn.length==0){
			alert("系统处理异常！");
			return;
		}
		alert(sReturn.split("@")[1]);
		reloadSelf();
	}
	
	//手续费代扣
	function SelectFeeRecieve(){
		var sObjectType = "jbo.app.BUSINESS_CONTRACT";
		var sObjectNo = getItemValue(0,getRow(),"serialNo");
	
		//创建手续费费用方案
		var feeschduleSerialno = getSerialNo("acct_fee_schedule", "serialno", "");
		var feeTermID ="N400";
		var sFeeSerialNo = RunMethod("PublicMethod","GetContractFeeSerialNo",sObjectNo+","+feeTermID+","+feeschduleSerialno);
		alert("合同:"+sObjectNo+"的手续费"+sFeeSerialNo);
		return;
		
	}
	
	function newRecord(){
		sCompID = "DistributorLoadInfo";
		sCompURL = "/DistributorInfo/DistributorLoadInfo.jsp";
	    popComp(sCompID,sCompURL,"","dialogWidth=300px;dialogHeight=400px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();	    
	}
	function modifyDetail(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");	
		var sCustomerID=getItemValue(0,getRow(),"customerID");
		var sBusinessType=getItemValue(0,getRow(),"BusinessType");	//产品代码
		var sQuotaID=getItemValue(0,getRow(),"quotaID");	     //额度协议编号
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		AsControl.OpenView("/DistributorInfo/DistributorLoadDetail.jsp","serialNo="+sSerialNo+"&businessType="+sBusinessType+"&quotaID="+sQuotaID+"&customerID="+sCustomerID,"_blank");		
		reloadSelf();
	}

	function enableLoad(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");	
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		if(confirm("您真的启用该额度吗？")){
			RunMethod("ModifyNumber","GetModifyNumber","business_contract,quotaStatus='02',serialNo='"+sSerialNo+"'");
		}
		reloadSelf();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>

