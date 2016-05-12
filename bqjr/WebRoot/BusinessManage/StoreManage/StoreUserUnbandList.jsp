<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例多选列表页面--
	 */
	String PG_TITLE = "销售代表门店解绑";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "UnbandStoreSalesmanList";	//StoreSalesmanList
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.multiSelectionEnabled=true;//设置可多选
	
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
		{"false","","Button","获得高亮行","获得高亮行","alert(	getRow(0))","","","",""},
		{"false","","Button","获得勾选的行","获得勾选中行","getChecked()","","","",""},
		{"true","","Button","解绑门店","解绑门店","deleteRecord()",sResourcesPath},
		{"true","","Button","返回","返回门店管理主页面","getBack()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function getBack() {
		
		AsControl.OpenView("/BusinessManage/StoreManage/StoreList.jsp","","_self","");
	}

	function getChecked(){
		 var arr = getCheckedRows(0);
		 if(arr.length < 1){
			 alert("您没有勾选任何行！");
		 }else{
			 alert(arr);
		 }
	}
	
	function deleteRecord(){
		var sSNos = getItemValueArray(0,"SERIALNO");//获取选中的多条记录ID			
		if (typeof(sSNos)=="undefined" || sSNos.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		var idstring = sSNos.toString();
		var re =/,/g; 
		idstring = idstring.replace(re,"@");	
		if(confirm("您真的想解绑所选门店吗？")){
			var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.billions.StoreManagerRelativeCommon","unbindStores","serialNos="+idstring+",userid=<%=CurUser.getUserID()%>,orgid=<%=CurOrg.orgID%>");
			if(sReturn=="SUCCESS"){
				alert("解绑成功!");
				reloadSelf();
			}	
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		showFilterArea();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>