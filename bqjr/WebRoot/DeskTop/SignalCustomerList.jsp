<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ndeng 2005-05-09
		Tester:
		Describe: 工作台风险预警提示客户列表;
		Input Param:
			
		Output Param:
			
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "风险预警提示客户列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数
	
	//获得组件参数
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
    if(sOrgID == null) sOrgID = CurOrg.getOrgID();
    String sSortNo=Sqlca.getString(new SqlObject("select SortNo from Org_Info where OrgID=:OrgID").setParameter("OrgID",sOrgID));
	if(sSortNo==null)sSortNo="";
    String sTime = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Time"));
    String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));
    String sOrgName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgName"));
    String sUserName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserName"));
    String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
    String sCertID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CertID"));
    if(sTime == null) sTime = "";
    if(sCustomerName == null) sCustomerName = "";
    if(sOrgName == null) sOrgName = "";
    if(sUserName == null) sUserName = "";
    if(sCustomerID == null) sCustomerID = "";
    if(sCertID == null) sCertID = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sSql = "";
	String sIsRight = "";
	String sHeaders[][] = {	{"CustomerID","客户编号"},
	                        {"CustomerName","客户名称"},
							{"CertTypeName","证件类型"},
							{"CertID","证件号"},
							{"CustomerTypeName","客户类型"},
							{"UserName","客户经理"}
						  };
	String sDate = StringFunction.getToday();
    if(CurUser.hasRole("480") || CurUser.hasRole("280"))
    {
	    sSql =	"select CustomerID,CustomerName,getItemName('CertType',CertType) as CertTypeName,CertID,"+
                        " getItemName('CustomerType',CustomerType) as CustomerTypeName from Customer_Info"+
                        " where CustomerID in (select distinct(CustomerID) from Customer_Belong where UserID='"+CurUser.getUserID()+"')"+
                        " and CustomerID in (select ObjectNo from risk_signal where InputUserID='"+CurUser.getUserID()+"')";

    }
    else if(CurUser.hasRole("040") || CurUser.hasRole("240") || CurUser.hasRole("440"))
    {
        sSql =	"select CustomerID,CustomerName,getItemName('CertType',CertType) as CertTypeName,CertID,"+
                        " getItemName('CustomerType',CustomerType) as CustomerTypeName from Customer_Info"+
                        " where CustomerID in (select CustomerID from Customer_Belong where OrgID in (select OrgID from ORG_INFO where SortNo like '"+sSortNo+"%'))"+
                        " and CustomerID in (select ObjectNo from risk_signal)";
        if(CurUser.hasRole("040"))
        {
            sIsRight = "Y";
        }
    }
    if(!sTime.equals(""))
    {
        
        if(sTime.equals("1")) //一周内
        {           
            sSql += " and CustomerID in (select ObjectNo from Risk_Signal where datediff(dy,inputdate,getdate()) <= 7)";
        }
        else if(sTime.equals("2")) //十天内
        {
            sSql += " and CustomerID in (select ObjectNo from Risk_Signal where datediff(dy,inputdate,getdate()) <= 10)";
        }
        else if(sTime.equals("3")) //一月内
        {
            sSql += " and CustomerID in (select ObjectNo from Risk_Signal where datediff(dy,inputdate,getdate()) <= 30)";
        }
    }
    if(!sCustomerName.equals(""))
    {
        sSql += " and CustomerName like '%"+sCustomerName+"%'";
    }
    if(!sOrgName.equals(""))
    {
        sSql += " and CustomerID in (select CustomerID from Customer_Belong where getOrgName(OrgID) like '%"+sOrgName+"%')";
    }
    if(!sUserName.equals(""))
    {
        sSql += " and CustomerID in (select CustomerID from Customer_Belong where getUserName(UserID) like '%"+sUserName+"%')";
    }
    if(!sCustomerID.equals(""))
    {
        sSql += " and CustomerID like '%"+sCustomerID+"%'";
    }
    if(!sCertID.equals(""))
    {
        sSql += " and CertID like '%"+sCertID+"%'";
    }
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	doTemp.setKey("CustomerID",true);
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
    dwTemp.setPageSize(20);

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //查询区的页面代码
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
		{"true","","Button","客户信息","查看客户信息","viewCustomer()",sResourcesPath},
		{"true","","Button","预警信息","查看预警信息","viewSignal()",sResourcesPath},
		{"true","","Button","查询信息","查询信息","Search()",sResourcesPath}
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看客户详情;InputParam=无;OutPutParam=无;]~*/
	function viewCustomer()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			openObject("Customer",sCustomerID,"001");
		}
	}
	/*~[Describe=查看预警详情;InputParam=无;OutPutParam=无;]~*/
    function viewSignal()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			popComp("CustomerSignalList","/CustomerManage/EntManage/CustomerSignalList.jsp","CustomerID="+sCustomerID+"&Enter=80","","");
		}
	}
	/*~[Describe=查询信息;InputParam=无;OutPutParam=无;]~*/
    function Search()
	{
		var sReturnValue = popComp("SignalSearchDialog","/DeskTop/SignalSearchDialog.jsp","","dialogWidth=450px;dialogHeight=330px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturnValue) != "undefined" && sReturnValue != "" && sReturnValue != "_none_")
		{	
		    sReturnValue = sReturnValue.split("@");
			sTime=sReturnValue[0];
			sCustomerName = sReturnValue[1];
			sCustomerID = sReturnValue[2];
			sCertID = sReturnValue[3];
			sOrgName = sReturnValue[4];
			sUserName = sReturnValue[5];
			if(sTime == null) sTime = "";
			if(sCustomerName == null) sCustomerName = "";
			if(sOrgName == null) sOrgName = "";
			if(sUserName == null) sUserName = "";
			if(sCustomerID == null) sCustomerID = "";
			if(sCertID == null) sCertID = "";
			sParaString = "Time="+sTime+"&CustomerName="+sCustomerName+"&OrgName="+sOrgName+"&UserName="+sUserName+"&CustomerID="+sCustomerID+"&CertID="+sCertID+"";
			if("<%=sIsRight%>" == "Y")
			    OpenComp("SignalCustomerList","/DeskTop/SignalCustomerList.jsp",sParaString,"right","");
			else
			    OpenComp("SignalCustomerList","/DeskTop/SignalCustomerList.jsp",sParaString,"_blank","");
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
