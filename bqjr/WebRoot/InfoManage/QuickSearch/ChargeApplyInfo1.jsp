<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


	<%
	String PG_TITLE = "代扣账号变更详情";
	//定义变量
	String sSql="",sCustomerName="",sCertID="",sMobileTelephone="",sReplaceName="",sReplaceAccount="",sOpenBank="",sArtificialNo="";
	String sOldCityName="",sOldCity="";
	//定义变量：查询结果集
	ASResultSet rs = null;
	//获得页面参数：
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo==null)  sSerialNo="";
	%>
	<%/*~END~*/%>
	
	<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ChargeApplyInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.setLimit("NewAccount",18); //限定卡号的录入长度
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="0";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindows
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//{"true","","Button","确认变更","确认变更","saveRecord()",sResourcesPath}
	};
	%> 

	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script language=javascript>
	var bIsInsert = false;
	//---------------------定义按钮事件------------------------------------

	function saveRecord()
	{
		//获取变更后的开户户名、扣款账户号、开户行
		ContractSerialno = getItemValue(0,getRow(),"ContractSerialNo");
		NewAccountName = getItemValue(0,getRow(),"NewAccountName");
		CustomerID = getItemValue(0,getRow(),"CustomerID");
		NewBankName = getItemValue(0,getRow(),"NewBankName");
		AccountIndicator = "01";//扣款
		NewAccount = getItemValue(0,getRow(),"NewAccount");
		NewCity = getItemValue(0,getRow(),"NewCity");		
		NewRePaymentWay = getItemValue(0,getRow(),"NEWREPAYMENTWAY");//新的还款方式1：代扣 2：非代扣
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	
		if (!(typeof(NewAccountName) == "undefined" || NewAccountName != ""|| typeof(NewBankName) == "undefined" || NewBankName != ""
		|| typeof(NewAccount) == "undefined" || NewAccount != ""))
		{
			alert("请输入需变更信息！");
			return;
		}
		//变更客户信息、变更客户下所有合同的 还款方式(代扣/非代扣);
		sReturnValue = RunMethod("CustomerManage","UpdateReplaceAccount", AccountIndicator+","+ContractSerialno+","+CustomerID+","+NewAccountName+","+NewBankName+","+NewAccount+","+NewCity+","+NewRePaymentWay);
	 	 if(sReturnValue=="Success") {
			alert("变更代扣账户信息成功!");
		}else{
			alert("变更代扣账户信息失败!");
			return;
		}
		as_save("myiframe0");
	}
	
	/*~[Describe=弹出省市选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getCityName()
	{
		//var sAreaCode = getItemValue(0,getRow(),"City");
		//sAreaCodeInfo = PopComp("AreaVFrame","/Common/ToolsA/AreaVFrame.jsp","AreaCode="+sAreaCode,"dialogWidth=650px;dialogHeight=450px;center:yes;status:no;statusbar:no","");
        var sAreaCodeInfo = setObjectValue("SelectCityCodeSingle","","",0,0,"");
		
		//增加清空功能的判断
		if(sAreaCodeInfo == "NO" || sAreaCodeInfo == '_CLEAR_'){
			setItemValue(0,getRow(),"NewCity","");
			setItemValue(0,getRow(),"NewCityName","");
		}else{
			 if(typeof(sAreaCodeInfo) != "undefined" && sAreaCodeInfo != ""){
					sAreaCodeInfo = sAreaCodeInfo.split('@');
					sAreaCodeValue = sAreaCodeInfo[0];//-- 行政区划代码
					sAreaCodeName = sAreaCodeInfo[1];//--行政区划名称
					setItemValue(0,getRow(),"NewCity",sAreaCodeValue);
					setItemValue(0,getRow(),"NewCityName",sAreaCodeName);			
			}
		}
	}
	
	
	function initRow()
	{	
		var sOpenBank=RunMethod("公用方法","GetColValue","code_library,itemName,itemNo='<%=sOpenBank%>'");
		if(sOpenBank=="Null") {sOpenBank="";}
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		
			
            //登记人信息
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserIDName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgIDName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "WITHHOLD_CHARGE_INFO";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀
       
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	</script>

<script language=javascript>	
	AsOne.AsInit();
	//showFilterArea();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	

<%@ include file="/IncludeEnd.jsp"%>
