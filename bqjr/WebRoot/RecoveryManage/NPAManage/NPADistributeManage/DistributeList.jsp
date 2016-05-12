<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: hxli 2005-8-4
*	Tester:
*	Describe:已分发不良资产信息列表
*	Input Param:
*
*	Output Param:     
*		sShiftType：移交类型
*		sOldOrgID：原管理机构ID
*		sOldUserID：原管理人ID
*		sOldOrgName：原管理机构
*		sOldUserName：原管理人
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "已分发不良资产信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sCurItemID ;    
	String sWhereClause=""; //Where条件
	String sSql="";

	//获得组件参数
	sCurItemID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemMenuNo"));
	if(sCurItemID == null) sCurItemID = "";
	String sSortNo = CurOrg.getSortNo();
	String sUserID = CurUser.getUserID();
	String sTempletNo = "";
 	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%

	
 	if(sCurItemID.equals("010"))	//客户移交
	{
 		sTempletNo = "DistributeList01";
	}else if(sCurItemID.equals("020")){
		sTempletNo = "DistributeList02";	
	}

	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);//20条一分页

	//生成HTMLDataWindow
	 Vector vTemp = dwTemp.genHTMLDataWindow(sSortNo+","+sUserID);//传入显示模板参数
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
		{"true","","Button","合同详情","查看信贷合同的主从信息、借款人信息及保证人信息等等","viewAndEdit()",sResourcesPath},
		{"true","","Button","变更管理人","不良合同保全部管理人更改","my_ChangeUser()",sResourcesPath},
		{"false","","Button","变更移交类型","合同管理性质转换","my_ShiftManage()",sResourcesPath},
		{"true","","Button","查看管理人变更记录","不良合同保全部管理人更改记录","my_ChangeUserRec()",sResourcesPath},
		{"false","","Button","查看移交类型变更记录","查看移交类型变更记录","my_ChangeType()",sResourcesPath}
		};
	
	if(sCurItemID.equals("020"))	//审批移交
	{
		sButtons[1][0]="false";
		sButtons[3][0]="false";
	}
%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<%/*查看合同详情代码文件*/%>
<%@include file="/RecoveryManage/Public/ContractInfo.jsp"%>

<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
   	
   	/*~[Describe=更改保全部管理人;InputParam=无;OutPutParam=无;]~*/
	function my_ChangeUser()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		else
		{
			sOldOrgID = getItemValue(0,getRow(),"RecoveryOrgID");
			sOldUserID = getItemValue(0,getRow(),"RecoveryUserID");
			sOldOrgName	= getItemValue(0,getRow(),"RecoveryOrgName");
			sOldUserName = getItemValue(0,getRow(),"RecoveryUserName");
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserInfo.jsp?OldOrgName="+sOldOrgName+"&OldUserName="+sOldUserName+"&OldOrgID="+sOldOrgID+"&OldUserID="+sOldUserID+"&ObjectType=BusinessContract&ObjectNo="+sSerialNo,"right",OpenStyle);
		}
	}

	/*~[Describe=变更移交类型;InputParam=无;OutPutParam=无;]~*/
	function my_ShiftManage()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			//弹出对话选择框
			sOldShiftType = getItemValue(0,getRow(),"ShiftType");
			sShiftType = PopPage("/RecoveryManage/NPAManage/NPADistributeManage/ManageShiftChoice.jsp","","dialogWidth=19;dialogHeight=07;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
			if(typeof(sShiftType)!="undefined" && sShiftType.length!=0)
			{
				if(sShiftType == sOldShiftType)
				{
					alert(getBusinessMessage("761"));	//您未改变移交管理类型，操作取消！
					return;
				}else if(confirm(getBusinessMessage("762")))   //是否真的替换移交管理类型?
				{
					sReturn = PopPageAjax("/RecoveryManage/NPAManage/NPADistributeManage/ManageShiftActionAjax.jsp?ShiftType="+sShiftType+"&SerialNo="+sSerialNo+"&OldShiftType="+sOldShiftType+"","","");
					if(sReturn == "true")//刷新页面
					{
						alert(getBusinessMessage("763"));//移交类型变更成功！
						reloadSelf();
					}else{
						alert("移交类型变更失败！");
					}
				}
			}
		}	
	}

    /*~[Describe=查看管理人历次变更记录;InputParam=无;OutPutParam=无;]~*/
	function my_ChangeUserRec()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserList.jsp?ObjectNo="+sSerialNo,"right",OpenStyle);			
		}
	}

	/*~[Describe=查看移交类型历次变更记录;InputParam=无;OutPutParam=无;]~*/
	function my_ChangeType()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else
		{
			OpenPage("/RecoveryManage/NPAManage/NPADistributeManage/NPAChangeUserList.jsp?ObjectNo="+sSerialNo+"&Flag=ShiftType","right",OpenStyle);			
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
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>