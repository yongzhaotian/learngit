<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
<div>
	<pre>

	ǰ���������̶���������������鶨�尴ť�Ĳ�������һ��
	ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button", "��ť����", "˵������", "�¼�script()", sResourcesPath, "��ť��ʽ��");
	</pre>    
</div>
<table>
	<tr id="ButtonTR">
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"","Button", "����", "����һ����¼", "newRecord()", sResourcesPath, "btn_icon_add")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath, "btn_icon_detail")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","����","����","saveRecord()",sResourcesPath,"btn_icon_save")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath, "btn_icon_delete")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","�ر�","�ر�","help()",sResourcesPath,"btn_icon_close")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","�ύ","�ύ","help()",sResourcesPath,"btn_icon_submit")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","�༭","�༭","help()",sResourcesPath,"btn_icon_edit")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","ˢ��","ˢ��","help()",sResourcesPath,"btn_icon_refresh")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","��Ϣ","��Ϣ","help()",sResourcesPath,"btn_icon_information")%></td>
	</tr>
	<tr>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","����","����","help()",sResourcesPath,"btn_icon_help")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","�˳�","�˳�","help()",sResourcesPath,"btn_icon_exit")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","����","����","help()",sResourcesPath,"btn_icon_check")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","�ϼ�ͷ","�ϼ�ͷ","help()",sResourcesPath,"btn_icon_up")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","�¼�ͷ","�¼�ͷ","help()",sResourcesPath,"btn_icon_down")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","���ͷ","���ͷ","help()",sResourcesPath,"btn_icon_left")%></td>
		<td class="buttontd"><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"All","Button","�Ҽ�ͷ","�Ҽ�ͷ","help()",sResourcesPath,"btn_icon_right")%></td>
	</tr>
</table>
<%@ include file="/IncludeEnd.jsp"%>