<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
 
 	// 获取组件参数
 	String sAreaNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaNo"));
 	if (sAreaNo == null) sAreaNo = "";
 	String sTypeCode = "ProvinceCodeCar";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ProvinceCodeList1";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.WhereClause += " and AttrStr1='"+sAreaNo+"'";

	//doTemp.setColumnAttribute("ExampleName","IsFilter","1");
	//doTemp.generateFilters(Sqlca);
	//doTemp.parseFilterData(request,iPostChange);
	//CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"false","","Button","使用ObjectViewer打开","使用ObjectViewer打开","openWithObjectViewer()",sResourcesPath},
		};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	<%/*记录被选中时触发事件*/%>
	function mySelectRow(){
		var sProvinceNo = getItemValue(0,getRow(),"Attr1");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");
		}else{
			AsControl.OpenView("/DistributorInfo/RegionCityList1.jsp","ProvinceNo="+sProvinceNo+"&AreaNo=<%=sAreaNo%>","rightdown","");
		}
	}
	
	function newRecord(){
		var sArea = "<%=sAreaNo %>";
		if (typeof(sArea)=='undefined' || sArea.length==0) {
			alert("请选择关联区域！");
			return;
		}
		AsControl.OpenView("/DistributorInfo/RegionProvinceInfo1.jsp","TypeCode=<%=sTypeCode %>&AreaNo=<%=sAreaNo %>"+"&PrevUrl=/DistributorInfo/RegionProvinceList1.jsp","_self","");
	}
	
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/DistributorInfo/RegionProvinceInfo1.jsp","AreaNo=<%=sAreaNo %>"+"&PrevUrl=/DistributorInfo/RegionProvinceList1.jsp&SerialNo="+sSerialNo+"&ProvinceNo="+getItemValue(0, getRow(), "Attr1"),"_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			
			RunMethod("公用方法", "DelByWhereClause", "Basedataset_Info,TypeCode='CityCodeCar' and AttrStr1='"+getItemValue(0, getRow(), "Attr1")+"' and AttrStr2='"+getItemValue(0, getRow(), "AttrStr1")+"'");			
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}
	
	function init_row() {
		
		var sProvinceNo = getItemValue(0,getRow(),"Attr1");
		var sSerialNo = getItemValue(0,0,"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");
		}else{
			AsControl.OpenView("/DistributorInfo/RegionCityList1.jsp","ProvinceNo="+sProvinceNo,"rightdown","");
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		init_row();
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>