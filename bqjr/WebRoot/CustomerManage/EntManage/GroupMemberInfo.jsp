<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: FMWu 2004-11-29
		Tester:
		Describe: 关联集团成员信息;
		Input Param:
			CustomerID：当前客户编号
			RelativeID：关联客户组织机构代码
			Relationship：关联关系
		Output Param:
			CustomerID：当前客户编号
		HistoryLog:
		    cbsu 2009/10/23 为适应新的集团客户管理需求，将更新表改为GROUP_RELATIVE。
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "关联集团成员信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
    String sCertType = "";
    String sCertID = "";
    String sCustomerName = "";
    ASResultSet rs = null;
	//获得组件参数
	//集团客户编号
	String sRelativeID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	//获得页面参数
	//集团成员编号
	String sGroupMemberID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GroupMemberID"));
	//集团类型:"实体集团"或"虚拟集团"
	String sGroupType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GroupType"));
	if(sRelativeID == null) sRelativeID = "";
	if(sGroupType == null) sGroupType = "";
	if(sGroupMemberID == null) {
		sGroupMemberID = "";
	} else {
	    //得到集团成员证件类型，证件编号，名称
		sSql = " Select CertType, CertID, CustomerName from CUSTOMER_INFO Where CustomerID = :CustomerID";
		rs =  Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sGroupMemberID));
		if (rs.next()) {
			sCustomerName = rs.getString("CustomerName");
			sCertType = rs.getString("CertType");
			sCertID = rs.getString("CertID");
		}
		rs.getStatement().close();
	} 
%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = {
							{"CustomerName","集团成员名称"},
							{"CertType","集团成员证件类型"},
							{"CertID","关联集团成员证件号码"},
							{"RelationShip","成员类型"},
							{"Remark","备注"},
							{"OrgName","登记机构"},
							{"UserName","登记人"},
							{"InputDate","登记日期"},
							{"UpdateDate","更新日期"}
						   };

	sSql =	" select '' as CustomerName,CustomerID,RelativeID," +
			" '' as CertType,'' as CertID,RelationShip," +
			" InputOrgId,getOrgName(InputOrgId) as OrgName,"+
			" InputUserId,getUserName(InputUserId) as UserName,InputDate,UpdateDate "+
			" from GROUP_RELATIVE " +
			" where CustomerID='"+sGroupMemberID+"' " +
			" and RelativeID='"+sRelativeID+"' ";

	//由sSql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头,更新表名,键值,必输项,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GROUP_RELATIVE";
	doTemp.setKey("CustomerID,RelativeID",true);
	doTemp.setRequired("RelationShip,CustomerName",true);
	doTemp.setVisible("CustomerID,RelativeID,InputUserId,InputOrgId",false);
	doTemp.setUpdateable("UserName,OrgName,CustomerName,CertType,CertID",false);

	//设置字段格式
	doTemp.setEditStyle("Remark","3");
	doTemp.setLimit("Remark",400);
	doTemp.setHTMLStyle("Remark","style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("CustomerName"," style={width:300px} ");
	//注意,先设HTMLStyle，再设ReadOnly，否则ReadOnly不会变灰
	doTemp.setHTMLStyle("UserName,InputDate,UpdateDate"," style={width:80px}");
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);

	//设置下拉框
	doTemp.setDDDWSql("CertType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='CertType' and ItemNo like 'Ent%'");
    doTemp.setDDDWSql("RelationShip","select ItemNo,ItemName from CODE_LIBRARY where CodeNo='GroupRelation' and ItemNo like '10%' and length(ItemNo)>2 ");
    doTemp.setDefaultValue("RelationShip","1020");
	doTemp.setReadOnly("CustomerName,CertType,CertID",true);
	//若关联客户编号为空，则出现选择客户提示框
	if(sGroupMemberID.equals(""))
	{
		doTemp.setUnit("CustomerName"," <input class=\"inputdate\" type=button value=... onclick=parent.selectCustomer()>");
	}
	//生成数据窗体
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform格式

	////更新CUSTOMER_INFO, ENT_INFO, GROUP_CHANGE三张表
	dwTemp.setEvent("AfterInsert","!CustomerManage.AddGroupInfo(#CustomerID,#RelativeID,"+CurUser.getUserID()+")");

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
		//保存前进行检查,检查通过后继续保存,否则给出提示
        if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}else
			beforeUpdate()
		as_save("myiframe0",sPostEvents);	
	}

	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/GroupMemberList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		sRelativeID = "<%=sRelativeID%>";
		//返回客户的相关信息、客户代码、客户名称、证件类型、客户证件号码、贷款卡编号		
		setObjectValue("SelectDisRelativeMember","RelativeID,"+sRelativeID,"@CustomerID@0@CustomerName@1@CertType@2@CertID@3",0,0,"");
    }

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
			bIsInsert = true;
			setItemValue(0,0,"RelativeID","<%=sRelativeID%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgId","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		} else {
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"CertType","<%=sCertType%>");
			setItemValue(0,0,"CertID","<%=sCertID%>");
		}
	}

	/*~[Describe=检查录入的客户是否为已经与集团相关联;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{
		
		//客户编号
		sCustomerID   = getItemValue(0,0,"CustomerID");
		//集团客户编号
		sRelativeID = getItemValue(0,0,"RelativeID");
		sRelationShip = getItemValue(0,0,"RelationShip");

		//检查是否录入了多个母公司，一个集团只能有一个母公司 add by cbsu 2009-11-02		
		if (sRelationShip == '1010') {
			var isMultiParent = RunMethod("CustomerManage", "CheckMultiParent", sRelativeID);
			if (isMultiParent == "Failed") {
				alert("母公司已经存在，一个集团不能有两个母公司！请重新选择成员类型或更改原母公司的成员类型为子公司。");
			    return false;
			}
		}

        //在新增时检查录入的客户是否为已经与集团相关联
		if(bIsInsert){			
			var isRelated = RunMethod("CustomerManage","CheckGroupRelative",sCustomerID + "," + sRelativeID);
			if (isRelated == "Failed"){
				alert("选择的客户已与集团关联，请选择其他客户！");
				return false;
			}
		}
		return true;
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	//页面装载时，对DW当前记录进行初始化
	initRow();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>