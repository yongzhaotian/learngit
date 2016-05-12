<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 风险分类认定列表;
		Input Param:			
			ClassifyType：分类类型（010：待完成分类；020：已完成分类）
			ObjectType：对象类型（按合同：BUSINESS_CONTRACT；按借据：BUSINESS_DUEBILL）
		Output Param:
			
		HistoryLog:zywei 2005/09/23 新增按照合同/借据分类
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "风险分类认定列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sTempletNo = "";
	String sSortNo = CurOrg.getSortNo(); //机构ID
	String sOrgLevel = CurOrg.getOrgLevel();//机构级别（0：总行；3：分行；6：支行；9：网点）
	
	//获得组件参数
	String sClassifyType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassifyType"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	//将空值转化为空字符串
	if(sClassifyType == null) sClassifyType = "";
	if(sObjectType == null) sObjectType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	//将空值转化为空字符串
	if(sOrgLevel == null) sOrgLevel = "";
	//定义表头文件
	if(sObjectType.equals("BusinessContract")){ //按合同分类
		if(sOrgLevel.equals("0")) //总行
			sTempletNo = "HeadClassifyList1";
		if(sOrgLevel.equals("3")) //分行
			sTempletNo = "BranchClassifyList1";
		if(sOrgLevel.equals("6")) //支行
			sTempletNo = "SubbranchClassifyList1";
	}	
	if(sObjectType.equals("BusinessDueBill")){ //按借据分类
		if(sOrgLevel.equals("0")) //总行
			sTempletNo = "HeadClassifyList2";
		if(sOrgLevel.equals("3")) //分行
			sTempletNo = "BranchClassifyList2";
		if(sOrgLevel.equals("6")) //支行
			sTempletNo = "SubbranchClassifyList2";
	}
	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	if(sClassifyType.equals("010")){ //需认定分类
		if(sOrgLevel.equals("0")){ //总行风险分类认定
			doTemp.WhereClause += " and (CLASSIFY_RECORD.FinishDate5 = ' ' or CLASSIFY_RECORD.FinishDate5 is null) and CLASSIFY_RECORD.FinishDate3 is not null and CLASSIFY_RECORD.FinishDate3 <> ' ' ";
		}
		if(sOrgLevel.equals("3")){ //分行风险分类认定
			doTemp.WhereClause += " and (CLASSIFY_RECORD.FinishDate3 = ' ' or CLASSIFY_RECORD.FinishDate3 is null) and CLASSIFY_RECORD.FinishDate2 is not null and CLASSIFY_RECORD.FinishDate2 <> ' ' ";
		}
		if(sOrgLevel.equals("6")){ //支行风险分类认定
			doTemp.WhereClause += " and (CLASSIFY_RECORD.FinishDate2 = ' ' or CLASSIFY_RECORD.FinishDate2 is null) ";
		}
	}
	
	if(sClassifyType.equals("020")){ //已认定分类
		if(sOrgLevel.equals("0")){ //总行风险分类认定
			doTemp.WhereClause += " and CLASSIFY_RECORD.FinishDate5 <> ' ' and CLASSIFY_RECORD.FinishDate5 is not null and CLASSIFY_RECORD.ResultUserID5='"+CurUser.getUserID()+"' ";
		}
		if(sOrgLevel.equals("3")){ //分行风险分类认定
	    	doTemp.WhereClause += " and CLASSIFY_RECORD.FinishDate3 <> ' ' and CLASSIFY_RECORD.FinishDate3 is not null and CLASSIFY_RECORD.ResultUserID3='"+CurUser.getUserID()+"' ";
		}
		if(sOrgLevel.equals("6")){ //支行风险分类认定
		 	doTemp.WhereClause += " and CLASSIFY_RECORD.FinishDate2 <> ' ' and CLASSIFY_RECORD.FinishDate2 is not null and CLASSIFY_RECORD.ResultUserID2='"+CurUser.getUserID()+"' ";
		}
	}
	
	doTemp.WhereClause += " and CLASSIFY_RECORD.FinishDate <> ' ' and CLASSIFY_RECORD.FinishDate is not null ";
		
	//设置查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);	
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
    dwTemp.setPageSize(20);

	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sSortNo);
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
		{"true","","Button","模型分类详情","查看模型分类详情","Model()",sResourcesPath},
		{(sClassifyType.equals("010")?"true":"false"),"","Button","分类认定","分类认定","viewAndEdit()",sResourcesPath},		
		{(sClassifyType.equals("020")?"true":"false"),"","Button","分类认定详情","查看分类认定详情","viewAndEdit()",sResourcesPath},				
		{(sClassifyType.equals("010")?"true":"false"),"","Button","分类完成","分类完成","Finished()",sResourcesPath},	
		{(sObjectType.equals("BusinessContract")?"true":"false"),"","Button","合同详情","查看合同详情","ContractInfo()",sResourcesPath},
		{(sObjectType.equals("BusinessDueBill")?"true":"false"),"","Button","借据详情","查看借据详情","DueBillInfo()",sResourcesPath}	
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看模型分类详情;InputParam=无;OutPutParam=无;]~*/
	function Model(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");		
		var sObjectType = getItemValue(0,getRow(),"ObjectType");

		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		OpenComp("ClassifyDetails","/CreditManage/CreditCheck/ClassifyDetail.jsp","ComponentName=风险分类参考模型&Action=_DISPLAY_&ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&AccountMonth="+sAccountMonth+"&SerialNo="+sSerialNo+"&ModelNo=Classify1&ClassifyType=020"+ "&ResultType=" + sObjectType,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		OpenPage("/CreditManage/CreditCheck/ClassifyCognInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=<%=sObjectType%>&ObjectNo="+sObjectNo+"&ClassifyType=<%=sClassifyType%>", "_self","");
	}
	
	/*~[Describe=完成分类;InputParam=无;OutPutParam=无;]~*/
	function Finished(){
		var sOrgLevel = "<%=sOrgLevel%>"; 
		var sResult = "";
		var sFieldName = "";
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！Result1
			return;
		}
		if(sOrgLevel == "0"){ //总行
			sResult = getItemValue(0,getRow(),"Result5");
			sFieldName = "FinishDate5"
		}
		if(sOrgLevel == "3"){ //分行
			sResult = getItemValue(0,getRow(),"Result3");
			sFieldName = "FinishDate3"
		}
		if(sOrgLevel == "6"){ //支行
			sResult = getItemValue(0,getRow(),"Result2");
			sFieldName = "FinishDate2"
		}
		if (typeof(sResult)=="undefined" || sResult.length==0){
			alert(getBusinessMessage('658'));//风险分类没有完成！
			return;
		}
		if(confirm(getBusinessMessage('659'))){ //您确定已经分类完成吗？
			//认定完成操作
			sFinishDate = "<%=StringFunction.getToday()%>";
			sReturn = RunMethod("PublicMethod","UpdateColValue","String@"+sFieldName+"@"+sFinishDate+",CLASSIFY_RECORD,String@SerialNo@"+sSerialNo);
			if(typeof(sReturn) == "undefined" || sReturn.length == 0) {				
				alert(getBusinessMessage('660'));//完成资产风险分类失败！
				return;			
			}else{
				reloadSelf();	
				alert(getBusinessMessage('661'));	//完成资产风险分类成功！
			}
		}
	}
	
	/*~[Describe=合同详情;InputParam=无;OutPutParam=无;]~*/
	function ContractInfo(){ 
		//合同流水号
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));  //请选择一条信息！
			return;
		}
		
		openObject("AfterLoan",sSerialNo,"002");
	}
	
	/*~[Describe=借据详情;InputParam=无;OutPutParam=无;]~*/
	function DueBillInfo(){
		//借据流水号
		var sSerialNo = getItemValue(0,getRow(),"ObjectNo");		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));  //请选择一条信息！
			return;
		}
		
		openObject("BusinessDueBill",sSerialNo,"002");
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>
