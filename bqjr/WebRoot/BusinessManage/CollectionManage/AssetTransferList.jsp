<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 交易对手选择列表界面--
	 */
	String PG_TITLE = "交易对手选择列表界面";

	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("AssetTransferList",Sqlca);
	//doTemp.multiSelectionEnabled=true;//设置可多选
	//查询条件
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
		//{"true","","Button","获得高亮行","获得高亮行","alert(	getRow(0))","","","",""},
		{"true","","Button","确定","确定","getAndReturnChecked()","","","",""},
		//{"true","","Button","删除勾选","删除勾选中的记录","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function getAndReturnChecked(){
		 var arr0 = getItemValue(0,getRow(),"SERIALNO");
		 var arr1 = getItemValue(0,getRow(),"SERVICEPROVIDERSNAME");
		 if(typeof(arr0)=="undefined"||arr0==""){
			 alert("请选择一条数据");
			 return;
		 }
		 var sRec = arr0+"@"+arr1;
		 self.returnValue=sRec;
		 self.close();
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