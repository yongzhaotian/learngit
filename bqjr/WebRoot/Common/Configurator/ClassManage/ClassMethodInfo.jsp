<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    类及方法记录详情
		Input Param:
                    ClassName：    类名称
                    MethodName：   方法名称
	 */
	String PG_TITLE = "类及方法记录详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String sDiaLogTitle;
	
	//获得组件参数	
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassName"));
	String sMethodName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("MethodName"));
	String sClassDescribe =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassDescribe"));
	if(sClassName==null) sClassName="";
	if(sClassName==null) sClassName="";
	if(sMethodName==null) sMethodName="";
	if (sClassName.equals("")){
		sDiaLogTitle = "【 新类新方法新增配置 】";	
	}else{
		if(sMethodName.equals("")){
			sDiaLogTitle = "【类"+sClassDescribe+"－["+ sClassName +"]】方法新增配置";
		}else{
			sDiaLogTitle = "【类"+sClassDescribe+"－["+ sClassName +"]】的『 "+sMethodName+" 』方法查看修改配置";
		}
	}

  //通过DW模型产生ASDataObject对象doTemp
  	String sTempletNo = "ClassMethodInfo";//模型编号
  	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca); 
   	
  	if (!sClassName.equals("")) {
		doTemp.setVisible("CLASSNAME",false);    	
	   	doTemp.setRequired("CLASSNAME",false);
	}
   	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sClassName+","+sMethodName);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存并返回","保存修改并返回","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecordAndReturn(){
        setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.getUserName()%>");
        setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
        as_save("myiframe0","doReturn('Y');");
	}
    
	function saveRecordAndAdd(){
        setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.getUserName()%>");
        setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
        as_save("myiframe0","newRecord()");
	}

	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"CLASSNAME");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
	function newRecord(){
        sClassName = getItemValue(0,getRow(),"CLASSNAME");
        OpenComp("ClassMethodInfo","/Common/Configurator/ClassManage/ClassMethodInfo.jsp","ClassName="+sClassName,"_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			if ("<%=sClassName%>" !=""){
				setItemValue(0,0,"CLASSNAME","<%=sClassName%>");
			}
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

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
 	setDialogTitle("<%=sDiaLogTitle%>");   
</script>	
<%@ include file="/IncludeEnd.jsp"%>