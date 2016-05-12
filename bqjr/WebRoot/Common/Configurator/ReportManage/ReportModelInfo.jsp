<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    财务报表模型详情
		Input Param:
                    ModelNo：    报表记录编号
	 */
	String PG_TITLE = "财务报表模型详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	String sRowNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RowNo"));
	if(sModelNo==null) sModelNo="";
	if(sRowNo==null) sRowNo="";
	
	String sTempletNo = "ReportModelInfo"; //模版编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo+","+sRowNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存并返回","保存修改并返回","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecordAndReturn(){
		as_save("myiframe0","doReturn('Y');");
	}
    
	function saveRecordAndAdd(){
		as_save("myiframe0","newRecord()");
	}

    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ModelNo");
       parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
	function newRecord(){
		sModelNo = getItemValue(0,getRow(),"ModelNo");
		OpenComp("ReportModelInfo","/Common/Configurator/ReportManage/ReportModelInfo.jsp","ModelNo="+sModelNo,"_self","");
	}

	function myDBLClick(myobj){
		editObjectValueWithScriptEditorForAFS(myobj,'<%=sModelNo%>');
	}

	function openScriptEditorForAFSAndSetText(){
		var oMyobj = oTempObj;
		sOutPut = OpenComp("ScriptEditorForAFS","/Common/ScriptEditor/ScriptEditorForAFS.jsp","","");
		if(typeof(sOutPut)!="undefined" && sOutPut!="_CANCEL_"){
			oMyobj.value = amarsoft2Real(sOutPut);
		}
	}

	function SelectSubject(){
		setObjectValue("SelectAllSubject","","@RowSubject@0@RowSubjectName@1",0,0,"");			
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//新增记录
			if ("<%=sModelNo%>" !=""){
				setItemValue(0,0,"ModelNo","<%=sModelNo%>");
			}
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>