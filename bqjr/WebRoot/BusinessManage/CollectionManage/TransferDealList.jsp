<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "资产转让协议列表页面";
	//获得页面参数
	String isSelected =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Selected"));
	if(isSelected==null) isSelected="";
	
	//首次转让或再转让判断标识
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));
	if(sTransferType==null) sTransferType="";
	
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	if(sApplyType==null) sApplyType="";
	
	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("TransferDealConfigList",Sqlca);
	
	doTemp.WhereClause+=" and T.applyType='"+sApplyType+"'";
	
	if("0010".equals(sTransferType)){
		doTemp.WhereClause+=" and T.DealStatus='01'";//筛选条件
	}
	
	if("0020".equals(sTransferType)){
		doTemp.WhereClause+=" and T.DealStatus='02'";//筛选条件
	}
	
	if("0030".equals(sTransferType)){
		doTemp.WhereClause+=" and T.DealStatus='03'";//筛选条件
	}
	
	//项目关联协议时选择协议时的判断
	if(isSelected.equals("true"))
	{
		doTemp.multiSelectionEnabled=true;
	}
	
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
		{"true","","Button","新增协议信息","新增资产转让协议","newRecord()",sResourcesPath},
		{"true","","Button","协议详情","查看资产转让协议详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除资产转让协议","deleteRecord()",sResourcesPath},
		{"true","","Button","协议生效","资产协议生效","finishedRecord()",sResourcesPath},
		{"true","","Button","协议终止","资产协议终止","endOfDeal()",sResourcesPath},
		{"true","","Button","重新登记协议","重新登记协议","RestartRecord()",sResourcesPath},
	};
	
	if("0010".equals(sTransferType)){
		sButtons[4][0]="false";
		sButtons[5][0]="false";
	}
	
	if("0020".equals(sTransferType)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
	}
	
	if("0030".equals(sTransferType)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
		sButtons[4][0]="false";
		sButtons[5][0]="false";
	}

%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	
	/*~~[新增资产转让协议]~~*/
	function newRecord(){
		var sTransferType = "<%=sTransferType%>";
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo.jsp","TransferType=<%=sTransferType%>"+"&ApplyType="+"<%=sApplyType%>","_self","");
		
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		var sReturn = RunMethod("公用方法","GetColValue","Transfer_group,count(*),RelativeSerialNo='"+sSerialNo+"'");
		if(typeof(sReturn)!="undefined"&&parseInt(sReturn)>0){
			alert("此协议已存在新增资产包，不允许删除！");
			return;
		}
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
		reloadSelf();
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo.jsp","SerialNo="+sSerialNo+"&TransferType=<%=sTransferType%>","_self","");
		
		
	}
	
	function RestartRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		sReturn = RunMethod("PublicMethod","UpdateColValue","String@DealStatus@01,transfer_deal,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("重新登记协议失败");//登记失败！
			return;
		}else
		{
			reloadSelf();
			alert("重新登记协议成功");//重新登记成功！
		}

	}
	
	function finishedRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		sReturn = RunMethod("PublicMethod","UpdateColValue","String@DealStatus@02,transfer_deal,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("协议生效失败");//登记失败！
			return;
		}else
		{
			reloadSelf();
			alert("协议生效成功");//完成登记！
		}
	}
	function endOfDeal(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		if(!confirm("您真的想终止该协议吗？")){
			return;
		}
		sReturn = RunMethod("PublicMethod","UpdateColValue","String@DealStatus@03,transfer_deal,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("协议终止失败");
			return;
		}else
		{
			reloadSelf();
			alert("协议终止成功");
		}
	}
	
	$(document).ready(function(){
		hideFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>