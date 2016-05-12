<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
	Author:   CChang 2003.8.25
	Tester:
	Content: ǩ�����
	Input Param:
		TaskNo��������ˮ��
		ObjectNo��������
		ObjectType����������
	Output param:
	History Log: zywei 2005/07/31 �ؼ�ҳ��
	*/
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ǩ�����";
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%	
	//��ȡ���������������ˮ��
	String sSerialNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sSNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sViewId = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewId"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null) sSerialNo = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if (sViewId == null) sViewId = "";
	sSNo = sObjectNo;
	
%>
<%/*~END~*/%>

	<%
	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
		String sRolIds = "";
		List roleList = CurUser.getRoleTable();
		for (int i=0; i<roleList.size(); i++) {
			sRolIds += roleList.get(i)+",";
		}
		if (!"".equals(sRolIds)) sRolIds = sRolIds.substring(0, sRolIds.length()-1);
		
		if ("002".equals(sViewId)) CurPage.setAttribute("RightType", "ReadOnly");
		
		String sTempletNo = "RetailStoreOpinion";//ģ�ͱ��
		ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      // ����DW��� 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
		
		//����HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo+","+sSNo);//�������,���ŷָ�
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
			{"true","","Button","ɾ��","ɾ�����","deleteRecord()",sResourcesPath},
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script type="text/javascript">

	var bIsInsert = false; // ���DW�Ƿ��ڡ�����״̬��
	
	// ���Ƶ�ѡ��ܾ�ʱ���Ʊ�ע���� add by tbzeng 2014/05/17
	function setRequireOpinion() {
		
		var sRetSult = getItemValue(0, 0, "SVRESULT");
		if( "01" == sRetSult) {
			setItemRequired(0, 0, "PHASEOPINION", true);
		} else if ("02" == sRetSult) {
			setItemRequired(0, 0, "PHASEOPINION", false);
		}
	}
	
	
	/*~[Describe=����ǩ������;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
				
		as_save("myiframe0");
		var sSvResult = getItemValue(0, 0, "SVRESULT");
		if (sSvResult == "01") {	// �ܾ�
			RunMethod("���÷���", "UpdateColValue", "Store_Info,Status,04,SerialNo='<%=sSerialNo%>'");
		} else if (sSvResult == "02") {	// ͨ��
			RunMethod("���÷���", "UpdateColValue", "Store_Info,Status,03,SerialNo='<%=sSerialNo%>'");
		}
	}
	
	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
		
		setItemValue(0, 0, "INPUTORG", "<%=CurOrg.orgID %>");
		setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
		setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UPDATETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>");
	}
	
	/*~[Describe=ɾ����ɾ�����;InputParam=��;OutPutParam=��;]~*/
    function deleteRecord()
    {
    	var sSerialNo = RunMethod("���÷���","GetColValue","Flow_Opinion,SerialNo,SerialNo='"+getItemValue(0, 0, "SERIALNO")+"' and OpinionNo='"+getItemValue(0, 0, "OPINIONNO")+"'");
 	    //δǩ�����,���ɾ��������ʾ��Ϣ�󣬲�����ҳ��ˢ�²���
 	    if (sSerialNo!='Null' && confirm("��ȷʵҪɾ�������")) {
	   		sReturn= RunMethod("���÷���","DelByWhereClause","Flow_Opinion,SerialNo='"+getItemValue(0, 0, "SERIALNO")+"' and OpinionNo='"+getItemValue(0, 0, "OPINIONNO")+"'");
	   		if (sReturn==1){
	    		alert("���ɾ���ɹ�!");
	  		}else{
	    		alert("���ɾ��ʧ�ܣ�");
	   		}
			reloadSelf();
		}
	} 
		
	/*~[Describe=����һ���¼�¼;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		//���û���ҵ���Ӧ��¼��������һ���������������ֶ�Ĭ��ֵ
		if (getRowCount(0)==0) 
		{
			as_add("myiframe0");//������¼
			setItemValue(0,getRow(),"SERIALNO","<%=sSerialNo%>");
			setItemValue(0,getRow(),"OBJECTTYPE","<%=sObjectType%>");
			setItemValue(0,getRow(),"OBJECTNO","<%=sObjectNo%>");
			setItemValue(0,getRow(), "OPINIONNO", "<%=sObjectNo%>");
			setItemValue(0,0, "ROLID", "<%=sRolIds %>");
			
			setItemValue(0,getRow(),"INPUTORG","<%=CurOrg.orgID%>");
			setItemValue(0,getRow(),"INPUTORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,getRow(),"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"INPUTTIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
			
			//setItemValue(0,getRow(),"UPDATEORG","<%=CurOrg.orgID%>");
			//setItemValue(0,getRow(),"UPDATEORGNAME","<%=CurOrg.orgName%>");
			setItemValue(0,getRow(),"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,getRow(),"UPDATETIME","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd") %>");
			
			bIsInsert = true;
		}        
		
		setRequireOpinion();
	}
	</script>
<%/*~END~*/%>


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%@ include file="/IncludeEnd.jsp"%>