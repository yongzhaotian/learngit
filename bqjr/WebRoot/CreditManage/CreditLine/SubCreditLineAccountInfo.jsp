<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:zywei 2006/03/31
		Tester:
		Content: 额度分配基本信息页面
		Input Param:
			ParentLineID：额度编号
			LineID：额度分配编号
		Output param:
		History Log:

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","300");
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得组件参数

	//获得页面参数	
	String sParentLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentLineID"));
	String sSubLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SubLineID"));
	//将空值转化为空字符串
	if(sParentLineID == null) sParentLineID = "";
	if(sSubLineID == null) sSubLineID = "";	
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//设置显示标题
	String[][] sHeaders = {
					{"CustomerID","客户编号"},
					{"CustomerName","客户名称"},
					{"BusinessTypeName","业务品种"},
					{"Rotative","是否循环"},
					{"BailRatio","最低保证金比率"},
					{"LineSum1","授信限额"},
					{"LineSum2","敞口限额"},
					{"InputOrgName","登记机构"},
					{"InputUserName","登记人"},
					{"InputTime","登记日期"},
					{"UpdateTime","更新日期"}
					};

	String sSql = 	" select ParentLineID,LineID,CustomerID,CustomerName,BusinessType, "+
					" getBusinessName(BusinessType) as BusinessTypeName,Rotative, "+
					" BailRatio,LineSum1,LineSum2,GetOrgName(InputOrg) as InputOrgName, "+
					" InputOrg,InputUser,GetUserName(InputUser) as InputUserName,InputTime, "+
					" UpdateTime,CLTypeID,CLTypeName,BCSerialNo "+
					" from CL_INFO "+
					" Where LineID = '"+sSubLineID+"' "+
					" and ParentLineID = '"+sParentLineID+"' ";	
					
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID",true);
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWCode("Rotative","YesNo");
	
	//设置不可见属性
	doTemp.setVisible("ParentLineID,LineID,BusinessType,InputUser,InputOrg,CLTypeID,CLTypeName,BCSerialNo,",false);
	//设置只读属性
	doTemp.setReadOnly("CustomerID,CustomerName,InputUserName,InputOrgName,InputTime,UpdateTime",true);
	//设置必输项
	doTemp.setRequired("BusinessTypeName,Rotative",true);
	//设置不可更新属性
	doTemp.setUpdateable("BusinessTypeName,InputUserName,InputOrgName",false);
	
	//设置格式
	doTemp.setType("LineSum1,LineSum2,BailRatio","Number");
	doTemp.setCheckFormat("LineSum1,LineSum2,BailRatio","2");
	doTemp.setUnit("LineSum1,LineSum2","(元)");
	doTemp.setUnit("BailRatio","(%)");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//设置setEvent

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
			{"true","","Button","授信子额度项下业务","查看授信子额度项下业务详情","viewBusiness()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看授信子额度项下业务详情;InputParam=无;OutPutParam=无;]~*/
	function viewBusiness()
	{
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sBCSerialNo = getItemValue(0,getRow(),"BCSerialNo");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("SublineSubList","/CreditManage/CreditLine/SublineSubList.jsp","LineNo="+sBCSerialNo+"&BusinessType="+sBusinessType,"","");
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">
		
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	OpenPage("/CreditManage/CreditLine/LimitationItemAccountList.jsp?SubLineID=<%=sSubLineID%>","DetailFrame","");	
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
