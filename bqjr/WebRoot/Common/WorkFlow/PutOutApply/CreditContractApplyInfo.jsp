<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.7
		Tester:
		Content: 创建授信额度申请
		Input Param:
			ObjectType：对象类型
			ApplyType：申请类型
			PhaseType：阶段类型
			FlowNo：流程号
			PhaseNo：阶段号		
		Output param:
		History Log: zywei 2005/07/28
					 zywei 2005/07/28 将授信额度新增页面单独处理
					 jgao1 2009/10/21 增加集团授信额度，以及选择客户类型变化时清空Data操作
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信方案新增信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseNo"));
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "CreditContractApplyInfo";
	
	//根据模板编号设置数据对象	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//设置必输背景色
	//doTemp.setHTMLStyle("CustomerType","style={background=\"#EEEEff\"} ");
	//当客户类型发生改变时，系统自动清空已录入的信息
	//doTemp.appendHTMLStyle("CustomerType"," onClick=\"javascript:parent.clearData()\" ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置保存时操作关联数据表的动作
	dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+")");
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
			{"true","","Button","确认","确认新增授信额度申请","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消新增授信额度申请","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		initSerialNo();
		as_save("myiframe0");
	}

		   
    /*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">
     var  sCustomerName;
	/*~[Describe=新增一笔授信申请记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
		sSerialNo = getItemValue(0,0,"SerialNo");
		sRemark = getItemValue(0,0,"remark");
		RunMethod("WorkFlowEngine","InitializeFlow","<%=sObjectType %>,"+sSerialNo +",<%=sApplyType %>,<%=sFlowNo %>,<%=sPhaseNo %>,<%=CurUser.getUserID() %>,<%=CurOrg.getOrgID() %>");
	    RunMethod("ModifyNumber","GetModifyNumber","business_contract,ContractStatus='200',serialNo='"+sSerialNo+"'");// 修改合同状态
	    RunMethod("ModifyNumber","GetModifyNumber","business_contract,remark='"+sRemark+"',serialNo='"+sSerialNo+"'");
		top.close();
	}
	
	/*~[Describe=确认新增授信申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		sObjectType = "<%=sObjectType%>";		
		top.returnValue = sObjectNo+"@"+sObjectType;
		top.close();
	}

	
	
	function getRegionCode(){
	    var sEntInfoValue=setObjectValue("SelectCarContract","","@ArtificialNo@1",0,0,"");
	    if(typeof(sEntInfoValue) == "undefined" || sEntInfoValue == ""){
			alert("请选择一条记录！");
			return;
		}
	    sEntInfoValue=sEntInfoValue.split('@');
	    sSerialNo=sEntInfoValue[0];  
	    sCustomerName=sEntInfoValue[2];           //合同编号
	    setItemValue(0,0,"CustomerName",sCustomerName);
	    setItemValue(0,0,"SerialNo",sSerialNo);
	}
	 
	
	//选择产品类型时，显示对应的文本框
	function checkType(){
		var sProductId = getItemValue(0,0,"ProductId");
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sIdentityId   = getItemValue(0,0,"CertID");
		
		
		if(sProductId=="020" && sCustomerName =="" && sIdentityId ==""){
		   alert("请填写客户名称及身份证号！");  	
		}

		if(sProductId=="020" && sCustomerName !="" && sIdentityId !=""){//如果是“预约现金贷” 验证客户信息
		   //查询预约现金贷准入客户名单
		   ssReturn = RunMethod("BusinessManage","CustomerNameInfo",sCustomerName+","+sIdentityId);
		   //alert("------------------"+ssReturn);
		   if(ssReturn == "Null"){
			   alert("客户未在预约现金贷准入客户名单中！");
			   return;
		   }
		}
		//获取客户ID
		sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName+","+sIdentityId);
		//alert("返回值："+sReturn);
			
	    //设置客户ID
	    if(sReturn == "Null"){
	    	//获取客户号
			var sSerialNo = getSerialNo("Customer_Info","CustomerID","");
			setItemValue(0,getRow(),"CustomerID",sSerialNo);
	    }else{
	    	//把客户号，身份证号设置只读
	    	setItemReadOnly(0,0,"CustomerName",true);
	    	setItemReadOnly(0,0,"CertID",true);
	    	//把查询的客户ID设置到CustomerID中
	        setItemValue(0,0,"CustomerID",sReturn);
	    }

	}
	
	//身份证正则表达校验
	function isCardNo()  
	{
		var card = getItemValue(0,getRow(),"CertID");
		//alert("==================="+card);
		
	   // 身份证号码为15位或者18位，15位时全为数字，18位前17位为数字，最后一位是校验位，可能为数字或字符X   
	   var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;  
	   if(reg.test(card) === false)  
	   {  
	      alert("身份证输入不合法");  
	       return  false;  
	   }  
	}
	
							
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录	
			//证件类型(身份证)
			setItemValue(0,0,"CertType","Ind01");
			//消费贷合同标识
			setItemValue(0,0,"CreditAttribute","0002");
			//合同状态:060新发生
			setItemValue(0,0,"ContractStatus","060");
			
			//经办机构
			setItemValue(0,0,"OperateOrgID","<%=CurUser.getOrgID()%>");
			//经办人
			setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");
			//经办日期
			setItemValue(0,0,"OperateDate","<%=StringFunction.getToday()%>");
			//登记机构
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			//登记人
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			//登记日期			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			//更新日期
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			//暂存标志
			setItemValue(0,0,"TempSaveFlag","1");//是否标志（1：是；2：否）
			//客户类型默认为个人客户
			setItemValue(0,0,"CustomerType","0310");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
								
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>