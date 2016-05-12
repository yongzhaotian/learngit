<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},//btn_icon_add
		{"true","All","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},//btn_icon_detail
		{"true","","Button","保存","保存修改","saveRecord()",sResourcesPath},//btn_icon_save
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},//btn_icon_delete
		{"true","All","Button","关闭","关闭","help()",sResourcesPath,"btn_icon_close"},
		{"true","All","Button","提交","提交","help()",sResourcesPath,"btn_icon_submit"},
		{"true","All","Button","编辑","编辑","help()",sResourcesPath,"btn_icon_edit"},
		{"true","All","Button","刷新","刷新","help()",sResourcesPath,"btn_icon_refresh"},
		{"true","All","Button","信息","信息","help()",sResourcesPath,"btn_icon_information"},
		{"true","All","Button","帮助","帮助","help()",sResourcesPath,"btn_icon_help"},
		{"true","All","Button","退出","退出","help()",sResourcesPath,"btn_icon_exit"},
		{"true","All","Button","搜索","搜索","help()",sResourcesPath,"btn_icon_check"},
		{"true","All","Button","上箭头","上箭头","help()",sResourcesPath,"btn_icon_up"},
		{"true","All","Button","下箭头","下箭头","help()",sResourcesPath,"btn_icon_down"},
		{"true","All","Button","左箭头","左箭头","help()",sResourcesPath,"btn_icon_left"},
		{"true","All","Button","右箭头","右箭头","help()",sResourcesPath,"btn_icon_right"}
	};
%>
<div>
  	<pre>
  	
  	按钮数组定义，依次为:
	0.是否显示 "true"/"false"
	1.权限类型，除了新增、删除和保存三个按钮可为空外，其他均设置为'All'
	2.类型，默认为Button (可选Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	3.按钮文字
	4.提示文字
	5.函数名
	6.资源图片路径	指定的变量 sResourcesPath
	7.按钮样式名        参考 button.css
	
  		String sButtons[][] = {
		{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","保存","保存","saveRecord()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","All","Button","关闭","关闭","close()",sResourcesPath,"btn_icon_close"}
	}
	</pre>
</div>
<table>
	<tr id="ButtonTR">
	    <td valign=top id="InfoButtonArea" class="infodw_buttonarea_td" align="left" >
			<%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%>
	    </td>
	</tr>
</table>
<%@ include file="/IncludeEnd.jsp"%>