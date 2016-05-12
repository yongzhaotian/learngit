<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
 <%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "快递签收类型管理";
	//获得页面参数
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//通过DW模型产生ASDataObject对象doTemp
	String sTempletNo = "ExpressTypeList";//模型编号
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

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
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","刷新缓存","刷新缓存","reloadCacheRole()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/Common/WorkFlow/PutOutApply/ExpressTypeInfo.jsp","","_self","");
	}

	function viewAndEdit(){
		var sItemNo = getItemValue(0,getRow(),"itemNo");
		if (typeof(sItemNo)=="undefined" || sItemNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/Common/WorkFlow/PutOutApply/ExpressTypeInfo.jsp","itemNo="+sItemNo,"_self","");
	}

	<%/*~[Describe=刷新缓存;]~*/%>
	function reloadCacheRole(){
		//AsDebug.reloadCacheAll();
		var sReturn = RunJavaMethod("com.amarsoft.app.util.ReloadCacheConfigAction","reloadCacheAll","");
		if(sReturn=="SUCCESS") alert("重载参数缓存成功！");
		else alert("重载参数缓存失败！");
	}

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	

<%@ include file="/IncludeEnd.jsp"%>
