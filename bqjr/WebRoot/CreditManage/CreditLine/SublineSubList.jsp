<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2006/04/07
		Tester:
		Content: 授信子额度项下业务列表
		Input Param:
			LineNo：授信额度协议号
			BusinessType：业务品种
		Output param:
		History Log:
				2009.07.01 hwang 修改获取子额度项下业务列表逻辑

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信子额度项下业务列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sLineNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("LineNo"));
	String sBusinessType = DataConvert.toRealString(iPostChange,CurComp.getParameter("BusinessType"));
	//将空值转化为空字符串
	if(sLineNo == null) sLineNo = "";
	if(sBusinessType == null) sBusinessType = "";
	
	//获得页面参数	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {
							{"BusinessTypeName","业务品种"},
							{"CustomerName","客户名称"},
							{"ArtificialNo","合同编号"},
							{"OccurTypeName","发生类型"},
							{"Currency","币种"},
							{"BusinessSum","合同金额"},
							{"RelativeSum","已出账金额"},
							{"Balance","余额"},
							{"VouchTypeName","主要担保方式"},
							{"PutOutDate","起始日期"},
							{"Maturity","到期日期"},
							{"ManageOrgName","经办机构"},
					};
	sSql = "select SerialNo,CustomerID,CustomerName,BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
		 " ArtificialNo,BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
		 " BusinessSum,Balance,OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
		 " VouchType,getItemName('VouchType',VouchType) as VouchTypeName,PutOutDate,Maturity,"+
		 " ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName "+
		 " from BUSINESS_CONTRACT "+
		 " Where SerialNo in(select ObjectNo from CREDITLINE_RELA where LineNo = '"+sLineNo+"' and ObjectType='BusinessContract' and BusinessType like '"+sBusinessType+"%') ";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="BUSINESS_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("SerialNo,CustomerID,BusinessType,OccurType,BusinessCurrency,VouchType,ManageOrgID",false);
	
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and 1=1 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//out.println(doTemp.SourceSql); //常用这句话调试datawindow
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
		{"true","","Button","合同详情","额度项下业务详情","viewTab()",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
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
	setDialogTitle("授信子额度项下业务列表");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
