<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    决策流模型详情
		Input Param:
                    ModelNo：    模板编号
                    GroupNo：   组编号
                    ConditionNo：条件编号
                    Status：状态
	 */
	String PG_TITLE = "决策流模型详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	String sGroupNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupNo"));
	String sConditionNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ConditionNo"));
	String sStatus =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Status"));
	if(sModelNo==null) sModelNo="";
	if(sGroupNo==null) sGroupNo="";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ClassifyModelInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	

	if (sModelNo.equals("")){
		//必输项
	   	doTemp.setRequired("ModelNo",true);
	}else{
		//只读项
		doTemp.setReadOnly("ModelNo",true);
	}

 	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo+","+sGroupNo+","+sConditionNo+","+sStatus);
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
        OpenComp("ClassifyModelInfo","/Common/Configurator/ClassifyManage/ClassifyModelInfo.jsp","ModelNo="+sModelNo,"_self","");
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