<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   jschen  2010.03.17
		Tester:
		Content: 补登额度页面
		Input Param:
			ObjectType：对象类型
			ApplyType：申请类型
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "额度业务补登新增信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数
	
	//将空值转化成空字符串
		
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "CreditLineInputCreationInfo";
	
	//根据模板编号设置数据对象	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
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
			{"true","","Button","确认","确认额度补登新增","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消额度补登新增","doCancel()",sResourcesPath}	
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
		setItemValue(0,0,"ContractFlag","2");//不占用额度
		initSerialNo();
		as_save("myiframe0",sPostEvents);		
	}
		   
    /*~[Describe=取消额度补登新增;InputParam=无;OutPutParam=取消标志;]~*/
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
		var sCustomerID = "";
		sCustomerType = getItemValue(0,0,"CustomerType");
		sCertType = getItemValue(0,0,"CertType");	
		sCertID = getItemValue(0,0,"CertID");	
		sCustomerName = getItemValue(0,0,"CustomerName");	
		sCustomerOrgType = getItemValue(0,0,"OrgNature");	
		//判断组织机构代码合法性
		if(sCertType =='Ent01')
		{			
			if(!CheckORG(sCertID))
			{
				alert(getBusinessMessage('102'));//组织机构代码有误！
				setItemFocus(0,0,"CertID");
				return;
			}			
		}
		//新增客户
		sReturnStatus = RunMethod("CustomerManage","CheckCustomerAction",sCustomerType+","+sCustomerName+","+sCertType+","+sCertID+",<%=CurUser.getUserID()%>");	
        //得到客户信息检查结果和客户号
        sReturnStatus = sReturnStatus.split("@");
        sStatus = sReturnStatus[0];
        sCustomerID = sReturnStatus[1];
      	//01为该客户不存在本系统中
		if(sStatus == "01")
		{
			sCustomerID = getNewCustomerID();
			
			var sParam = "";
            sParam = sCustomerID+","+sCustomerName+","+sCustomerType+","+sCertType+","+sCertID+
                     ","+sStatus+","+sCustomerOrgType+",<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,"+"";
            sReturn = RunMethod("CustomerManage","AddCustomerAction",sParam);
            //为了不让额度管理员拥有该客户的管户权，所以在增加客户后，删除所有管户权
            sDelReturn = PopPageAjax("/CustomerManage/DelCustomerBelongActionAjax.jsp?CustomerID="+sCustomerID+"","","");
            
            if(sStatus == "01"){
                alert("客户号："+sCustomerID+"新增成功!"); //新增客户成功
            }else{
                alert("新增客户失败！"); //新增客户成功
                return;
            }
		}
		setItemValue(0,0,"CustomerID",sCustomerID);
		
		saveRecord("doReturn()");
	}
	
	/*~[Describe=确认新增授信申请;InputParam=无;OutPutParam=申请流水号;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");		
		top.returnValue = sObjectNo;
		top.close();
	}
		
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{			
		sCustomerType = getItemValue(0,0,"CustomerType");
		sCustomerType = sCustomerType.substr(0,2);
		if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
		{
			alert("请先选择客户类型!");
			return;
		}
		//具有业务申办权的客户信息
		sParaString = "UserID"+","+"<%=CurUser.getUserID()%>"+","+"CustomerType"+","+sCustomerType;
		if(sCustomerType == "02")
			//选择集团客户
			setObjectValue("SelectApplyCustomer2",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
		else
			//选择公司类客户(包括大型企业与已认定的中小企业)
			setObjectValue("SelectApplyCustomer3",sParaString,"@CustomerID@0@CustomerName@1",0,0,"");
	}
	
	/*~[Describe=弹出业务品种选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectBusinessType(sType)
	{		
		if(sType == "CL") //授信额度的业务品种
		{
			sCustomerType = getItemValue(0,0,"CustomerType");
			sCustomerType = sCustomerType.substr(0,2);
			if(typeof(sCustomerType) == "undefined" || sCustomerType == "")
			{
				alert("请先选择客户类型!");
				return;
			}
			//“01”代表公司客户，“02”代表集团客户，如果选择的是公司客户，则弹出授信额度业务品种，如果选择的是集团客户，则默认为集团授信额度
			if(sCustomerType=="01")
				setObjectValue("SelectCLBusinessType","","@BusinessType@0@BusinessTypeName@1",0,0,"");	
			if(sCustomerType=="02"){
				//新增弹出框提示语句，防止出现异议！
				alert("集团客户只能申请集团授信额度！");
				return;
			}		
		}
	}
							
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录			
			//发生类型
			setItemValue(0,0,"OccurType","010");
			//发生日期
			setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");
			//产品种类
			setItemValue(0,0,"BusinessType","3010");
			//产品种类名称
			//setItemValue(0,0,"BusinessTypeName","公司综合授信额度");  //commented by yzheng 2013-6-25
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
			//客户类型默认为公司客户
			setItemValue(0,0,"CustomerType","01");
			//币种
			setItemValue(0,0,"BusinessCurrency","01");//人民币
			//申请类型
			setItemValue(0,0,"ApplyType","DependentApply");//申请类型
			//补登标志
			setItemValue(0,0,"ReinforceFlag","110");//未补登完成的授信额度
			//管户机构
			setItemValue(0,0,"ManageOrgID","<%=CurUser.getOrgID()%>");//管户机构
			//管户人
			setItemValue(0,0,"ManageUserID","<%=CurUser.getUserID()%>");//管户人
			//冻结标志
			setItemValue(0,0,"FreezeFlag","1");//正常
			//放贷机构
			setItemValue(0,0,"PutOutOrgID","<%=CurUser.getOrgID()%>");//放贷机构
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

	/*~[Describe=清空信息;InputParam=无;OutPutParam=申请流水号;]~*/
	function clearData(){
		var sCustomerType = getItemValue(0,0,"CustomerType");
		sCustomerType = sCustomerType.substr(0,2);
		if(sCustomerType=="01")
		{
			//如果客户类型为公司客户，则默认为综合授信额度，代码为3010
			setItemValue(0,0,"BusinessType","3010");
			setItemValue(0,0,"BusinessTypeName","内部授信额度");
		}else if(sCustomerType=="02")
		{
			//如果客户类型为集团客户，则默认为集团授信额度，代码为3020
			setItemValue(0,0,"BusinessType","3020");
			setItemValue(0,0,"BusinessTypeName","集团授信额度");
		}else{
			setItemValue(0,0,"BusinessTypeName","");
			setItemValue(0,0,"BusinessType","");
		}
		setItemValue(0,0,"CustomerID","");
		setItemValue(0,0,"CustomerName","");
	}

    /*~[Describe=生成新客户ID;InputParam=无;OutPutParam=无;]~*/
    function getNewCustomerID(){
    	var sTableName = "CUSTOMER_INFO";//表名
		var sColumnName = "CustomerID";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
        return sSerialNo;
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