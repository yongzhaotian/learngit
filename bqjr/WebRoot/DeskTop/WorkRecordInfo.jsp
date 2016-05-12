<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Describe:--�ͻ��������ʼ��б�;
		Input Param:
			ObjectNo��������
			NoteType���ʼ�����
			SerialNo���ʼ���ˮ��
	 */
	String PG_TITLE = "�����ʼ�����"; // ��������ڱ��� <title> PG_TITLE </title>
		
	//���ҳ�����
	String sFinishType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FinishType"));
	String sNoteType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("NoteType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sNoteType == null) sNoteType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sFinishType == null) sFinishType = "";
	//���ҳ�����
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject("WorkRecordInfo",Sqlca);	
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{sFinishType.equals("")?"true":"false","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	function saveRecord(sPostEvents){
	
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	function goBack(){
		OpenPage("/DeskTop/WorkRecordList.jsp","_self","");
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert(){
		setItemValue(0,getRow(),"SERIALNO",getSerialNo("WORK_RECORD","SERIALNO")); //��ʼ����ˮ���ֶ�
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"OperateUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"OperateOrgID","<%=CurUser.getOrgID()%>");
			setItemValue(0,0,"OperateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ObjectType","<%=sNoteType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"PROMPTBEGINDATE","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"PromptBeginDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%@ include file="/IncludeEnd.jsp"%>