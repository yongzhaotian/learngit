<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   rqiao 20141118
		Tester:
		Content:   交叉现金贷活动维护
		Input Param:
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "交叉现金贷活动维护"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
    //产品类型
    String sEventStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EventStatus"));
    if(null == sEventStatus) sEventStatus = "";
    
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	ASDataObject doTemp = new ASDataObject("CashLoanList",Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sEventStatus);
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
			{"false","","Button","新增","新增费用记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","详情记录","myDetail()",sResourcesPath},
			{"false","","Button","删除","删除","deleteRecord()",sResourcesPath},
			{"false","","Button","生效","生效","UpdateStatus(\'"+sEventStatus+"\')",sResourcesPath},
		    };
	//未开始的活动
	if("01".equals(sEventStatus))
	{
		sButtons[0][0] = "true";
		sButtons[2][0] = "true";
		sButtons[3][0] = "true";
	}
	//进行中的活动
	if("02".equals(sEventStatus))
	{
		sButtons[3][3] = "结束";
		sButtons[3][4] = "结束";
		sButtons[3][0] = "true";
	}
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
	
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurTypeNo=""; //记录当前所选择行的代码号
    var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------
	
	function newRecord()
	{
		//活动序号
		var sSerialNo = "<%=DBKeyHelp.getSerialNoXD("BUSINESS_CASHLOANEVENT", "SERIALNO", "yyyyMMdd", "000", new  Date(), Sqlca)%>";
		//活动状态
		var sEventStatus = "<%=sEventStatus%>";
		RunMethod("BusinessManage","InsertCashLoanEvent",sSerialNo+","+sEventStatus+",<%=CurUser.getUserID()%>,<%=CurOrg.orgID%>,<%=StringFunction.getToday()%>");
		AsControl.OpenView("/BusinessManage/Products/CashLoan/CashLoanTab.jsp","SerialNo="+sSerialNo+"&EventStatus="+sEventStatus,"_blank","");
		reloadSelf();
	}
    
    function myDetail(){
        var sEventStatus = "<%=sEventStatus%>";
    	var sSerialNo =getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/Products/CashLoan/CashLoanTab.jsp","SerialNo="+sSerialNo+"&EventStatus = "+sEventStatus,"_blank","");
		reloadSelf();
	}
    
	function deleteRecord(){
		var sSerialNo =getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		
		if(confirm("确实删除该活动吗？")){
			RunMethod("公用方法","DelByWhereClause","BUSINESS_CASHLOAN_RELATIVE,EVENTSERIALNO='"+sSerialNo+"'");
			as_del("myiframe0");
		    as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}

	function UpdateStatus(sEventStatus){
		var sSerialNo =getItemValue(0,getRow(),"SERIALNO");
		
		var Status = "生效";
		var NextEventStatus = "02";
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		/*update tangyb CCS-817 添加“已作废”状态 start*/
		if("02" == sEventStatus) {
			Status = "结束";
			
			var enddate =getItemValue(0,getRow(),"ENDDATE"); //结束日期
			start = enddate.split('/'); //用的是时间控件格式是yyyy/MM/dd

			var date = new Date(); //当前日期
			
			//因为当前时间的月份需要+1，故在此-1，不然和当前时间做比较会判断错误
			var start1 = new Date(start[0], start[1] - 1, start[2]); 

			if (date > start1) {
				NextEventStatus = "03";//超过有效期活动修改状态为"03:结束"
			}else{
				NextEventStatus = "04";//有效期内的活动修改状态为“04：已作废”
			}
		} else {
			var error = "";
			var eventname =getItemValue(0,getRow(),"EVENTNAME"); //活动名称
			var eventattribute =getItemValue(0,getRow(),"EVENTATTRIBUTE"); //活动属性
			var eventtype =getItemValue(0,getRow(),"EVENTTYPE"); //活动类别
			var begindate =getItemValue(0,getRow(),"BEGINDATE"); //开始日期
			var enddate =getItemValue(0,getRow(),"ENDDATE"); //结束日期
			
			if(eventname == null || eventname == ""){
				error = "活动名称";
			}
			
			if(eventattribute == null || eventattribute == ""){
				if(error == ""){
					error = "活动属性";
				}else{
					error = error + "、活动属性";
				}
			}
			
			if(eventtype == null || eventtype == ""){
				if(error == ""){
					error = "活动类别";
				}else{
					error = error + "、活动类别";
				}
			}
			
			if(begindate == null || begindate == ""){
				if(error == ""){
					error = "开始日期";
				}else{
					error = error + "、开始日期";
				}
			}
			
			if(enddate == null || enddate == ""){
				if(error == ""){
					error = "结束日期";
				}else{
					error = error + "、结束日期";
				}
			}
			
			if(error != ""){ //必输项检查
				alert("["+error+"]为空不能生效");
				return;
			}
			
			var count = RunMethod("公用方法", "GetColValue", "BUSINESS_CASHLOAN_RELATIVE,count(*),EVENTSERIALNO='"+sSerialNo+"'");
			if(typeof(count)=="undefined" || parseInt(count)==0){
				alert("客户名单没有导入不能生效 ");
				return;
			}
		}
		/*end*/

		if(confirm("确实标记该活动"+Status+"吗？")){
			RunMethod("公用方法","UpdateColValue","BUSINESS_CASHLOANEVENT,EVENTSTATUS,"+NextEventStatus+",SERIALNO='"+sSerialNo+"'");
			alert("操作成功"); //add tangyb 添加成功提示
			reloadSelf();
		}
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


<%@ include file="/IncludeEnd.jsp"%>
