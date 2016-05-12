<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    财务报表目录信息详情
		Input Param:
                    ModelNo：    报表记录编号
	 */
	String PG_TITLE = "财务报表目录信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	
	String sModelNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo"));
	if(sModelNo==null) sModelNo="";

	String sTempletNo = "ReportCatalogInfo"; //模版编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sModelNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},
		{"false","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
	};

%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	function saveRecord()
	{
		if(beforeSave() == false && bIsInsert){
			alert("该报表编号已经被占用,请输入新的编号");
			return;
		}
		bIsInsert = false;	
		as_save("myiframe0","");
		setItemReadOnly(0,0,"MODELNO",true);
	}
	
	/*~[Describe=检验插入数据唯一性;InputParam=;OutPutParam=是否有记录;]~*/
    function beforeSave()
    {
    	var modelNo  = getItemValue(0,getRow(),"MODELNO");
		var sPara = "ModelNo=" + modelNo;
		var hasRecord =  RunJavaMethodSqlca("com.amarsoft.app.als.finance.report.ModelNoUniqueCheck","insertUniqueCheck",sPara);
		if (hasRecord == "true"){
			return false;
		}
    }

	function saveRecordAndBack(){
		as_save("myiframe0","doReturn('N');");        
	}

	function saveRecordAndAdd(){
		as_save("myiframe0","newRecord()");     
	}
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"MODELNO");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function newRecord(){
		OpenComp("ReportCatalogInfo","/Common/Configurator/ReportManage/ReportCatalogInfo.jsp","","_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			bIsInsert = true;
		}
		else{
			setItemReadOnly(0,0,"MODELNO",true);
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>