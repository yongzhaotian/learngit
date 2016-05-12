<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 未归档的车辆登记证
		
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
	String PG_TITLE = "未归档的车辆登记证"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sCurItemID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("curItemID"));
	if(sCurItemID == null) sCurItemID = "";
		
		
	String sTempletNo="";
	 ASDataObject doTemp = null;
	 if(sCurItemID.equals("3")){
		 sTempletNo = "BoxNOCarList";
	 }else if(sCurItemID.equals("4")) {
		 sTempletNo = "BoxYesCarList";
	 }else if(sCurItemID.equals("5")){
		 sTempletNo = "BoxNoLendCarList";
	 }
	 else if(sCurItemID.equals("6")){
		 sTempletNo = "BoxLendCarList";
	 }else if(sCurItemID.equals("7")){
		 sTempletNo = "BoxStayOutCarList";
	 }else if(sCurItemID.equals("8")){
		 sTempletNo = "BoxOutCarList";
	 }
	 doTemp = new ASDataObject(sTempletNo,Sqlca);//新增模型：2013-5-9
	 if(sCurItemID.equals("3")){
		 doTemp.setColumnAttribute("customerName,contractEffectiveDate","IsFilter","1");
	 }else if (sCurItemID.equals("4")){
		 doTemp.setColumnAttribute("customerName,CarFrame,carNumber","IsFilter","1");
	 }else{
		 doTemp.setColumnAttribute("customerName,CarFrame","IsFilter","1");
	 }
	 doTemp.generateFilters(Sqlca);
	 doTemp.parseFilterData(request,iPostChange);
	 CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
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
		{"true","","Button","给金融经理发邮件","给金融经理发邮件","newRecord()",sResourcesPath},		
		};
	   if(sCurItemID.equals("4")){
		   sButtons[0][0]="false";
	   }else if(sCurItemID.equals("5")){
		   sButtons[0][3]="临时借出";
		   sButtons[0][4]="临时借出";
		   sButtons[0][5]="lendCar()";
	   }else if(sCurItemID.equals("6")){
		   sButtons[0][3]="归还登记证";
		   sButtons[0][4]="归还登记证";
	   }else if(sCurItemID.equals("7")){
		   sButtons[0][3]="登记证出库";
		   sButtons[0][4]="登记证出库";
		   sButtons[0][5]="outCar()";
	   }else if(sCurItemID.equals("8")){
		   sButtons[0][0]="false";
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
	}
	
	function lendCar(){
		var sRetVal = setObjectValue("SelectContractCarInfo", "", "", 0, 0, "");
		if (typeof(sRetVal)=="undefined" || sRetVal=="_CLEAR_" || sRetVal.length==0) {
			alert("请选择一条记录!");
			return;
		}
		var sTypeArry = sRetVal.substring(0, sRetVal.length-1).split("@");
		sSerialNo=sTypeArry[0];
		sCustomerID=sTypeArry[1];
		sCompID = "BoxNoLendCarInfo";
		sCompURL = "/AppConfig/Document/BoxNoLendCarInfo.jsp";
	    popComp(sCompID,sCompURL,"serialNo="+sSerialNo,"dialogWidth=300px;dialogHeight=360px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	    reloadSelf();
	}
	
	function myDetail(){
		sTypeNo=getItemValue(0,getRow(),"TypeNo");	
		if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return
		}else{
			AsControl.OpenView("/BusinessManage/BusinessType/BusinessTypeDetail.jsp","typeNo="+sTypeNo,"_blank");		
		}
	}
	
	function outCar(){
		var sSerialNo=getItemValue(0,getRow(),"serialNo");	
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		RunMethod("ModifyNumber","GetModifyNumber","business_contract,CarStatus='06',serialNo='"+sSerialNo+"'");
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

