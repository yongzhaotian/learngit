<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "新增关联合同"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得页面参数
    String sOpenBank    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OpenBank"));
    String sCity        = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("City"));

    System.out.println("----------------"+sOpenBank+"---------------"+sCity);

    if(sOpenBank==null) sOpenBank="";
    if(sCity==null) sCity="";
%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = { 							
			{"Bank","开户银行"},
			{"BankNo","支行代码"},
			{"Branch","开户支行"}
		   }; 

	 String sSql = "select (getItemName('BankPutCode',BANACODE)) as Bank,"+
	               " BankNo,"+
			       " BankName as Branch"+
			       " from bankput_info where BANACODE = '"+sOpenBank+"' and"+
			       " City ='"+sCity+"'";
		
	 ASDataObject doTemp = null;
	 doTemp = new ASDataObject(sSql);
	 doTemp.setHeader(sHeaders);	
	 //doTemp.multiSelectionEnabled=true;//控制多选
	 //doTemp.setKey("ArtificialNo", true);
	 
	 //doTemp.setHTMLStyle("modelsID", "style={width:50px}");
	 //doTemp.setHTMLStyle("modelsBrand,modelsSeries,carModel,carModelCode", "style={width:100px}");
	 //doTemp.setHTMLStyle("bodyType,manufacturers,salesStartTime,engineSize,color", "style={width:100px}");
	 doTemp.setColumnAttribute("BankNo,Branch","IsFilter","1");
	 
	 //设置显示文本框的长度及事件属性
	 doTemp.setHTMLStyle("Branch","style={width:380px} ");
	 doTemp.setHTMLStyle("Bank","style={width:150px} ");
	 
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
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
			{"true","","Button","确认","确认","doCreation()",sResourcesPath},
			{"true","","Button","取消","取消","doCancel()",sResourcesPath}	
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=确定信息;InputParam=无;OutPutParam=无;]~*/
	function doCreation()
	{
      doReturn();
	}
	
	/*~[Describe=确认;InputParam=无;OutPutParam=无;]~*/
	function doReturn(){
		sBankNo     = getItemValue(0,getRow(),"BankNo");
		sBranch     = getItemValue(0,getRow(),"Branch");
		
		//alert("-----"+sBranch+"------"+sBankNo);
		top.returnValue = sBankNo+"@"+sBranch;
		top.close();
	}
	
	/*~[Describe=取消;InputParam=无;OutPutParam=无;]~*/
	function doCancel()
	{
		self.returnValue='_CANCEL_';
		self.close();
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	showFilterArea();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>