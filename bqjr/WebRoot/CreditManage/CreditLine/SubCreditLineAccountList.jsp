<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2006/03/31
		Tester:
		Content: 授信额度分配列表页面
		Input Param:
			ParentLineID：额度编号
		Output param:
		
		History Log: 

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信额度分配列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数	
	
	//获得页面参数	
	String sParentLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentLineID"));
	if(sParentLineID == null) sParentLineID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%		
	//显示标题
	String[][] sHeaders = {
						{"CustomerID","客户编号"},
						{"CustomerName","客户名称"},
						{"BusinessTypeName","业务品种"},
						{"RotativeName","是否循环"},
						{"BailRatio","最低保证金比率"},
						{"LineSum1","授信限额"},
						{"LineSum2","敞口限额"},
						{"SubBalance","子额度余额"}
					};
	
		sSql =  " select LineID,CustomerID,CustomerName,BusinessType, "+
				" getBusinessName(BusinessType) as BusinessTypeName, "+
				" Rotative,getItemName('YesNo',Rotative) as RotativeName, "+
				" BailRatio,LineSum1,LineSum2,SubBalance,BCSerialNo "+
				" from CL_INFO "+
				" Where ParentLineID = '"+sParentLineID+"' ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID,",true);
	doTemp.setHeader(sHeaders);
	//设置不可见性
	doTemp.setVisible("LineID,BusinessType,Rotative,BCSerialNo",false);
	//设置格式
	doTemp.setType("LineSum1,LineSum2,BailRatio,SubBalance","Number");
	doTemp.setCheckFormat("LineSum1,LineSum2,BailRatio,SubBalance","2");
	//doTemp.setUnit("LineSum1,LineSum2,SubBalance","(元)");
	doTemp.setUnit("BailRatio","(%)");
			
	//设置Filter
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//定义后续事件
	dwTemp.setEvent("AfterDelete","!CreditLine.DeleteCLLimitationRelative(#LineID)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","授信子额度项下业务","查看授信子额度项下业务详情","viewBusiness()",sResourcesPath},
		{"true","","Button","授信子额度余额","查看授信子额度余额","viewSubLineBalance()",sResourcesPath},
		};
		
	%> 
	
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看授信子额度项下业务详情;InputParam=无;OutPutParam=无;]~*/
	function viewBusiness()
	{
		sBCSerialNo = getItemValue(0,getRow(),"BCSerialNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("SublineSubList","/CreditManage/CreditLine/SublineSubList.jsp","LineNo="+sBCSerialNo+"&BusinessType="+sBusinessType,"","");
	}

	/*~[Describe=查看授信子额度余额;InputParam=无;OutPutParam=无;]~*/
	function viewSubLineBalance()
	{
		sBCSerialNo = getItemValue(0,getRow(),"BCSerialNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		PopPage("/CreditManage/CreditLine/GetSubLineBalance.jsp?LineNo="+sBCSerialNo+"&BusinessType="+sBusinessType,"","dialogWidth=26;dialogHeight=14;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSubLineID = getItemValue(0,getRow(),"LineID");
		if (typeof(sSubLineID) == "undefined" || sSubLineID.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		PopComp("SubCreditLineAccountInfo","/CreditManage/CreditLine/SubCreditLineAccountInfo.jsp","ParentLineID=<%=sParentLineID%>&SubLineID="+sSubLineID,"","");
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

<%@ include file="/IncludeEnd.jsp"%>
