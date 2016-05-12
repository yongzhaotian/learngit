<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    评估模型详情
	 */
	String PG_TITLE = "评估模型详情";
	
	//获得组件参数 ModelNo：报表记录编号		ItemNo：阶段编号	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
    if(sModelNo==null) sModelNo="";
	if(sItemNo==null) sItemNo="";

	String sTempletNo = "EvaluateModelInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	//filter过滤条件
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo+","+sItemNo);
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
		OpenComp("EvaluateModelInfo","/Common/Configurator/EvaluateManage/EvaluateModelInfo.jsp","ModelNo="+sModelNo,"_self","");
	}

	function SelectCode(sType){
		if(sType == "ALL"){
			setObjectValue("SelectAllCode","","@ValueCode@1",0,0,"");			
		}
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
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