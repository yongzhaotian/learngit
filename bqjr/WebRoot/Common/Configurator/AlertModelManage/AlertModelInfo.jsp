<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
		/*
		Author:   cwzhan 2004-12-15
		Tester:
		Content: ������Ŀ��Ϣ����
		Input Param:
                    AppID��    �������
 		Output param:
		                
		History Log: 
            
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ӧ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql;
	
	//����������	
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	//ͨ����ʾģ�����ASDataObject����doTemp
	//String sTempletNo = "AppInfo";
	//String sTempletFilter = "1=1";
	//ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	String[][] sHeaders = {
		{"SerialNo","��ˮ��"},
		{"ObjectType","��������"},
		{"Describe","Ԥ������˵��"},
		{"Criteria","����"},
		{"Cycle","��������"},
		{"CycleUnit","��������"},
		{"LastRun","��һ����������"}
	};
	sSql = "select SerialNo,ObjectType,Describe,Criteria,Cycle,CycleUnit,LastRun,InputUser,InputOrg,InputTime,UpdateUser,UpdateTime from RISK_CRITERIA where SerialNo='"+sSerialNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable="RISK_CRITERIA";
	doTemp.setHeader(sHeaders);
	doTemp.setEditStyle("Criteria","3");
	doTemp.setHTMLStyle("Criteria","style={width:600px;height:100px;overflow:auto} onDBLClick=\"parent.editCriteria(this)\"");
	doTemp.setDDDWSql("ObjectType","select ObjectType,ObjectName from OBJECTTYPE_CATALOG where ObjectType in('Customer','Individual','BusinessContract')");
	doTemp.setCheckFormat("Cycle","2");
	doTemp.setDDDWCode("CycleUnit","PeriodType");
	doTemp.setVisible("SerialNo,InputUser,InputOrg,InputTime,UpdateUser,UpdateTime,LastRun",false);
	//filter��������
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sCriteriaAreaHTML = ""; 
%>

<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	var bIsInsert=false;
    var sCurAppID=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
        as_save("myiframe0","doReturn('Y');");
	}
    
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"AppID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		    bIsInsert = true;
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
	}
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
	}

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "RISK_CRITERIA";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "RC";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}

	function editObjectValueWithScriptEditorForAlertSQL(oObject,sSqlObjectType){
		sInput = oObject.value;
		sInput = real2Amarsoft(sInput);
		sInput = replaceAll(sInput,"~","$[wave]");
		oTempObj = oObject;
        saveParaToComp("ScriptText="+sInput+"&SqlObjectType="+sSqlObjectType,"openScriptEditorForAlertSqlAndSetText()");
		
	}
	function openScriptEditorForAlertSqlAndSetText(){
		var oMyobj = oTempObj;
		sOutPut = popComp("ScriptEditorForAlertSql","/Common/ScriptEditor/ScriptEditorForAlertSql.jsp","","");
		if(typeof(sOutPut)!="undefined" && sOutPut!="_CANCEL_"){
			oMyobj.value = amarsoft2Real(sOutPut);
		}
	}
	function editCriteria(oTemp){
		var sObjectType = getItemValue(0,0,"ObjectType");
		if(sObjectType=="" || typeof(sObjectType)=="undefined"){
			alert("����ѡ���������!");
			return;
		}
		editObjectValueWithScriptEditorForAlertSQL(oTemp,sObjectType);
	}

	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
