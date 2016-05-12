<%@ page contentType="text/html; charset=GBK"%>
<%@
 include file="/IncludeBegin.jsp"%><%

	String PG_TITLE = "资产转让协议列表页面";
    String PG_CONTENT_TITLE = "&nbsp;&nbsp;资产转让筛选&nbsp;&nbsp;";
 %>
 <% 
	//首次转让或再转让判断标识
	String sTransferType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TransferType"));
	if(sTransferType==null) sTransferType="";
	
	String sApplyType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType"));
	if(sApplyType==null) sApplyType="";
	
	String sTempleteNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TempleteNo"));
	if(sTempleteNo==null) sTempleteNo="";
	
	//通过DW模型产生ASDataObject对象doTemp
	ASDataObject doTemp = new ASDataObject(sTempleteNo,Sqlca);
	
	doTemp.WhereClause+=" and T.applyType='"+sApplyType+"'";
	
	if("0010".equals(sTransferType)){
		doTemp.WhereClause+= " and T.DealStatus='01'";
	}
	if("0020".equals(sTransferType)){
		doTemp.WhereClause+= " and T.DealStatus='02'";
	}
	
	if("0030".equals(sTransferType)){
		doTemp.WhereClause+= " and T.DealStatus='03'";
	}
	
	if("0040".equals(sTransferType)){
		doTemp.WhereClause+= " and T.DealStatus='04'";
	}
	
	if("0050".equals(sTransferType)){
		doTemp.WhereClause+= " and T.DealStatus='05'";
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
		{"true","","Button","新增资产包","新增资产包","newRecord()",sResourcesPath},
		{"true","","Button","资产包详情","查看资产包详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除资产转让协议","deleteRecord()",sResourcesPath},
		{"true","","Button","完成筛选","资产完成筛选","finishedRecord()",sResourcesPath},
		{"true","","Button","重新筛选","重新筛选资产","restartRecord()",sResourcesPath},
	};
	
	if("0010".equals(sTransferType)){
		sButtons[4][0]="false";
	}
	
	if("0020".equals(sTransferType)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
	}
	
	if("0030".equals(sTransferType)||"0040".equals(sTransferType)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
		sButtons[4][0]="false";
	}
	if("0050".equals(sTransferType)){
		sButtons[0][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="false";
		sButtons[4][0]="false";
	}

%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	
	/*~~[新增资产转让协议]~~*/
	function newRecord(){
		var array = setObjectValue("SelectDealInfo","","",0,0,"");
		if(typeof(array)=="undefined"||array.length==0||array==null){
			return;
		}
		var serialNo = array.split("@")[0];
		
		if(serialNo=="_CLEAR_"){
			return;
		}
		//如果是框架协议，一笔协议能进行多次资产转让，反之则不能
		var sReturn = RunMethod("公用方法","GetColValue","Transfer_Group,count(*),RelativeSerialNo='"+serialNo+"' and IsFlag='2'");
		
		if(typeof(sReturn)!="undefined"&&parseInt(sReturn)>0){
			alert("非框架协议,不能重复新增资产包");
			return;
		}
		
		var applyType = "<%=sApplyType%>";
		var userID = "<%=CurUser.getUserID()%>";
		//var sReturnSerialNo = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AddProperTySelectInfo","initDealInfo","ObjectType="+applyType+",ObjectNo="+serialNo+",UserID="+userID);
		//if(typeof(sReturnSerialNo)=="undefined"||sReturnSerialNo==""||sReturnSerialNo==null){
		//	alert("资产筛选登记协议失败");
		//	return;
		//}
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealSelectTab.jsp","SSerialNo="+serialNo+"&TransferType="+"<%=sTransferType%>"+"&AdpplyType="+applyType,"_blank","");
		reloadSelf();
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			var sReturn = RunJavaMethodSqlca("com.amarsoft.app.lending.bizlets.AddProperTySelectInfo","delSelPropertyInfo","ObjectNo="+sSerialNo);
			if(sReturn=="Success"){
				as_del("myiframe0");
				as_save("myiframe0");  //如果单个删除，则要调用此语句
			}
		}
		reloadSelf();
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sRelativeSerialNo = getItemValue(0,getRow(),"RelativeSerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/CollectionManage/TransferDealSelectTab.jsp","SSerialNo="+sRelativeSerialNo+"&ApplySerialNo="+sSerialNo+"&TransferType="+"<%=sTransferType%>","_blank","");
		
		
	}
	
	function finishedRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var sCount = RunMethod("公用方法","GetColValue","dealcontract_reative,count(*),SerialNo='"+sSerialNo+"'");
		if(typeof(sCount)!="undefined"&&parseInt(sCount)==0.0){
			alert("请导入合同信息");
			return ;
		}
		var sReturn = RunMethod("PublicMethod","UpdateColValue","String@DealStatus@02,transfer_group,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("筛选失败");//登记失败！
			return;
		}else
		{
			reloadSelf();
			alert("完成筛选");//完成登记！
		}
	}
	
	function restartRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		sReturn = RunMethod("PublicMethod","UpdateColValue","String@DealStatus@01,transfer_group,String@SerialNo@"+sSerialNo);
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) {					
			alert("重新筛选失败");//登记失败！
			return;
		}else
		{
			reloadSelf();
			alert("重新筛选成功");//完成登记！
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