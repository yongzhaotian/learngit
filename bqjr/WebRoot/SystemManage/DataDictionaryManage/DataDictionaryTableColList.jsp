<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 表字段列表页面
		author:yzheng
		date:2013-6-8
	 */
	String PG_TITLE = "表字段列表页面";
	//获得页面参数
	String tableNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TableNo"));
	String colName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ColName"));
	String readOnly =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReadOnly"));
	String codeNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));
	
	if(codeNo==null) codeNo="";
	if(readOnly==null) readOnly="";   //0: 只读关联模式
	if(colName==null) colName="";
	if(tableNo==null) tableNo="";
	//变量定义
	String viewType = "";  // 1:由表查询字段   2: 直接查询字段
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "TableColList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	if(!tableNo.equals("")){  //由表查询字段
		doTemp.WhereClause += "where TABLECOL_INFO.TableNo='" + tableNo + "' and DWTEMPLATE_INFO.TemplateNo=TABLECOL_INFO.UsageInfo";
		viewType = "1";
	}
	else{  //直接查询字段
		doTemp.WhereClause += "where DWTEMPLATE_INFO.TemplateNo=TABLECOL_INFO.UsageInfo";
		if(!colName.equals("")){
			doTemp.WhereClause += " and TABLECOL_INFO.ColName = '" + colName + "' ";
		}
		viewType = "2";
	}
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(tableNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{readOnly.equals("0") ? "false" : "true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{readOnly.equals("0") ? "false" : "true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{readOnly.equals("0") ? "false" : "true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{readOnly.equals("0") ? "true" : "false","","Button","返回","返回","goBack()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTableColInfo.jsp","TableNo=<%=tableNo%>","_self","");
	}
	
	function deleteRecord(){
		var tableNo = getItemValue(0,getRow(),"TableNo");
		if (typeof(tableNo)=="undefined" || tableNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function viewAndEdit(){
		var tableNo=getItemValue(0,getRow(),"TableNo");
		var colName=getItemValue(0,getRow(),"ColName");
		if (typeof(tableNo)=="undefined" || tableNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTableColInfo.jsp","TableNo="+tableNo + "&ColName=" + colName + "&ViewType=<%=viewType%>","_self","");
	}
	
	function goBack(){
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryCodeUsageDetailList.jsp","CodeNo=<%=codeNo%>","_self");
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
