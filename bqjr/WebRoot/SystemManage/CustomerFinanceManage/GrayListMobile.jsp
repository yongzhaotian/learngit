<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 手机号码灰名单列表页面
	 */
	String PG_TITLE = "手机号码灰名单列表页面";
 
	String path = request.getContextPath(); 
	//获取项目路径，提供下载使用
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "GrayListMobile";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) {
		// doTemp.WhereClause+=" and 1=2"; // 如果不输入条件时，默认不查询数据，避免大量数据查询会缓慢。
	}
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","excel导入","excel导入","importRecords()",sResourcesPath},
		{"true","","Button","excel模板下载","excel模板下载","downExcelMould()",sResourcesPath},
		{"false","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
/*
 * excel模板下载
 */
function downExcelMould() {
	var file = "<%=basePath %>/FormatDoc/Excel/graylistmobile.xls";

	var left = (window.screen.availWidth-600)/2;
	var top = (window.screen.availHeight-400)/2;
	var features ='left='+left+',top='+top+',width=600,height=400';
	var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll=no;status=no,menubar=no,'+features;
	
	window.open(file,'searchWin',style);
	
	//-- 以下方法都不行，一直提示找不到 --//
	//var src = "/AppConfig/ControlCenter/LogManage/FileView.jsp";
	//AsControl.OpenView(src, "file="+file+"&ViewType=view", "", style);
}

	function newRecord(){
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/GrayListMobileInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			RunMethod("GrayList_MODEL","delData","GrayListMobile,"+sSerialNo);
			//as_del("myiframe0");
			//as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/GrayListMobileInfo.jsp","SERIALNO="+sSerialNo,"_self","");
	}
	function importRecords(){
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0 || sFilePath=="_none_") {
			// 导入Excel文 alert("请选择文件！");
			return;
		}
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "importGrayListMobileModel", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		//处理导入了重复的数据
	    RunMethod("GrayList_MODEL","delMulti_1","GrayListMobile,PHONE");
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
	
	checkMobile = function(v){}

	$(document).ready(function(){
		AsOne.AsInit();
//		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
