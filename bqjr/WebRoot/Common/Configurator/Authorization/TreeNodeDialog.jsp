<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.sadre.app.widget.tree.ITreeNode"%>
<%@page import="com.amarsoft.sadre.app.widget.*"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zllin@20120410
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//��ȡ��������ѯ���ƺͲ���
	String sSelName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParaString"));
	
	//����ֵת��Ϊ���ַ���
	if(sSelName == null) sSelName = "";
	if(sParaString == null) sParaString = "";
		
	//ARE.getLog().info(sSelName);
	//ARE.getLog().info(sParaString);
	Map attributes = new HashMap();
	if(sParaString.length()>0){
		String [] var = sParaString.split(",");
		for(int v=0; v<var.length; v++){
			String[] tmp = var[v].split("@");
			attributes.put(tmp[0], tmp[1]);
		}
	}
	//ARE.getLog().info("attributes="+attributes);
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ѡ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=����ҵ���߼�;]~*/%>
<%
	
%>

<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=����ҵ���߼�;]~*/%>
<html>
<head> 
<title><%=PG_TITLE%></title>

<script language=javascript>
	function TreeViewOnClick()
	{		
		var sType = getCurTVItem().type;
		var sName = getCurTVItem().name;
		var sValue = getCurTVItem().value;
		if(sType == "root")
		{
			buff.ReturnString.value = "root";
		}else
		{
			if(sType == "page")
			{
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.sObjectInfo = buff.ReturnString.value;
			}else
			{
				alert("ҳ�ڵ���Ϣ����ѡ��������ѡ��");
			}
		}
	}
	
	function TreeViewOnDBLClick(){
		TreeViewOnClick();
	};
	
	function startMenu() 
	{
	<%
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ѡ����Ϣ�б�","right");
		tviTemp.TriggerClickEvent=true;		
		
		//����������������Ϊ��
		ITreeNode treeNode = null;
		if(sSelName.equalsIgnoreCase("IMPL")){
			treeNode = new MethodTree();
		}else if(sSelName.equalsIgnoreCase("DIMENSION")){
			treeNode = new DimensionTree();
		}else if(sSelName.equalsIgnoreCase("ImportScene")){
			treeNode = new ImportSceneTree();
		}
		
		treeNode.appendTreeNode(tviTemp, attributes, Sqlca);
		
		//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
		//tviTemp.initWithSql(sSelHideField,sSelFieldDisp,sSelFieldName,"","",sSelCode,sSelFilterField,Sqlca);		
		
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		out.println(tviTemp.generateHTMLTreeView());
	%>
		expandNode('root');	
	}
	
	
</script>
<style>

.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}

</style>
</head>

<body class="pagebackground">
	<center>
		<form  name="buff">
		<input type="hidden" name="ReturnString" value="">
			<table width="90%" border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
				<tr> 
        				<td id="myleft"  align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
				</tr>
			</table>
		</form>
	</center>
</body>
<script>
	startMenu();	
</script>
</html>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>