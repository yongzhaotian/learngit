<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	//获得参数	
	String sFunctionID =  CurPage.getParameter("FunctionID");
	String sModuleID =  CurPage.getParameter("ModuleID");
	String sModuleName =  CurPage.getParameter("ModuleName");
	if(sModuleID==null) sModuleID="";
	if(sModuleName==null) sModuleName="";
	if(sFunctionID==null) sFunctionID="";

	ASObjectModel doTemp = new ASObjectModel("FunctionInfo");
	
   	//如果不为新增页面，则参数的ID不可修改
	if(sFunctionID.length() != 0 ){
		doTemp.setReadOnly("FunctionID,ModuleID,ModuleName",true);
	}
   	doTemp.setDefaultValue("ModuleID",sModuleID);
   	doTemp.setDefaultValue("ModuleName",sModuleName);
   	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sFunctionID);

	String sButtons[][] = {
		{"true","","Button","保存","","saveRecord()","","","",""},
		{"true","","Button","配置可见角色","","selectFunctionRoles()","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	function saveRecord(){
		as_save("myiframe0","afterOpen();"); //刷新tree使用
	}
	
	function afterOpen(){
		var sFunctionID=getItemValue(0,getRow(),"FunctionID");
		AsControl.OpenView("/AppConfig/FunctionManage/FunctionConfTree.jsp","DefaultNode="+sFunctionID,"frameleft","");
	}
	
	/*~[Describe=选择可见角色;InputParam=无;OutPutParam=无;]~*/
	function selectFunctionRoles(){
	    var sFunctionName=getItemValue(0,getRow(),"FunctionName");
	    AsControl.PopView("/AppConfig/FunctionManage/SelectFuncRoleTree.jsp","FunctionID=<%=sFunctionID%>&FunctionName="+sFunctionName,"dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>