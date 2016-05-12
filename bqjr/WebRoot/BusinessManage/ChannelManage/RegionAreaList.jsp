<%@page import="com.amarsoft.app.billions.CommonConstans"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
 
 	// 组件参数
 	String sTypeCode = "AreaCode";

	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "AreaCodeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
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
		var sAreaNo = getItemValue(0,getRow(),"Attr1");
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sAreaUserId = getItemValue(0, 0, "Attr3");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");
		}else{
			AsControl.OpenView("/BusinessManage/ChannelManage/RegionProvinceList.jsp","AreaNo="+sAreaNo+"&AreaUserId="+sAreaUserId,"rightmiddle","");
		}
	}
	
	function newRecord(){
		
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionAreaInfo.jsp","TypeCode=<%=sTypeCode %>","_self","");
	}
	
	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/BusinessManage/ChannelManage/RegionAreaInfo.jsp","SerialNo="+sSerialNo+"&PrevUrl=/BusinessManage/ChannelManage/RegionProvinceList.jsp","_self","");
		
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		
		var sAreaNo = getItemValue(0, getRow(), "Attr1");
		var sUserId = getItemValue(0, getRow(), "Attr3");
		var sAreaSerialNo = RunMethod("公用方法", "GetColValue", "Basedataset_Info,SerialNo,(TypeCode='CityCode' and AttrStr2='"+sAreaNo+"') or (TypeCode='ProvinceCode' and AttrStr1='"+sAreaNo+"')");

		if (sAreaSerialNo != "Null") {
			alert("请先删除该区域下关联省市，再删除此区域！");
			return;
		}
		
		if(confirm("您真的想删除该信息吗？")){
			
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			
			// 更新上级
			RunJavaMethodSqlca("com.amarsoft.app.billions.RegionCommanManager", "updateAreaSuperDel", "roleId=<%=CommonConstans.CEO_MANAGER%>,userId="+sUserId+",areaNo="+sAreaNo);
			//RunMethod("公用方法", "DelByWhereClause", "Basedataset_Info,(TypeCode='CityCode' and AttrStr2='"+sAreaNo+"') or (TypeCode='ProvinceCode' and AttrStr1='"+sAreaNo+"')");
			parent.reloadSelf();
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>