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
	String PG_TITLE = "转让合同信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得页面参数
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {	{"RelativeSerialNo","合同编号"},
                            {"CustomerName","客户名称"},
							{"ProductID","产品编号"},
							{"ProductName","产品名称"}
           }; 

		String sSql = "select bc.relativeserialno as RelativeSerialNo,"+
				       " bc.customername as CustomerName,"+
				       " bc.issuedate as IssueDate,"+
				       " bc.lastpaydate as LastPayDate,"+
				       " bc.issue as Issue,"+
				       " bc.endnum as EndNum,"+
				       " bc.residue as Residue,"+
				       " bc.balance as Balance,"+
				       " bc.nextpaydate as NextPayDate,"+
				       " bc.customerType as CustomerType,"+
				       " ii.occupation as Occupation,"+
				       " ii.unitkind as Unitkind,"+
				       " bc.productid as ProductID,"+
				       " bc.productname as ProductName,"+
				       " bc.creditrate as CreditRate,"+
				       " bc.overduedays as OverdueDays,"+
				       " bc.classifyresult as ClassifyResult,"+
				       " bc.creditperson as CreditPerson,"+
				       " bc.overduetime as OverdueTime"+
				       " from business_contract bc, ind_info ii"+
				       " where bc.customerid = ii.customerid";

	
		//由SQL语句生成窗体对象。
		ASDataObject doTemp = new ASDataObject(sSql);
		doTemp.setHeader(sHeaders);
		//设置表名
		doTemp.UpdateTable = "business_contract";
		//设置主键
		doTemp.setKey("SerialNo",true);
		//设置不可见项
		//doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	    //设置更新字段
		//doTemp.setUpdateable("UserName,OrgName,LCCurrencyName",false);
	    //设置字段样式
		//doTemp.setHTMLStyle("UserName,OrgName"," style={width:80px} ");
	    //设置对齐方式（左、中、右）
		//doTemp.setAlign("LCSum","3");
	    //设置格式（字符串，数字、日期）
		//doTemp.setCheckFormat("LCSum","2");
		//设置查询条件
		//doTemp.setFilter(Sqlca,"2","IndustryType","DefaultOperator=BeginsWith");

		//生成datawindow
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="1";      //设置为Grid风格
		dwTemp.ReadOnly = "1"; //设置为只读

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
		{"false","","Button","新增","新增提款记录","newRecord()",sResourcesPath},
		{"false","","Button","详情","详情记录","myDetail()",sResourcesPath},
		{"false","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath}
		};
	if(!sSerialNo.equals("")){
		sButtons[0][3]="确定";
		sButtons[0][4]="确定";
		sButtons[0][5]="determine()";
		sButtons[1][3]="取消";
		sButtons[1][4]="取消";
		sButtons[1][5]="doCancel()";
		sButtons[2][0]="false";
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
		sCompID = "CostType";
		sCompURL = "/BusinessManage/Products/CostTypeInfo.jsp";
	    popComp(sCompID,sCompURL," ","dialogWidth=320px;dialogHeight=430px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	function myDetail(){
		var sSerialNo =getItemValue(0,getRow(),"serialNo");
		var sFeeType =getItemValue(0,getRow(),"feeType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}else{
			AsControl.OpenView("/BusinessManage/Products/CostTypeDetailInfo.jsp","serialNo="+sSerialNo+"&feeType="+sFeeType,"_self");
			
		}
	}
	
	function deleteRecord(){
		var sSerialNo =getItemValue(0,getRow(),"serialNo");//获取删除记录的单元值
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			 reloadSelf();
		}
	}
	
	function determine(){
		var sSerialNo = getItemValueArray(0,"serialNo");
		var temp="";//记录费用代码
		var flag=true;
		for(var i=0;i<sSerialNo.length;i++){
			var count= RunMethod("Unique","uniques","businessType_Cost,count(1),costNo='"+sSerialNo[i]+"' and busTypeID=<%=sTypeNo%>");
			if(count>="1.0"){
				 temp=temp+sSerialNo[i]+",";
				 flag=false;
			 }
		}
		if(flag&&sSerialNo!=""){
			for(var i=0;i<sSerialNo.length;i++){
				 RunMethod("BusinessTypeRelative","InsertBusRelative","businessType_Cost,busTypeCostID,busTypeID,costNo,"+getSerialNo("businessType_Cost", "busTypeCostID", " ")+",<%=sTypeNo%>,"+sSerialNo[i]);
			}
			alert("导入成功！！！");
			top.close();
		}else if(sSerialNo!=""){
			alert("你选择中有已存在记录！请重新选择！谢谢！");
		}else{
			alert("你没有选择记录，不能导入！请选择！");
		}		
		
	}
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
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

