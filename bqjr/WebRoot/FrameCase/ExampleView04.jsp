<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 <div>
 	<pre>
 	
 	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��ѡ����","right");
 	...
 	tviTemp.MultiSelect = true;//������ͼΪ��ѡ,��ͼ��Ϊ��ѡ
 	
 	JS������
 	var nodes = getCheckedTVItems();//��ȡ�Ѿ�ѡ�нڵ��ID
 	setCheckTVItem('�ڵ�ID', true);//���ýڵ�Ϊѡ��״̬
 	</pre>
 </div>
 <%
	/*
		ҳ��˵��: ��ѡ��ͼ
	 */
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"��ѡ����","right");
	tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
	tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
	tviTemp.MultiSelect = true;//������ͼΪ��ѡ
	//ͨ��insertFolder��insertPage������ͼ
	tviTemp.insertFolder("1", "root", "�ڵ�1", "1", "", 1);
	tviTemp.insertFolder("2", "root", "�ڵ�2", "2", "", 2);
	tviTemp.insertFolder("21", "2", "�ڵ�3", "21", "", 1);
	tviTemp.insertPage("211", "21", "�ڵ�4", "211", "", 1);
	tviTemp.insertPage("212", "21", "�ڵ�5", "212", "", 2);
	tviTemp.insertPage("213", "21", "�ڵ�6", "213", "", 3);
	tviTemp.insertPage("22", "2", "�ڵ�7", "22", "", 2);
	tviTemp.insertPage("23", "2", "�ڵ�8", "23", "", 3);
	
	String sButtons[][] = {
		{"true","","Button","���Զ�ѡ","","testChecked()",sResourcesPath},//btn_icon_add
	};
%>
<html>
<body style="overflow: hidden;">
	<table width=100% height=100% cellspacing="0" cellpadding="0" border="0">
		<tr style="height: 30px;">
			<td><%@ include file="/Frame/resources/include/ui/include_buttonset_dw.jspf"%></td>
		</tr>
		<tr> 
  			<td id="myleft"  align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
		</tr>
	</table>
</body>
</html>
<script type="text/javascript">
	function TreeViewOnClick(){
		var node = getCurTVItem();
		var str = "";
		for(var o in node){
			str += o + " = " + node[o] + "\n";
		}
		alert(str);
	}
	
	function testChecked(){
		var nodes = getCheckedTVItems();
		if(nodes.length < 1){
			alert("δѡ��ڵ�");
			return;
		}
		var str = "";
		for(var i = 0; i < nodes.length; i++){
			str += nodes[i].name + "��";
		}
		alert("��ѡ���˽ڵ㡾"+str+"��������"+nodes.length+"������¼")
	}
	
	function initTreeView(){
		<%=tviTemp.generateHTMLTreeView()%>
		expandNode('root');
		expandNode('1');
		expandNode('2');
	}
	
	initTreeView();
	setCheckTVItem('211', true);
</script>
<%@ include file="/IncludeEnd.jsp"%>