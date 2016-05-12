<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
<div>
	<pre>

	前三个参数固定，后面参数和数组定义按钮的参数含义一样
	ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button", "按钮文字", "说明文字", "事件script()", sResourcesPath, "按钮样式名");
	</pre>    
</div>
<table>
	<tr id="ButtonTR">
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"","Button", "新增", "新增一条记录", "newRecord()", sResourcesPath, "btn_icon_add")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath, "btn_icon_detail")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","保存","保存","saveRecord()",sResourcesPath,"btn_icon_save")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath, "btn_icon_delete")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","关闭","关闭","help()",sResourcesPath,"btn_icon_close")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","提交","提交","help()",sResourcesPath,"btn_icon_submit")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","编辑","编辑","help()",sResourcesPath,"btn_icon_edit")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","刷新","刷新","help()",sResourcesPath,"btn_icon_refresh")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","信息","信息","help()",sResourcesPath,"btn_icon_information")%></td>
	</tr>
	<tr>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","帮助","帮助","help()",sResourcesPath,"btn_icon_help")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","退出","退出","help()",sResourcesPath,"btn_icon_exit")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","搜索","搜索","help()",sResourcesPath,"btn_icon_check")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","上箭头","上箭头","help()",sResourcesPath,"btn_icon_up")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","下箭头","下箭头","help()",sResourcesPath,"btn_icon_down")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","左箭头","左箭头","help()",sResourcesPath,"btn_icon_left")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","右箭头","右箭头","help()",sResourcesPath,"btn_icon_right")%></td>
	</tr>
</table>
<%@ include file="/IncludeEnd.jsp"%>