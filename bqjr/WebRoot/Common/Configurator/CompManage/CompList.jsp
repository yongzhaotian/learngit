<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cwzhan 2004-12-22
		Tester:
		Content: 组件管理列表
		Input Param:
                  
		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "组件管理列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql;
	
	//获得组件参数	
	String sAppID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("AppID"));
	if(sAppID==null) sAppID="";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
   	String sHeaders[][] = {
				{"CompID","组件ID"},
				{"CompName","组件名称"},
				{"AppID","应用ID"},
				{"OrderNo","排序号"},
				{"CompType","组件类型"},
				{"DefaultPage","缺省页面"},
				{"CompURL","组件URL"},
				{"CompPath","组件路径"},
				{"RightID","权限ID"},
				{"REMARK","备注"},
				{"INPUTUSERNAME","输入人"},
				{"INPUTUSER","输入人"},
				{"INPUTORGNAME","输入机构"},
				{"INPUTORG","输入机构"},
				{"INPUTTIME","输入时间"},
				{"UPDATEUSERNAME","更新人"},
				{"UPDATEUSER","更新人"},
				{"UPDATETIME","更新时间"}
			       };  

	sSql = " Select  "+
				"CompID,"+
				"CompName,"+
				"AppID,"+
				"OrderNo,"+
				"getItemName('ComponentType',CompType) as CompType,"+
				"DefaultPage,"+
				"CompURL,"+
				"CompPath,"+
				"RightID,"+
				"REMARK,"+
				"getUserName(INPUTUSER) as INPUTUSERNAME,"+
				"INPUTUSER,"+
				"getOrgName(INPUTORG) as INPUTORGNAME,"+
				"INPUTORG,"+
				"INPUTTIME,"+
				"getUserName(UPDATEUSER) as UPDATEUSERNAME,"+
				"UPDATEUSER,"+
				"UPDATETIME "+
				"From REG_COMP_DEF where 1=1 order by OrderNo";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_COMP_DEF";
	doTemp.setKey("CompID",true);
	doTemp.setHeader(sHeaders);

	//doTemp.setDDDWSql("AppID","select AppID,AppID ||'--'|| AppName from REG_APP_DEF");

	doTemp.setHTMLStyle("CompID"," style={width:160px} ");
	doTemp.setHTMLStyle("CompName"," style={width:160px} ");
	doTemp.setHTMLStyle("AppID"," style={width:160px} ");
	doTemp.setHTMLStyle("OrderNo"," style={width:140px} ");
	doTemp.setHTMLStyle("CompType"," style={width:80px} ");
	doTemp.setHTMLStyle("DefaultPage,CompPath,CompURL"," style={width:600px} ");
	doTemp.setHTMLStyle("RightID"," style={width:260px} ");
	doTemp.setHTMLStyle("INPUTUSER,UPDATEUSER"," style={width:160px} ");
	doTemp.setHTMLStyle("INPUTORG"," style={width:160px} ");
	doTemp.setHTMLStyle("INPUTTIME,UPDATETIME"," style={width:130px} ");
	doTemp.setHTMLStyle("REMARK"," style={width:400px} ");
	doTemp.setReadOnly("INPUTUSER,UPDATEUSER,INPUTORG,INPUTTIME,UPDATETIME",true);
 
	doTemp.setVisible("CommentText,REMARK,INPUTUSER,INPUTORG,UPDATEUSER,NPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME",false);    	
	doTemp.setUpdateable("INPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME",false);

	//查询
 	doTemp.setColumnAttribute("CompID,CompPath,OrderNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" And 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(30);

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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","生成帮助点","为所有没有功能说明的组件生成帮助点","genComment()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
    var sCurCompID=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord(){
        sReturn=popComp("CompInfo","/Common/Configurator/CompManage/CompInfo.jsp","","");
        if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			//新增数据后刷新列表
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/CompManage/CompList.jsp","_self","");    
				}
			}
		}
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit(){
        var sCompID = getItemValue(0,getRow(),"CompID");
        if(typeof(sCompID)=="undefined" || sCompID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
        //openObject("ComponentDefinition",sCompID,"001");
        popComp("CompView","/Common/Configurator/CompManage/CompView.jsp","ObjectNo="+sCompID,"","");
        if(confirm("是否刷新列表？")) reloadSelf();

	/*
	sReturn=popComp("CompInfo","/Common/Configurator/CompManage/CompInfo.jsp","CompID="+sCompID,"");
        //修改数据后刷新列表
        if (typeof(sReturn)!='undefined' && sReturn.length!=0) 
        {
		sReturnValues = sReturn.split("@");
		if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y") 
		{
			OpenPage("/Common/Configurator/CompManage/CompList.jsp?CompID="+sCompID,"_self","");           
 		}
}
	*/
	}
    
	/*~[Describe=生成帮助点;InputParam=无;OutPutParam=无;]~*/
	function genComment(){
		RunMethod("Configurator","GenerateCompComment","");
	}
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord(){
		var CompID = getItemValue(0,getRow(),"CompID");
		if(typeof(CompID)=="undefined" || CompID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
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
