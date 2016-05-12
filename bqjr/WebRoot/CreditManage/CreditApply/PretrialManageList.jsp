<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: 创建申请
		Input Param:
		Output Param:
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "创建申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	// 获取最新预审数据
	String sTypeCode = "PreCredit";
	String sSql = "select attrstr1 from Basedataset_Info where TypeCode='"+sTypeCode+"' order by UpdateDate desc ";
	String attrstr1 = DataConvert.toString( Sqlca.getString(sSql));
	
	
	String sIsFinish = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("isFinish"));
	ARE.getLog().debug("完成标志："+sIsFinish);
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "PretrialList"; //模版编号
	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混淆

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	if("true".equalsIgnoreCase(sIsFinish)){
		doTemp.WhereClause  = " where PretrialResult is not null";
	}else if("false".equalsIgnoreCase(sIsFinish)){
		doTemp.WhereClause  = " where PretrialResult is  null  and  ContractStatus='170'       ";
	}
	
	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);//25条一分页

	//定义后续事件
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//传入显示模板参数
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
			{"true","","Button","新增预审","新增预审","my_add()",sResourcesPath},
			{"true","","Button","预审详情","预审详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","主借款人详情","主借款人详情","view()",sResourcesPath},
			{"true","","Button","提交正式申请","提交正式申请","submitApply()",sResourcesPath},
			{"true","","Button","删除","删除","deleteRecord()",sResourcesPath},
		};
	
	if("true".equalsIgnoreCase(sIsFinish)){
		sButtons[0][0] = "false";
		sButtons[3][0] = "false";
		sButtons[4][0] = "false";
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
	function my_add()
	{ 
		//add by jli5 增加预审判断
		var yesNo = "<%=attrstr1%>";
		if("1"!=yesNo){
			alert("无需预审，可直接发起正式申请。");
			return;
		}else{
			sCompID = "MainPretrialInfo";
			sCompURL = "/CreditManage/CreditApply/MainPretrialInfo.jsp";
			sReturn = popComp(sCompID,sCompURL,"","dialogWidth=650px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			reloadSelf();
		}
	}                                                                                                                                                                                                                                                                                                                                                 
	/*~[Describe=主借款人详情;InputParam=无;OutPutParam=无;]~*/
	function view()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "MainPretrialInfo";
		sCompURL = "/CreditManage/CreditApply/MainPretrialInfo.jsp";
		sParamString = "SerialNo="+sSerialNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=850px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
		
	}
	

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//合同编号（预审编号）
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			RunMethod("BusinessManage","DeleteRelativeInfo",sSerialNo);
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}	
	

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		sCompID = "PretrialManageList2";
		sCompURL = "/CreditManage/CreditApply/PretrialManageList2.jsp";
		sParamString = "SerialNo="+sSerialNo;
		sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=850px;dialogHeight=550px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
		
	}
	
	/*~[Describe=提交正式申请;InputParam=无;OutPutParam=无;]~*/
	function submitApply(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//申请编号

		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//判断是否存在未预审
		var sPara = "serialNo="+sSerialNo;
	    var returnValue =	RunJavaMethodSqlca("com.amarsoft.proj.action.PretrialApproveResult","isFinishAll",sPara);
	    if(returnValue=="false"){
	    	alert("存在未预审的记录");
	    	return;
	    }
		//查询预审结果，更新到合同表整体预审结果
		var sPretrialResult=RunMethod("BusinessManage","SelectPretrialResult",sSerialNo);
		//alert("------"+sPretrialResult);
		//returnValue = sReturns.split("@");
		//sPretrialResult = returnValue[1];
		
		//FinallySurveyResult:01拒绝；02通过
		if(sPretrialResult=="02"){
			//更新合同，选择产品类型及产品
		    sCompID = "CarApplyInfo";
	        sCompURL = "/CreditManage/CreditApply/CarApplyInfo.jsp";
	        sParamString ="SerialNo="+sSerialNo;
            sReturn = popComp(sCompID,sCompURL,sParamString,"dialogWidth=550px;dialogHeight=450px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			reloadSelf();
		}else{
			alert("整体预审结果未通过，无法提交到正式申请！");
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
