<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
		/*
		Content:    类及方法目录详情
		Input Param:
                    ClassName：    类名称
	 */
	String PG_TITLE = "类及方法目录详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String sDiaLogTitle;
	
	//获得组件参数	
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassName"));
	String sClassDescribe =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassDescribe"));
	if(sClassName==null){
		sClassName="";
		sDiaLogTitle = "【 类新增 】";
	}else{
		sDiaLogTitle = "【"+sClassDescribe+"】类名：『"+sClassName+"』查看修改配置";	
	}
 
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ClassCatalogInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
 	if (sClassName != "")	doTemp.setReadOnly("ClassName",true);
 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sClassName);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    var sCurClassName=""; //记录当前所选择行的代码号

	function saveRecord(){
		if(!checkName()){
			alert("所输入的类名已被使用！");
			return;
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0","");
	}
	
	function saveRecordAndBack(){
		if(!checkName()){
			alert("所输入的类名已被使用！");
			return;
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
       setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
       setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
       as_save("myiframe0","doReturn('Y');");
	}

	function saveRecordAndAdd(){
		if(!checkName()){
			alert("所输入的类名已被使用！");
			return;
		}
       setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
       setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
       setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
       as_save("myiframe0","newRecord()");
	}

	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ClassName");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
	
	function checkName(){
		sClassName = getItemValue(0,getRow(),"ClassName");
		sReturn=RunMethod("PublicMethod","GetColValue","ClassName,CLASS_CATALOG,String@ClassName@"+sClassName);
		if(typeof(sReturn) != "undefined" && sReturn != ""){
			return false;
		}
		return true;
	}
	function newRecord(){
		OpenComp("ClassCatalogInfo","/Common/Configurator/ClassManage/ClassCatalogInfo.jsp","","_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		    
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
 	setDialogTitle("<%=sDiaLogTitle%>");   
</script>	
<%@ include file="/IncludeEnd.jsp"%>