<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zllin@amarsoft.com
		Tester:
		Describe: ��Ȩά����Ϣ����;
		Input Param:
			SynonymnID��BOM��������
			
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ȩά����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";//Sql���
	
	//���ҳ��������������͡������š�������Ϣ��š���Ѻ���š���������
	String sSceneID = DataConvert.toString((String)CurComp.getParameter("SceneID"));
	String sGroupID = DataConvert.toString((String)CurComp.getParameter("GroupID"));
	//ARE.getLog().debug("sSceneID=["+sSceneID+"],sGroupID=["+sGroupID+"]");
		
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%	
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("AuthorSceneInfo",Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	
	//����setEvent
	dwTemp.setEvent("AfterInsert", "!PublicMethod.AuthorObjectManage('update','scene',#SCENEID)+!PublicMethod.AuthorRelative(#SCENEID,"+sGroupID+")");
	dwTemp.setEvent("AfterUpdate", "!PublicMethod.AuthorObjectManage('update','scene',#SCENEID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSceneID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","PlainText","�������Ĳ����������Ҫ�������\"��Ȩ������������\"","","",sResourcesPath}
	};
	
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//¼��������Ч�Լ��
		if(bIsInsert){		
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0","self.close();");	
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	
	function resetObjects(){
		setItemValue(0,0,"OBJECTS","");
		setItemValue(0,0,"OBJECTSNAME","");
	}
	
	function selectUser(colId,colName){
		popDynamicSelector("DYNAMICUSER",colId,colName);
	}
	function selectRole(colId,colName){
		popDynamicSelector("DYNAMICROLE",colId,colName);
	}
	function selectDimension(colId,colName){
		popSelector("DIMENSION",colId,colName);
	}
	function selectFlow(colId,colName){
		popSelector("FLOW",colId,colName);
	}
	function selectOrg(colId,colName){
		popSelector("ORG",colId,colName);
	}
	
	function popSelector(type,colId,colName){
		var selectedId = getItemValue(0,getRow(),colId);	
		var sReturn = PopPage("/Common/Configurator/Authorization/ElementSelect.jsp?iniString="+selectedId+"&type="+type,"","dialogWidth=550px;dialogHeight=400px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=="_CANCEL_"){
			return ;		//do nothing
		}
		if(sReturn=="_CLEAR_"){
			setItemValue(0,0,colId,"");
			setItemValue(0,0,colName,"");
			return;
		}
		var selectedValue = sReturn.split("@");
		if(typeof(selectedValue[0])!="undefined" && selectedValue[0].length > 0){		//û������ѡ��
			setItemValue(0,0,colId,selectedValue[0]);
			setItemValue(0,0,colName,selectedValue[1]);
		}
	}
	
	function popDynamicSelector(type,colId,colName){
		var selectedId = getItemValue(0,getRow(),colId);	
		var sReturn = PopPage("/Common/Configurator/Authorization/ElementSelectDynamic.jsp?iniString="+selectedId+"&type="+type,"","dialogWidth=640px;dialogHeight=400px;center:yes;resizable:yes;scrollbars:no;status:no;help:no");
		if(typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=="_CANCEL_"){
			return ;		//do nothing
		}
		/**/
		if(sReturn=="_CLEAR_"){
			setItemValue(0,0,colId,"");
			setItemValue(0,0,colName,"");
			return;
		}
		var selectedValue = sReturn.split("@");
		if(typeof(selectedValue[0])!="undefined" && selectedValue[0].length > 0){		//û������ѡ��
			setItemValue(0,0,colId,selectedValue[0]);
			setItemValue(0,0,colName,selectedValue[1]);
		}
		
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		//
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"INPUTDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			bIsInsert = true;			
		}
		
    }

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "SADRE_RULESCENE";//����
		var sColumnName = "SCENEID";//�ֶ���
		var sPrefix = "S";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		//var sSceneID = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","");
		var sSceneID = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"SCENEID",sSceneID);				
	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��

</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
