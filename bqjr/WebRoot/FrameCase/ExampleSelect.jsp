<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
<div>
	<pre>

	��Ҫ���ѡ���ķ���ֵʱ���ŵ���AsDialog.OpenSelector()�򿪵���ѡ�������ȡ����ֵ��
	����ǽ���ͨ��ѡ���ķ���ֵ��DW���ֶθ�ֵ������DWģ��������
	AsDialog.OpenSelector(sSelname,sParaString,sStyle)
	sSelname��ѡ��Ի�����
	sParaString������ѡ��Ի���������Ҫ�Ĳ�����������ʽΪ    ������=����ֵ
	sStyle��  �Ի�����ʽ
	</pre>
</div>
<table>
		<tr class="buttontd"><td><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"","Button", "�б�ѡ���", "�����б�ѡ���", "selectList()", sResourcesPath, "btn_icon_detail")%></td></tr>
		<tr class="buttontd"><td><%=ASWebInterface.generateControl(Sqlca,CurComp,sServletURL,"","Button","��ͼѡ���","�����б�ѡ���","selectTree()",sResourcesPath, "btn_icon_detail")%></td></tr>
</table>
<script type="text/javascript">
	<%/*~[Describe=������ͼѡ���;InputParam=��;OutPutParam=��;]~*/%>
	function selectTree(){
		//��Ҫ���ѡ���ķ���ֵʱ���ŵ���AsDialog.OpenSelector()�򿪵���ѡ�������ȡ����ֵ��
		//����ǽ���ͨ��ѡ���ķ���ֵ��DW���ֶθ�ֵ������DWģ��������
		//AsDialog.OpenSelector(sSelname,sParaString,sStyle)
		//sSelname��ѡ��Ի�����
		//sParaString������ѡ��Ի���������Ҫ�Ĳ�����������ʽΪ    ������=����ֵ
		//sStyle��  �Ի�����ʽ
		var sReturn = AsDialog.OpenSelector("SelectAllOrg","","");
		alert("�����ַ��� ��"+sReturn);//ע�ⷵ���ַ����ķ�����ʽ
		//sReturn = sReturn.split("@");
		//alert(sReturn[0]);
	}
	
	<%/*~[Describe=�����б�ѡ���;InputParam=��;OutPutParam=��;]~*/%>
	function selectList(){
		//��Ҫ���ѡ���ķ���ֵʱ���ŵ���AsDialog.OpenSelector()�򿪵���ѡ�������ȡ����ֵ��
		//����ǽ���ͨ��ѡ���ķ���ֵ��DW���ֶθ�ֵ������DWģ��������
		//AsDialog.OpenSelector(sSelname,sParaString,sStyle)
		//sSelname��ѡ��Ի�����
		//sParaString������ѡ��Ի���������Ҫ�Ĳ�����������ʽΪ    ������=����ֵ
		//sStyle��  �Ի�����ʽ
		var sReturn  = AsDialog.OpenSelector("SelectAllUser","","");
		alert("�����ַ��� ��"+sReturn);//ע�ⷵ���ַ����ķ�����ʽ
		//sReturn = sReturn.split("@");
		//alert(sReturn[0]);
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>