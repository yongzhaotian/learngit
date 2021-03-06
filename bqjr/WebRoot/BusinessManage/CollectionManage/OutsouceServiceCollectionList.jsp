<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:
		Tester:
		Describe: 待催收的业务
		Input Param:
		Output Param:
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "待催收的业务"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	String sTempletNo = "UnServiceCollectionList"; //模版编号
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
			{"true","","Button","查看合同","查看合同","viewContract()",sResourcesPath},
			{"true","","Button","跟进结果登记","跟进结果登记","showRegistList()",sResourcesPath},
			{"true","","Button","退回","退至委外分配","goBackProvider()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~~[Describe=委外催收任务的合同信息查看;InputParam=无;OutPutParam=无;]~~*/
	function viewContract(){
		var sObjectType = "BusinessContract";
		var sObjectNo = getItemValue(0,getRow(),"ContractSerialno");//合同号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");//催收任务号
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert("该任务合同号为空!");//请选择一条信息！
			return;
		}
		
		var sCompURL = "/BusinessManage/CollectionManage/BusinessContractViewTab.jsp";
		var sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&RightType=ReadOnly";
		AsControl.OpenComp(sCompURL, sParamString, "_blank", OpenStyle);
		reloadSelf();
	}
	
	/*~~[Describe=委外催收任务退回;InputParam=无;OutPutParam=无;]~~*/
	function goBackProvider(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//催收任务流水号
		var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.hhcf.after.colection.AfterColectionAction","goBackProvider","ColSerialNo="+sSerialNo);
		if(sRec != "Success"){
			alert("委外催收任务退回失败!");
			return;
		}
	}
	
	/*~~[Describe=查看委外催收跟进结果登记列表;InputParam=无;OutPutParam=无;]~~*/
	function showRegistList(){
		sSerialNo = getItemValue(0,getRow(),"SerialNo");//催收任务流水号
		var sBcSerialNo = getItemValue(0,getRow(),"ContractSerialno");//合同号
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if (typeof(sBcSerialNo)=="undefined" || sBcSerialNo.length==0)
		{
			alert("合同号不能为空!");//请选择一条信息！
			return;
		}
		AsControl.OpenPage("/BusinessManage/CollectionManage/ColectionRegistList2.jsp", "ColectionSerialNo="+sSerialNo+"&ContractSerialNo="+sBcSerialNo, "_self", "");
	}
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
