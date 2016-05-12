<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  
		Tester:
		Content: 
		Input Param:
			ObjectType：对象类型
			ApplyType：申请类型
			PhaseType：阶段类型
			FlowNo：流程号
			PhaseNo：阶段号		
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "共同借款人申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));

	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null)   sObjectNo = "";

		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "CarCommApplyInfo";
	
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
	//dwTemp.setEvent("AfterInsert","!WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.getUserID()+","+CurOrg.getOrgID()+") + !WorkFlowEngine.InitializeCLInfo(#SerialNo,#BusinessType,#CustomerID,#CustomerName,#InputUserID,#InputOrgID)");
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
			{"true","","Button","确认","确认","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消","doCancel()",sResourcesPath}	
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
		checkType();//检查客户号
		InsertCustomer();//插入客户信息表
		
		//插入关联信息表
		customerRel();
		//返回结果
		doReturn();
		//as_save("myiframe0",sPostEvents);
	}
	
	//关联信息表
	function customerRel(){
		//----插入信息岛关联表中-----
		//客户编号
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		//客户类型
		var sCustomerType = getItemValue(0,getRow(),"CustomerType");
		//申请角色类型
		var sCustomerRole = getItemValue(0,getRow(),"CustomerRole");
		//出生日期
		//var sBirthDay = getItemValue(0,getRow(),"BirthDay");
		var sBirthDay = "";
		//申请类型
		var sObjectType = "<%=sObjectType%>";
		//申请号
		var sSerialNo = "<%=sObjectNo%>";
		
		//alert("=========客户编号============"+sCustomerID);
		
		
		//alert("获取客户编号："+sCustomerID+"申请角色:"+sCustomerRole+"客户类型:"+sCustomerType+"申请类型:"+sObjectType+"申请号:"+sSerialNo);
		//判断关联表中是否存在记录
		var sReturn=RunMethod("BusinessManage","ContractYesNo",sSerialNo+","+sObjectType+","+sCustomerID);
		//alert("----------------"+sReturn);
		if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn == "Null"){
			  //插入信息到关联表中
		      RunMethod("BusinessManage","AddContractRecord",sSerialNo+","+sObjectType+","+sCustomerID+","+sCustomerType+","+sCustomerRole+","+sBirthDay);
		}else{
			  //更新信息到关联表中
		      RunMethod("BusinessManage","UpdateContractRecord",sSerialNo+","+sObjectType+","+sCustomerID+","+sCustomerType+","+sCustomerRole+","+sBirthDay);
		}
		
	}
	
	function InsertCustomer(){
		//判断当前客户是否存在
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sCertID = getItemValue(0,0,"CertID");
		var sCertType = getItemValue(0,0,"CertType");
		var sCustomerType = getItemValue(0,0,"CustomerType");
		var sCustomerID = getItemValue(0,0,"CustomerID");
		
		//alert("客户ID："+sCustomerID+"客户类型："+sCustomerType+"客户名称："+sCustomerName+"证件号码："+sCertID);
		
		var sStatus = "01";
		var sCustomerOrgType = sCustomerType;
		var sHaveCustomerType = sCustomerType;
		//获取客户ID
		sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName+","+sCertID);
		//alert("返回值00000："+sReturn);
		
		if(sReturn == "Null"){
			var sParam = "";
            sParam = sCustomerID+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
                     ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+sHaveCustomerType;

			sReturn = RunMethod("CustomerManage","AddCustomerAction",sParam);
        }
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

	/*~[Describe=新增一笔授信申请记录;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
		if(isCardNo()== false){
			return;
		}else{
			saveRecord("doReturn()");
		}
	}
	
	
	/*~[Describe=确认申请;InputParam=无;OutPutParam=无;]~*/
	function doReturn(){
		sCustomerID = getItemValue(0,0,"CustomerID");
		sCustomerType = getItemValue(0,0,"CustomerType");
		//alert("22222222"+sCustomerID);
		top.returnValue = sCustomerID+"@"+sCustomerType;
		top.close();
	}

	
	//根据客户类型，填写证件信息
	function selectCustomerType(){
		sCustomerType = getItemValue(0,0,"CustomerType");
		
		if(sCustomerType=="03"){//个人客户
			//设置证件类型为身份证
			setItemValue(0,0,"CertType","Ind01");
		}else if(sCustomerType=="04"){//自雇、公司客户
			setItemValue(0,0,"CertType","Ent02");
		}else if(sCustomerType=="05"){
			setItemValue(0,0,"CertType","Ent02");
		}else{
			setItemValue(0,0,"CertType","");
		}
	}
	
	//身份证正则表达校验
	function isCardNo()
	{
		var card = getItemValue(0,getRow(),"CertID");
		var sCertType = getItemValue(0,0,"CertType");
		
		//只对身份证做验证
		if(sCertType=="Ind01"){
			// 身份证号码为15位或者18位，15位时全为数字，18位前17位为数字，最后一位是校验位，可能为数字或字符X   
			var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;  
			if(reg.test(card) === false)  
			 {
			    alert("身份证输入不合法");  
			    return  false;  
			 } 
		}
	}
	
	//检查客户号是否存在
	function checkType(){
		var sCustomerName = getItemValue(0,0,"CustomerName");
		var sIdentityId = getItemValue(0,0,"CertID");
        //alert("---1111---"+sCustomerName+"--2222----"+sIdentityId);

		//获取客户ID
		sReturn = RunMethod("BusinessManage","CustomerID",sCustomerName+","+sIdentityId);
		//alert("返回值："+sReturn);
			
	    //设置客户ID
	    if(sReturn == "Null"){
	    	//获取客户号
			var sCustomerID = getSerialNo("Customer_Info","CustomerID","");
			setItemValue(0,getRow(),"CustomerID",sCustomerID);
	    }else{
	    	//把客户号，身份证号设置只读
	    	setItemReadOnly(0,0,"CustomerName",true);
	    	setItemReadOnly(0,0,"CertID",true);
	    	//把查询的客户ID设置到CustomerID中
	        setItemValue(0,0,"CustomerID",sReturn);
	    }
	}
	
							
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录
			setItemValue(0,0,"CustomerRole","02");//共同借款人
			bIsInsert = true;
		}
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