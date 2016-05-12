<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例多选列表页面--
	 */
	 
	String sProjectSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProjectSerialNo"));//项目编号
	if(sProjectSerialNo==null) sProjectSerialNo="";
	out.println("项目编号:"+sProjectSerialNo);

	
	String PG_TITLE = "示例多选列表页面";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AssetsBusinessContractList";
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
		{"true","","Button","确定","获得高亮行","getAndReturnSelected()","","","",""},
		//{"true","","Button","获得勾选的行","获得勾选中行","getChecked()","","","",""},
		//{"true","","Button","删除勾选","删除勾选中的记录","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~~关联项目项下合同编号~~*/
	function getAndReturnSelected(){
		var sContractSerialNo = getItemValueArray(0,"SERIALNO");
		if(sContractSerialNo.length<1){
			if(!confirm("确定不选择合同并关闭该合同列表界面吗？")){
				return;
			}
		}
		
		if(sContractSerialNo.length>1){
			alert("一次只能选择一个合同!");
			return;
		}
		self.returnValue=sContractSerialNo;
		self.close();
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