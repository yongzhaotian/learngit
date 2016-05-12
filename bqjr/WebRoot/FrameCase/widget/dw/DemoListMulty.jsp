<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 <script>
 function setHilightRows(){
	 var iRows = prompt("输入选中行，多个用逗号分隔",getSelRows(0));
	 selectRows(0,iRows);
 }
 function getChecked(){
	 var arr = getCheckedRows(0);
	 if(arr.length < 1){
		 alert("您没有勾选任何行！");
	 }else{
		 alert(arr);
	 }
 }
 </script>
<%	
	ASObjectModel doTemp = new ASObjectModel("TestCustomerList");
doTemp.setLockCount(2);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.MultiSelect = true;//允许多选
	dwTemp.ReadOnly = "1";//编辑模式
	
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
		{"true","","Button","测试多选传值[注意后台打印信息]","测试多选传值","as_doAction(0,undefined,'test')","","","",""},
		{"true","","Button","设置选中的行","设置选中的行","setHilightRows()","","","",""},
		{"true","","Button","获得高亮行","获得高亮行","alert(	getRow(0))","","","",""},
		{"true","","Button","获得选中的行","获得选中行","alert(getSelRows(0))","","","",""},
		{"true","","Button","获得勾选的行","获得勾选中行","getChecked()","","","",""}
	};
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
