<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hwang 2009-06-17 
		Tester:
		Describe: ҵ��Ʒ��ѡ��
		Input Param:
			��
		Output Param:
			TypeNo��ҵ��Ʒ�ֱ��
			TypeName��ҵ��Ʒ������

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>
<%
	String sWhereClause="";//�������
	//��ȡ����
	String sStatus=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Status"));
	if(sStatus == null) sStatus = "";
%>

<html>
<head>
<title>��ѡ��ҵ��Ʒ�� </title>
</head>
<script type="text/javascript">

	//��ͼ������Ӧ����,��ȡ�û�ѡ���ҵ��Ʒ��
	function TreeViewOnClick(){
		var sBusinessType=getCurTVItem().id;
		var sBusinessTypeName=getCurTVItem().name;		
		buff.BusinessType.value=sBusinessType+"@"+sBusinessTypeName;		
	}		
	
	//˫����Ӧ�¼�
	function TreeViewOnDBLClick(){
		newBusiness();
	}	

	//�����ȡ����Ϣ�뷵��
	function newBusiness(){
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
		HTMLTreeView tviTemp = new HTMLTreeView("ҵ��Ʒ���б�","right");
		tviTemp.TriggerClickEvent=true;
		if("0110".equals(sStatus)){//��˾�ͻ�
			sWhereClause=" from BUSINESS_TYPE where isinuse='1' and TypeNo not like '3%' and TypeNo not like '2100%' and TypeNo not like '2060%' and TypeNo not like '2030_%' and TypeNo not like '2040_%' and Attribute1 like '%1%'";
		}else{//��С��ҵ�ͻ�
			sWhereClause=" from BUSINESS_TYPE where isinuse='1' and TypeNo not like '3%' and TypeNo not like '2100%' and TypeNo not like '2060%' and TypeNo not like '2030_%' and TypeNo not like '2040_%' and Attribute1 like '%1%'";
		}
		tviTemp.initWithSql("TypeNo","TypeName","TypeNo","",sWhereClause,Sqlca);
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.MultiSelect = true;
		out.println(tviTemp.generateHTMLTreeView());
	%>
	}
</script>

<body class="pagebackground">
<center>
<form  name="buff">
<input type="hidden" name="BusinessType" value="">
<table width="96%" align=center border='1' height="90%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
<tr>
    <td id="myleft" colspan='2' align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
</tr>
<tr height=4%>
	<span class="STYLE9"></span></br>
	<p align="left" class="black9pt">ҵ��Ʒ������<font color=red>(��ѡ�������ʽ����ȴ���)</font></p>
	<td nowrap align="right" class="black9pt" >
		<%=HTMLControls.generateButton("ȷ��","ȷ��","javascript:newBusiness()",sResourcesPath)%>
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
