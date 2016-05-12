<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
  
<%
	String PG_TITLE = "账户信息管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String businessType = "";
	String projectVersion = "";
	
	//获得页面参数
	String SerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String sStatus = DataConvert.toRealString(iPostChange,CurPage.getParameter("Status"));
	String sAccountIndicator = DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("AccountIndicator")));
	String right=DataConvert.toString(DataConvert.toRealString(iPostChange,CurPage.getParameter("RightType")));
	if(SerialNo == null) SerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(sStatus == null) sStatus = "";
	
	BusinessObject bo = AbstractBusinessObjectManager.getBusinessObject(sObjectType,sObjectNo,Sqlca);
	
	//显示模版编号
	String sTempletNo = "DepositAccountsInfo";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	if("00".equals(sAccountIndicator) || "01".equals(sAccountIndicator) || !"".equals(SerialNo))
		doTemp.setReadOnly("AccountIndicator",true);
	else if("99".equals(sAccountIndicator))
		doTemp.setDDDWSql("AccountIndicator","select itemno,itemname from code_library where codeno = 'AccountIndicator' and itemno in('02','03','04')");
	
	if("00".equals(sAccountIndicator) || "99".equals(sAccountIndicator) || !"".equals(SerialNo)){
		doTemp.setVisible("PRI",false);
		doTemp.setDefaultValue("PRI","1");
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "2"; //设置DW风格 1:Grid 2:Freeform
	if("ReadOnly".equals(right)||sObjectType.equals("PutOutApply")){
		dwTemp.ReadOnly = "1";
	}else{
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	}
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(SerialNo);
	for(int i=0;i < vTemp.size();i++)out.print((String) vTemp.get(i));
	

	String sButtons[][] = {
			{"true", "", "Button", "保存", "新增一条信息","saveRecord()",sResourcesPath},
			{"true", "", "Button", "返回", "返回","goBack()",sResourcesPath},
	};
	if("ReadOnly".equals(right)||sObjectType.equals("PutOutApply")){
		sButtons[0][1]="false";
	}
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>

<script language=javascript>
	var coreCheckFlag = false;
	//保存
	function saveRecord(){
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate();
		//账户性质 如果为放款账户则为多个可以保存如果为其他账户性质则只能保存一次再次出现则不能保存
		var accountIndicator = getItemValue(0,getRow(),"AccountIndicator");
		var status = getItemValue(0,getRow(),"Status");
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		/* if("01"==accountIndicator){
			as_save("myiframe0","goBack();");
		}else{
			
		}*/	
		sReturn = RunMethod("PublicMethod","DistinctAccount","<%=sObjectNo%>,<%=bo.getObjectType()%>,"+accountIndicator+","+serialNo);
		if(sReturn>=1){
			alert("该账户性质已存在");
			return;
		}else
			as_save("myiframe0","goBack();");
	}
	//返回
	function goBack(){
		OpenPage("/Accounting/LoanDetail/LoanTerm/DepositAccountsList.jsp?Status=<%=sStatus%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>","_self","");
	}
	
	/*~[Describe=执行新增操作前初始化流水号;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert(){
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo(){
		var sTableName = "ACCT_DEPOSIT_ACCOUNTS";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀	
		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"ObjectType","<%=bo.getObjectType()%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"Status","0");
			bIsInsert = true;
			
			if("<%=sAccountIndicator%>" == "00")
				setItemValue(0,0,"AccountIndicator","00");
			else if("<%=sAccountIndicator%>" == "01")
				setItemValue(0,0,"AccountIndicator","01");
		}else{
			bIsInsert = false;
		}
	}
	//改变账户性质引发其他选项的改变
	function changeAccountIndicator(){
		var sResult = getItemValue(0,getRow(),"AccountIndicator");
		if("00"==sResult){
			setItemDisabled(0,getRow(),"PRI",false);
			return;
		}else{
			setItemValue(0,0,"PRI","1");
			setItemDisabled(0,getRow(),"PRI",true);
			return;
		}
	}
		
</script>

<script language=javascript>
	//初始化
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>