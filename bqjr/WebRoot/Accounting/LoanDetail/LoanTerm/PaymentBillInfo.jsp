<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "相关支付清单信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>

<%
	//获得组件参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sAccountInFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountInFlag"));
	String sBusinessSum = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessSum"));
	String sBusinessCurrency = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessCurrency"));

	if(sSerialNo == null ) sSerialNo = ""; 
	if(sObjectType == null) sObjectType = "";
    if(sObjectNo == null) sObjectNo = ""; 
    if(sAccountInFlag == null) sAccountInFlag = "1";
    if(sBusinessSum == null) sBusinessSum = "0";
    if(sBusinessCurrency == null) sBusinessCurrency = "01";

    
%>


<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "PutOutInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,"ColAttribute like '%"+sAccountInFlag+"%'",Sqlca);
	
	
	//设置金额为三位一逗数字
	doTemp.setType("TransFerSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("TransFerSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
	doTemp.setAlign("TransFerSum","3");	
	//支付金额不能为负数
	doTemp.appendHTMLStyle("TransFerSum"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"支付金额必须大于等于0！\" ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
%> 

<%@include file="/Resources/CodeParts/Info05.jsp"%>

<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		setItemValue(0,0,"ObjectType","<%=sObjectType%>");
		setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate();
		as_save("myiframe0","goBack()");
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/Accounting/LoanDetail/LoanTerm/PaymentBillList.jsp","_self","");
	}

</script>

<script type="text/javascript">
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");	
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"TurnFee","0");
			setItemValue(0,0,"BussType","11");
			setItemValue(0,0,"AccountInFlag","1");
			setItemValue(0,0,"AccountOutFlag","1");
			setItemValue(0,0,"AccountOutBank","<%=CurOrg.getOrgName()%>");
			bIsInsert = true;
			initSerialNo();
		}
		setItemValue(0,0,"AccountInFlag","<%=sAccountInFlag%>");
		if("1" == "<%=sAccountInFlag%>"){
			setItemValue(0,0,"AccountInBank","<%=CurOrg.getOrgName()%>");
		}else{
			setItemValue(0,0,"AccountInBank","");
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "ACCT_TRANSFER";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=更改汇划路径触发选择报文的更改;InputParam=无;OutPutParam=无;]~*/
	function changeClearingType(){
		var clearingType = getItemValue(0,getRow(),"ClearingType");
		if("1"==clearingType){
			setItemValue(0,0,"TurnMsgType","CMT100");
			setItemValue(0,0,"BussTypeNo","CMT100");
			setItemDisabled(0,getRow(),"TurnMsgType",true);
		}else if("2"==clearingType){
			setItemValue(0,0,"TurnMsgType","PKG001");
			setItemValue(0,0,"BussTypeNo","PKG001");
			setItemDisabled(0,getRow(),"TurnMsgType",true);
		}else{
			setItemValue(0,0,"TurnMsgType","CMT101");
			setItemValue(0,0,"BussTypeNo","CMT101");
			setItemDisabled(0,getRow(),"TurnMsgType",false);
		}
		return;
	}
	
	/*~[Describe=更改选择报文触发业务类型号的变化;InputParam=无;OutPutParam=无;]~*/
	function changeTurnMsgType(){
		var turnMsgType = getItemValue(0,getRow(),"TurnMsgType");
		setItemValue(0,0,"BussTypeNo",turnMsgType);
		return;
	}
	//更改转入账户是否为本行
	function changeAcctInFlag(){
		var sReturn = getItemValue(0,getRow(),"AccountInFlag");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		OpenPage("/CreditManage/CreditApply/PaymentBillInfo.jsp?AccountInFlag="+sReturn+"&SerialNo="+sSerialNo,"_self","");
	}
	//更改销户标志如果出现销户失败小胡原因可以编写
	function changeDestroyFlag(){
		var sReturn = getItemValue(0,getRow(),"DestroyFlag");
		if("03" == sReturn){
			setItemDisabled(0,getRow(),"DestroySourse",false);
		}else{ 
			setItemValue(0,0,"DestroySourse","");
			setItemDisabled(0,getRow(),"DestroySourse",true);
		}
		return;
	}
</script>

<script type="text/javascript">	
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>