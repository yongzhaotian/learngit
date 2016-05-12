<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		--页面说明: 示例列表页面--
	 */
	String PG_TITLE = "示例列表页面";
	//获得页面参数
	String sObjectNO =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNO"));
	String sTemp =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	if(sTemp==null) sTemp="";
	if(sObjectNO==null) sObjectNO="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "DELEGATECOMPANYCITY";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(10);

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectNO);//传入参数,逗号分割
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"false","","Button","确定","确定","queDing()",sResourcesPath},
	};
	if(sTemp.equals("002")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="true";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sObjectNO = <%=sObjectNO%>;
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCompanyCityInfo.jsp","ObjectNO="+sObjectNO,"_self","");
	}
	
	function deleteRecord(){
		var sExampleId = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCompanyCityInfo.jsp","SerialNO="+sSerialNo+"&ObjectNO=<%=sObjectNO%>","_self","");
	}
	
	<%/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/%>
	function queDing(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		var sCompanyName = getItemValue(0,getRow(),"CUSTOMERNAME");
		var sCityNo = getItemValue(0,getRow(),"CITYNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		RunMethod("ModifyNumber","GetModifyNumber","CONSUME_COLLECTION_INFO,PROVIDERSERIALNO='"+sCompanyName+"',SERIALNO='<%=sSerialNo%>'");
		RunMethod("ModifyNumber","GetModifyNumber","CONSUME_COLLECTION_INFO,PROVIDERAREA='"+sCityNo+"',SERIALNO='<%=sSerialNo%>'");
		alert("修改成功！");
		window.close();
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
