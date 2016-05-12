<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:Thong 2005.8.29 11:30
		Tester:
		Content:限额管理主界面
		Input Param:
		Output param:
		History Log: 

	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "限额管理主界面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;限额管理主界面&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	
	//获得页面参数	
	
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"限额设置工作台","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否选中时自动触发TreeViewOnClick()函数

	//定义树图结构
	tviTemp.insertPage("root","监管限额","",1);
	tviTemp.insertPage("root","客户限额","",2);
	String sFolder1=tviTemp.insertFolder("root","基础限额","",3);
	
	tviTemp.insertPage(sFolder1,"行业","",1);
	tviTemp.insertPage(sFolder1,"地区","",2);
	tviTemp.insertPage(sFolder1,"规模","",3);
	tviTemp.insertPage(sFolder1,"期限","",4);
	tviTemp.insertPage(sFolder1,"风险等级","",5);
	tviTemp.insertPage(sFolder1,"担保","",6);
	tviTemp.insertPage(sFolder1,"产品","",7);
	
	String sFolder4 = tviTemp.insertFolder("root","交叉限额","",4);
	tviTemp.insertPage(sFolder4,"交叉组合定义","",1);
		
	String sFolder5 = tviTemp.insertFolder(sFolder4,"交叉组合限额","",2);
	
	String sSql = "select SerialNo,GetItemName('CombiType',CombiType1) as CombiType1,"+
				  "GetItemName('CombiType',CombiType2) as CombiType2,GetItemName('CombiType',CombiType3) as CombiType3 "+
				  "from XLIMIT_DEF "+
				  "order by CombiType1,CombiType2,CombiType3";
	ASResultSet rs = Sqlca.getResultSet(sSql);
	int i = 0;
	String sInfo = "";
	while(rs.next())
	{
		i++;
		sInfo = "";
		sInfo = sInfo + rs.getString("CombiType1") + " - ";
		if(rs.getString("CombiType3")!=null)
			sInfo = sInfo + rs.getString("CombiType2") + " - " + rs.getString("CombiType3");
		else
			sInfo = sInfo + rs.getString("CombiType2") ;
			
		tviTemp.insertPage(sFolder5,sInfo,"javascript:top.doAction(\"XCombiLimit\",\""+rs.getString(1)+"\")",i);
	}
	rs.getStatement().close();	
		
	//另一种定义树图结构的方法：SQL
	//String sSqlTreeView = "from EXAMPLE_INFO";
	//tviTemp.initWithSql("SortNo","ExampleName","ExampleID","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为： ID字段,Name字段,Value字段,Script字段,Picture字段,From子句,OrderBy子句,Sqlca
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script type="text/javascript"> 
	/*~[Describe=treeview单击选中事件(动态使用);InputParam=XCombiLimit,ResultSet;OutPutParam=无;]~*/
	function doAction(sAction,sSerialNo)
	{
		if (sAction=="XCombiLimit")  
		{			
			OpenComp("XCombiLimitList","/LimitManage/XCombiLimitList.jsp","LimitSerialNo="+sSerialNo+"","right");	
		}
	}
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/

	function TreeViewOnClick()
	{
		//如果tviTemp.TriggerClickEvent=true，则在单击时，触发本函数
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;

		if(sCurItemname=='监管限额'){
			OpenComp("RegularLimitList","/LimitManage/RegularLimitList.jsp","","right");

		}
		else if(sCurItemname=='客户限额'){
			OpenComp("CustomerLimitList","/LimitManage/CustomerLimitList.jsp","","right");						

		}
		else if(sCurItemname=='行业'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=IndustryType","right");	
			
		}
		else if(sCurItemname=='地区'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=BankAddress","right");
			
		}
		else if(sCurItemname=='规模'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=Scope","right");
			
		}
		else if(sCurItemname=='期限'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=Term","right");
			
		}
		else if(sCurItemname=='风险等级'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=CustomerLevel","right");
			
		}
		else if(sCurItemname=='担保'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=Warrant","right");
			
		}
		else if(sCurItemname=='产品'){
			OpenComp("CombiLimitList","/LimitManage/CombiLimitList.jsp","KindCode=Product","right");
			
		}								
		else if(sCurItemname=='交叉组合定义'){
			OpenComp("XCombiDef","/LimitManage/XCombiDef.jsp","","right");
			
		}
		else{
			return;
		}
		setTitle(getCurTVItem().name);
	}

	
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
	</script> 
<%/*~END~*/%>




<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script type="text/javascript">
	startMenu();
	expandNode('root');		
	</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
