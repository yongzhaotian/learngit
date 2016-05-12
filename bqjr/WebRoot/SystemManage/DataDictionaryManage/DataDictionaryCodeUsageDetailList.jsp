<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 代码使用详情列表页面
		author:yzheng
		date:2013-6-13
	 */
	String PG_TITLE = "代码使用详情列表页面";
	//获得页面参数
	String codeNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo"));
	if(codeNo==null) codeNo="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CodeUsageDetailList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(codeNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
// 		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
// 		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
// 		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"true","","Button","字段详情","查看/修改详情","viewAndEditTableCol()",sResourcesPath},
			{"true","","Button","模板详情","查看/修改详情","viewAndEditTemplate()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryCodeInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var codeNo = getItemValue(0,getRow(),"CodeNo");
		if (typeof(codeNo)=="undefined" || codeNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function viewAndEdit(){
		var codeNo=getItemValue(0,getRow(),"CodeNo");
		if (typeof(codeNo)=="undefined" || codeNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryCodeInfo.jsp","CodeNo="+codeNo,"_self","");
	}
	
	function viewAndEditTableCol(){
		var codeNo=getItemValue(0,getRow(),"CodeNo");
		var colName=getItemValue(0,getRow(),"ColName");
		
		if (typeof(codeNo)=="undefined" || codeNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTableColList.jsp","ColName=" + colName + "&ReadOnly=0" + "&CodeNo="+codeNo,"_self","");
	}

	function viewAndEditTemplate(){
		var codeNo=getItemValue(0,getRow(),"CodeNo");
		var doNo=getItemValue(0,getRow(),"DoNo");
		
		if (typeof(doNo)=="undefined" || doNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTemplateList.jsp","DoNo=" + doNo + "&ReadOnly=0" + "&CodeNo="+codeNo,"_self","");
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
