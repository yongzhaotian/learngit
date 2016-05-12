<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: DW模板列表页面
		author: yzheng
		date: 2013-6-6
	 */
	String PG_TITLE = "DW模板列表页面";
	//获得页面参数
	String doNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DoNo"));
	String readOnly =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReadOnly"));
	String codeNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));
	
	if(codeNo==null) codeNo="";
	if(readOnly==null) readOnly="";   //0: 只读关联模式
	if(doNo==null) doNo="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "DWTemplateList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	if(!doNo.equals("")){
		doTemp.WhereClause += " and TemplateNo = '" + doNo + "' ";  //关联到指定模板
	}
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(20);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTemplateInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var templateNo = getItemValue(0,getRow(),"TemplateNo");
		
		if (typeof(templateNo)=="undefined" || templateNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function viewAndEdit(){
		var templateNo=getItemValue(0,getRow(),"TemplateNo");
		
		if (typeof(templateNo)=="undefined" || templateNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTemplateInfo.jsp","TemplateNo="+templateNo,"_self","");
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
