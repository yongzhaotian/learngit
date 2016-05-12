<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: 未分配的委外业务
		Input Param:
		Output Param:
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未分配的委外业务"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量：SQL语句
	String sSql = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	

	
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "UntreatedCollectionList"; //模版编号
	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混淆

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

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
			{"true","","Button","查看合同","查看合同","viewContractInfo()",sResourcesPath},
			{"true","","Button","分配服务商","分配服务商","assignService()",sResourcesPath},
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
	function my_add()
	{ 	 
	    OpenPage("/BusinessManage/QueryManage/PhoneManageInfo.jsp","_self","");
	}	                                                                                                                                                                                                                                                                                                                                                 

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}	

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			OpenPage("/BusinessManage/QueryManage/PhoneManageInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
	}
	
	/*~[Describe=查看合同;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewContractInfo()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"ContractSerialno");
		
	    sObjectType = "BusinessContract";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			sCompURL = "/BusinessManage/CollectionManage/BusinessContractViewTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo+"&RightType=ReadOnly";
    		AsControl.OpenComp(sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	
	/*~[Describe=分配服务商;InputParam=无;OutPutParam=SerialNo;]~*/
	function assignService(){
		var sCity =getItemValue(0,getRow(),"NewAddCode");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if (typeof(sCity)=="undefined" || sCity.length==0)
		{
			alert("客户所在地不能为空!");//请选择一条信息！
			return;
		}
		//根据催收任务的居住地址获取催收任务的催收城市
		var sProvidersCity = AsControl.RunJavaMethodSqlca("com.amarsoft.app.hhcf.after.colection.AfterColectionAction","getCollectionCity","City="+sCity);
		if(sProvidersCity == "Falture"){
			alert("催收任务的催收城市获取失败!");
			return;
		}
		//传入催收城市参数弹出分配服务商页面选择委外催收服务商
		var sProviderInfo= AsControl.PopPage("/BusinessManage/CollectionManage/ColectionServiceProvidersList.jsp", "City="+sProvidersCity,"");
		var sProviderSerialNo="";
		var sProviderName="";
		
		if (typeof(sProviderInfo)=="undefined" || sProviderInfo.length==0)
		{
			alert("该任务未分配委外催收服务商!");  //请选择一条记录！
			return;
		}else{
			var sProvider = new Array();
			sProvider = sProviderInfo.split("@"); 
			sProviderSerialNo=sProvider[0];
			sProviderName=sProvider[1];
			
		}
		
		//将选择的委外催收服务商关联至委外催收任务中 并更新委外催收任务状态大类(委外催收)和小类(己分配)
		var sRec = AsControl.RunJavaMethodSqlca("com.amarsoft.app.hhcf.after.colection.AfterColectionAction","updateCollectionProviderAndStatus","ColSerialNo="+sSerialNo+",ProviderSerialNo="+sProviderSerialNo+",ProviderName="+sProviderName);
		if(sRec != "Success"){
			alert("委外催收任务分配服务商及状态更新失败!");
			return;
		}
		
		
		//sSerialNo =getItemValue(0,getRow(),"SerialNo");
		//if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		//{
		//	alert(getHtmlMessage(1));  //请选择一条记录！
		//	return;
		//}
		
		//var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.hhcf.after.colection.AfterColectionAction","assignService","ColSerialNo="+sSerialNo);
		//if(sReturn != "Success"){
		//	alert("催收跟进登记结果状态更新失败!");
		//	return;
		//}
		reloadSelf();
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
