<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Content: ��ʾ��Ϣ_Info
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ʾ��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������

	//���ҳ�����	
	String sAlertID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlertID"));
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(sAlertID==null) sAlertID="";
	if(sObjectType==null) sObjectType="";
	if(sObjectNo==null) sObjectNo="";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	String sSql = "select SerialNo,ObjectType,ObjectNo,GetObjectName(ObjectType,ObjectNo) as ObjectName,AlertType,GetItemName('AlertSignal',AlertType) as AlertTypeName,AlertTip,AlertDescribe,OccurDate,OccurTime,UserID,GetUserName(UserID) as UserName,GetOrgName(OrgID) as OrgName,OrgID,OccurReason,Treatment,EndTime,Remark,InputUser,GetUserName(InputUser) as InputUserName,InputOrg,InputTime,UpdateUser,UpdateTime from ALERT_LOG where SerialNo='"+sAlertID+"'";
	String[][] sHeaders = {
		{"ObjectType","��ʾ���ҵ���������"},
		{"ObjectName","��ʾ���ҵ�����"},
		{"AlertTypeName","��ʾ����"},
		{"AlertTip","��ʾ����"},
		{"OccurDate","��������"},
		{"AlertDescribe","��ʾ��Ϣ"},
		{"UserName","������"},
		{"OrgName","�������"},
		{"InputUserName","������"},
		{"InputTime","����ʱ��"},
		{"Remark","��ע"},
		};
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="ALERT_LOG";
	doTemp.setKey("SerialNo",true);
	doTemp.setUpdateable("ObjectName,AlertTypeName,OrgName,UserName,InputUserName",false);

	doTemp.setDDDWSql("ObjectType","select ObjectType,ObjectName from OBJECTTYPE_CATALOG where ObjectType in('Customer','Individual','BusinessContract')");
	doTemp.setVisible("SerialNo,ObjectNo,AlertType,UserName,UserID,OrgID,OccurTime,OccurReason,Treatment,EndTime,InputUser,InputOrg,UpdateUser,UpdateTime",false);

	//doTemp.setDDDWCode("AlertType","AlertSignal");
	doTemp.setUnit("UserName"," <input type=button value=\"..\" class=inputDate onClick=javascript:parent.setObjectInfo(\"User\",\"@UserID@0@UserName@1@OrgID@2\")> ");
	doTemp.setUnit("OrgName"," <input type=button value=\"..\" class=inputDate onClick=javascript:parent.SelectOrg()> ");
	doTemp.setEditStyle("AlertTypeName,Remark,AlertDescribe","3");
	doTemp.setRequired("AlertTypeName,AlertTip,ObjectName",true);
	doTemp.setCheckFormat("OccurDate","3");
	doTemp.setReadOnly("AlertTypeName,OrgName",true);
	doTemp.appendHTMLStyle("AlertDescribe","style={overflow:auto}");
	doTemp.appendHTMLStyle("Remark","style={overflow:auto}");
	doTemp.setHTMLStyle("AlertTip"," style={width:300px;}");
	doTemp.setHTMLStyle("ObjectName"," style={width:300px;}");
	doTemp.setHTMLStyle("AlertTypeName"," style={width:300px;height:50px;cursor: pointer;} onClick=parent.setObjectInfo(\"Code\",\"CodeNo=AlertSignal^��ʾ����^ItemNo$like$\\'AL%\\'$and$length(ItemNo)=6@AlertType@0@AlertTypeName@1\") ");
	doTemp.setUnit("ObjectName"," <input type=button value=\"..\" class=inputDate onClick=\"javascript:parent.chooseObject(\\'@ObjectNo@0@ObjectName@1\\')\"> ");
	
	if(!sObjectType.equals("")) doTemp.setDefaultValue("ObjectType",sObjectType);
	else doTemp.setDefaultValue("ObjectType","Customer");

	doTemp.setDefaultValue("ObjectNo",sObjectNo);
	doTemp.setDefaultValue("OccurDate",StringFunction.getToday());

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
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
		{"true","","Button","���沢����","���������޸�,�������б�ҳ��","saveAndGoBack()",sResourcesPath},
		{"true","","Button","���沢����","���沢����һ����¼","saveAndNew()",sResourcesPath},
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
	}
	
	/*~[Describe=���������޸�,�������б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function saveAndGoBack(){
		saveRecord("goBack()");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack(){
		self.close();
	}

	/*~[Describe=���沢����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function saveAndNew(){
		saveRecord("newRecord()");
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">
	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord(){
		OpenPage("/CreditManage/CreditAlarm/AlertInfo.jsp?AlertID=new","_self","");
	}

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		initSerialNo();//��ʼ����ˮ���ֶ�
		setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
	}

	function chooseObject(sValueString){
		var sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(sObjectType==null || sObjectType==""){
			alert("����ѡ����ض�������");
			return;
		}
		setObjectInfo(sObjectType,sValueString);
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurUser.getOrgID()%>");
		}
    }
	
	function SelectOrg(){
        setObjectInfo("Org","@OrgID@0@OrgName@1");    
	}
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo(){
		var sTableName = "ALERT_LOG";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "AL";//ǰ׺

		//��ȡ��ˮ��
		var sSerialNo = getSerialNo(sTableName,sColumnName,sPrefix);
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
