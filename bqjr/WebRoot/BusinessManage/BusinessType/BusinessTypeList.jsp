<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 用款记录列表
		
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
	String PG_TITLE = "基本配置"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	
	//获得页面参数
	String sProductID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("productID"));	
    if(sProductID==null) sProductID="";
    //产品类型
    String sProductType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProductType"));
    if(null == sProductType) sProductType = "";
 	 //产品子类型
	String sSubProductType  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SubProductType"));	
    if(null == sSubProductType) sSubProductType = "";
    
   //add by clhuang 2015/06/17 CCS-839 产品配置删除按钮缺陷 
     String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("businesstype"));
    if(null == sBusinessType) sBusinessType = "";
   //end by clhuang
   
/*     String sNo = Sqlca.getString(new SqlObject("select count(1) from business_contract  where contractstatus not in('010','020','030','040','110') and businesstype=:businesstype ").setParameter("businesstype", sBusinessType));

    if(sNo == null) sNo = "";  */
    
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
		
	
	 ASDataObject doTemp = null;
	 String sTempletNo = "BusinessTypeList";
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	 if(!sProductID.equals("")){
		 doTemp.multiSelectionEnabled=true;
	 }
	 doTemp.setColumnAttribute("TypeNo,typename,productType","IsFilter","1");
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	 
	 
	
	 //add 现金贷需求
	 if("020".equals(sProductType) || "030".equals(sProductType)){
		 doTemp.WhereClause += " and ProductType = '"+sProductType+"' ";
	 }
	 
	// add by dahl ccs-733
	 if( "030".equals(sProductType) && "".equals(sSubProductType) ){	//消费贷产品不包含学生消费贷产品	add by dahl 
		 doTemp.WhereClause += " and (SubProductType is null or SubProductType <> '7') ";
	 }else if( "030".equals(sProductType) && "7".equals(sSubProductType) ){	//学生消费贷产品	add by dahl 
		 doTemp.WhereClause += " and SubProductType = '"+sSubProductType+"' ";
	 }
	//end add by dahl
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	
	dwTemp.setEvent("BeforeDelete","!ProductManage.DeleteVersionInfo(#TypeNo,V1.0)");//删除版本
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//新增参数传递：2013-5-9
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
		{"true","","Button","重载缓存","产品参数变更后系统需重新载入","reloadCacheRole()",sResourcesPath},
		};
	if(!sProductID.equals("")){
		sButtons[0][3]="确定";
		sButtons[0][4]="确定";
		sButtons[0][5]="determine()";
		sButtons[1][3]="取消";
		sButtons[1][4]="取消";
		sButtons[1][5]="doCancel()";
		sButtons[2][0]="false";
	}
	
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
		OpenPage("/BusinessManage/BusinessType/BusinessTypeInfo.jsp?ProductType=<%=sProductType%>&SubProductType=<%=sSubProductType%>","_self","");//update 现金贷需求（增加产品类型参数）
	}
	
	function deleteRecord(){
		var sTypeNo =getItemValue(0,getRow(),"TypeNo");//获取删除记录的单元值
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		   //add by clhuang 2015/06/17 CCS-839 产品配置删除按钮缺陷 
		var sNo = RunMethod("BusinessManage", "SelectBusinessType", sTypeNo);
		if(sNo != "0.0"){
		   return alert("该产品存在有效合同，不允许删除");
		}
		//end by clhuang
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			 reloadSelf();
		}
	}
	function myDetail(){
		sTypeNo=getItemValue(0,getRow(),"TypeNo");	
		if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else{
			AsControl.OpenView("/BusinessManage/BusinessType/BusinessTypeDetail.jsp","typeNo="+sTypeNo+"&ProductType=<%=sProductType%>&SubProductType=<%=sSubProductType%>","_blank");//update 现金贷需求		
		}
		reloadSelf();
	}
	
	function determine(){
		var sTypeNo = getItemValueArray(0,"TypeNo");
		var temp="";//记录费用代码
		var flag=true;
		for(var i=0;i<sTypeNo.length;i++){
			var count= RunMethod("Unique","uniques","product_businessType,count(1),busTypeID='"+sTypeNo[i]);
			if(count>="1.0"){
				 temp=temp+sTypeNo[i]+",";
				 flag=false;
			 }
		}
		if(flag&&sTypeNo!=""){
			for(var i=0;i<sTypeNo.length;i++){
				 RunMethod("BusinessTypeRelative","InsertBusRelative","product_businessType,productBusTypeID,busTypeID,productSeriesid,"+getSerialNo("product_businessType", "productBusTypeID", " ")+","+sTypeNo[i]+",<%=sProductID%>");
			}
			alert("导入成功！！！");
			top.close();
		}else if(sTypeNo!=""){
			alert("你选择中产品在该产品系列或其它产品系列下已存在！请重新选择！谢谢！");
		}else{
			alert("你没有选择记录，不能导入！请选择！");
		}		
		
	}
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	
	<%/*~[Describe=刷新缓存;]~*/%>
	function reloadCacheRole(){
		//AsDebug.reloadCacheAll();
		var sReturn = RunJavaMethod("com.amarsoft.app.util.ReloadCacheConfigAction","reloadCacheAll","");
		if(sReturn=="SUCCESS") alert("重载参数缓存成功！");
		else alert("重载参数缓存失败！");
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

