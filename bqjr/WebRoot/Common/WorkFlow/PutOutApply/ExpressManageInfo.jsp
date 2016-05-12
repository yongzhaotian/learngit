<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "查看/修改详情";

	// 获得页面参数
	String serialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("serialNo"));
	if(serialNo==null) serialNo="";
	
	// 通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ExpressManageInfo";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(serialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","保存","保存所有修改","saveAndGoBack()",sResourcesPath},
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath}
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	
	/*~[Describe=保存所有修改;InputParam=sPostEvents;OutPutParam=无;]~*/
	function saveRecord(sPostEvents){
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=保存所有修改;InputParam=无;OutPutParam=无;]~*/
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack(){
		top.close();
	}

	/*~[Describe=页面初始化;InputParam=无;OutPutParam=无;]~*/
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		//bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
	});
	
</script>
<%@ include file="/IncludeEnd.jsp"%>
