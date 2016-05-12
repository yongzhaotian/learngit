<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		页面说明: 示例列表页面
	 */
	String PG_TITLE = "示例列表页面";
 %>
<%/*~END~*/%>
	
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	
	String sHeaders[][] = { 							
		{"itemNo","代码项编号"},
		{"itemName","错误类型名称"},
		{"bankNo","征信代码"},
		{"sortNo","排序号"},
		{"isInUse","是否使用"},
		{"inputUser","录入人"},
		{"inputTime","录入时间"},
		{"updateUser","更新人"},
		{"updateTime","更新时间"},
		{"remark","备注"}
			
	};
	
	String sSql = " select t.itemno as itemNo,t.itemname as itemName, "
			    + " t.sortno as sortNo,(case  when  t.isinuse=1 then '是' else '否' end) as isInUse, "
			    + " t.inputuser as inputUser,t.inputtime as inputTime,t.updateuser as updateUser, "
			    + " t.updatetime as updateTime, t.remark as remark "
				+ " from code_library t where t.codeno = 'ErrorType' order by t.sortno asc ";
	
	ASDataObject doTemp = null;
	doTemp = new ASDataObject(sSql);//新增模型：2013-5-9
	doTemp.setHeader(sHeaders);	
	//doTemp.setKey("itemNo", true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//新增参数传递：2013-5-9
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","重载缓存","产品参数变更后系统需重新载入","reloadCacheRole()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/ErrorTypeInfo.jsp","","_self","");
	}

	function viewAndEdit(){
		var sItemNo = getItemValue(0,getRow(),"itemNo");
		if (typeof(sItemNo)=="undefined" || sItemNo.length==0){
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/ErrorTypeInfo.jsp","itemNo="+sItemNo,"_self","");
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
