<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   slliu 2004.11.22
		Tester:
		Content: 管理人变更基本信息
		Change Param:
				ObjectNo: 对象编号
				ObjectType：对象类型
				SerialNo：变更记录流水号
				ManageUserID：原管理人
				ManageOrgID：原管理机构		       		
		Output param:
		               
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "管理人变更基本信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	String sSerialNo = "";  	//记录流水号
	String sManageUserID = ""; 	//原管理人
	String sManageOrgID = "";	//原管理机构
	String sUserName = "";  	//原管理人名称
	String sOrgName = "";	//原管理机构名称
	String sObjectNo = "";	//对象编号
	String sObjectType = "";	//对象类型
	String sTableName = "";
	
	//获得页面参数
	//变更记录流水号
	sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));  
	//原管理人,原管理机构
	sManageUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ManageUserID"));  
	sManageOrgID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ManageOrgID"));  
    //原管理人名称,原管理机构名称
	sUserName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserName"));  
	sOrgName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgName"));  
    //对象编号（案件编号）,对象类型
	sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
	String sFlag = DataConvert.toRealString(iPostChange,CurPage.getParameter("Flag"));
	if(sFlag==null) sFlag="";
%>
<%/*~END~*/%>


<%

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ManagerChangeInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//保存时后续事件
	//定义后续事件中要保存的表
	sTableName = "LAWCASE_INFO";
	dwTemp.setEvent("AfterInsert","!BusinessManage.ChangeManagerAction("+sObjectNo+",#NewUserID,#NewOrgID,"+sTableName+")");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo+","+sSerialNo);
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
		
	if(sFlag.equals("Y")) 
	{
		sButtons[0][0]="false";
	}
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	
	<script type="text/javascript">
	
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;ChangeParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
	}
	
	/*~[Describe=返回列表页面;ChangeParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		var Flag="<%=sFlag%>";
		if(Flag=='Y') 
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseHistoryChangeList.jsp","right","");
		else
			OpenPage("/RecoveryManage/LawCaseManage/LawCaseManagerChangeList.jsp","right","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">

	
	/*~[Describe=执行更新操作前执行的代码;ChangeParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=页面装载时，对DW进行初始化;ChangeParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录			
			//记录流水号
			setItemValue(0,0,"SerialNo","<%=sSerialNo%>");			
			//对象编号、对象类型
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");			
			//原管理人、原管理人名称、原管理机构、原管理机构名称
			setItemValue(0,0,"OldUserID","<%=sManageUserID%>");
			setItemValue(0,0,"OldUserName","<%=sUserName%>");
			setItemValue(0,0,"OldOrgID","<%=sManageOrgID%>");
			setItemValue(0,0,"OldOrgName","<%=sOrgName%>");		
			//登记人、登记人名称、登记机构、登记机构名称
			setItemValue(0,0,"ChangeUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ChangeUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"ChangeOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"ChangeOrgName","<%=CurOrg.getOrgName()%>");			
			//登记日期						
			setItemValue(0,0,"ChangeTime","<%=StringFunction.getToday()%>");			
		}
    }
    	
    /*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/	
	function getNewUserName()
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.getOrgID()%>";
		setObjectValue("SelectUserLaw",sParaString,"@NewUserID@0@NewUserName@1@NewOrgID@2@NewOrgName@3",0,0,"");
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

