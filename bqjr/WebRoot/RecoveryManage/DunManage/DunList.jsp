<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   	王业罡 2005-08-18
		Tester:
		Content:  	催收函列表
		Input Param:												
				ObjectType	对象类型
				ObjectNo	对象编号        
		Output param:
		                	
		History Log: 
		               
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "催收函列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%		
	//获得组件参数	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));	
	String sDunCurrency    =DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Currency"));
	String flag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("flag"));

	//sxjiang 2010/08/05 此处获取参数需访问Comp和Page
	if(flag == null) flag = "";
	if(sObjectType==null) {
		sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
		if(sObjectType == null) sObjectType = "";
	}
	if(sObjectNo==null) {
		sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
		if(sObjectNo == null) sObjectNo = "";
	}
	if(sDunCurrency==null) {
		sDunCurrency = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Currency"));
		if(sDunCurrency == null) sDunCurrency = "";
	}
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	
	String sTempletNo="DunList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//生成查询条件
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);//20条一分页

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sObjectNo);//传入显示模板参数
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
			{"true","","Button","新增","新增催收函","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除当前催收函","deleteRecord()",sResourcesPath},
			{"true","","Button","打印催收函","打印催收函","PrintDunLetter()",sResourcesPath},
			{(flag.equals("page")?"true":"false"),"","Button","返回","返回到授信台帐","goBack()",sResourcesPath}
	};	
	%>	
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			//url = "/RecoveryManage/DunManage/DunInfo.jsp?ObjectType="+"<%=sObjectType%>"+"&ObjectNo="+"<%=sObjectNo%>"+"&SerialNo="+sSerialNo+"&Currency="+"<%=sDunCurrency%>";
			//OpenPage(url,"_self","");
			popComp("DunInfo","/RecoveryManage/DunManage/DunInfo.jsp","ObjectType="+"<%=sObjectType%>"+"&ObjectNo="+"<%=sObjectNo%>"+"&SerialNo="+sSerialNo+"&Currency="+"<%=sDunCurrency%>"+"&flag=comp","dialogwidth:640px;dialogheight:480;");
			reloadSelf();
		}
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

	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/	
	function newRecord()
	{
		popComp("DunInfo","/RecoveryManage/DunManage/DunInfo.jsp","ObjectType="+"<%=sObjectType%>"+"&ObjectNo="+"<%=sObjectNo%>"+"&Currency="+"<%=sDunCurrency%>"+"&flag=comp","dialogwidth:640px;dialogheight:480;");
		reloadSelf();
	}

	/*~[Describe=打印催收函;InputParam=无;OutPutParam=无;]~*/
	function PrintDunLetter()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sDunObjectType = getItemValue(0,getRow(),"DunObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else
		{
			if(sDunObjectType == "01")//催收对象为借款人
			{
                //modified by djia 2010/08/03
				//如果调用此页面的上层窗口是一个模态窗口，此页面不能用OpenPage的形式打开，只能用PopPage的形式打开，否则会出现session丢失问题
				OpenPage("/RecoveryManage/DunManage/Println1.jsp?SerialNo="+sSerialNo,"",OpenStyle);
				//popComp("Println1","/RecoveryManage/DunManage/Println1.jsp","SerialNo="+sSerialNo,OpenStyle);
			}
			else if(sDunObjectType == "02")//催收对象为保证人
			{
				OpenPage("/RecoveryManage/DunManage/Println2.jsp?SerialNo="+sSerialNo,"",OpenStyle);
				//popComp("Println2","/RecoveryManage/DunManage/Println2.jsp","SerialNo="+sSerialNo,OpenStyle);
			}
			else{
				alert("系统中不支持催收对象为“其他类型”的催收函打印！");
				return;
			}	
		}
	}	

	/*~[Describe=页面返回;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		OpenPage("/CreditManage/CreditPutOut/ContractList.jsp","_self");
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