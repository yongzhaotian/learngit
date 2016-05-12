<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --FMWu 2004-12-7
		Tester:
		Describe: --担保合同信息;
		Input Param:
			ObjectType: --对象类型(业务阶段)。
			ObjectNo: --对象编号（申请/批复/合同流水号）。
			SerialNo:--担保合同号
			sContractType：--合同类型
			sGuarantyType：--担保类型
		Output Param:

		HistoryLog:
			2005-08-07 王业罡 代码重检 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "担保合同信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sContractStatus = "";//--合同状态
	String sTempletFilter = "";//--过滤条件
	String sSql = "",sRelativeTableName="",sObjectTable="";
	ASResultSet rs=null;//--存放结果集

	//获得组件参数，对象类型、对象编号、合同类型
	String sObjectType   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo     = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sContractType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractType"));
	if(sContractType==null) sContractType="";
	
	//获得页面参数,担保类型,流水号
    String sGuarantyType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyType"));
	if(sGuarantyType==null) sGuarantyType="";
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";

	if (sObjectType.equals("GuarantyContract")) {
		sSerialNo=sObjectNo;
		sContractStatus = "020";
		sTempletFilter = " (ColAttribute like '%BC%' ) ";
	}else{
		//根据sObjectType的不同，得到不同的关联表名和模版名
		sSql="select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType));
		if(rs.next()){
			sRelativeTableName=rs.getString("RelativeTable");
			sObjectTable=rs.getString("ObjectTable");
		}
		rs.getStatement().close();
		
		//合同阶段，显示合同阶段的信息
		if (sObjectTable.equals("BUSINESS_CONTRACT")) {
			sContractStatus = "020";
			sTempletFilter = " (ColAttribute like '%BC%' ) ";
		}else{
			sContractStatus = "010";
			sTempletFilter = " (ColAttribute like '%BA%' ) ";
		}
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
    //假如sGuarantyID不为空，从数据库中取担保类型
	if (!sSerialNo.equals("")) {
		sSql="select GuarantyType from GUARANTY_CONTRACT where SerialNo=:SerialNo";
		sGuarantyType = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	}
	//根据担保类型取得显示模版号
	sSql="select ItemDescribe from CODE_LIBRARY where CodeNo='GuarantyType' and ItemNo=:ItemNo";
	String sTempletNo = Sqlca.getString(new SqlObject(sSql).setParameter("ItemNo",sGuarantyType));

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//引入的最高额担保合同在非合同阶段不允许修改
	if(sObjectType.equals("GuarantyContract")||(!sObjectTable.equals("BUSINESS_CONTRACT") && sContractType.equals("020"))) {
		dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写		
	}

	//合同阶段的担保合同类型不允许修改
	if (sObjectTable.equals("BUSINESS_CONTRACT")) {
		doTemp.setReadOnly("ContractType",true);
	}
	doTemp.setUnit("CertID"," <input type=button value=.. onclick=parent.selectCustomer()><font color=red>(存在的客户请选择,否则请输入)</font>");
	doTemp.setHTMLStyle("GuarantyName","style={width:400px} onchange=parent.checkCustomer() ");
	doTemp.setHTMLStyle("CertID","style={width:400px} onchange=parent.getCustomerName() ");

	//设置setEvent
	dwTemp.setEvent("AfterInsert","!BusinessManage.InsertGuarantyRelative(#SerialNo,GuarantyContract,"+sObjectNo+","+sRelativeTableName+")");
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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

	if(sObjectType.equals("GuarantyContract")) {
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
	}
	//客户关联关系搜索的合同信息不允许修改
	if(sObjectType.equals("Customer")) {
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
	}
	//非合同阶段的最高额担保合同不允许修改
	if (!sObjectTable.equals("BUSINESS_CONTRACT") && sContractType.equals("020")) {
		sButtons[0][0] = "false";
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

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){		
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CreditManage/CreditPutOut/AssureFrame.jsp","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
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
		if (getRowCount(0) == 0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"ContractType","<%=sContractType%>");
			setItemValue(0,0,"GuarantyType","<%=sGuarantyType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ContractStatus","<%=sContractStatus%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "GUARANTY_CONTRACT";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码		
		sParaString ="CertType, ";
		sReturn = setObjectValue("SelectOwner",sParaString,"@GuarantyID@0@GuarantyName@1",0,0,"");
		if(sReturn != "_CANCEL_" && typeof(sReturn) != "undefined"){
			getCustomerInfo();
		}		
	}

	/*~[Describe=得到证件类型和证件号码;InputParam=无;OutPutParam=无;]~*/
	function getCustomerInfo()
	{
		var sGuarantyID   = getItemValue(0,getRow(),"GuarantyID");

		//获得客户名称
        var sColName = "CertID@CertType";
		var sTableName = "CUSTOMER_INFO";
		var sWhereClause = "String@CustomerID@"+sGuarantyID;
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('~');
			var my_array1 = new Array();
			for(i = 0;i < sReturn.length;i++)
			{
				my_array1[i] = sReturn[i];
			}
			
			for(j = 0;j < my_array1.length;j++)
			{
				sReturnInfo = my_array1[j].split('@');	
				var my_array2 = new Array();
				for(m = 0;m < sReturnInfo.length;m++)
				{
					my_array2[m] = sReturnInfo[m];
				}
				
				for(n = 0;n < my_array2.length;n++)
				{		
					//设置证件类型
					if(my_array2[n] == "certtype")
						setItemValue(0,getRow(),"CertType",sReturnInfo[n+1]);
					//设置证件号码
					if(my_array2[n] == "certid")
						setItemValue(0,getRow(),"CertID",sReturnInfo[n+1]);
				}				
			}			
		}		
	}

	/*~[Describe=检查是否输入的客户名称，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function checkCustomer()
	{
		setItemValue(0,0,"GuarantyID","")
	}

	/*~[Describe=得到客户名字;InputParam=无;OutPutParam=无;]~*/
	function getCustomerName()
	{
		var sCertType   = getItemValue(0,getRow(),"CertType");
		var sCertID   = getItemValue(0,getRow(),"CertID");
		
		//获得客户名称
        var sColName = "CustomerID@CustomerName";
		var sTableName = "CUSTOMER_INFO";
		var sWhereClause = "String@CertID@"+sCertID+"@String@CertType@"+sCertType;
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('~');
			var my_array1 = new Array();
			for(i = 0;i < sReturn.length;i++)
			{
				my_array1[i] = sReturn[i];
			}
			
			for(j = 0;j < my_array1.length;j++)
			{
				sReturnInfo = my_array1[j].split('@');	
				var my_array2 = new Array();
				for(m = 0;m < sReturnInfo.length;m++)
				{
					my_array2[m] = sReturnInfo[m];
				}
				
				for(n = 0;n < my_array2.length;n++)
				{									
					//设置客户ID
					if(my_array2[n] == "customerid")
						setItemValue(0,getRow(),"GuarantyID",sReturnInfo[n+1]);
					//设置客户名称
					if(my_array2[n] == "customername")
						setItemValue(0,getRow(),"GuarantyName",sReturnInfo[n+1]);
				}
			}			
		}		
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
