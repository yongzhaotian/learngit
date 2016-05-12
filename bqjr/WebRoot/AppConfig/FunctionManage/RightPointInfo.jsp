<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	//获得参数	
	String sFunctionID =  CurPage.getParameter("FunctionID");
	String sSerialNo =  CurPage.getParameter("SerialNo");
	if(sFunctionID==null) sFunctionID="";
	if(sSerialNo==null) sSerialNo="";

	ASObjectModel doTemp = new ASObjectModel("RightPointInfo");
	doTemp.setDefaultValue("FunctionID",sFunctionID);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	dwTemp.genHTMLObjectWindow(sSerialNo);

	String sButtons[][] = {
		{"true","","Button","保存","","saveRecord()","","","",""},
		{"true","","Button","配置可见角色","","selectRoles()","","","",""},
	};
	
	String sOtherHtml="<table style='margin-bottom:2px;margin-left:2px;margin-right:2px;margin-top:2px;width:95%;height:30px;border:1px solid #9fc0e3;'>" 
		+"<tr><td><b>资源路径格式为：对应JSP全路径（以/为分隔符）+“_”+按钮名称<b></td></tr>"
		+"</table>";
%><%out.print(sOtherHtml);%>
<%@include file="/Frame/resources/include/ui/include_info.jspf"%>
<script type="text/javascript">
	setDialogTitle("权限点详情");
	function saveRecord(){
		as_save("myiframe0","afterOpen();"); //刷新tree使用
	}
	
	function afterOpen(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		AsControl.OpenView("/AppConfig/FunctionManage/FunctionConfTree.jsp","DefaultNode="+sSerialNo,"frameleft","");
	}
	
	/*~[Describe=选择可见角色;]~*/
	function selectRoles(){
	    var sRightPointName=getItemValue(0,getRow(),"RightPointName");
	    var sURL=getItemValue(0,getRow(),"URL");
	    if(typeof(sURL)=="undefined" || sURL.length == 0){
	    	alert("请将资源路径填写完整！");
	    	return;
	    }
       AsControl.PopView("/AppConfig/FunctionManage/SelectRightRoleTree.jsp", "RightPointURL="+sURL+"&RightPointName="+sRightPointName, "dialogWidth=600px;dialogHeight=500px;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
	}
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>