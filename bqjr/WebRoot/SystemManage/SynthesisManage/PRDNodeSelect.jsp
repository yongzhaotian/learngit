<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: yzheng 2013-05-23
		Tester:
		Describe: ��Ʒ��ؽڵ�ѡ��
		Input Param:
			selectedNodes���Ѿ�ѡ��Ľڵ㣬����ͼ���з�ѡ
		Output Param:
			sPRDNodeID����Ʒ��ؽڵ���
			sPRDNodeName����Ʒ��ؽڵ�����

		HistoryLog:
	 */
	%>
<%/*~END~*/%>
<%
	String sWhereClause="";//�������
	//��ȡ����
	String selectedNodes=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelectedNodes"));
	
	if(selectedNodes == null) 
		selectedNodes = "";
	else if (selectedNodes != "")
	{
		selectedNodes = selectedNodes.substring(0, selectedNodes.length()-1);   //ȥ�����һ����@������
	}
	
	//out.print(selectedNodes);
%>

<html>
<head>
<title>��ѡ���Ʒ��ؽڵ� </title>
</head>
<script type="text/javascript">

	//��ͼ������Ӧ����,��ȡ�û�ѡ���ҵ��Ʒ��
	function TreeViewOnClick(){
		var sPRDNodeID=getCurTVItem().id;
		var sPRDNodeName=getCurTVItem().name;		
		buff.PRDNode.value=sPRDNodeID+"@"+sPRDNodeName;		
	}		
	
	//˫����Ӧ�¼�
	function TreeViewOnDBLClick(){
		newPRDNode();
	}	

	//�����ȡ����Ϣ�뷵��
	function newPRDNode(){
		var nodes = getCheckedTVItems();
		if(nodes.length < 1){
			alert("δѡ��ڵ�");
			return;
		}
		var str = "";
		var id = "";
		for(var i = 0; i < nodes.length; i++){
			str += nodes[i].name + "|";
			id += nodes[i].id + "|";
		}
		//alert("��ѡ���˽ڵ㡾"+str+"��������"+nodes.length+"������¼");
		//alert("��ѡ���˽ڵ㡾"+id+"��������"+nodes.length+"������¼");
		top.returnValue = id+"@"+str;
		top.close();
	}

	function testChecked(){

	}
	
	//����
	function goBack(){
		top.close();
	}

	//����ѯ����ҵ��Ʒ�ְ���TreeViewչʾ
	function startMenu(){
	<%
		HTMLTreeView tviTemp = new HTMLTreeView("��Ʒ��ؽڵ��б�","right");
		tviTemp.TriggerClickEvent=true;
		sWhereClause =  "from PRD_NODEINFO where IsInUse = '1'";
		//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
		tviTemp.initWithSql("NodeID","NodeName","NodeID","", "",sWhereClause,"order by SortNo asc",Sqlca);
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.MultiSelect = true;
		out.println(tviTemp.generateHTMLTreeView());
	%>
	
		
	}
</script>

<body class="pagebackground">
<center>
<form  name="buff">
<input type="hidden" name="PRDNode" value="">
<table width="96%" align=center border='1' height="90%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr>
    <td id="myleft" colspan='2' align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
</tr>
<tr height=4%>
	<span class="STYLE9"></span></br>
	<p align="left" class="black9pt">��Ʒ��ؽڵ��б�<font color=red>(��ѡ���ڵ��ѡ�������ӽڵ�)</font></p>
	<td nowrap align="right" class="black9pt" >
		<%=HTMLControls.generateButton("ȷ��","ȷ��","javascript:newPRDNode()",sResourcesPath)%>
	</td>
	<td nowrap class="black9pt" >
		<%=HTMLControls.generateButton("ȡ��","ȡ��","javascript:goBack()",sResourcesPath)%>
	</td>
</tr>
</table>
</form>
</center>
</body>
</html>

<script type="text/javascript">
	startMenu();
	expandNode('root');
	expandNode('1');
</script>

<%@ include file="/IncludeEnd.jsp"%>
