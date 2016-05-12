<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
	Author:   
	Tester:	  
	Content: 集团客户主界面
	Input Param:
	Output param:
	History Log: 
 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "集团客户管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;集团客户管理&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	String sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));	
	if(sCustomerType == null) sCustomerType = "";
	String sParm = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Parm"));	
	if(sParm == null) sParm = "";
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script type="text/javascript"> 
		
	</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script type="text/javascript">
	//如果为集团客户，则自动打开List,并且隐藏树图部分
	   var sCustomerType = "<%=sCustomerType%>";
	   var sParm="<%=sParm%>";

		if(sParm=="GroupCustomerView"){
			myleft.width=1;
			OpenComp("GroupCustomerList","/CustomerManage/GroupManage/GroupCustomerView.jsp","CustomerType="+sCustomerType,"right");//集团家谱查询
		}else{
			myleft.width=1;
			OpenComp("GroupCustomerList","/CustomerManage/GroupManage/GroupCustomerList.jsp","CustomerType="+sCustomerType,"right");//集团家谱维护
		}
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
	