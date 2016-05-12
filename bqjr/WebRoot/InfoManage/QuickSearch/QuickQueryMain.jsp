<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  FSGong 2005.01.25
		Tester:
		Content: 快速查询主界面
		Input Param:		
		Output param:		                
		History Log: 		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "快速查询主界面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;快速查询主界面&nbsp;&nbsp;"; //默认的内容区标题
	String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
	String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	
	
	String sDisplay=DataConvert.toRealString(iPostChange,(CurComp.getParameter("Display")));
	if(sDisplay==null){
		sDisplay="";
	}

	//获得页面参数

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/%>
	<%
	//定义Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"快速查询","right");
	tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
	tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
	tviTemp.TriggerClickEvent=true; //是否自动触发选中事件


	//定义树图结构,去掉跟踪的不良资产和催收函快速查询
	String sSqlTreeView = "from CODE_LIBRARY where CodeNo= 'QuickQueryList' and IsInUse = '1' ";
	//获取配置文件参数ApproveNeed，判断是否显示树图最终审批意见快速查询：true-显示，false-不显示
	String sApproveTreeView = "";
	sApproveTreeView = CurConfig.getConfigure("ApproveNeed");
	if("false".equalsIgnoreCase(sApproveTreeView)){
		sSqlTreeView = sSqlTreeView + " and itemNo not in('0100202')";
	}
	
    /*********新增客服部公告栏 ADD byang CCS-1252 20160304 权限控制***********************/
	String flag="";//1:标识为客服组长、电销组长、投诉组、质检组长、培训组。2：标识为客服专员、电销专员。3：非客服部人员
	if(CurUser.getOrgID().equals("14")){//若是审核部人员则进行下一步判断是否为管理员权限
	  if(CurUser.hasRole("1036") || CurUser.hasRole("1059") || CurUser.hasRole("1060") || CurUser.hasRole("1061") || CurUser.hasRole("1062") || CurUser.hasRole("1064")){
	  	flag="1";
	  }else{
	  	flag="2";
	  }
	}else{
	  flag="3";
	}
	
	if(flag.equals("2")){
		sSqlTreeView = sSqlTreeView + " and itemNo not in ('010030010')";
	}else if(flag.equals("3")){
		sSqlTreeView = sSqlTreeView + " and itemNo not in ('01003','010030010','010030020')";
	}
	//end
	
	tviTemp.initWithSql("SortNo","ItemName","ItemDescribe","","",sSqlTreeView,"Order By SortNo",Sqlca);
	//参数从左至右依次为：
	//ID字段(必须),Name字段(必须),Value字段,Script字段,Picture字段,From子句(必须),OrderBy子句,Sqlca
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>

<script type="text/javascript"> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemName = getCurTVItem().name;
		var sCurItemDescribe = getCurTVItem().value;

		sCurItemDescribe = sCurItemDescribe.split("@");
		sCurItemDescribe1=sCurItemDescribe[0];  //代码表描述字段中用@分隔的第1个串
		sCurItemDescribe2=sCurItemDescribe[1];  //代码表描述字段中用@分隔的第2个串
		sCurItemDescribe3=sCurItemDescribe[2];  //代码表描述字段中用@分隔的第3个串，根据情况，还可以很多。
		if(sCurItemDescribe1 != "null" && sCurItemDescribe1 != "root"){
			OpenComp(sCurItemDescribe2,sCurItemDescribe1,"ComponentName="+sCurItemName,"right");
			setTitle(getCurTVItem().name);
		}
	}
	
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
		
</script> 
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>

<script type="text/javascript">    
	startMenu();
	expandNode('root');
	expandNode('010');
	expandNode('01001');
	expandNode('01002');
	expandNode('01003');
	expandNode('050');
	selectItemByName('<%=sDisplay%>');

	<% /*********新增客服部公告栏 ADD CCS-1252 20160304 byang ***********************/%>
	//进入此页面,权限为审核员时弹出公告栏
	function UpNotice(){
		AsControl.PopView("/Common/WorkFlow/UpNoticeList.jsp", "identtype=01", "dialogWidth=850px;dialogHeight=600px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	   
    function ReloadNotice(){
 	    <%/*~begin判断登录身份org为14则是审核部都弹屏 */%>
 	    if(<%=CurUser.getOrgID()%>=='14'){
 	    	var UserId = "<%=CurUser.getUserID()%>";
 	    	var userOrg = "<%=CurUser.getOrgID()%>";
 	    	//若有新公告则弹出界面，否则不弹出界面
 	    	//add by byang CCS-1252	控制查看已阅公告栏为本部门的发出的公告,如果是客服部门还要限制可见的角色
 	    	var swhere = "notice_info,count(1),";
 	    	<%
 	    		String str = "";
	 	   		//一个用户多个角色,至少有一个角色
	 	   		ArrayList<String> roleList = CurUser.getRoleTable();
	 	   		if(roleList.size()==1){
	 	   		str += " visibleRole like '%"+roleList.get(0)+"%'";
	 	   		}else{
	 	   			for(int i=0;i<roleList.size();i++){
	 	   				if(i==0){
	 	   					str += " (visibleRole like '%"+roleList.get(i)+"%'";
	 	   				}else if(i==roleList.size()-1){
	 	   					str += " or visibleRole like '%"+roleList.get(i)+"%')";
	 	   				}else{
	 	   					str += " or visibleRole like '%"+roleList.get(i)+"%'";
	 	   				}
	 	   			}
	 	   		}
 	    	%>
 	    	swhere += "<%=str%>";
 	   		swhere += " and noticeid not in (select t.noticeid  from USER_NOTICE t  where t.isflag = '1' and t.UserID = '"+UserId+"') and inputorg='"+userOrg+"'";
 	    	var count= RunMethod("Unique","uniques",swhere);
 	    	if(count>0){
 	    		UpNotice();
 	    	}
 	    }
    }
    
    try{
	    ReloadNotice();
	    //规定的时间间隔内调用某个JS方法(调用此方法是完成实时公告监控功能)
	    /*setInterval(function () {
	    	ReloadNotice();
        }, 60000);*/
    }catch(e){}
    
    <% /*********end ***********************/%>
</script>

<%@ include file="/IncludeEnd.jsp"%>
