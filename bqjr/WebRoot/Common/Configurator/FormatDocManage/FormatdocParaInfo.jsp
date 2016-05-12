<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    ��ʽ�����������Ϣ����
		Input Param:
                    DocID�� ��ʽ�����鱨����
                    OrgID�� ʹ�û���  
	 */
	String PG_TITLE = "��ʽ�����������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	
	String sDocID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocID"));
	String sOrgID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	if(sDocID == null) sDocID = "";
	if(sOrgID == null) sOrgID = "";

	String[][] sHeaders={
			{"OrgID","�������"},
			{"DocID","�ĵ����"},
			{"DocName","�ĵ�����"},
			{"DefaultValue","ȱʡ�ڵ����"},			
			{"Attribute1","����һ"},
			{"Attribute2","���Զ�"},
			{"InputUser","�Ǽ���Ա"},
			{"InputUserName","�Ǽ���Ա"},
			{"InputTime","�Ǽ�ʱ��"},
			{"UpdateUser","������Ա"},
			{"UpdateUserName","������Ա"},
			{"UpdateDate","��������"}
		};

	String sSql = "Select OrgID,DocID,DocName,DefaultValue,Attribute1,Attribute2,"+
			"InputUser,getUserName(InputUser) as InputUserName,InputTime,"+
			"UpdateUser,getUserName(UpdateUser) as UpdateUserName,UpdateDate "+
			"From FormatDoc_Para "+
			"where DocID='"+sDocID+"' and OrgID='"+sOrgID+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FormatDoc_Para";
	doTemp.setKey("DocID,OrgID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setDDDWSql("OrgID","select OrgID,OrgName from Org_Info ");
	doTemp.setHTMLStyle("DocID"," style={width:60px} ");
	doTemp.setHTMLStyle("DocName"," style={width:250px} ");
	doTemp.setEditStyle("Attribute1,Attribute2,DefaultValue","3");
	doTemp.setRequired("OrgID,DocID,DocName,DefaultValue",true);   //������
	doTemp.setVisible("InputUser,UpdateUser",false);
	doTemp.setUpdateable("InputUserName,UpdateUserName",false);
	doTemp.setReadOnly("DocID,DocName,InputUserName,UpdateUserName,InputTime,UpdateDate",true);
	doTemp.setUnit("DocName"," <input type=button class=inputdate value=.. onclick=parent.getDocName()>");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDocID+","+sOrgID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����","saveRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
       setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
       as_save("myiframe0","doReturn('Y');");        
	}
    
    function doReturn(sIsRefresh){
		sDocID = getItemValue(0,getRow(),"DocID");
		parent.sObjectInfo = sDocID+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	/*~[Describe=������ʽ�������ĵ�����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getDocName(){	
		sParaString = "";			
		setObjectValue("SelectFormatDoc",sParaString,"@DocID@0@DocName@1",0,0,"");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
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