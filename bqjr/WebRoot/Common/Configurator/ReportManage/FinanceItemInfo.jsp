<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    财务科目详情
		Input Param:
                    ItemNo：    报表记录编号
	 */
	String PG_TITLE = "财务科目详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	
	//获得组件参数	
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
	if(sItemNo==null) sItemNo="";

	String sTempletNo = "FinanceItemInfo"; //模版编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sItemNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","保存并返回","保存修改并返回","saveRecordAndBack()",sResourcesPath},
		{"true","","Button","保存并新增","保存修改并新增另一条记录","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //标记DW是否处于“新增状态”

	function saveRecordAndBack(){
		if(beforeSave() == false && bIsInsert){
			alert("该科目编号已经被占用,请输入新的编号");
			return;
		}
		
		bIsInsert = false;	
        as_save("myiframe0","doReturn('Y');");
	}

	function saveRecordAndAdd(){
		if(beforeSave() == false && bIsInsert){
			alert("该科目编号已经被占用,请输入新的编号");
			return;
		}
		bIsInsert = false;	
		
        as_save("myiframe0","newRecord()");
	}
    
	/*~[Describe=检验插入数据唯一性;InputParam=;OutPutParam=是否有记录;]~*/
    function beforeSave()
    {
    	var itemNo  = getItemValue(0,getRow(),"ItemNo");
		var sPara = "ItemNo=" + itemNo;
		var hasRecord =  RunJavaMethodSqlca("com.amarsoft.app.als.finance.report.ItemNoUniqueCheck","insertUniqueCheck",sPara);
		if (hasRecord == "true"){
			return false;
		}
    }
	
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ItemNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function newRecord(){
        OpenComp("FinanceItemInfo","/Common/Configurator/ReportManage/FinanceItemInfo.jsp","","_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
		    bIsInsert = true;
		}
		else{
			setItemReadOnly(0,0,"ItemNo",true);
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>