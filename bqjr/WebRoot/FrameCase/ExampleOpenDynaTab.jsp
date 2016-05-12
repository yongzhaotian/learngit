<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "以标签页形式打开示例";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ExampleList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","openRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function openRecord(sExampleID){
		var sParas = "";
		if(sExampleID) sParas = "ExampleId="+sExampleID;
		
		if(typeof parent.addTabItem == "function"){
			var text;
			if(sExampleID) text = "详情【"+sExampleID+"】";
			else text = "新增";
			parent.addTabItem(text, "/FrameCase/ExampleInfo.jsp", sParas);
		}else{
			AsControl.OpenView("/FrameCase/ExampleInfo.jsp", sParas, "_self","");
		}
	}
	
	function viewAndEdit(){
		var sExampleID = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleID)=="undefined" || sExampleID.length==0){
			alert("请选择一条记录！");
			return;
		}
		openRecord(sExampleID);
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>