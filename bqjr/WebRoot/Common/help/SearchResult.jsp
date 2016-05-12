<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>搜索结果</title>
</head>
<%
String sKeyWords = DataConvert.toRealString(iPostChange,CurPage.getParameter("KeyWords"));
String sSql = "";
ASResultSet rs = null;
%>
<body>
	<div style="width: 100%;height:100%;overflow:auto;visibility: inherit">
	<table width="100%" border="0" cellspacing="0" cellpadding="3">
		<tr>
		  <td height="1" bgcolor="#104A7B"> </td>
		</tr>
		<tr>
		  <td bgcolor="e6f2ea" style="background-color: #d0dee9"><font size="-1"><b>搜索结果：</b></font></td>
		</tr>
		<tr>
		  <td height="1" bgcolor="#104A7B"> </td>
		</tr>

		<tr>
		  <td height="30"></td>
		</tr>
		<tr>
		  <td  bgcolor="ECECEC"><font face=Arial,Helvetica><font size="-1">有关于 <b>[<%=sKeyWords%>]</b>  的帮助信息</font></font></td>
		</tr>
		<tr>
			<td height="1" ><p>
			<UL>
		
			<%
			
			sSql = "select CommentItemID,CommentItemName,GetItemName('CommentItemType',CommentItemType) as CommentItemType from REG_COMMENT_ITEM where CommentItemName like '%"+sKeyWords+"%' or CommentText like '%"+sKeyWords+"%' order by CommentItemType";
			
			rs = SqlcaRepository.getResultSet(sSql);
			while(rs.next()){
				out.println("<LI><a href=\"javascript:OpenComp('HelpContent','/Common/help/HelpContent.jsp','CommentItemID="+rs.getString("CommentItemID")+"','_self',OpenStyle)\" > ["+DataConvert.toString(rs.getString("CommentItemType"))+"] "+DataConvert.toString(rs.getString("CommentItemName"))+"</a></LI>");
			}
			rs.getStatement().close();

			%>
			</UL>
			</td>
		</tr>

		<tr>
		  <td height="30"> </td>
		</tr>

		
<!--  如果是对象类型为“组件”，则显示相关联的功能，如果对象类型为功能，则显示相关联的组件  -->
<%
	String sTargetObjectNo="",sTargetObjectName="";
%>
		<tr>
		  <td  bgcolor="ECECEC"><font face=Arial,Helvetica><font size="-1">有关于 <b>[<%=sKeyWords%>]</b>  的组件</font></font></td>
		</tr>
		<tr>
			<td height="1" ><p>
			<UL>
		
			<%
			sSql = "select CompID as TargetObjectNo,CompName as TargetObjectName from REG_COMP_DEF where CompID like '%"+sKeyWords+"%' or CompName like '%"+sKeyWords+"%'";
			//return sSql;
			
			rs = SqlcaRepository.getResultSet(sSql);
			while(rs.next()){
				sTargetObjectNo = DataConvert.toString(rs.getString("TargetObjectNo"));
				sTargetObjectName = DataConvert.toString(rs.getString("TargetObjectName"));
				
				out.println("<LI><a href=\"javascript:OpenComp('OnlineHelp','/Common/help/HelpFrame.jsp','ObjectNo="+sTargetObjectNo+"&ObjectType=ComponentDefinition','_self',OpenStyle)\" >"+sTargetObjectName+"&nbsp;&nbsp;["+DataConvert.toString(rs.getString("TargetObjectNo"))+"]</a></LI>");
			}
			rs.getStatement().close();

			%>
			</UL>
			</td>
		</tr>
		<tr>
		  <td height="30"> </td>
		</tr>
		<tr>
		  <td bgcolor="ECECEC"><font face=Arial,Helvetica><font size="-1">有关于 <b>[<%=sKeyWords%>]</b>  的功能</font></font></td>
		</tr>

		<tr>
			<td height="1" ><p>
			<UL>
		
			<%
			sSql = "select FunctionID as TargetObjectNo,FunctionName as TargetObjectName from REG_FUNCTION_DEF where FunctionID like '%"+sKeyWords+"%' or FunctionName like '%"+sKeyWords+"%'";
			//return sSql;
			
			rs = SqlcaRepository.getResultSet(sSql);
			while(rs.next()){
				out.println("<LI><a href=\"javascript:OpenComp('OnlineHelp','/Common/help/HelpFrame.jsp','ObjectNo="+rs.getString("TargetObjectNo")+"&ObjectType=Function','_self',OpenStyle)\" >"+DataConvert.toString(rs.getString("TargetObjectName"))+"&nbsp;&nbsp;["+DataConvert.toString(rs.getString("TargetObjectNo"))+"]</a></LI>");
			}
			rs.getStatement().close();

			%>
			</UL>
			</td>
		</tr>
		<tr>
		  <td height="30"> </td>
		</tr>

	</table>
	</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>
