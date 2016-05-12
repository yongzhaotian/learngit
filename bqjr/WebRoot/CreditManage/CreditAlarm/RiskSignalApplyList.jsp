<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 预警信号发起信息_List
		Input Param:			
			SignalType：预警类型（01：发起；02：解除）
			SignalStatus：预警状态（10：待处理；15：待分发；20：审批中；30：批准；40：否决）   
	 */
	String PG_TITLE = "预警信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
		
	//获得组件参数		
	String sSignalType = CurPage.getParameter("SignalType");
	String sSignalStatus = CurPage.getParameter("SignalStatus");
	//将空值转化为空字符串	
	if(sSignalType == null) sSignalType = "";
	if(sSignalStatus == null) sSignalStatus = "";	

	String[][] sHeaders = {							
							{"CustomerName","客户名称"},
							{"SignalName","预警信号"},
							{"SignalType","预警类型"},
							{"SignalStatus","预警状态"},													
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记时间"}
						};
		
	String sSql =  " select ObjectNo,GetCustomerName(ObjectNo) as CustomerName, "+
			" SignalName,getItemName('SignalType',SignalType) as SignalType, "+
			" getItemName('SignalStatus',SignalStatus) as SignalStatus, "+
			" GetOrgName(InputOrgID) as InputOrgName, "+
			" GetUserName(InputUserID) as InputUserName,InputDate,SerialNo, "+
			" ObjectType "+
			" from RISK_SIGNAL "+
			" where ObjectType = 'Customer' "+
			" and SignalType = '"+sSignalType+"' "+   
			" and SignalStatus = '"+sSignalStatus+"' "+
			" and InputUserID = '"+CurUser.getUserID()+"' ";
	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//设置字段位置
	doTemp.setAlign("SignalType,SignalStatus","2");
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置不可见性
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo",false);
	//设置格式
	doTemp.setHTMLStyle("CustomerName","style={width:200px}");	
	//设置过滤器
	doTemp.setColumnAttribute("CustomerName,SignalName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{(sSignalStatus.equals("10")?"true":"false"),"","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{((!sSignalStatus.equals("10") && !sSignalStatus.equals("20"))?"true":"false"),"","Button","查看意见","查看/修改认定意见详情","viewOpinion()",sResourcesPath},
			{"true","","Button","预警详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{(sSignalStatus.equals("10")?"true":"false"),"","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{(sSignalStatus.equals("10")?"true":"false"),"","Button","提交","提交所选中的记录","commitRecord()",sResourcesPath},
			{(sSignalStatus.equals("30")?"true":"false"),"","Button","查看预警检查报告","查看预警检查报告","viewReport()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp","_self","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2'))){ //您真的想删除该信息吗？
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinion(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		AsControl.PopView("/CreditManage/CreditAlarm/ViewRiskSignalOpinions.jsp","ObjectNo="+sSerialNo+"&SignalType=<%=sSignalType%>","");
	}
			
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		OpenPage("/CreditManage/CreditAlarm/RiskSignalApplyInfo.jsp?SerialNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=提交记录;InputParam=无;OutPutParam=无;]~*/
	function commitRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
			
		if(confirm(getHtmlMessage('17'))){ //确信需要提交该记录吗？
			//提交操作
			sReturn = RunMethod("PublicMethod","UpdateColValue","String@SignalStatus@15,RISK_SIGNAL,String@SerialNo@"+sSerialNo);
			if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}else{
				reloadSelf();
				alert(getHtmlMessage('18'));//提交成功！
			}				
	   	}	
	}
	/*~[Describe=填写预警检查报告;InputParam=无;OutPutParam=无;]~*/
	function viewReport(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		AsControl.PopView("/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp","ObjectType=RiskSignal&ObjectNo="+sSerialNo,"");
	}
		
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>