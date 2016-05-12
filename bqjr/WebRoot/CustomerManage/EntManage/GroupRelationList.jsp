<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: --集团客户搜索;
		Input Param:
			CustomerID：--当前客户编号
		Output Param:
			CustomerID：--当前客户编号
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "集团客户搜索"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
     String sSql="";
    
	//获得页面参数
	
	//获得组件参数
	//String sSqlTemp    =  DataConvert.toRealString(iPostChange,(String)request.getParameter("SqlTemp"));
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
		
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {     
							{"OtherRelativeID","成员组织机构代码"},
							{"RelativeName","集团成员名称"},
							{"AggregateName","主体名称"},
							{"BelongOrg","管户机构"},
							{"CorporationName","法定代表人"},
							{"Region","所在地"},
							{"RelativeTypeName","与借款人关系"},
							{"IsBusiness","是否存在授信申请或未结清业务"},
							{"SearchFlagName","是否系统搜索结果"}  
			       		  };  
	

	sSql = " select A.CustomerID,A.RelativeID,EI.EnterpriseName as RelativeName,"+
	       " EI.CorpID as OtherRelativeID,FictitiousPerson as CorporationName,"+
	       " getItemName('AreaCode',EI.RegionCode) as Region,A.InputOrgID,"+
		   " getItemName('YesNo','2') as IsBusiness,"+
		   " getOrgName(CB.OrgID) as BelongOrg, "+
		   " A.RelativeType,getItemName('RelativeType',A.RelativeType) as RelativeTypeName,"+
		   " A.SearchFlag,getItemName('YesNo',A.SearchFlag) as SearchFlagName "+
		   " from GROUP_SEARCH A,ENT_INFO EI ,CUSTOMER_BELONG CB"+
		   " where  "+
		   " A.RelativeID=EI.CustomerID and EI.CustomerID = CB.CustomerID and CB.BelongAttribute = '1' and A.CustomerID='"+sCustomerID+"' "+
		   " order by A.RelativeType ";	

	//设置显示模板
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GROUP_SEARCH";
	//客户名称长度
  	//doTemp.setHTMLStyle("RelativeName"," style={width:250px} ");
  	
	doTemp.setKey("CustomerID,RelativeID",true);	 
	doTemp.setVisible("Region,CustomerID,RelativeID,InputOrgID,InputDate,SearchFlag,RelativeType",false);
	doTemp.setAlign("IsBusiness,SearchFlagName","2");

	//doTemp.setUpdateable("RelativeName,OtherRelativeID,Region,InputOrgName,IsBusiness,SearchFlagName,BelongOrg,RelativeTypeName,CorporationName",false); 
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
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
		{"true","","Button","集团客户搜索","集团客户搜索","my_relativesearch()",sResourcesPath},
		{"true","","Button","新增成员","手工新增集团成员客户","my_RelativeAdd()",sResourcesPath},
		{"true","","Button","查看成员详情","查看成员详情","my_customerinfo()",sResourcesPath},
		{"true","","Button","集团客户认定申请书","集团客户认定申请书","my_relativefile()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">
		
	/*~[Describe=搜索当前客户的关联成员;InputParam=无;OutPutParam=无;]~*/
	function my_relativesearch()
	{
		sReturnValue = PopPageAjax("/CustomerManage/EntManage/GroupMemberSearchAjax.jsp?CustomerID=<%=sCustomerID%>","","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(sReturnValue == "True")
		{
			alert("集团客户关系搜索成功！");
			reloadSelf();
		}
		if(sReturnValue == "False")
		{
			alert("集团客户关系搜索失败，请重新搜索！");
			return
		}
	}
	
	/*~[Describe=新增当前客户的关联成员;InputParam=无;OutPutParam=无;]~*/
	function my_RelativeAdd()
	{
		sCustomerInfo = PopPage("/CustomerManage/EntManage/AddGroupMemberDialog.jsp","","dialogWidth=20;dialogHeight=10;minimize:yes");
		if (typeof(sCustomerInfo)=="undefined" || sCustomerInfo.length==0)
		{
		}else
		{		
			sCustomerInfo = sCustomerInfo.split("@");
			sRelativeID = sCustomerInfo[0];
			sRelativeType = sCustomerInfo[1];			
			sReturnValue = PopPageAjax("/CustomerManage/EntManage/AddGroupMemberActionAjax.jsp?CustomerID=<%=sCustomerID%>&RelativeID="+sRelativeID+"&RelativeType="+sRelativeType,"","dialogWidth=0;dialogHeight=0;minimize:yes");
			if(sReturnValue == "HaveRecord_Member")
			{
				alert("客户已经属于某个集团，不能增加到当前集团下！");
				return
			}
			if(sReturnValue == "HaveRecord_Search")
			{
				alert("集团客户搜索中已经存在该客户的信息，无法继续添加！");
				return
			}
			if(sReturnValue == "Join")
			{
				alert("新增成员成功！");
				return
			}
		}
	}
	
	/*~[Describe=客户详情;InputParam=无;OutPutParam=无;]~*/
	function my_customerinfo()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");
		if (typeof(sRelativeID)=="undefined" || sRelativeID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			openObject("Customer",sRelativeID,"001");
		}
	}
	
	/*~[Describe=集团客户认定;InputParam=无;OutPutParam=无;]~*/
	function my_relativefile()
	{		
		alert("正在建设中......")
		return;			
	}
	
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
