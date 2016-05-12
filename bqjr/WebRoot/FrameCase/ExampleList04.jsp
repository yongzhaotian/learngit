<%@ page contentType="text/html; charset=GBK"%>
<div>
	<pre>
	
	单击选中列表一条记录，会触发函数mySelectRow()
	function mySelectRow(){
		viewAndEdit();//选中某记录自动展现详情
    	}
    </pre>
</div>
<%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: DW单击事件示例页面
	 */
	String PG_TITLE = "DW单击事件示例页面";

	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ExampleList"; //模版编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);
 
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function viewAndEdit(){
		var sExampleId=getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId="+sExampleId+"&PrevUrl=/FrameCase/ExampleList04.jsp","_self","");
	}

	<%/*选中列表一条记录，会触发函数mySelectRow()*/%>
	function mySelectRow(){
		viewAndEdit();//选中某记录自动展现详情
    }

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>