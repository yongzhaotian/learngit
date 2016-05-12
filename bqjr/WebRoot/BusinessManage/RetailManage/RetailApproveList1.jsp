<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "零售商准入申请";
	//获得页面参数
	String sType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type"));
	if(sType==null) sType="";
	System.out.println("----------------------"+sType);
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "RetailApplyModel2";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
  
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow	dw
	Vector vTemp = dwTemp.genHTMLDataWindow(sType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、快捷键	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","协议审核","协议审核","PrimaryApprove()","","","","btn_icon_detail",""},
			{"true","All","Button","导出","导出","exportRetailInfo()","","","","btn_icon_delete",""},
			{"true","All","Button","导入","导入","importRetailInfo()","","","","btn_icon_delete",""},
			{"true","All","Button","撤销","撤销","UndoRetailInfo()","","","","btn_icon_delete",""},
			{"true","","Button","详情","详情","ViewDetail()","","","","btn_icon_detail",""},
		
		};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function exportRetailInfo(){
		amarExport("myiframe0");
	}
	
	//-- add by 添加详情功能 tangyb 20151223 --//
	function ViewDetail(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sRegCode=getItemValue(0,getRow(),"REGCODE");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/RetailManage/RetailInfoDetail.jsp","SerialNo="+sSerialNo+"&RegCode="+sRegCode+"&PhaseType=<%=sType%>","_blank");
	
	}
	//-- end --//
	
	function importRetailInfo(){
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0) {
			// 导入Excel文 alert("请选择文件！");
			return;
		}
		
		var retal=RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "dataImportSafApproveRetail", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		var sReturn = "";
		var sReturnNo = "";
		if(retal!=null||retal!=""){
			sReturn = retal.split("@")[0];
			sReturnNo = retal.split("@")[1];
		}
		if(sReturn=="error"){
			alert("导入失败！");
			return;
		}
		
		var rt = RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectRnoIsBuild", "AllSerialNo="+sReturnNo);
		
		if(rt == "S"){
			alert("导入成功！");
		}else{
			alert("导入失败！");
		}
		
		reloadSelf();
	}
	
	//-- add by 添加撤销功能 tangyb 20151223 --//
	function UndoRetailInfo(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		var sAgreementApproveStatus = RunMethod("公用方法", "GetColValue", "Retail_info,AgreementApproveStatus,serialno='"+sSerialNo+"'");
	    var sSafDepApproveStatus = RunMethod("公用方法", "GetColValue", "Retail_info,SafDepApproveStatus,serialno='"+sSerialNo+"'");
	    if((sAgreementApproveStatus=="1" || sSafDepApproveStatus=="2")||(sAgreementApproveStatus=="2" || sSafDepApproveStatus=="1")){
	    	alert("安全部或合作协议已审批，不能撤销！");
	    }else if(sAgreementApproveStatus=="4" &&sSafDepApproveStatus=="4"){
	    	RunMethod("PublicMethod","UpdateColValue","String@PrimaryApproveStatus@4@String@PrimaryApproveTime@None,retail_info,String@serialno@"+sSerialNo);
	    	RunJavaMethodSqlca("com.amarsoft.app.billions.UpdateRetailRno", "selectRnoIsBuild", "SerialNo="+sSerialNo);
	    	alert("撤销成功");
	    }
	    reloadSelf();
	}
	//-- end --//

	function PrimaryApprove(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sRegCode = getItemValue(0,getRow(),"REGCODE");
	    var sAgreementApproveStatus = getItemValue(0,getRow(),"AgreementApproveStatus");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		if(sAgreementApproveStatus=="1" ){
			alert("该商户已审核，不能再审！");
			return;
		}
		AsControl.OpenView("/BusinessManage/RetailManage/RetailInfoDetail1.jsp","SerialNo="+sSerialNo+"&RegCode="+sRegCode,"_blank");
		
		reloadSelf();
	}
	
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
