<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   djia 2010-09-06
		Tester:
		Content: 抵债资产管理人变更
		Input Param:
				下列参数作为组件参数输入
				ComponentName	组件名称：已抵入/处置中的资产列表
			    ComponentType		组件类型： ListWindow
		Output param:
				ObjectNo				抵债资产编号
				ObjectType			LAP_REPAYASSETINFO
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产管理人变更---资产列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;抵债资产管理人变更---资产列表&nbsp;&nbsp;";
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sComponentType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentType"));	
	
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"SerialNo","资产编号"},
							{"ObjectNo","申请编号"},
							{"ApplyNo","申请编号"},							
							{"AssetName","资产名称"},
							{"AssetType","资产类别"},	
							{"AssetTypeName","资产类别"},	
							{"AssetSum","抵债资产总额(元)"},
							{"AssetBalance","抵债资产余额(元)"},
							{"ManageUserID","管理人"},
							{"ManageUserName","管理人"},
							{"ManageOrgID","管理机构"},
							{"ManageOrgName","管理机构"}
						}; 
				
		//从抵债资产信息表LAP_REPAYASSETINFO中选出当前管理人的资产
		sSql = "  select SerialNo,"+
					" ObjectNo,"+
					" ApplyNo,"+
					" AssetNo,"+
					" AssetName,"+
					" AssetType,"+
					" getItemName('PDAType',trim(AssetType)) as AssetTypeName,"+
					" AssetSum," +	
					" AssetBalance," +	
					" ManageUserID, " +	
					" ManageOrgID, " +	
					" getUserName(ManageUserID) as ManageUserName, " +	
					" getOrgName(ManageOrgID) as ManageOrgName"+			
					" from LAP_REPAYASSETINFO" +
					" where ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%') "+
					" and AssetAttribute='01' and ManageUserID='"+CurUser.getUserID()+"' order by AssetName desc";
					//AssetAttribute：01－抵债资产、02－查封资产
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LAP_REPAYASSETINFO";
	
	//设置关键字
	doTemp.setKey("SerialNo",true);	 

	//设置不可见项
	doTemp.setVisible("ApplyNo,ObjectNo,AssetType,ManageUserID,ManageOrgID,AssetNo",false);

	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("SerialNo","style={width:100px} ");  
	doTemp.setHTMLStyle("AssetTypeName,AssetNo","style={width:80px} ");  
	doTemp.setHTMLStyle("AssetName,ManageUserName,ManageOrgName,AssetSum,AssetBalance"," style={width:100px} ");
	doTemp.setUpdateable("AssetTypeName",false); 
	doTemp.setCheckFormat("AssetSum,AssetBalance","2");	
	
	//设置对齐方式
	doTemp.setAlign("AssetSum,AssetBalance","3");
	doTemp.setType("AssetSum,AssetBalance","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("AssetSum,AssetBalance","2");
		
	//生成查询框
	doTemp.setColumnAttribute("AssetName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页
	
	//生成HTMLDataWindow
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
				{"true","","Button","资产详情","查看抵债资产详情","viewAndEdit()",sResourcesPath},
				{"true","","Button","变更管理人","变更管理人","Change_Manager()",sResourcesPath},
				{"true","","Button","查看变更记录","查看变更记录","Change_History()",sResourcesPath}
			};
			
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得抵债资产流水号
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！			
		}else
		{
			openObject("AssetInfo",sSerialNo,"002");				
			reloadSelf();
		}
	}

	/*~[Describe=变更管理人信息;InputParam=无;OutPutParam=SerialNo;]~*/
	function Change_Manager()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	  //获得抵债资产流水号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！			
		}else
		{
			var sManageOrgID=getItemValue(0,getRow(),"ManageOrgID");	
			var sManageOrgName=getItemValue(0,getRow(),"ManageOrgName");	
			var sManageUserID=getItemValue(0,getRow(),"ManageUserID");	
			var sManageUserName=getItemValue(0,getRow(),"ManageUserName");	
			OpenPage("/LAP/RepayAssetManage/PDAManagerChange/RepayAssetChangeInfo.jsp?"+
					"ObjectType=AssetInfo&ObjectNo="+sSerialNo+
					"&OldOrgID="+sManageOrgID+
					"&OldOrgName="+sManageOrgName+
					"&OldUserID="+sManageUserID+
					"&OldUserName="+sManageUserName+"&GoBackType=1","right");
		}
	}

	/*~[Describe=查看变更管理人历史;InputParam=无;OutPutParam=SerialNo;]~*/	
	function Change_History()
	{
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	  //获得抵债资产流水号
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！			
		}else
		{ 
			OpenComp("PDAManagerChangeHistory",
					"/LAP/RepayAssetManage/PDAManagerChange/RepayAssetChangeHistory.jsp",
					"ComponentName=抵债资产管理人变更记录&ComponentType=ListWindow"+
					"&ObjectType=AssetInfo&ObjectNo="+sSerialNo,"right");
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
