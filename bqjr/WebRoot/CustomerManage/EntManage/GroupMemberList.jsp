<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zywei 2005-12-27
		Tester:
		Describe: 关联集团成员信息列表;
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			CustomerID：当前客户编号
			RelativeID：关联客户组织机构代码
			Relationship：关联关系
		HistoryLog:
		    cbsu 2009/10/23 为适应ALS6.5新的集团客户管理需求，将页面更新表由CUSTOMER_RELATIVE改为GROUP_RELATIVE.
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "关联集团成员信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得页面参数
	//获得组件参数
	
    //集团客户编号
    String sRelativeID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

    //得到集团客户的客户类型：实体集团或虚拟集团 
    String sSql = " Select CustomerType from CUSTOMER_INFO where CustomerID = :CustomerID";
    String sGroupType = Sqlca.getString(new SqlObject(sSql).setParameter("CustomerID",sRelativeID));
    if (sGroupType == null) sGroupType = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
	String sHeaders[][] = {
							{"CustomerName","集团成员名称"},
							{"CertType","证件类型"},
							{"CertID","证件号码"},
							{"RelationShip","成员类型"},
							{"RelationShipName","成员类型"},
							{"ManageOrgName","管户机构"},
							{"ManageUserName","管户客户经理"}
						  };
    //从GROUP_RELATIVE和CUSTOMER_INFO表中得到 集团成员编号，集团编号，集团成员名称，集团成员证件类型
    //集团成员证件号码，关系，管户机构，管户人
	sSql =  " select CI.CustomerID,GR.RelativeID,CI.CustomerName, "+
			" getItemName('CertType',CI.CertType) as CertType, "+
			" CI.CertID,GR.RelationShip, getItemName('GroupRelation',GR.RelationShip) as RelationShipName,"+
			" getManageOrgName(CI.CustomerID) as ManageOrgName, "+
			" getManageUserName(CI.CustomerID) as ManageUserName " +
			" from GROUP_RELATIVE GR, CUSTOMER_INFO CI" +
			" where GR.RelativeID='"+sRelativeID+"' "+
			" and GR.CustomerID = CI.CustomerID";

   	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GROUP_RELATIVE";
	//设置主键。用于后面的删除
	doTemp.setKey("CustomerID,RelativeID",true);
	//设置不可见项
	doTemp.setVisible("CustomerID,RelativeID,InputUserID,RelationShip,RelationShipName",false);
	//格式设置
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setAlign("CertType","2");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteGroupInfo(#CustomerID,#RelativeID,"+CurUser.getUserID()+")");
	
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
		{"true","","Button","新增","新增关联企业成员信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看关联企业成员信息详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除关联企业成员信息","deleteRecord()",sResourcesPath},
		{"true","","Button","客户详情","查看关联企业成员客户信息详情","viewCustomer()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{  
		var sGroupType = "<%=sGroupType%>";
	    OpenPage("/CustomerManage/EntManage/GroupMemberInfo.jsp?GroupType="+sGroupType,"_self",""); //modify by cbsu 2009-10-22
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句			
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sGroupType = "<%=sGroupType%>"; //add by cbsu 2009-10-22
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/CustomerManage/EntManage/GroupMemberInfo.jsp?GroupMemberID="+sCustomerID+"&GroupType="+sGroupType, "_self","");
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomer()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			openObject("Customer",sCustomerID,"003");
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
