<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ccxie 2010/03/22
		Tester:
		Describe: 业务合同所对应的新增的担保合同列表（一个保证合同对应一个保证人）;
		Input Param:
				ObjectType：对象类型（BusinessContract）
				ObjectNo: 对象编号（合同流水号）
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "担保合同列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
    String  sWhereCondition="";
	//获得组件参数：对象类型、对象编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TRSerialNo"));
	String sRelationStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RelationStatus"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sSerialNo == null) sSerialNo = "";	
	if(sRelationStatus == null) sRelationStatus = "";
	sSql ="select RelativeSerialNo from GUARANTY_TRANSFORM where SerialNo =:SerialNo ";
	String sObjectNo = Sqlca.getString(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	sWhereCondition= "where TRANSFORM_RELATIVE.ObjectNo = GUARANTY_CONTRACT.SerialNo "+
	                                 " and TRANSFORM_RELATIVE.SerialNo = '"+sSerialNo+"' ";
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "TransformContractList1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
			
	if(sRelationStatus.equals("010"))
		doTemp.WhereClause = doTemp.WhereClause +sWhereCondition+ " and (TRANSFORM_RELATIVE.RelationStatus = '"+sRelationStatus+"' or TRANSFORM_RELATIVE.RelationStatus = '030' )";
	else
		doTemp.WhereClause = doTemp.WhereClause +sWhereCondition+ " and TRANSFORM_RELATIVE.RelationStatus = '"+sRelationStatus+"' ";
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	
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
		{sRelationStatus.equals("020")?"true":"false","All","Button","新增","新增担保合同","newRecord()",sResourcesPath},
		{sRelationStatus.equals("020")?"true":"false","All","Button","引入","引入最高额担保合同","importGuaranty()",sResourcesPath},
		{sRelationStatus.equals("030")?"true":"false","All","Button","引入","拟解除担保合同","importRecord()",sResourcesPath},
		{"true","","Button","详情","查看担保信息详情","viewAndEdit()",sResourcesPath},
		{sRelationStatus.equals("020")?"true":"false","All","Button","删除","删除担保信息","deleteRecord()",sResourcesPath},
		{sRelationStatus.equals("030")?"true":"false","All","Button","删除","删除解除担保","cancelRecord()",sResourcesPath},
		{"true","","Button","担保客户详情","查看担保相关的担保客户详情","viewCustomerInfo()",sResourcesPath},
		};
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
		sGuarantyType=PopPage("/CreditManage/CreditAssure/AddAssureDialog2.jsp","","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
		if(typeof(sGuarantyType) != "undefined" && sGuarantyType.length != 0 && sGuarantyType != '_none_')
		{
			OpenPage("/CreditManage/CreditTransform/TransformContractAssureInfo1.jsp?GuarantyType="+sGuarantyType,"right");
		}
	}

	/*~[Describe=引入最高额担保合同;InputParam=无;OutPutParam=无;]~*/
	function importGuaranty()
	{
	  	sParaString = "RelativeTableName,TRANSFORM_RELATIVE RT,ObjectNo,<%=sObjectNo%>,ContractStatus,020,ContractType,020,OrgID,<%=CurUser.getOrgID()%>";
		sReturn = selectObjectValue("SelectImportGuarantyContract",sParaString,"",0,0,"");
		if(sReturn=="" || sReturn=="_CANCEL_" || sReturn=="_NONE_" || sReturn=="_CLEAR_" || typeof(sReturn)=="undefined") return;
		sReturn= sReturn.split('@');
		sObjectNo = sReturn[0];
		sReturn = RunMethod("BusinessManage","InsertTransformRelative",<%=sSerialNo%>+","+sObjectNo+",GuarantyContract,020");
		if(sReturn == "EXIST") alert(getBusinessMessage('415'));//该担保合同已经引入！
		if(sReturn == "SUCCEEDED") {
			alert(getBusinessMessage('416'));//引入担保合同成功！
			reloadSelf();
		}
	}
	
	/*~[Describe=引入拟解除担保合同;InputParam=无;OutPutParam=无;]~*/
	function importRecord()
	{
		var sParaString = "SerialNo,<%=sSerialNo%>,RelationStatus,010";
		var sReturn= selectObjectValue("SelectTransformGuaranty",sParaString,"");
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_'||sReturn=='_NONE_'))
		{
			sReturns = sReturn.split('@');
			RunMethod("BusinessManage","UpdateTransformStatus",<%=sSerialNo%>+",030,"+sReturns[0]);
			alert("引入成功！");
			reloadSelf();
		}
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		sContractType = getItemValue(0,getRow(),"ContractType");
		if(sContractType == "010"){
			if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
			{
				alert(getHtmlMessage('1'));//请选择一条信息！
			}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
			{
				sReturn=RunMethod("BusinessManage","DeleteGuarantyContract","<%=sObjectType%>,<%=sSerialNo%>,"+sSerialNo);
				if(typeof(sReturn)!="undefined"&&sReturn=="SUCCEEDED") 
				{
					alert(getHtmlMessage('7'));//信息删除成功！
					reloadSelf();
				}else
				{
					alert(getHtmlMessage('8'));//对不起，删除信息失败！
					return;
				}
			}
		}else{
			RunMethod("BusinessManage","DeleteTransformRelative","<%=sSerialNo%>,<%=sObjectNo%>,GuarantyContract,"+sSerialNo);
			alert(getHtmlMessage('7'));//信息删除成功！
			reloadSelf();
		}
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function cancelRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			sReturn=RunMethod("BusinessManage","UpdateTransformStatus",<%=sSerialNo%>+",010,"+sSerialNo);
			alert(getHtmlMessage('7'));//信息删除成功！
			reloadSelf();
		}
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--担保信息编号
		sContractType = getItemValue(0,getRow(),"ContractType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");//--担保方式
			OpenPage("/CreditManage/CreditTransform/TransformContractAssureInfo1.jsp?SerialNo="+sSerialNo+"&GuarantyType="+sGuarantyType+"&ContractType="+sContractType+"&TRSerialNo=<%=sSerialNo%>","right");
		}
	}

	/*~[Describe=查看担保客户详情详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomerInfo()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else 
		{
			sCustomerID = getItemValue(0,getRow(),"GuarantorID");
			if (typeof(sCustomerID)=="undefined" || sCustomerID.length == 0)
				alert(getBusinessMessage('413'));//系统中不存在担保人的客户基本信息，不能查看！
			else
				openObject("Customer",sCustomerID,"002");
		}
	}


	/*~[Describe=选中某笔担保合同,联动显示担保项下的抵质押物;InputParam=无;OutPutParam=无;]~*/
	function mySelectRow()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//--流水号码
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
		}else
		{
			sGuarantyType = getItemValue(0,getRow(),"GuarantyType");
			if (sGuarantyType.substring(0,3) == "010") {
				OpenPage("/Blank.jsp?TextToShow=保证担保下无详细信息!","DetailFrame","");
			}else 
			{
				if (sGuarantyType.substring(0,3) == "050") //抵押
					OpenPage("/CreditManage/CreditTransform/TransformContractPawnList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&RelationStatus=<%=sRelationStatus%>&ContractNo="+sSerialNo,"DetailFrame","");
				else //质押
					OpenPage("/CreditManage/CreditTransform/TransformContractImpawnList1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&RelationStatus=<%=sRelationStatus%>&ContractNo="+sSerialNo,"DetailFrame","");
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
	OpenPage("/Blank.jsp?TextToShow=请先选择相应的担保信息!","DetailFrame","");
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>