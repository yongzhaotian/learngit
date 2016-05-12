<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 预警信号发起认定信息_List
		Input Param:			 
			SignalType：预警类型（01：发起；02：解除）
			SignalStatus：预警状态（10：待处理；15：待分发；20：审批中；30：批准；40：否决）    
	 */
	String PG_TITLE = "预警信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String sSql = "";
		
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
		
	sSql =  " select RS.ObjectNo,GetCustomerName(RS.ObjectNo) as CustomerName, "+
			" RS.SignalName,getItemName('SignalType',RS.SignalType) as SignalType, "+
			" getItemName('SignalStatus',RS.SignalStatus) as SignalStatus, "+
			" GetOrgName(RS.InputOrgID) as InputOrgName, "+
			" GetUserName(RS.InputUserID) as InputUserName,RS.InputDate,RS.SerialNo, "+
			" RS.ObjectType "+
			" from RISK_SIGNAL RS,RISKSIGNAL_OPINION RO "+
			" where RS.SerialNo = RO.ObjectNo "+
			" and RS.ObjectType = 'Customer' "+
			" and RS.SignalType = '"+sSignalType+"' "+
			" and RS.SignalStatus = '"+sSignalStatus+"' "+
			" and RO.CheckUser = '"+CurUser.getUserID()+"' ";
	//通过sql定义doTemp数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="RISK_SIGNAL";
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置不可见性
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo",false);
	//设置格式
	doTemp.setHTMLStyle("CustomerName,SignalName","style={width:180px}");
	doTemp.setHTMLStyle("SignalType,SignalStatus","style={width:80px}");
	doTemp.setAlign("SignalType,SignalStatus","2");
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
			{(sSignalStatus.equals("20")?"true":"false"),"","Button","签署意见","填写该笔预警信息的认定意见","newOpinion()",sResourcesPath},		
			{"true","","Button","查看意见","查看/修改认定意见详情","viewOpinion()",sResourcesPath},
			{"true","","Button","预警详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{(sSignalStatus.equals("20")?"true":"false"),"","Button","填写预警检查报告","填写预警检查报告","writeReport()",sResourcesPath},
			{(sSignalStatus.equals("20")?"true":"false"),"","Button","提交","提交所选中的记录","commitRecord()",sResourcesPath},
			{(sSignalStatus.equals("30")?"true":"false"),"","Button","查看预警检查报告","查看预警检查报告","viewReport()",sResourcesPath},		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=签署意见;InputParam=无;OutPutParam=无;]~*/
	function newOpinion(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		sCompID = "SignRiskSignalOpinionInfo";
		sCompURL = "/CreditManage/CreditAlarm/SignRiskSignalOpinionInfo.jsp";
		OpenComp(sCompID,sCompURL,"ObjectNo="+sSerialNo+"&SignalType=<%=sSignalType%>","_blank",OpenStyle);		
	}
	
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinion(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		AsControl.PopView("/CreditManage/CreditAlarm/ViewRiskSignalOpinions.jsp","ObjectNo="+sSerialNo+"&SignalType=<%=sSignalType%>","");
	}
	
	function viewReport(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		sReturn=RunMethod("PublicMethod","GetColValue","SerialNo,INSPECT_INFO,String@ObjectType@RiskSignal@String@ObjectNo@"+sSerialNo);
		if(typeof(sReturn)=="undefined" || sReturn.length == 0){
			alert(getBusinessMessage('678'));//尚未生成预警检查报告
			return;
		}
		AsControl.PopView("/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp","ObjectType=RiskSignal&ObjectNo="+sSerialNo,"");
	}
	/*~[Describe=填写预警检查报告;InputParam=无;OutPutParam=无;]~*/
	function writeReport(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));
			return;
		}
		sReturn=RunMethod("PublicMethod","GetColValue","SerialNo,INSPECT_INFO,String@ObjectType@RiskSignal@String@ObjectNo@"+sSerialNo);
		if(typeof(sReturn)!="undefined" && sReturn.length != 0){
			alert('已经完成预警检查报告，只能查看');//已经完成预警检查报告，只能查看
			
		}
		AsControl.PopView("/CreditManage/CreditAlarm/RiskSignalInspectInfo.jsp","ObjectType=RiskSignal&ObjectNo="+sSerialNo,"");
	}
					
	/*~[Describe=查看及修改意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		
		OpenPage("/CreditManage/CreditAlarm/RiskSignalApproveInfo.jsp?SerialNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=提交记录;InputParam=无;OutPutParam=无;]~*/
	function commitRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		//检查是否填写预警检查报告		
		sReturn=RunMethod("PublicMethod","GetColValue","SerialNo,INSPECT_INFO,String@ObjectType@RiskSignal@String@ObjectNo@"+sSerialNo);
		if(typeof(sReturn)=="undefined" || sReturn.length == 0){
			alert(getBusinessMessage('678'));//尚未生成预警检查报告
			return;
		}
		//检查是否签署意见
		sReturn=RunMethod("PublicMethod","GetColValue","Opinion,RISKSIGNAL_OPINION,String@ObjectNo@"+sSerialNo);
		sReturnValue=sReturn.split("~");
		sReturnValue=sReturnValue[0].split("@");
		if(typeof(sReturnValue[1])=="undefined" || sReturnValue[1].trim().length == 0||sReturnValue[1]=="null"){
			alert("尚未签署意见！");//尚未签署意见！
			return;
		}
		if(confirm(getHtmlMessage('17'))){ //确信需要提交该记录吗？
			sSignalStatus = PopPage("/CreditManage/CreditAlarm/AddSignalStatusDialog.jsp","","resizable=yes;dialogWidth=18;dialogHeight=8;center:yes;status:no;statusbar:no");
			if(typeof(sSignalStatus) != "undefined" && sSignalStatus.length != 0 && sSignalStatus != '_none_'){
				//提交操作
				sReturn = RunMethod("PublicMethod","UpdateColValue","String@SignalStatus@"+sSignalStatus+",RISK_SIGNAL,String@SerialNo@"+sSerialNo);
				if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
					alert(getHtmlMessage('9'));//提交失败！
					return;
				}else{
					reloadSelf();
					alert(getHtmlMessage('18'));//提交成功！
				}
			}	
		}			
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>