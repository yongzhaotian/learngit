<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 代码列表页面
		author:yzheng
		date:2013-6-8
	 */
	String PG_TITLE = "代码列表页面";
	//获得页面参数
// 	String codeType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeType"));
// 	if(codeType==null) codeType="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CodeList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(25);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
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
	
	function mySelectRow(){
		var codeNo = getItemValue(0,getRow(),"CodeNo");
		if(typeof(codeNo)=="undefined" || codeNo.length==0) {
		}
		else{
			AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryCodeUsageDetailList.jsp","CodeNo="+codeNo,"rightdown"); 
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		mySelectRow();
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
