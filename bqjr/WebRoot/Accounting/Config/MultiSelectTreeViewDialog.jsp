<%@ page contentType="text/html; charset=GBK"%>
<script>
var multiTreeSelectFlag=true;
</script>
<%@ include file="/IncludeBegin.jsp"%>


<%
	//��ȡ��������ѯ���ƺͲ���
	String sSelName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParaString"));
	String sSelectedValue = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelectedValue"));
	//����ֵת��Ϊ���ַ���
	if(sSelName == null) sSelName = "";
	if(sParaString == null) sParaString = "";
	if(sSelectedValue == null) sSelectedValue = "";
		
	//�����������ѯ�����
	ASResultSet rs = null;
	//���������SQL���
	String sSql = "";
	//�����������ѯ���͡�չ�ַ�ʽ��������������
	String sSelType = "",sSelBrowseMode = "",sSelArgs = "",sSelHideField = "";
	//������������롢�ֶ���ʾ�������ơ�����������
	String sSelCode = "",sSelFieldName = "",sSelTableName = "",sSelPrimaryKey = "";
	//����������ֶ���ʾ��񡢷���ֵ�������ֶΡ�ѡ��ʽ
	String sSelFieldDisp = "",sSelReturnValue = "",sSelFilterField = "",sMutilOrSingle = "";
	//�������������1������2������3������4������5
	String sAttribute1 = "",sAttribute2 = "",sAttribute3 = "",sAttribute4 = "",sAttribute5 = "";
	//������������鳤��
	int l = 0;
	
%>

	<%
	String PG_TITLE = "ѡ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%
	
	sSql =  " select SelType,SelTableName,SelPrimaryKey,SelBrowseMode,SelArgs,SelHideField,SelCode, "+
			" SelFieldName,SelFieldDisp,SelReturnValue,SelFilterField,MutilOrSingle,Attribute1, "+
			" Attribute2,Attribute3,Attribute4,Attribute5 "+
			" from SELECT_CATALOG "+
			" where SelName = '"+sSelName+"' "+
			" and IsInUse = '1' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sSelType = rs.getString("SelType");
		sSelTableName = rs.getString("SelTableName");
		sSelPrimaryKey = rs.getString("SelPrimaryKey");
		sSelBrowseMode = rs.getString("SelBrowseMode");
		sSelArgs = rs.getString("SelArgs");
		sSelHideField = rs.getString("SelHideField");
		sSelCode = rs.getString("SelCode");
		sSelFieldName = rs.getString("SelFieldName");
		sSelFieldDisp = rs.getString("SelFieldDisp");
		sSelReturnValue = rs.getString("SelReturnValue");
		sSelFilterField = rs.getString("SelFilterField");
		sMutilOrSingle = rs.getString("MutilOrSingle");
		sAttribute1 = rs.getString("Attribute1");
		sAttribute2 = rs.getString("Attribute2");
		sAttribute3 = rs.getString("Attribute3");
		sAttribute4 = rs.getString("Attribute4");
		sAttribute5 = rs.getString("Attribute5");
	}
	rs.getStatement().close();

	//����ֵת��Ϊ���ַ���
	if(sSelType == null) sSelType = "";
	if(sSelTableName == null) sSelTableName = "";
	if(sSelPrimaryKey == null) sSelPrimaryKey = "";
	if(sSelBrowseMode == null) sSelBrowseMode = "";
	if(sSelArgs == null) sSelArgs = "";
	else sSelArgs = sSelArgs.trim();
	if(sSelHideField == null) sSelHideField = "";
	else sSelHideField = sSelHideField.trim();
	if(sSelCode == null) sSelCode = "";
	else sSelCode = sSelCode.trim();	
	if(sSelFieldName == null) sSelFieldName = "";
	else sSelFieldName = sSelFieldName.trim();
	if(sSelFieldDisp == null) sSelFieldDisp = "";
	else sSelFieldDisp = sSelFieldDisp.trim();
	if(sSelReturnValue == null) sSelReturnValue = "";
	else sSelReturnValue = sSelReturnValue.trim();
	if(sSelFilterField == null) sSelFilterField = "";
	else sSelFilterField = sSelFilterField.trim();
	if(sMutilOrSingle == null) sMutilOrSingle = "";
	if(sAttribute1 == null) sAttribute1 = "";
	if(sAttribute2 == null) sAttribute2 = "";
	if(sAttribute3 == null) sAttribute3 = "";
	if(sAttribute4 == null) sAttribute4 = "";
	if(sAttribute5 == null) sAttribute5 = "";
	
	//��ȡ����ֵ
	StringTokenizer st = new StringTokenizer(sSelReturnValue,"@");
	String [] sReturnValue = new String[st.countTokens()];  
	while (st.hasMoreTokens()) 
	{
		sReturnValue[l] = st.nextToken();                
		l ++;
	}
	//������ʾ����
	String sHeaders = sSelFieldName;
	
	//��Sql�еı��������Ӧ��ֵ�滻	
	StringTokenizer stArgs = new StringTokenizer(sParaString,",");
	while (stArgs.hasMoreTokens()) 
	{
		try{
			String sArgName  = stArgs.nextToken().trim();
			String sArgValue  = stArgs.nextToken().trim();		
			sSelCode = StringFunction.replace(sSelCode,"#"+sArgName,sArgValue );		
		}catch(NoSuchElementException ex){
			throw new Exception("���������ʽ����");
		}
	}
	
