<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 提前还款查询
		Input Param:
			ObjectType:
			ObjectNo:
			SerialNo：业务流水号
		Output Param:
			SerialNo：业务流水号
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "提前还款信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	
	if(sSerialNo == null) sSerialNo = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {	{"SerialNo","申请编号"},
		                    {"ArtificialNo","合同编号"},
		                    {"FeasibleDate","提前还款可行日期"},
	                        {"BusinessSum","提前还款本金"},
							{"Interest","提前还款利息"},
							{"CustomerCost","客户服务费"},
							{"PayMent","担保服务费"},
							{"Fee","提前还款手续费"},
							{"TotalSum","总金额"}
	                       }; 


	String sSql =  " select bc.SerialNo as SerialNo,bc.ArtificialNo as ArtificialNo,"+
			" '' as FeasibleDate,bre.principal as BusinessSum,bre.interest as Interest,"+
			" bre.customercost as CustomerCost,"+
			" bre.payment as PayMent,"+
			" '' as Fee,"+
			" '' as TotalSum"+
			" from business_contract bc, business_rate br ,business_repayment bre"+
	     	" where bc.serialno=br.contractserialno and bc.serialno=bre.contractserialno and bc.SerialNo='"+sSerialNo+"' ";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//doTemp.UpdateTable = "LC_INFO";
	//doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //为后面的删除
	//设置不可见项
	//doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	//设置不可见项
	//doTemp.setVisible("InputOrgID,InputUserID",false);
	//doTemp.setUpdateable("UserName,OrgName,LCCurrencyName",false);
	//doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	//doTemp.setUpdateable("",false);
	//doTemp.setAlign("LCSum","3");
	//doTemp.setCheckFormat("LCSum","2");

	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","提前还款申请","提前还款申请","newRecord()",sResourcesPath}
	};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//申请流水号
		sArtificialNo = getItemValue(0,getRow(),"ArtificialNo");//合同编号
		sFeasibleDate = getItemValue(0,getRow(),"FeasibleDate");
		sBusinessSum = getItemValue(0,getRow(),"BusinessSum");
		sInterest = getItemValue(0,getRow(),"Interest");
		sCustomerCost = getItemValue(0,getRow(),"CustomerCost");
		sPayMent = getItemValue(0,getRow(),"PayMent");
		sFee = getItemValue(0,getRow(),"Fee");
		sTotalSum = getItemValue(0,getRow(),"TotalSum");
		sApplicationType="05";//提前还款标识
		sStatus="01";//处理中状态
		
		if(sSerialNo==null) sSerialNo="";
		if(sArtificialNo==null) sArtificialNo="";
		if(sFeasibleDate==null) sFeasibleDate="";
		if(sBusinessSum==null) sBusinessSum="";
		if(sInterest==null) sInterest="";
		if(sCustomerCost==null) sCustomerCost="";
		if(sPayMent==null) sPayMent="";
		if(sFee==null) sFee="";
		if(sTotalSum==null) sTotalSum="";


		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息!
			return;
		}
		
		//获取流水号
		var ssSerialNo = getSerialNo("WITHHOLD_CHARGE_INFO","SerialNo","");
		//查询提前还款记录是否存在
		sReturn = RunMethod("BusinessManage","SelectPay",sSerialNo);
       // alert("------"+sReturn);
		if(sReturn=="Null"){
			//把提前还款信息插入到withhold_charge_info表中
			sString=ssSerialNo+","+sArtificialNo+","+sFeasibleDate+","+sBusinessSum+","+sInterest+","+sCustomerCost+","+sPayMent+","+sFee+","+sTotalSum+","+sApplicationType+","+sSerialNo+","+sStatus;
			sReturn = RunMethod("BusinessManage","InsertContract",sString);
			if(sReturn=="1.0"){
				alert("发起提前还款成功！");
			}else{
				alert("发起提前还款失败，请检查！");
			}
		 }else{
			alert("该笔合同已在提前还款申请中，请检查！");
		 }
	 }

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">


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
