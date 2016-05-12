<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hwang 2009-06-15
		Tester:
		Describe: 业务流水信息;
		Input Param:
			SerialNo:流水号
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = " 业务流水信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";

	//获得组件参数
	
	//获得页面参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
	 //流水类型,OccurDirection=1，还款流水，OccurDirection=2，借款流水。
	String sOccurDirection = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurDirection"));
	if(sOccurDirection == null) sOccurDirection = "";

	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = { {"SerialNo","流水号"},
	                        {"RelativeSerialNo","相关借据流水号"},
                            {"RelativeContractNo","相关合同流水号"},
                            {"TransactionFlag","交易标志"},
                            {"OccurType","发生类型"},
                            {"OccurDirection","发生方向"},
                            {"OccurDirectionName","发生方向"},
                            {"OccurDate","交易日期"},
                            {"BackType","回收方式"},
                            {"OccurSubject","发生摘要"},
                            {"ActualDebitSum","发放金额(元)"},
                            {"ActualCreditSum","回收金额(元)"},
                            {"OrgName","登记机构"},
                            {"UserName","登记人"},
                          };

	if(sOccurDirection == null || sOccurDirection.length() == 0){
		sSql ="select OccurDirection from BUSINESS_WASTEBOOK where SerialNo=:SerialNo";
		sOccurDirection = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
		if(sOccurDirection==null || sOccurDirection.length() == 0) sOccurDirection="1"; //1.是回收
	}

	if(sOccurDirection.equals("1")){
		sSql=	" select SerialNo,RelativeContractNo,OccurDate,ActualCreditSum, "+
				" OccurType,TransactionFlag,OccurDirection,getItemName('OccurDirection',OccurDirection) as OccurDirectionName,OccurSubject,BackType,OrgID,"+
				" getOrgName(OrgID) as OrgName,UserID,getUserName(UserID) as UserName "+
				" from BUSINESS_WASTEBOOK where SerialNo='"+sSerialNo+"'";
	}else{
		sSql=	" select SerialNo,RelativeContractNo,OccurDate,ActualDebitSum, "+
				" OccurType,TransactionFlag,OccurDirection,getItemName('OccurDirection',OccurDirection) as OccurDirectionName,OccurSubject,BackType,OrgID,"+
				" getOrgName(OrgID) as OrgName,UserID,getUserName(UserID) as UserName "+
				" from BUSINESS_WASTEBOOK where SerialNo='"+sSerialNo+"'";
	}

	//通过sql定义数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置可更新的表
	doTemp.UpdateTable = "BUSINESS_WASTEBOOK";
	//设置关键字
	doTemp.setKey("SerialNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置只读选项
	doTemp.setReadOnly("SerialNo,RelativeContractNo,OccurDirectionName,OrgID,UserID,OrgName,UserName",true);	
	//设置不可见项
	doTemp.setVisible("OrgID,UserID,OccurDirection",false);
	if("0".equals(sOccurDirection))
	{
		doTemp.setVisible("BackType",false);
		//设置必输项
		doTemp.setRequired("RelativeSerialNo,RelativeContractNo,OccurDate,ActualCreditSum,ActualDebitSum,OccurType,TransactionFlag,OccurSubject",true);
	}else{	
		//设置必输项
		doTemp.setRequired("RelativeSerialNo,RelativeContractNo,OccurDate,ActualCreditSum,ActualDebitSum,OccurType,TransactionFlag,OccurSubject,BackType",true);
	}
		
	//设置不可更新字段
	doTemp.setUpdateable("OrgName,UserName,OccurDirectionName",false);
	//设置下拉选项
	doTemp.setDDDWCode("OccurSubject","OccurSubjectName");
	doTemp.setDDDWCode("OccurType","WasteOccurType");
	//doTemp.setDDDWCode("OccurDirection","OccurDirection");
	doTemp.setDDDWCode("TransactionFlag","TransactionFlag");
	doTemp.setDDDWCode("BackType","ReclaimType");
	doTemp.setCheckFormat("OccurDate","3");
    doTemp.setType("ActualCreditSum,ActualDebitSum","Number");
	doTemp.setCheckFormat("ActualCreditSum,ActualDebitSum","2");
	doTemp.setAlign("ActualCreditSum,ActualDebitSum","3");
	doTemp.setHTMLStyle("OrgName,UserName"," style={width:80px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	
	sSql="select BusinessType from BUSINESS_CONTRACT where SerialNo=:SerialNo";
	String sBusinessType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	
	sSql="select attribute4 from BUSINESS_TYPE where TypeNo=:TypeNo";
	String sOrigin = Sqlca.getString(new SqlObject(sSql).setParameter("TypeNo",sBusinessType));
	if (sOrigin == null) sOrigin = "";

	//假如为回收且数据来源不是628
	if(!sOrigin.equals("010")) {
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	}
	else {
		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	}
	
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
	
	//假如为回收且数据来源不是628
	if (!sOrigin.equals("010")) {
		sButtons[0][0] = "true";
	}
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=保存;InputParam=无;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditPutOut/AccountWasteBookList1.jsp","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	function beforeInsert()
	{		
		initSerialNo();//初始化流水号字段
	}

	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_WASTEBOOK";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
			var occurDirection = "<%=sOccurDirection%>";
			setItemValue(0,0,"OccurDirection",occurDirection);
			if(occurDirection == "1"){
				setItemValue(0,0,"OccurDirectionName","回收");
			}else{
				setItemValue(0,0,"OccurDirectionName","发放");
			}			
			setItemValue(0,0,"RelativeContractNo","<%=sObjectNo%>");
			setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
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

