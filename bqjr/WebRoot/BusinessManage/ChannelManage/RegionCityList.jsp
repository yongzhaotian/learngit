<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
 
 	// 获取组件参数
 	String sAreaNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AreaNo"));
 	String sProvinceNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProvinceNo"));
 	String sProvinceManager =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProvinceManager"));
 	
 	if (sAreaNo == null) sAreaNo = "";
 	if (sProvinceNo == null) sProvinceNo = "";
 	if (sProvinceManager == null) sProvinceManager = "";
 	String sTypeCode = "CityCode";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "CityCodeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.WhereClause += " and AttrStr1='" + sProvinceNo + "' and AttrStr2='"+sAreaNo+"' and Attr1='"+sProvinceManager+"'";

	/* doTemp.setColumnAttribute("ExampleName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange); */
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
		/* var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if(typeof(sExampleId)=="undefined" || sExampleId.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");
		}else{
			AsControl.OpenView("/FrameCase/ExampleInfo.jsp","ExampleId="+sExampleId,"rightdown","");
		} */
	}
	
	function newRecord(){
		var sProvince = "<%=sProvinceNo %>";
		if (typeof(sProvince)=='undefined' || sProvince=='undefined' || sProvince.length==0) {
			alert("请选择关联省份！");
			return;
		}
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionCityInfo.jsp","TypeCode=<%=sTypeCode %>&AreaNo=<%=sAreaNo%>&ProvinceNo=<%=sProvinceNo %>"+"&PrevUrl=/BusinessManage/ChannelManage/RegionCityList.jsp"+"&ProvinceManager=<%=sProvinceManager%>&CityNo="+getItemValue(0, getRow(), "Attr2"),"_self","");
	}
	
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		var sParam = "SerialNo="+sSerialNo+"&ProvinceManager=<%=sProvinceManager%>"+"&PrevUrl=/BusinessManage/ChannelManage/RegionAreaList.jsp&ProvinceNo=<%=sProvinceNo %>&AreaNo=<%=sAreaNo %>&CityNo="+getItemValue(0, getRow(), "Attr2");
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionCityInfo.jsp", sParam,"_self","");
		
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			
			// 更新城市管理人员上级及原区域管理人员上级
			RunJavaMethodSqlca("com.amarsoft.app.billions.RegionCommanManager", "updateCitySuperDel","cityUserId="+getItemValue(0, getRow(), "Attr3")+",rawUserId=,cityNo="+getItemValue(0, getRow(), "Attr2"));

			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			reloadSelf();
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>