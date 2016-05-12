<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/* 页面说明: 示例详情页面 */
	String PG_TITLE = "查看审核提醒";

	// 获得页面参数
	//合同编号
	String serialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("serialNo"));
	//模板编号
	String sTempletNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("sTempletNo"));
	if(serialNo==null) serialNo="";
	if(sTempletNo==null) sTempletNo = "";
	
	// 通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      // 设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; // 设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(serialNo);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = true;
		my_load(2,0,'myiframe0');
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>
