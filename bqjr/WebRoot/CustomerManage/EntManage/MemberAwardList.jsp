<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-1
		Tester:
		Describe: 关联集团(或联保小组)成员授信额度信息列表;
		Input Param:
			CustomerID：当前客户编号
			NoteType：区分 关联集团：Aggregate
            		       联保小组：AssureGroup
		Output Param:
          	ObjectType: 对象类型。
        	ObjectNo: 对象编号。
        	BackType: 返回方式类型(Blank)


		HistoryLog:
		增加联保小组
		2004-12-14
		jytian
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "关联集团成员授信额度信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sCon = "";
	
	//获得页面参数	
	
	//获得组件参数	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sNoteType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("NoteType"));
	if(sCustomerID == null) sCustomerID = "";
	if(sNoteType == null) sNoteType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	if (sNoteType.equals("Aggregate"))
	{
		//将目标表由CUSTOMER_RELATIVE改为GROUP_RELATIVE add by cbsu 2009-11-02
		sCon=" ( Select CustomerID from GROUP_RELATIVE where RelativeID='"+sCustomerID+"' and (RelationShip like '10%' or RelationShip like '20%') )";
	}
    //下面这个分支是处理关系为"联保小组"的客户，在ALS6.5版本中并未提供此功能模块。如需添加此功能，请自行更改。
	//else if (sNoteType.equals("AssureGroup"))
	//{
	//	sCon=" (select CustomerID from CUSTOMER_RELATIVE where RelativeID='"+sCustomerID+"' and RelationShip='5501' ) ";
	//}
	
	String sHeaders[][] = { 
							{"SerialNo","授信合同流水号"},
					    	{"CustomerName","成员客户名称"},
	                        {"BusinessTypeName","业务品种"},
	                        {"Currency","币种"},
				            {"BusinessSum","授信额度金额"},
				            {"TotalBalance","剩余额度"},
				            {"VouchTypeName","主要担保方式"},
				            {"OperateOrgName","经办机构"},
				            {"PutOutDate","起始日期"},
				            {"Maturity","到期日期"},
			      		};   				   		
	//取得关联集团(或联保小组)成员CustomerID列表Sql
	String sSql =   " select SerialNo,"+
					" CustomerID,getCustomerName(CustomerID) as CustomerName,"+
					" BusinessType, getBusinessName(BusinessType) as BusinessTypeName,"+
					" getItemName('Currency',BusinessCurrency) as Currency,BusinessSum,TotalBalance,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName,"+
					" PutOutDate,Maturity"+
					" from BUSINESS_CONTRACT "+
					" where CustomerID in  "
					+ sCon +
					" and BusinessType like '3%' and length(BusinessType)>1";

   	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//设置不可见项
	doTemp.setVisible("CustomerID,BusinessType,VouchType,OperateOrgID,",false);
	doTemp.setAlign("BusinessSum,TotalBalance","3");
	doTemp.setAlign("BusinessTypeName,VouchTypeName,Currency","2");
	doTemp.setCheckFormat("BusinessSum,TotalBalance","2");
	//设置格式
	doTemp.setHTMLStyle("BusinessTypeName,CreditTypeName,VouchTypeName,PutOutDate,Maturity,Currency"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("BusinessTypeName"," style={width:150px} ");
	doTemp.setHTMLStyle("VouchTypeName"," style={width:350px} ");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
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
		{"true","","Button","详情","查看授信额度信息详情","viewAndEdit()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			openObject("AfterLoan",sSerialNo,"001");
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

<%@ include file="/IncludeEnd.jsp"%>
