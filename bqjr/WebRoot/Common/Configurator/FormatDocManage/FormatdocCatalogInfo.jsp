<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
		/*
		Content:    ��ʽ������ģ����Ϣ����
		Input Param:
                    DocID��    ��ʽ�����鱨����
	 */
	String PG_TITLE = "��ʽ������ģ����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	
	String sDocID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocID"));
	if(sDocID == null) sDocID = "";

	String[][] sHeaders={
			{"DocID","�ĵ����"},
			{"DocName","�ĵ�����"},
			{"Attribute1","����һ"},
			{"Attribute2","���Զ�"},
			{"Attribute3","������"},
			{"Attribute4","������"},
			{"OrgID","�������"},
			{"OrgName","��������"},
			{"UserID","��Ա���"},
			{"UserName","��Ա����"},
			{"InputDate","��������"},
			{"UpdateDate","��������"}
		};

	String sSql = "Select DocID,DocName,Attribute1,Attribute2,Attribute3,Attribute4,"+
			"OrgID,getOrgName(OrgID) as OrgName,"+
			"UserID,getUserName(UserID) as UserName,InputDate,UpdateDate "+
			"From FormatDoc_Catalog "+
			"where DocID='"+sDocID+"' ";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FormatDoc_Catalog";
	doTemp.setKey("DocID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("DocID"," style={width:60px} ");
	doTemp.setHTMLStyle("DocName"," style={width:180px} ");
	doTemp.setEditStyle("Attribute1,Attribute2,Attribute3,Attribute4","3");
	doTemp.setRequired("DocID,DocName",true);   //������
	doTemp.setVisible("OrgID,UserID",false);
	doTemp.setUpdateable("OrgName,UserName",false);
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDocID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����","saveRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
        setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
        as_save("myiframe0","doReturn('Y');");        
	}
    
    function doReturn(sIsRefresh){
		sDocID = getItemValue(0,getRow(),"DocID");
       parent.sObjectInfo = sDocID+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"UserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"UserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>