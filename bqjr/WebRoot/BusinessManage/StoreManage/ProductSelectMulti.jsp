<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例多选列表页面--
	 */
	String PG_TITLE = "示例多选列表页面";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ProductTypes";
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
		{"false","","Button","删除勾选","删除勾选中的记录","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	function test(){
		var sReturnValue = "";
		try{
			var b = getRowCount(0);
			sReturnValue = "";
			for(var iMSR = 0 ; iMSR < b ; iMSR++){
				var a = getItemValue(0,iMSR,"MultiSelectionFlag");				
				if(a == "√"){
					sReturnValue = sReturnValue+getItemValue(0,iMSR,"productID")+"@";
				}
			}
		}catch(e){
			return;
		}
		//alert(sReturnValue);
		return sReturnValue;
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
		var sExampleIds = getItemValueArray(0,"ExampleId");//获取选中的多条记录ID			
		if (typeof(sExampleIds)=="undefined" || sExampleIds.length==0){
			alert("请至少选择一条记录！");
			return;
		}
		var idstring = sExampleIds.toString();
		var re =/,/g; 
		idstring = idstring.replace(re,"@");	
		if(confirm("您真的想删除该信息吗？")){
			var sReturn = AsControl.RunJavaMethodSqlca("com.amarsoft.app.awe.framecase.Example4RJM","deleteExampleByIds","ExampleId="+idstring);
			if(sReturn=="SUCCESS"){
				alert("删除成功!");
				reloadSelf();
			}	
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>