<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
<div>
	<pre>

	当要获得选择框的返回值时，才调用AsDialog.OpenSelector()打开弹出选择框，来获取返回值；
	如果是仅是通过选择框的返回值给DW的字段赋值，请在DW模型里配置
	AsDialog.OpenSelector(sSelname,sParaString,sStyle)
	sSelname：选择对话框编号
	sParaString：传入选择对话框配置需要的参数，参数形式为    参数名=参数值
	sStyle：  对话框样式
	</pre>
</div>
<table>
		<tr class="buttontd"><td><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"","Button", "列表选择框", "弹出列表选择框", "selectList()", sResourcesPath, "btn_icon_detail")%></td></tr>
		<tr class="buttontd"><td><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"","Button","树图选择框","弹出列表选择框","selectTree()",sResourcesPath, "btn_icon_detail")%></td></tr>
</table>
<script type="text/javascript">
	<%/*~[Describe=弹出树图选择框;InputParam=无;OutPutParam=无;]~*/%>
	function selectTree(){
		//当要获得选择框的返回值时，才调用AsDialog.OpenSelector()打开弹出选择框，来获取返回值；
		//如果是仅是通过选择框的返回值给DW的字段赋值，请在DW模型里配置
		//AsDialog.OpenSelector(sSelname,sParaString,sStyle)
		//sSelname：选择对话框编号
		//sParaString：传入选择对话框配置需要的参数，参数形式为    参数名=参数值
		//sStyle：  对话框样式
		var sReturn = AsDialog.OpenSelector("SelectAllOrg","","");
		alert("返回字符串 ："+sReturn);//注意返回字符串的返回形式
		//sReturn = sReturn.split("@");
		//alert(sReturn[0]);
	}
	
	<%/*~[Describe=弹出列表选择框;InputParam=无;OutPutParam=无;]~*/%>
	function selectList(){
		//当要获得选择框的返回值时，才调用AsDialog.OpenSelector()打开弹出选择框，来获取返回值；
		//如果是仅是通过选择框的返回值给DW的字段赋值，请在DW模型里配置
		//AsDialog.OpenSelector(sSelname,sParaString,sStyle)
		//sSelname：选择对话框编号
		//sParaString：传入选择对话框配置需要的参数，参数形式为    参数名=参数值
		//sStyle：  对话框样式
		var sReturn  = AsDialog.OpenSelector("SelectAllUser","","");
		alert("返回字符串 ："+sReturn);//注意返回字符串的返回形式
		//sReturn = sReturn.split("@");
		//alert(sReturn[0]);
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>