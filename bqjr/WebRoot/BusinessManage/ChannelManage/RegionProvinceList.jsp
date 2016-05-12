<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
 
 	// 获取组件参数
 	String sAreaNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaNo"));
 	String sAreaUserId =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaUserId"));
 	
 	if (sAreaNo == null) sAreaNo = "";
 	if (sAreaUserId == null) sAreaUserId = "";
 	String sTypeCode = "ProvinceCode";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ProvinceCodeList";
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
		var sProvinceManager = getItemValue(0, getRow(), "Attr3");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");
		}else{
			AsControl.OpenView("/BusinessManage/ChannelManage/RegionCityList.jsp","ProvinceNo="+sProvinceNo+"&AreaNo=<%=sAreaNo%>"+"&ProvinceManager="+sProvinceManager,"rightdown","");
		}
	}
	
	function newRecord(){
		var sArea = "<%=sAreaNo %>";
		if (typeof(sArea)=='undefined' || sArea.length==0) {
			alert("请选择关联区域！");
			return;
		}
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionProvinceInfo.jsp","TypeCode=<%=sTypeCode %>&AreaNo=<%=sAreaNo %>"+"&PrevUrl=/BusinessManage/ChannelManage/RegionProvinceList.jsp&AreaUserId=<%=sAreaUserId%>","_self","");
	}
	
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionProvinceInfo.jsp","AreaNo=<%=sAreaNo %>"+"&PrevUrl=/BusinessManage/ChannelManage/RegionProvinceList.jsp&SerialNo="+sSerialNo+"&ProvinceNo="+getItemValue(0, getRow(), "Attr1")+"&AreaUserId=<%=sAreaUserId%>","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		var sProvinceSerialNo = RunMethod("公用方法", "GetColValue", "Basedataset_Info,SerialNo,TypeCode='CityCode' and AttrStr1='"+getItemValue(0, getRow(), "Attr1")+"' and AttrStr2='"+getItemValue(0, getRow(), "AttrStr1")+"'");
		if (sProvinceSerialNo != "Null") {
			alert("请先删除该省份下关联城市，再删除此省份！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			// 更新省级管理人员上级及原区域管理人员上级
			RunJavaMethodSqlca("com.amarsoft.app.billions.RegionCommanManager", "updateProvinceSuperDel","provinceUserId="+getItemValue(0, getRow(), "Attr3")+",rawUserId=,provinceNo="+getItemValue(0, getRow(), "Attr1"));
			
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}
	
	function init_row() {
		
		var sProvinceNo = getItemValue(0,getRow(),"Attr1");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");
		}else{
			AsControl.OpenView("/BusinessManage/ChannelManage/RegionCityList.jsp","ProvinceNo="+sProvinceNo,"rightdown","");
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