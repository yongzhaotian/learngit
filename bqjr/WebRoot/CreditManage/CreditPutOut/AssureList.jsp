<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --FMWu 2004-12-6
		Tester:
		Describe: --担保合同列表;
		Input Param:
				ObjectType: --对象类型(业务阶段)。
				ObjectNo: --对象编号（申请/批复/合同流水号）。
				ContractType: --合同类型
					010 --一般担保信息
					020 --最高额担保合同
		Output Param:
				SerialNo:--担保合同号
				ContractType: --合同类型
					010 --一般担保信息
					020 --最高额担保合同

		HistoryLog:
			2005-08-07 王业罡 代码重检 
								1.增加引入bizlet
								2.修改删除时错误的逻辑：对于引入的最高担保合同，删除时不能删除担保合同主体
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "担保合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	ASResultSet rs=null;//--存放结果集
	//获得组件参数，对象类型、对象编号、合同类型
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sContractType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ContractType"));
	String sWhereType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("WhereType"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sContractType == null) sContractType = "";
	if(sWhereType == null) sWhereType = "";
	//根据sObjectType的不同，得到不同的关联表名
	sSql="select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
	String sRelativeTableName = "",sObjectTable="";
	rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType",sObjectType));
	if(rs.next()){
		sRelativeTableName=rs.getString("RelativeTable");
		sObjectTable=rs.getString("ObjectTable");
	}
	rs.getStatement().close();

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","担保合同流水号"},
							{"ContractNo","担保合同编号"},
							{"GuarantyTypeName","担保类型"},
				            {"ContractStatusName","合同状态"},
							{"Currency","币种"},
				            {"GuarantorName","保证人/抵押人/出质人名称"},
				            {"GuarantyValue","担保总金额"},
						  };

	sSql =  " select"+
			" SerialNo,CustomerID,ContractNo,"+
			" GuarantyType,getItemName('GuarantyType',GuarantyType) as GuarantyTypeName,"+
			" GuarantorID,GuarantorName,GuarantyValue,"+
			" ContractStatus,getItemName('ContractStatus',ContractStatus) as ContractStatusName"+
			" from GUARANTY_CONTRACT"+
			" where SerialNo in (Select ObjectNo from "+sRelativeTableName+" where "+
			" SerialNo='"+sObjectNo+"' and ObjectType='GuarantyContract') ";
	if(sWhereType.equals("User"))
		sSql =  " select"+
			" SerialNo,CustomerID,ContractNo,"+
			" GuarantyType,getItemName('GuarantyType',GuarantyType) as GuarantyTypeName,"+
			" GuarantorID,GuarantorName,GuarantyValue,"+
			" ContractStatus,getItemName('ContractStatus',ContractStatus) as ContractStatusName"+
			" from GUARANTY_CONTRACT "+
			" where InputUserID='"+CurUser.getUserID()+"'";
	else if(sWhereType.equals("Org"))
		sSql =  " select"+
			" SerialNo,CustomerID,ContractNo,"+
			" GuarantyType,getItemName('GuarantyType',GuarantyType) as GuarantyTypeName,"+
			" GuarantorID,GuarantorName,GuarantyValue,"+
			" ContractStatus,getItemName('ContractStatus',ContractStatus) as ContractStatusName"+
			" from GUARANTY_CONTRACT "+
			" where  InputOrgID='"+CurOrg.getOrgID()+"'";

    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头,更新表名,键值,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("SerialNo,CustomerID,GuarantorID,ContractStatus,ContractType,GuarantyType,GuarantyCurrency,InputOrgId,InputUserId",false);
	doTemp.setUpdateable("",false);
	//设置格式
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setCheckFormat("GuarantyValue","2");
	doTemp.setHTMLStyle("GuarantyType,ContractStatus"," style={width:60px} ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:180px} ");
	if(sObjectTable.equals("BUSINESS_APPROVE")||sObjectTable.equals("BUSINESS_APPLY"))
	{
		if(sContractType.equals("010"))
		{
			doTemp.setVisible("ContractNo,ContractStatusName",false);
			doTemp.WhereClause+=" and (ContractStatus='010' or ContractStatus is null) ";
		}
		else if(sContractType.equals("020"))
			doTemp.WhereClause+=" and ContractStatus='020' and ContractType='020'";
	}
	else
	{
		doTemp.WhereClause+=" and ContractType='"+sContractType+"' ";
	}
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	//out.print(doTemp.SourceSql);
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
		{"true","","Button","新增","新增担保合同信息","newRecord()",sResourcesPath},
		{"true","","Button","引入","引入担保合同信息","addRecord()",sResourcesPath},
		{"true","","Button","详情","查看担保合同信息详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除担保合同信息","deleteRecord()",sResourcesPath},
		{"true","","Button","担保客户详情","查看担保合同相关的担保客户详情","viewCustomerInfo()",sResourcesPath},
		{"true","","Button","相关业务详情","查看担保合同相关的主合同信息列表","viewBusinessInfo()",sResourcesPath},
		{"true","","Button","担保失效","失效担保合同","statusChange()",sResourcesPath},
		};

	//假如是一般担保合同，则没有引入
	if (sContractType.equals("010")) {
		sButtons[1][0] = "false";
	}

	if(!sObjectTable.equals("BUSINESS_CONTRACT"))
	{
		sButtons[6][0] = "false";
		if(sContractType.equals("020"))
		{
			sButtons[0][0] = "false";
		}
	}
	if(sWhereType.equals("User")||sWhereType.equals("Org"))
	{
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[3][0] = "false";
	}
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		sGList=PopPage("/CreditManage/CreditPutOut/AddAssureDialog.jsp","","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(sGList)!="undefined" && sGList.length!=0 && sGList != '_none_')
		{
			OpenPage("/CreditManage/CreditPutOut/AssureInfo.jsp?GuarantyType="+sGList,"right");
		}
	}

	/*~[Describe=引入记录;InputParam=无;OutPutParam=无;]~*/
	function addRecord()
	{
	    //传入当前的条件即可
	    sParaString = "ContractStatus"+","+"020"+","+"ContractType"+","+"020";
		sReturn = selectObjectValue("SelectImportGuarantyContract",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") return;
		sReturn= sReturn.split('@');
		sSerialNo = sReturn[0];
		sReturn=RunMethod("BusinessManage","ImportGauarantyContract","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
		if(sReturn == "EXIST") alert("该担保合同已经引入！");
		if(sReturn == "SUCCEEDED") {
			alert("引入合同成功！");
			reloadSelf();
		}
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			sReturn=RunMethod("BusinessManage","DeleteAssure","<%=sObjectType%>,<%=sObjectNo%>,"+sSerialNo);
			if(typeof(sReturn)!="undefined"&&sReturn=="SUCCEEDED") 
			{
				alert("删除成功!");
				reloadSelf();
			}
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else {
			OpenPage("/CreditManage/CreditPutOut/AssureInfo.jsp?SerialNo="+sSerialNo,"right");
		}
	}

	/*~[Describe=查看担保客户详情详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomerInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else {
			sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (sCustomerID.length == 0)
				alert("担保客户无详细信息！");
			else
				openObject("Customer",sCustomerID,"002");
		}
	}

	/*~[Describe=查看最高额担保合同关联业务详情;InputParam=无;OutPutParam=无;]~*/
	function viewBusinessInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else {
			OpenComp("AssureBusinessList","/CreditManage/CreditPutOut/AssureBusinessList.jsp","SerialNo="+sSerialNo,"_blank",OpenStyle);
		}
	}

	/*~[Describe=失效担保合同;InputParam=无;OutPutParam=无;]~*/
	function statusChange()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm('您真的想失效担保合同吗？')) //您真的想失效担保合同吗？
		{
			RunMethod("BusinessManage","UpdateGuarantyContractStatus",sSerialNo+",030");
			reloadSelf();
			OpenPage("/Blank.jsp??TextToShow=请在上方列表中选择一条担保合同信息","rightdown");
		}
	}

	/*~[Describe=选中某笔担保合同,联动显示担保项下的抵质押物;InputParam=无;OutPutParam=无;]~*/
	function mySelectRow()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}
		else {
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");
			//alert(sGuarantyType);
			if (sGuarantyType.substring(0,3) == "010") {
				OpenPage("/Blank.jsp?TextToShow=保证担保下无详细信息!","rightdown");
			}
			else {
				OpenComp("GuarantyList","/CreditManage/GuarantyManage/GuarantyList.jsp","ObjectNo="+sSerialNo+"&ObjectType=<%=sObjectType%>&GuarantyType="+sGuarantyType+"&WhereType=Guaranty_Contract","rightdown");
			}
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