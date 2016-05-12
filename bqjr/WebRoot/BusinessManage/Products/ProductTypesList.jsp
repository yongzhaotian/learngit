<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 产品系列
		
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
	String PG_TITLE = "产品系列"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
    //产品类型
    String sProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));
	if(null == sProductType) sProductType = "";
	//产品子类型
	String sSubProductType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubProductType"));	
    if(null == sSubProductType) sSubProductType = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "ProductTypes";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	 
	 //add by ybpan at 20150411 CCS-583  ----车主、无预约现金贷仍需绑定业务员绑定产品/销售代表后才能出单
	 //若子类型不为空，则List列表显示时显示显示具体的某种子类型的数据列表
	 if(!sSubProductType.equals("")){
		 doTemp.WhereClause +=" and SubProductType = '"+sSubProductType+"'";
	 }else if( "030".equals(sProductType) && "".equals(sSubProductType) ){//消费贷产品不包含学生消费贷产品	add by dahl 
		doTemp.WhereClause += " and (SubProductType is null or SubProductType <> '7') ";
	 }
	//end  by ybpan CCS-583
	 doTemp.setColumnAttribute("productName","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProductType);//新增参数传递：2013-5-9
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
		{"true","","Button","新增","新增提款记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","详情记录","myDetail()",sResourcesPath},	
        {"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}, 		
		};
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		OpenPage("/BusinessManage/Products/ProductTypesInfo.jsp?ProductType=<%=sProductType%>","_self","");//update 现金贷需求
	}
	
	function deleteRecord(){
		var sProductID =getItemValue(0,getRow(),"productID");//获取删除记录的单元值
		if (typeof(sProductID)=="undefined" || sProductID.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			RunMethod("DeleteNumber","GetDeleteNumber","product_businessType,productseriesid,"+sProductID);
			 reloadSelf();
		}
	}
	
	function myDetail(){
		var sProductID =getItemValue(0,getRow(),"productID");
		if(typeof(sProductID)=="undefined" || sProductID.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			AsControl.OpenView("/BusinessManage/Products/ProductTypesDetail.jsp","productID="+sProductID+"&ProductType=<%=sProductType%>&SubProductType=<%=sSubProductType%>","_blank");//update 现金贷需求
			
		}
		reloadSelf();
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

