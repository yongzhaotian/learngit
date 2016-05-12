<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 二类集团成员列表;
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "二类集团成员列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql="" ;
	
	//获得页面参数
	//获得组件参数
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
	//列表
	String sHeaders[][] = {     
							{"CustomerName","成员名称"},	
							{"CertID","成员组织机构代码"},	
							{"whethen2Name","与借款人关系"},
							{"RelationShipName","该客户在集团中的地位"},													
							{"OrgName","管户机构"},
							{"UserName","管户客户经理"}
			       		  };  
	

		sSql = " select CR.CustomerID,CR.RelativeID,CR.CustomerName,CR.CertID as CertID, "+
		       " CR.RelationShip,GetItemName('RelativeType',whethen2) as whethen2Name, "+			   
			   " getItemName('RelationShip',RelationShip) as RelationShipName, "+
			   " getManageOrgName(CR.RelativeID) as OrgName,getManageUserName(CR.RelativeID) as UserName "+
			   " from CUSTOMER_RELATIVE CR,CUSTOMER_BELONG CB "+
			   " where CR.CustomerID = CB.CustomerID "+
			   " and CR.RelativeID = '"+sCustomerID+"' "+
			   " and CR.RelationShip like '04%' "+
			   " and CR.Describe = '2' "+
			   " order by CR.Whethen1 desc ";		

	
	//设置显示模板
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_RELATIVE";
	//设置主键
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);	
	//设置不可见属性 
	doTemp.setVisible("CustomerID,RelativeID,RelationShip",false);	
	//设置不可更新属性
	doTemp.setUpdateable("CustomerName,RelationShipName,OrgName,UserName,whethen2Name",false); 
	//设置显示格式
  	doTemp.setHTMLStyle("CustomerName"," style={width:250px} ");  	
	
	
	//定义datawindow
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
		{"true","","Button","查看详情","查看详情","my_customerinfo()",sResourcesPath},
		{"true","","Button","二类集团客户信用信息","查看二类集团客户信用信息","my_RelativeBusiness()",sResourcesPath},
		{"true","","Button","成员变更记录","成员变更记录","my_relativechangeinfo()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script>
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
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
	
	/*~[Describe=客户信用信息;InputParam=无;OutPutParam=无;]~*/
	function my_RelativeBusiness()
	{
		sRelativeID = getItemValue(0,getRow(),"RelativeID");
		if (typeof(sRelativeID)=="undefined" || sRelativeID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CustomerCreditView";
		sCompURL = "/CustomerManage/CustomerCreditView.jsp";
		sParamString = "ObjectNo="+sRelativeID;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
	}

	/*~[Describe=二类集团成员变更记录;InputParam=无;OutPutParam=无;]~*/
	function my_relativechangeinfo()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));
			return;
		}else
		{
			//显示集团成员的变更记录
			OpenComp("GroupMemberChangeList","/CustomerManage/EntManage/GroupMemberChangeList.jsp","CustomerID="+sCustomerID,"right");
		}
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
