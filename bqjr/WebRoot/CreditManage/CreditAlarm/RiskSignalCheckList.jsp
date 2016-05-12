<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 预警信号发起认定信息_List
		Input Param:			 
			FinishType：完成类型（Y：已完成；N：未完成）			    
	 */
	String PG_TITLE = "预警信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String sClewDate = "";
	String sSql = "";
		
	//获得组件参数	
	String sFinishType = CurPage.getParameter("FinishType");	
	//将空值转化为空字符串	
	if(sFinishType == null) sFinishType = "";
	
	//提示日期
	sClewDate = StringFunction.getRelativeDate(StringFunction.getToday(),7);
	
	String[][] sHeaders = {							
							{"CustomerName","客户名称"},
							{"SignalName","预警信号"},
							{"SignalType","预警类型"},
							{"SignalStatus","预警状态"},													
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记时间"}
						};
		
	sSql =  " select RS.ObjectNo,GetCustomerName(RS.ObjectNo) as CustomerName, "+
			" RS.SignalName,getItemName('SignalType',RS.SignalType) as SignalType, "+
			" getItemName('SignalStatus',RS.SignalStatus) as SignalStatus, "+
			" GetOrgName(RS.InputOrgID) as InputOrgName, "+
			" GetUserName(RS.InputUserID) as InputUserName,RS.InputDate,RS.SerialNo, "+
			" RS.ObjectType "+
			" from RISK_SIGNAL RS "+
			" where RS.ObjectType = 'Customer' "+
			" and RS.SignalType = '01' "+ 
			" and RS.SignalStatus = '30' "+
			" and ((exists (select RO.ObjectNo from RISKSIGNAL_OPINION RO "+
			" where RO.ObjectNo = RS.SerialNo "+
			" and RO.NextCheckDate <= '"+sClewDate+"' "+
			" and RO.NextCheckUser = '"+CurUser.getUserID()+"'))) ";

	if(sFinishType.equals("N"))
		sSql += " and (FinishDate is null or FinishDate = ' ') ";
	if(sFinishType.equals("Y"))
		sSql += " and (FinishDate is not null and FinishDate <> ' ') ";
	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置不可见性
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo",false);
	
	doTemp.setHTMLStyle("CustomerName,SignalName","style={width:200px}");
	doTemp.setHTMLStyle("SignalType,SignalStatus","style={width:50px}");
	doTemp.setHTMLStyle("InputDate","style={width:80px}");
	//设置格式
	doTemp.setAlign("SignalType,SignalStatus","2");
	//设置过滤器
	doTemp.setColumnAttribute("SignalName","IsFilter","1");
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
			{(sFinishType.equals("N")?"true":"false"),"","Button","预警检查详情","填写该笔预警信息的预警检查报告","newReport()",sResourcesPath},		
			{(sFinishType.equals("Y")?"true":"false"),"","Button","查看预警检查报告","查看/修改预警检查报告详情","viewReport()",sResourcesPath},
			{"true","","Button","预警详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{(sFinishType.equals("N")?"true":"false"),"","Button","完成检查","提交所选中的记录","commitRecord()",sResourcesPath}		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=预警检查;InputParam=无;OutPutParam=无;]~*/
	function newReport(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		AsControl.PopView("/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp","ObjectType=RiskSignal&ObjectNo="+sSerialNo,"");
	}
	
	/*~[Describe=查看预警检查详情;InputParam=无;OutPutParam=无;]~*/
	function viewReport(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		AsControl.PopView("/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp","ObjectType=RiskSignal&ObjectNo="+sSerialNo,"");
	}
					
	/*~[Describe=查看及修改预警详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		OpenPage("/CreditManage/CreditAlarm/RiskSignalCheckInfo.jsp?SerialNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=提交记录;InputParam=无;OutPutParam=无;]~*/
	function commitRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		//提交操作
		sReturn = RunMethod("PublicMethod","UpdateColValue","String@FinishDate@<%=StringFunction.getToday()%>,RISK_SIGNAL,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("所选记录提交失败！");
			return;
		}else{
			reloadSelf();
			alert("所选记录提交成功！");
		}					
	}
		
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>