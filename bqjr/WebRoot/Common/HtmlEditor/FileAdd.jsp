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
<title>�����ļ�</title>

<script type="text/javascript">
	function getHTMLScript(){
		sSelect = FileAdd.inserttatus.value ;
		sText = FileAdd.FileName.value ;
		sCommentName = FileAdd.CommentName.value ;
		if(sText == "undefined" || sText == "") {
			alert("�������ļ�����ȷ���ļ���������ȷ��Ŀ¼�£�") ;
			return ;
		}else if(sSelect == "undefined" || sSelect == ""){
			alert("��ѡ����ȷ�Ĳ��뷽ʽ") ;
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
				alert("ͼƬ����δ�ɹ�,����ϵϵͳ����Ա��")
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
		<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȷ��","ȷ��","javascript:getHTMLScript()",sResourcesPath)%>
	</td>
	<td>
		<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȡ��","ȡ��","javascript:cancel()",sResourcesPath)%>
	</td>
</tr>
</table><p>
<table align = "center">
<tr>
	<b>ͼƬ˵��</b>��<input type="text" size=30  name="CommentName">
</tr>
��
<tr>
	<b>ͼƬ�ļ���</b>��<input type="text" size=30  name="FileName">
</tr>

<tr>
        <td><b>���뷽ʽ</b>��</td>
        <td colspan=1>
        <select name = inserttatus>
        <option value='01'>����</option>   
        <option value='02'>����</option>                 
        </select>                
        </td>
        <td class=black9pt>&nbsp;</td>
</tr>  
</table>
</form>
</body>
</html>

<%@ include file="/IncludeEnd.jsp"%>
