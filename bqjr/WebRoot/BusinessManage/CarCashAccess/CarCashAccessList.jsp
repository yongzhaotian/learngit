<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "车主现金贷准入客户列表";
 
 	String path = request.getContextPath(); 
	//获取项目路径，提供下载使用
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/"; 

	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ResCashAccessList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","模板下载","excel模板下载","getExcelMould()",sResourcesPath},
		{"true","","Button","excel导入","excel导入","importData()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"false","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
	};

	if (CurUser.hasRole("1035")||CurUser.hasRole("1036")) {
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*
	 * excel模板下载
	 */
	function getExcelMould(){
		var path = "<%=basePath %>FormatDoc/Excel/";
		var file = path + "customer.xls";

		var left = (window.screen.availWidth-600)/2;
    	var top = (window.screen.availHeight-400)/2;
    	var features ='left='+left+',top='+top+',width=600,height=400';
    	var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll=no;status=no,menubar=no,'+features;
    	
    	window.open(file,'searchWin',style);
    	
    	//-- 以下方法都不行，一直提示找不到 --//
    	//var src = "/AppConfig/ControlCenter/LogManage/FileView.jsp";

    	//AsControl.OpenView(src, "file="+file+"&ViewType=view", "", style);
	}
	
	//excel导入
	function importData(){
			if(confirm("上传新名单将会删除现有全部数据，请确认！")){
				var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
				if (typeof(sFilePath)=="undefined" || sFilePath.length==0 || sFilePath == "_none_") {
					// 导入Excel文 alert("请选择文件！");
					return;
				}
				var outmsg = RunJavaMethodSqlca("com.amarsoft.app.billions.ResCashExcelImport", "dataImportResCash", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
				if(outmsg == null) {
					alert("导入失败");
				} else {
					alert(outmsg);
				}
			}
			reloadSelf();
		}
	
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
	
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		sCompID = "ResCashAccessInfo";
		sCompURL = "/BusinessManage/CarCashAccess/CarCashAccessInfo.jsp";
		sCompParam = "SerialNo="+sSerialNo; //赋值参数
		
		var left = (window.screen.availWidth-800)/2;
		var top = (window.screen.availHeight-400)/2;
		var features ='left='+left+',top='+top+',width='+800+',height='+400;
		var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll:no;status=no,menubar=no,'+features;
		
		popComp(sCompID, sCompURL, sCompParam , style);
	}
	


	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>

