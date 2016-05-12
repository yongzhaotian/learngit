<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   XWu  2004.12.06
		Tester:
		Content: 不良资产管理人更改
		Input Param:
			sObjectType  :对象类型
			sObjectNo    :对象类型
			sOldRecoveryOrgName :原管理机构
			sOldRecoveryUserName:原管理人
			sSerialNo    :取流水号
		Output param:

		History Log: slliua 2004.12.26

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产管理人更改"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	boolean IsAddInfoFlag = false;  //是否为修改或新增标记，因有不同jsp调用本jsp。
	//获得组件参数	
	
	//获得页面参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType")); //对象类型
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo")); //合同编号
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo")); //流水号
	String sOldOrgID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OldOrgID")); //原管理机构ID
	String sOldUserID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OldUserID")); //原管理人ID
	String sOldOrgName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OldOrgName")); //原管理机构
	String sOldUserName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OldUserName")); //原管理员
	String sFlag = DataConvert.toRealString(iPostChange,CurPage.getParameter("Flag"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sOldOrgID == null) sOldOrgID = "";
	if(sOldUserID == null) sOldUserID = "";
	if(sOldOrgName == null) sOldOrgName = "";
	if(sOldUserName == null) sOldUserName = "";
	if(sFlag == null) sFlag = "";
	if(sSerialNo.equals("")) IsAddInfoFlag = true;     //流水号为空，新增
	
	String sSql = "select getUserName(RecoveryUserID) as RecoveryUserName,getOrgName(RecoveryOrgID) as RecoveryOrgName from BUSINESS_CONTRACT where SerialNo=:SerialNo";
	ASResultSet rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
	if(rs.next()){
		sOldUserName = rs.getString("RecoveryUserName");
		sOldOrgName = rs.getString("RecoveryOrgName");
	}
	rs.getStatement().close();
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ManageChangeInfo";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//设置选项行宽
//	doTemp.setHTMLStyle("OldUserName,NewUserName,ChangeDate,ChangeUserName,ChangeTime"," style={width:80px} ");
	
	//选择新用户
//	doTemp.setUnit("NewUserName"," <input type=button class=inputDate  value=... name=button onClick=\"javascript:parent.getNewUserName()\">");
	//doTemp.appendHTMLStyle("NewUserName","  style={cursor:pointer;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getNewUserName()\" ");
	
	
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
		{"true","","Button","保存","保存所有修改","mySave()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
		};
		
	if(IsAddInfoFlag==false)
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
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}

	//更改合同表保全部门及人员
	function my_ChangeUserAction()
	{
		sRecoveryOrgID = getItemValue(0,getRow(),"NewOrgID");
		sRecoveryUserID = getItemValue(0,getRow(),"NewUserID");
		var sReturn = PopPageAjax("/RecoveryManage/NPAManage/NPADistributeManage/ChangeUserActionAjax.jsp?RecoveryOrgID="+sRecoveryOrgID+"&RecoveryUserID="+sRecoveryUserID+"&SerialNo=<%=sObjectNo%>","","");
	}
	
	/*~[Describe=保存录入的信息;InputParam=无;OutPutParam=无;]~*/
	function mySave()
	{
		//录入数据有效性检查
		saveRecord(my_ChangeUserAction())
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{	
		if(<%=IsAddInfoFlag%>==true) 
		{
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/DistributeList.jsp","right");
			self.close();
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserList.jsp?ObjectNo=<%=sObjectNo%>","right");
			self.close();
		}		
 	}
  		
</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
<script type="text/javascript">

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{		
		initSerialNo();//初始化流水号字段
		setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
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
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"OldOrgID","<%=sOldOrgID%>");
			setItemValue(0,0,"OldUserID","<%=sOldUserID%>");
			setItemValue(0,0,"OldOrgName","<%=sOldOrgName%>");
			setItemValue(0,0,"OldUserName","<%=sOldUserName%>");
			setItemValue(0,0,"ChangeUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"ChangeOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"ChangeUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"ChangeOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"ChangeTime","<%=StringFunction.getToday()%>");
		}
   	}
    	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "MANAGE_CHANGE";//表名
		var sColumnName = "SerialNo";//字段名
		var sPrefix = "";//前缀

		//获取流水号
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	/*~[Describe=弹出用户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/	
	function getNewUserName()
	{
		sParaString = "BelongOrg"+","+"<%=CurOrg.getOrgID()%>";
		setObjectValue("SelectUser",sParaString,"@NewUserID@0@NewUserName@1@NewOrgID@2@NewOrgName@3",0,0,"");
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