%>

<html>
<head> 
<title><%=PG_TITLE%></title>

<script language=javascript>
	function TreeViewOnClick()
	{		
		var sType = getCurTVItem().type;
		var sName = getCurTVItem().name;
		var sValue = getCurTVItem().value;
		if(sValue == "root")
		{
			buff.ReturnString.value = "root";
		}else
		{
			if(sType == "page" && "<%=sAttribute2%>" == '2')
			{
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.sObjectInfo = buff.ReturnString.value;
			}else if("<%=sAttribute2%>" == '1')
			{	
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.sObjectInfo = buff.ReturnString.value;
			}else
			{
				alert("ҳ�ڵ���Ϣ����ѡ��������ѡ��");
			}
		}
	}
	
	//������ͼ˫���¼���Ӧ���� 
	function TreeViewOnDBLClick()
	{
		var sType = getCurTVItem().type;
		var sName = getCurTVItem().name;
		var sValue = getCurTVItem().value;
		if(sValue == "root")
		{
			buff.ReturnString.value = "root";
		}else
		{
			if(sType == "page" && "<%=sAttribute2%>" == '2')
			{
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.returnValue = buff.ReturnString.value;
				self.close();
			}else if("<%=sAttribute2%>" == '1')
			{	
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.returnValue = buff.ReturnString.value;
				self.close();
			}else
			{
				alert("ҳ�ڵ���Ϣ����ѡ��������ѡ��");			
			}
		}
	}	
	
	function getMultiTreeValue(){
		var ids="";
		var names="";
		for(ik=1;ik<nodes.length;ik++){
			if(nodes[ik].checked){
				ids+=nodes[ik].value+",";
				names+=nodes[ik].name+",";
			}
		}
		if(ids.length>0) ids=ids.substring(0, ids.length-1);
		if(names.length>0) names=names.substring(0, names.length-1);
		return ids+"@"+names;
	}
	
	function setMultiTreeValue(sTreeValueList){
		var ids="";
		var names="";
		
		sTreeValueList = ","+sTreeValueList+",";
		for(ik=1;ik<nodes.length;ik++){
			if(sTreeValueList.indexOf(","+nodes[ik].value+",")>=0){
				var nodeID = nodes[ik].id;
				try{
					setCheckTVItem(nodeID,true);
				}
				catch(e){}
			}
		}
		if(ids.length>0) ids=ids.substring(0, ids.length-1);
		if(names.length>0) names=names.substring(0, names.length-1);
		return ids+"@"+names;
	}
	
	function startMenu() 
	{
		multiTreeSelectFlag=true;
	<%
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ѡ����Ϣ�б�","right");
		tviTemp.TriggerClickEvent=true;
		tviTemp.MultiSelect=true;
		//����������������Ϊ��
		//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
		tviTemp.initWithSql(sSelHideField,sSelFieldDisp,sSelFieldName,"","",sSelCode,sSelFilterField,Sqlca);		
		
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		out.println(tviTemp.generateHTMLTreeView());
	%>
		expandNode('root');	
		<%
		int j = sAttribute1.split("@").length;
		String sExportNode[] = new String[20];
		sExportNode = sAttribute1.split("@");
		for(int i=0;i<j;i++)
		{
		%>
			try{
				expandNode('<%=sExportNode[i]%>');		
			}catch(e)
			{
	
			}
		<%
		}
		%>
		
		setMultiTreeValue("<%=sSelectedValue%>");
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
				<tr>
					<td nowarp bgcolor="" height="25" align=center> 
						<input type="button" name="ok" value="ȷ��" onClick="javascript:returnSelection()"  border='1'>
						<input type="button" name="ok" value="���" onClick="javascript:clearAll()"  border='1'>
						<input type="button" name="Cancel" value="ȡ��" onClick="javascript:doCancel();" border='1'>
					</td>
				</tr>
			</table>
		</form>
	</center>
</body>
<script>
	function returnSelection()
	{
		var returnValue=getMultiTreeValue();
		if(returnValue==""){
			if(confirm("����δ����ѡ��ȷ��Ҫ������")){
				returnValue="_NONE_";
			}else{
				return;
			}
			
		}
		self.returnValue=returnValue;
		self.close();
	}
	
	function clearAll()
	{
		self.returnValue='_CLEAR_';
		self.close();
	
	}
	
	function doCancel()
	{
		self.returnValue='_CANCEL_';
		self.close();
	}
	
	startMenu();	
</script>
</html>


<%@ include file="/IncludeEnd.jsp"%>