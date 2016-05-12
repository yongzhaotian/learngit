<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   byhu  2004.12.7
		Tester:
		Content: 创建授信额度申请
		Input Param:
			ObjectType：对象类型
			ApplyType：申请类型
			PhaseType：阶段类型
			FlowNo：流程号
			PhaseNo：阶段号
			OccurType：发生类型	
			OccurDate：发生日期
		Output param:
		History Log: zywei 2005/07/28
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授信方案新增信息"; // 浏览器窗口标题 <title> PG_TITLE </title>	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//获得组件参数	：对象类型、申请类型、阶段类型、流程编号、阶段编号、发生方式、发生日期
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApplyType"));
	String sPhaseType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseType"));
	String sFlowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FlowNo"));
	String sPhaseNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PhaseNo"));
	String sOccurType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurType"));
	String sOccurDate =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OccurDate"));
	
	//将空值转化成空字符串
	if(sObjectType == null) sObjectType = "";	
	if(sApplyType == null) sApplyType = "";
	if(sPhaseType == null) sPhaseType = "";	
	if(sFlowNo == null) sFlowNo = "";
	if(sPhaseNo == null) sPhaseNo = "";
	if(sOccurType == null) sOccurType = "";	
	if(sOccurDate == null) sOccurDate = "";	
	
	//定义变量：SQL语句
	String sSql = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
<%
	//通过显示模版产生ASDataObject对象doTemp
	String[][] sHeaders = {
							{"OccurType","发生类型"},							
							{"OccurDate","发生日期"},
							{"InputOrgName","登记机构"},
							{"InputUserName","登记人"},
							{"InputDate","登记日期"}
						  };
	sSql = 	" select OccurType,OccurDate,getOrgName(InputOrgID) as InputOrgName, "+	
			" getUserName(InputUserID) as InputUserName,InputDate "+		
			" from BUSINESS_APPLY where 1 = 2 ";	
			
	//通过SQL产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sSql);	
	//设置标题
	doTemp.setHeader(sHeaders);
	
	//设置必输项
	doTemp.setRequired("OccurType",true);//add by jgao1 去掉发生日期必输项
	//设置下拉框选择内容
	if(sApplyType.equals("IndependentApply"))
		doTemp.setDDDWCode("OccurType","OccurType");	
	if(sApplyType.equals("DependentApply"))
		doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'OccurType' and ItemNo <> '015' and IsInUse='1'");
	//设置必输背景色
	doTemp.setHTMLStyle("OccurType,OccurDate","style={background=\"#EEEEff\"} ");
	//设置日期格式
	doTemp.setCheckFormat("OccurDate","3");	
	//注意,先设HTMLStyle，再设ReadOnly，否则ReadOnly不会变灰
	doTemp.setHTMLStyle("InputDate"," style={width:80px}");
	doTemp.setReadOnly("InputOrgName,InputUserName,InputDate,OccurDate",true);//增加发生日期只读项
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","下一步","新增授信额度申请的下一步","nextStep()",sResourcesPath},
		{"true","","Button","取消","取消新增授信额度申请","doCancel()",sResourcesPath}		
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script type="text/javascript">
		/*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
		function doCancel(){		
			top.returnValue = "_CANCEL_";
			top.close();
		}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script type="text/javascript">	
	
	/*~[Describe=下一步;InputParam=无;OutPutParam=无;]~*/
	function nextStep()
	{
		//发生方式
		sOccurType = getItemValue(0,getRow(),"OccurType");		
		if (typeof(sOccurType) == "undefined" || sOccurType.length == 0)
		{
			alert(getBusinessMessage('506'));//请选择发生类型！
			return;
		}
		
		//发生日期
		sOccurDate = getItemValue(0,getRow(),"OccurDate");		
		if (typeof(sOccurDate) == "undefined" || sOccurDate.length == 0)
		{
			alert(getBusinessMessage('507'));//请选择发生日期！
			return;
		}else
		{
			sToday = "<%=StringFunction.getToday()%>";//当前日期	
			if(sOccurDate > sToday)
			{		    
				alert(getBusinessMessage('508'));//发生日期必须早于或等于当前日期！
				return;		    
			}
		}
		OpenPage("/CreditManage/CreditApply/CreditApplyCreationInfo2.jsp?ObjectType=<%=sObjectType%>&ApplyType=<%=sApplyType%>&PhaseType=<%=sPhaseType%>&FlowNo=<%=sFlowNo%>&PhaseNo=<%=sPhaseNo%>&OccurType="+sOccurType+"&OccurDate="+sOccurDate,"_self","");
    }
    		
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增一条空记录			
			sOccurType = "<%=sOccurType%>";
			sOccurDate = "<%=sOccurDate%>";
			if (typeof(sOccurType) == "undefined" || sOccurType.length == 0)
				setItemValue(0,0,"OccurType","010");
			else
				setItemValue(0,0,"OccurType",sOccurType);
			if (typeof(sOccurDate) == "undefined" || sOccurDate.length == 0)
				setItemValue(0,0,"OccurDate","<%=StringFunction.getToday()%>");	
			else
				setItemValue(0,0,"OccurDate",sOccurDate);			
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");	
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");	
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");			
		}
    }
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();	
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化	
	var bCheckBeforeUnload=false;	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>