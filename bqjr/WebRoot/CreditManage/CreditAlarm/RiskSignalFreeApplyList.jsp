<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: 预警信号解除信息_List
		Input Param:
			SignalType：预警类型（01：发起；02：解除）						 
			SignalStatus：预警状态（10：待处理；15：待分发；20：审批中；30：批准；40：否决）     
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "预警信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
		
	//获得组件参数	
	String sSignalType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalType"));	
	String sSignalStatus = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SignalStatus"));	
	//将空值转化为空字符串	
	if(sSignalType == null) sSignalType = "";
	if(sSignalStatus == null) sSignalStatus = "";	
	//获得页面参数	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	String[][] sHeaders = {							
							{"CustomerName","客户名称"},
							{"SignalName","预警信号"},
							{"SignalType","预警类型"},
							{"SignalStatus","预警状态"},													
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记时间"}
						};
		
	sSql =  " select ObjectNo,GetCustomerName(ObjectNo) as CustomerName, "+
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
			{(sSignalStatus.equals("10")?"true":"false"),"","Button","新增","新增一个待解除的预警信号","newRecord()",sResourcesPath},
			{((!sSignalStatus.equals("10") && !sSignalStatus.equals("20"))?"true":"false"),"","Button","查看意见","查看/修改认定意见详情","viewOpinion()",sResourcesPath},
			{"true","","Button","预警解除详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{(sSignalStatus.equals("10")?"true":"false"),"","Button","提交","提交所选中的记录","commitRecord()",sResourcesPath}		
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
	function newRecord()
	{		
		//获取已批准的预警信号
		sParaStr = "InputUserID"+","+"<%=CurUser.getUserID()%>";
		sReturn = setObjectValue("SelectRiskSignal",sParaStr,"",0,0,"");
		//判断是否返回有效信息
		if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined") return;
		sReturn = sReturn.split('@');
		sSerialNo = sReturn[0];	
		//将批准的预警信号信息拷贝到预警信号解除信息中
		sReturn = RunMethod("BusinessManage","AddRiskSignalFreeInfo",sSerialNo+","+"<%=CurUser.getUserID()%>");
		if(typeof(sReturn) != "undefined" && sReturn.length > 0) 			
			OpenPage("/CreditManage/CreditAlarm/RiskSignalFreeApplyInfo.jsp?SerialNo="+sReturn,"_self","");
	}
	
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinion()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		popComp("ViewRiskSignalOpinions","/CreditManage/CreditAlarm/ViewRiskSignalOpinions.jsp","ObjectNo="+sSerialNo+"&SignalType=<%=sSignalType%>","");
	}
					
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		
		OpenPage("/CreditManage/CreditAlarm/RiskSignalFreeApplyInfo.jsp?SerialNo="+sSerialNo,"_self","");
	}
	
	/*~[Describe=提交记录;InputParam=无;OutPutParam=无;]~*/
	function commitRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
			
		if(confirm(getHtmlMessage('17'))) //确信需要提交该记录吗？
	    {
			//取消归档操作
			sReturn = RunMethod("PublicMethod","UpdateColValue","String@SignalStatus@15,RISK_SIGNAL,String@SerialNo@"+sSerialNo);
			if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}else
			{
				reloadSelf();
				alert(getHtmlMessage('18'));//提交成功！
			}				
	   	}	
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

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
