<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	String sMatchType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MatchType"));
	String sInputDate =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputDate"));
	
	if(sMatchType == null) sMatchType="";
	if(sInputDate == null) sInputDate="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "TackbackFileList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sInputDate+","+sMatchType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  详情  激活  关闭  暂时关闭  取消关闭
<<<<<<< .mine
		{"false","","Button","手工匹配","手工匹配还款","newRecord()",sResourcesPath},
		{"false","","Button","分离","分离已经手工匹配的还款","deleteRecord()",sResourcesPath},
=======
		{"false","","Button","手工匹配","查看详情","newRecord()",sResourcesPath},
>>>>>>> .r2300
	};
<<<<<<< .mine
	if ("01".equals(sMatchType)) sButtons[0][0] = "true";
	if ("03".equals(sMatchType)) sButtons[1][0] = "true";
=======
	if ("1".equals(sMatchType)) sButtons[0][0] = "true";
>>>>>>> .r2300
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	function newRecord(){
<<<<<<< .mine
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
=======
		var Serialno = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(Serialno)=="undefined" || Serialno.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/BankLinkInfo.jsp","SerialNo="+Serialno,"_self","");
>>>>>>> .r2300
	}
	
	function deleteRecord(){
		alert("分离已经手工匹配的还款！");
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/RetailManage/RetailInfoTab.jsp","RSerialNo="+sSerialNo,"_blank","");
		reloadSelf();
	}
	
	<%/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//使用ObjectViewer以视图001打开Example，
	}

	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>