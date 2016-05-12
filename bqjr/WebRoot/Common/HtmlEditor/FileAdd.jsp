<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   Thong 2005.03.16
 * Tester:
 * Content: 
 * Input Param:
 *                  sCommentItemid
 * Output param:
 * History Log:     
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sYear = StringFunction.getToday().substring(0,4) ;
    String sSerialNo =  DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sCommentItemid =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CommentItemid"));
	String CommentItemid =sYear+sCommentItemid ;
	ASResultSet rs = null;
	String sSql = "",sTempstr = "";
%>
<html>
<head> 
<title>新增文件</title>

<script type="text/javascript">
	function getHTMLScript(){
		sSelect = FileAdd.inserttatus.value ;
		sText = FileAdd.FileName.value ;
		sCommentName = FileAdd.CommentName.value ;
		if(sText == "undefined" || sText == "") {
			alert("请输入文件名并确定文件保存在正确的目录下！") ;
			return ;
		}else if(sSelect == "undefined" || sSelect == ""){
			alert("请选择正确的插入方式") ;
			return ;			
		}else {
			var sReturnValue = PopPageAjax("/Common/HtmlEditor/InsertPageValueAjax.jsp?CommentText="+sText+"&CommentItemName="+sCommentName+"&TableName=REG_COMMENT_ITEM&CommentItemID=<%=sCommentItemid%>&rand="+randomNumber(),"", "dialogWidth:280px; dialogHeight:200px; help: no; scroll: no; status: no");
			if(sSelect == '01' && sReturnValue !="") {
				self.returnValue = "#embed@img@"+sReturnValue+"#";
				self.close();
			}else if(sSelect == '02' && sReturnValue !=""){
				self.returnValue = "#link@img@"+sReturnValue+"#";
				self.close();
			}else {
				alert("图片插入未成功,请联系系统管理员！")
			}
		}
//        self.close();
    }
	function cancel(){
		self.close();
	}
</script>

</head>
<body bgcolor="#D3D3D3">
<form name="FileAdd" method=post action="">
<table>
<tr>
	<td>
		<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","确认","确认","javascript:getHTMLScript()",sResourcesPath)%>
	</td>
	<td>
		<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","取消","取消","javascript:cancel()",sResourcesPath)%>
	</td>
</tr>
</table><p>
<table align = "center">
<tr>
	<b>图片说明</b>：<input type="text" size=30  name="CommentName">
</tr>
　
<tr>
	<b>图片文件名</b>：<input type="text" size=30  name="FileName">
</tr>

<tr>
        <td><b>插入方式</b>：</td>
        <td colspan=1>
        <select name = inserttatus>
        <option value='01'>插入</option>   
        <option value='02'>链接</option>                 
        </select>                
        </td>
        <td class=black9pt>&nbsp;</td>
</tr>  
</table>
</form>
</body>
</html>

<%@ include file="/IncludeEnd.jsp"%>
