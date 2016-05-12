<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: sjchuan 2009-10-20
		Tester:
		Describe: 出账信息中的票据信息列表
		Input Param:
		Output Param:		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "商品类型 "; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数

	//获得组件参数
	String sBusinessRange1 = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessRange1"));
    if(sBusinessRange1 == null) sBusinessRange1 = ""; 
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>

<%

	String[] sBusinessRanges1;
	StringBuffer sb=new StringBuffer();

	sBusinessRanges1=sBusinessRange1.split(",");
	for(int i=0;i<sBusinessRanges1.length;i++){
		sb.append("'");
		sb.append(sBusinessRanges1[i]);
		sb.append("'");
		sb.append(",");
	}

	sBusinessRange1=sb.toString().substring(0, sb.toString().lastIndexOf(","));    


	String sHeaders[][] = {	{"productctypeid","类型编号"},
							{"productctypename","类型名称"}
	                       }; 
	String sSql = " select productctypeid,productctypename from Product_CType where IsinUse='1' and productcategoryid in("+sBusinessRange1+")";

	//由SQL语句生成窗体对象。
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setKey("SerialNo,PutoutNo",true);	 //为后面的删除
	//生成查询条件
	doTemp.setColumnAttribute("productctypename","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 
//	doTemp.multiSelectionEnabled=true;
	
	//设置金额为三位一逗数字
//	doTemp.setType("BillSum","Number");

	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
//	doTemp.setCheckFormat("BillSum","2");
	
	//设置字段对齐格式，对齐方式 1 左、2 中、3 右
//	doTemp.setAlign("BillSum","3");
	
	//生成datawindow
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
		{"true","","Button","确定","确定","doSubmit()",sResourcesPath},
		{"true","","Button","取消 ","取消","doNo()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/

	function doSubmit(){
		var sProductctypeid = getItemValue(0,getRow(),"productctypeid");
		var sProductctypename = getItemValue(0,getRow(),"productctypename");
		if(typeof(sProductctypeid) == "undefined" || sProductctypeid == "")
		{
			alert("请选择一条!");
			return;
		}
		top.returnValue=sProductctypeid+"@"+sProductctypename;
		top.close();
	}
	
	function doNo(){
		top.returnValue = "_CANCEL_";
		top.close();
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
	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
