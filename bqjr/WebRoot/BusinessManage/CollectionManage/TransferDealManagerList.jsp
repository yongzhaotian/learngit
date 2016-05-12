<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "资产转让协议列表页面";
	//获得页面参数
	String isSelected =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Selected"));
	if(isSelected==null) isSelected="";
	
	//首次转让或再转让判断标识
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));
	if(sTransferType==null) sTransferType="";
	
	//out.println("转让类型："+sTransferType);
	
	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject("TransferDealManagerList",Sqlca);
	doTemp.WhereClause+=" and T.TransferType='0010'";//首次转让协议或再转让协议判断条件
	
	//项目关联协议时选择协议时的判断
	if(isSelected.equals("true"))
	{
		doTemp.multiSelectionEnabled=true;
	}
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//首次转让和再次转让时，原协议流水号字段隐藏判断
	if(sTransferType.equals("0020")){
		doTemp.setVisible("RelativeSerialNo", true);//再次转让协议时显示该字段
	}else{
		doTemp.setVisible("RelativeSerialNo", false);//非再次转让协议时隐藏该字段(false不显示;true显示)
	}
	
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
		{"false","","Button","确定","确定","getAndReturnSelected()",sResourcesPath},
	};
	if(isSelected.equals("true")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="true";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~新建项目关联协议~*/
	function getAndReturnSelected(){
		var arr0 = getItemValueArray(0, "SerialNo");
		var arr1 = getItemValueArray(0,"RivalSerialNo");//对手编号
		var arr2 = getItemValueArray(0,"RivalName");//对手名称
		if(arr0.length!=1){
			 alert("必须且只能勾选一个委外资产受让方");return;
		 }
		alert(arr0[0]+"@"+arr1[0]+"@"+arr2[0]);
		if (typeof(arr0[0])=="undefined" || arr0[0].length==0 || typeof(arr1[0])=="undefined" || arr1[0].length==0 || typeof(arr2[0])=="undefined" || arr2[0].length==0){
			alert("选择的该协议信息不完整!");
			return;
		}
		self.returnValue=arr0[0]+"@"+arr1[0]+"@"+arr2[0];
		self.close();
	}
	
	/*~~[新增资产转让协议]~~*/
	function newRecord(){
		var sTransferType = "<%=sTransferType%>";//转让类型(0010首次转让;0020再次转让)
		
		//打开再次转让详情、首次转让详情判断 
		if(sTransferType=="0010")
		{
			AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo.jsp","TransferType=<%=sTransferType%>","_self","");
		}
		else if(sTransferType=="0020")
		{
			AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo2.jsp","TransferType=<%=sTransferType%>","_self","");
		}
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			as_del("myiframe0");
			//setItemValue(0,getRow(),"Status","1");
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
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealManagerInfo.jsp","SerialNo="+sSerialNo+"&RightType=ReadOnly&TransferType=<%=sTransferType%>","_self","");
	}
	
	$(document).ready(function(){
		showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>