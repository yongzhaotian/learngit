<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},//btn_icon_add
		{"true","All","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},//btn_icon_detail
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},//btn_icon_save
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},//btn_icon_delete
		{"true","All","Button","�ر�","�ر�","help()",sResourcesPath,"btn_icon_close"},
		{"true","All","Button","�ύ","�ύ","help()",sResourcesPath,"btn_icon_submit"},
		{"true","All","Button","�༭","�༭","help()",sResourcesPath,"btn_icon_edit"},
		{"true","All","Button","ˢ��","ˢ��","help()",sResourcesPath,"btn_icon_refresh"},
		{"true","All","Button","��Ϣ","��Ϣ","help()",sResourcesPath,"btn_icon_information"},
		{"true","All","Button","����","����","help()",sResourcesPath,"btn_icon_help"},
		{"true","All","Button","�˳�","�˳�","help()",sResourcesPath,"btn_icon_exit"},
		{"true","All","Button","����","����","help()",sResourcesPath,"btn_icon_check"},
		{"true","All","Button","�ϼ�ͷ","�ϼ�ͷ","help()",sResourcesPath,"btn_icon_up"},
		{"true","All","Button","�¼�ͷ","�¼�ͷ","help()",sResourcesPath,"btn_icon_down"},
		{"true","All","Button","���ͷ","���ͷ","help()",sResourcesPath,"btn_icon_left"},
		{"true","All","Button","�Ҽ�ͷ","�Ҽ�ͷ","help()",sResourcesPath,"btn_icon_right"}
	};
%>
<div>
  	<pre>
  	
  	��ť���鶨�壬����Ϊ:
	0.�Ƿ���ʾ "true"/"false"
	1.Ȩ�����ͣ�����������ɾ���ͱ���������ť��Ϊ���⣬����������Ϊ'All'
	2.���ͣ�Ĭ��ΪButton (��ѡButton/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
	3.��ť����
	4.��ʾ����
	5.������
	6.��ԴͼƬ·��	ָ���ı��� sResourcesPath
	7.��ť��ʽ��        �ο� button.css
	
  		String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","����","saveRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","All","Button","�ر�","�ر�","close()",sResourcesPath,"btn_icon_close"}
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