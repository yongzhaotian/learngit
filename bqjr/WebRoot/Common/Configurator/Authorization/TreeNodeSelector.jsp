<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBeginMD.jsp"%><%
	//获取参数：查询名称和参数
	String sSelName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParaString"));
	
	//将空值转化为空字符串
	if(sSelName == null) sSelName = "";
	if(sParaString == null) sParaString = "";
%>
<html>
<head> 
<!-- 为了页面美观,请不要删除下面 TITLE 中的空格 -->
<title>请选择所需信息
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
</title>
</head>
<body class="pagebackground" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}">
<table width="100%" border='1' height="98%" cellspacing='0' align=center bordercolor='#999999' bordercolordark='#FFFFFF'>
<form  name="buff" align=center>
	<tr> 
		<td id="selectPage">
			<iframe name="ObjectList" width=100% height=100% frameborder=0 =no src="<%=sWebRootPath%>/Blank.jsp"></iframe>
		</td>
	</tr>
	<tr>
		<td nowarp bgcolor="" height="25" align=center  colspan="2"> 
			<input type="button" name="ok" value="确认" onClick="javascript:returnSelection()"  border='1'>
			<input type="button" name="ok" value="清空" onClick="javascript:clearAll()"  border='1'>
			<input type="button" name="Cancel" value="取消" onClick="javascript:doCancel();" border='1'>
		</td>
	</tr>
</form>
</table>
</body>
</html>
<script language=javascript>
	var sObjectInfo="";
	function returnSelection(){
		if(sObjectInfo==""){
			if(confirm("您尚未进行选择，确认要返回吗？")){
				sObjectInfo="_NONE_";
			}else{
				return;
			}
		}
		top.returnValue=sObjectInfo;
		top.close();
	}

	function clearAll(){
		top.returnValue='_CLEAR_';
		top.close();
	}

	function doCancel(){
		top.returnValue='_CANCEL_';
		top.close();
	}

	/*~[Describe=支持ESC关闭页面;InputParam=无;OutPutParam=无;]~*/
	document.onkeydown = function(){
		if(event.keyCode==27){
			top.returnValue = "_CANCEL_"; 
			top.close();
		}
	};
	
	OpenComp("TreeNodeSelectDialog","/Common/Configurator/Authorization/TreeNodeDialog.jsp","SelName=<%=sSelName%>&ParaString=<%=sParaString%>","ObjectList","");
</script>
<%@ include file="/IncludeEnd.jsp"%>