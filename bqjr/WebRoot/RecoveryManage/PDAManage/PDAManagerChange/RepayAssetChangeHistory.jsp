<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*	Author: djia 2010-09-06
*	Tester:
*	Describe: 抵债管理人变更记录列表;
*	Input Param:
*		ObjectType：Asset_info
*		ObjectNo：抵债资产流水编号
*	Output Param:     
*		SerialNo	:变更记录流水号       
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债管理人变更记录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%


	//获得组件参数
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); //资产流水号
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); //asset_info
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String sHeaders[][] = {								
							{"OldUserName","原管理人"},
							{"OldOrgName","原管理机构"},
							{"NewUserName","现管理人"},
							{"NewOrgName","现管理机构"},
							{"ChangeUserName","变更人"},
							{"ChangeOrgName","变更机构"},
							{"ChangeTime","变更日期"}
						};

	String sSql = " select SerialNo, "+				  
				  " OldUserName, "+ 
				  " OldOrgName, "+
				  " NewUserName, "+ 
				  " NewOrgName, "+ 
				  " getUserName(ChangeUserID) as ChangeUserName, "+ 
				  " getOrgName(ChangeOrgID) as ChangeOrgName, "+ 
				  " ChangeTime  as ChangeTime "+
				  " from MANAGE_CHANGE "+
				  " where ObjectType = '"+sObjectType+"' "+
				  " and ObjectNo = '"+sObjectNo+"' "+
				  " order by ChangeTime desc";

	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.UpdateTable = "MANAGE_CHANGE";	
	doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //设置关键字

	//设置不可见项
	doTemp.setVisible("SerialNo",false);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	doTemp.setHTMLStyle("OldUserName"," style={width:67px} ");
	doTemp.setHTMLStyle("OldOrgName"," style={width:90px} ");
	doTemp.setHTMLStyle("NewUserName"," style={width:67px} ");
	doTemp.setHTMLStyle("NewOrgName"," style={width:90px} ");
	doTemp.setHTMLStyle("ChangeUserName"," style={width:65px} ");
	doTemp.setHTMLStyle("ChangeOrgName,AssetNo,AssetName"," style={width:90px} ");
	doTemp.setHTMLStyle("ChangeTime"," style={width:70px} ");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNo);	
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
		{"true","","Button","详情","查看记录详细信息","viewAndEdit()",sResourcesPath},
		{"true","","Button","返回","返回","goBack()",sResourcesPath},
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else
		{
			sObjectNo="<%=sObjectNo%>";
			sObjectType="<%=sObjectType%>";
			OpenPage(	"/LAP/RepayAssetManage/PDAManagerChange/RepayAssetChangeInfo.jsp?"+
				"ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo+"&GoBackType=2","right");
		}
	}
	
	function goBack()
	{
		OpenComp("RepayAssetList","/LAP/RepayAssetManage/PDAManagerChange/RepayAssetList.jsp","ComponentName=抵债资产管理人变更&ComponentType=ListWindow","right");
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

<%@include file="/IncludeEnd.jsp"%>
