<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: zllin@amarsoft.com
		Tester:
		Describe: 授权维度列表
		Input Param:
				
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "授权维度列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//CurPage.setAttribute("ShowDetailArea","true");
	//CurPage.setAttribute("DetailAreaHeight","125");
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	//获得组件参数：对象类型、对象编号
	String sGroupID = DataConvert.toString((String)CurPage.getAttribute("GroupID"));
	ARE.getLog().info("GroupID="+sGroupID);
	
	//将空值转化为空字符串
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	
	//通过显示模版产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("AuthorSceneList",Sqlca);

	//增加过滤器 
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	//设置setEvent
	dwTemp.setEvent("AfterDelete", "!PublicMethod.AuthorObjectManage('remove','scene',#SCENEID)");
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sGroupID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	
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
		{"true","","Button","新增","新增授权方案","newRecord()",sResourcesPath},
		{"true","","Button","编辑","编辑授权方案","editRecord()",sResourcesPath},
		{"true","","Button","删除","删除授权方案","deleteRecord()",sResourcesPath},
		{"true","","Button","复制方案","授权方案复制","replicateScene()",sResourcesPath},
		{"true","","Button","授权规则配置","授权规则配置","configScenes()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
<script type="text/javascript">

	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
		PopComp("RuleSceneInfo","/Common/Configurator/Authorization/RuleSceneInfo.jsp","GroupID=<%=sGroupID%>","");
		reloadSelf();
	}

	/*~[Describe=编辑记录;InputParam=无;OutPutParam=无;]~*/
	function editRecord(){
		var sSceneID = getItemValue(0,getRow(),"SCENEID");		//--流水号码
		if(typeof(sSceneID)=="undefined" || sSceneID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息!
		}else{
			PopComp("RuleSceneInfo","/Common/Configurator/Authorization/RuleSceneInfo.jsp","GroupID=<%=sGroupID%>&SceneID="+sSceneID,"");
			reloadSelf();
		}
	}
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var sSceneID = getItemValue(0,getRow(),"SCENEID");		//--流水号码
		if(typeof(sSceneID)=="undefined" || sSceneID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息!
		}else if(confirm(getHtmlMessage('2'))){//您真的想删除该信息吗？
			as_del('myiframe0');
    		as_save('myiframe0');  //如果单个删除，则要调用此语句
		}
	}
	
	function configScenes(){
		var sSceneID = getItemValue(0,getRow(),"SCENEID");
		if(typeof(sSceneID)=="undefined" || sSceneID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息!
			return;
		}
		var sStatus = getItemValue(0,getRow(),"STATUS");
		if(typeof(sStatus)=="undefined" || sStatus.length==0 ||sStatus=="2"){
			alert("授权方案状态为非有效状态,不能配置授权规则.");
			return;
		}
		OpenComp("SceneRuleList","/Common/Configurator/Authorization/RuleList.jsp","SceneID="+sSceneID,"_blank","");
	}
	
	function replicateScene(){
		var sSceneID = getItemValue(0,getRow(),"SCENEID");
		if(typeof(sSceneID)=="undefined" || sSceneID.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息!
			return;
		}
		
		ShowMessage("系统正在复制授权方案,请等待...",true,false);
		var sStatus = RunMethod("PublicMethod","AuthorObjectManage","replicate,scene,"+sSceneID);
		try{hideMessage();}catch(e){;}
		
		if(typeof(sStatus)=="undefined" || sStatus.length==0){
			
		}else if(sStatus=="SUCCESSFUL"){
			alert("授权场景复制成功!");
			OpenPage("/Common/Configurator/Authorization/RuleSceneList.jsp?GroupID=<%=sGroupID%>","_self");
		}else{
			alert("授权场景复制失败!");
		}
	}
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	hideFilterArea();
</script>
<%/*~END~*/%>
<%@	include file="/IncludeEnd.jsp"%>