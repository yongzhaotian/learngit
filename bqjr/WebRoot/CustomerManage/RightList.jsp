<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ndeng 2005-04-04
		Tester:
		Describe: 客户管理权一览
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			CustomerID：当前客户编号
			

		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-24 fbkang    新版本的改写
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户管理权维护信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//获得页面参数	
	//获得组件参数	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
    //String sRightType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RightType"));  
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	String sHeaders[][] = {     
                            {"CustomerID","客户编号"},
                            {"CustomerName","客户名称"},
                            {"CustomerTypeName","客户类型"},
                            {"InputOrgID","登记机构"},
                            {"UserName","管户客户经理"},
                            {"OrgName","机构名称"},                           
                            {"BelongAttribute","客户主办权"},
                            {"BelongAttribute1","信息查看权"},
                            {"BelongAttribute2","信息维护权"},
                            {"BelongAttribute3","业务申办权"}
			                  };   	  		   		
	
	String sSql = " select CustomerID, "+
                " getCustomerName(CustomerID) as CustomerName,"+
                " UserID,getUserName(UserID) as UserName," +
                " OrgID, getOrgName(OrgID) as OrgName,"+                
                " getItemName('HaveNot',BelongAttribute) as BelongAttribute,"+
                " getItemName('HaveNot',BelongAttribute1) as BelongAttribute1,"+
                " getItemName('HaveNot',BelongAttribute2) as BelongAttribute2,"+
                " getItemName('HaveNot',BelongAttribute3) as BelongAttribute3"+
                " from CUSTOMER_BELONG" +
                " where CustomerID='"+sCustomerID+"'";	
  
  //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_BELONG";
	doTemp.setKey("CustomerID,OrgID,UserID",true);	 //为后面的删除
	//设置不可见项
	doTemp.setVisible("OrgID,UserID,CustomerID,CustomerName,InputOrgID",false);
	//通常用于外部存储函数得到的字段
	doTemp.setUpdateable("UserName,OrgName",false);   
	doTemp.setHTMLStyle("CustomerTypeName"," style={width:80px} ");
    doTemp.setHTMLStyle("BelongAttribute"," style={width:70px} ");
    doTemp.setHTMLStyle("BelongAttribute1"," style={width:90px} ");
    doTemp.setHTMLStyle("BelongAttribute2"," style={width:70px} ");
    doTemp.setHTMLStyle("BelongAttribute3"," style={width:70px} ");
    doTemp.setHTMLStyle("CustomerName"," style={width:200px} "); 
	//out.println(doTemp.SourceSql);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(20);
	
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

		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	
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