<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content: 组件信息详情
		Input Param:
                    CompID：    组件编号
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "组件管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql;
	String sSortNo; //排序编号
	
	//获得组件参数	
	String sCompID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CompID"));
	if(sCompID==null) sCompID="";

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
				"CompType,"+
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
				"From REG_COMP_DEF Where CompID = '"+sCompID+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="REG_COMP_DEF";
	doTemp.setKey("CompID",true);
	doTemp.setHeader(sHeaders);

	//设置下拉框来源
	doTemp.setDDDWCode("CompType","ComponentType");	
	doTemp.setDDDWSql("AppID","select AppID,AppID ||'--'|| AppName from REG_APP_DEF");

	doTemp.setUnit("OrderNo","<input type=button class=inputDate value=\"..\" onClick=\"parent.setSortNo()\"> ");
	doTemp.setRequired("CompID,CompName,OrderNo",true);
	doTemp.setHTMLStyle("CompPath,CompURL"," style={width:600px} ");
	doTemp.setHTMLStyle("DefaultPage,RightID"," style={width:200px} ");
	doTemp.setEditStyle("REMARK","3");
	doTemp.setHTMLStyle("REMARK"," style={height:100px;width:600px;overflow:auto} ");
 	doTemp.setLimit("REMARK",120);
	doTemp.setReadOnly("IINPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME,INPUTTIME,UPDATETIME",true);
 
	doTemp.setVisible("INPUTUSER,INPUTORG,UPDATEUSER",false);    	
	doTemp.setUpdateable("INPUTUSERNAME,INPUTORGNAME,UPDATEUSERNAME",false);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
   
    	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);

			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//dwTemp.harbor.getDock(0).setAttribute("DefaultColspan","3");

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCompID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	

	String sCriteriaAreaHTML = ""; 
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
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
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
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(){
		var sOrderNo=getItemValue(0,0,"OrderNo");
		if(sOrderNo.length!=2 && sOrderNo.length!=6 && sOrderNo.length!=10 && sOrderNo.length!=14 && sOrderNo.length!=18){
			alert("非法的排序号长度："+sOrderNo.length+"\n\n排序号长度仅允许：\n2位\n6位\n10位\n14位\n18位");
			return;
		}
		if(sOrderNo.indexOf("0")==0){
			alert("组件排序号请不要以“0”开始！");
			return;
		}
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","reloadCache()");
	}
    
    function reloadCache(){
    	if(confirm("您已对组件注册信息进行了修改，现在刷新组件定义缓存吗？")){
    		AsDebug.reloadCache("ASCompSet");
    	}
    }
    
	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"INPUTTIME","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
		        bIsInsert = true;
		}
	}
	
	function setSortNo(){
		var sCurCompID = getItemValue(0,0,"CompID");
		var sReturn="";
		sReturn = popComp("SelectComp","/Common/Configurator/CompManage/CompSelectTree.jsp","","");
		if(typeof(sReturn)=="undefined" || sReturn=="") return;
		var sReturns = sReturn.split("@");
		var sTargetCompID = sReturns[0];
		var sTargetCompName = sReturns[1];
		var sTargetOrderNo = sReturns[2];
		var sInjectionType = PopPage("/Common/Configurator/CompManage/SelectInjectionTypeDialog.jsp","","dialogwidth:200px;dialogheight:150px");
		if(typeof(sInjectionType)=="undefined" || sInjectionType=="") return;
		sReturn  = PopPage("/Common/Configurator/CompManage/InjectOrderNo.jsp?CurCompID="+sCurCompID+"&TargetCompID="+sTargetCompID+"&TargetOrderNo="+sTargetOrderNo+"&InjectionType="+sInjectionType,"","dialogwidth:400px;dialogheight:300px");
		if(typeof(sReturn)!="undefined" && sReturn!="failed"){
			setItemValue(0,0,"OrderNo",sReturn);
		}
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
