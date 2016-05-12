<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 流程模型列表
	 */
	String PG_TITLE = "流程模型列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	 
	String sTempletNo = "FlowCatalogList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelFlowModel(#FlowNo)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","流程模型列表","查看/修改流程模型列表","viewAndEdit2()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","业务流程信息","查看所选流程的业务信息","viewInfo()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","","_self","");
	}
	
    /*~[Describe=查看及修改详情;]~*/
	function viewAndEdit(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       //openObject("FlowCatalogView",sFlowNo,"001");
       popComp("FlowCatalogView","/Common/Configurator/FlowManage/FlowCatalogView.jsp","ObjectNo="+sFlowNo+"&ItemID=0010","");
	}
    
    /*~[Describe=查看及修改详情;]~*/
	function viewAndEdit2(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
       //popComp("FlowModelList","/Common/Configurator/FlowManage/FlowModelList.jsp","FlowNo="+sFlowNo,"");
       popComp("FlowCatalogView","/Common/Configurator/FlowManage/FlowCatalogView.jsp","ObjectNo="+sFlowNo+"&ItemID=0020","");
	}

	function deleteRecord(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('49'))){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	
	 /*~[Describe=查看所选流程的业务详情;]~*/
	function viewInfo(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		var sFlowType = "";		
		if(sFlowNo == "CreditFlow")//授信申请审批流程
        	sFlowType = "01";
       if(sFlowNo == "ApproveFlow")//最终审批意见审批流程
        	sFlowType = "02";
       if(sFlowNo == "PutOutFlow")//业务出帐审批流程
        	sFlowType = "03";
       popComp("FlowFindList","/SystemManage/GeneralSetup/FlowFindList.jsp","FlowType="+sFlowType,"");
	}
	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>