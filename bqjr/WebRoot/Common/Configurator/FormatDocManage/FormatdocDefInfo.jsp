<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
		/*
		Content:    ��ʽ�����涨����Ϣ����
		Input Param:
                    DocID��    ��ʽ�����鱨����
                    DirID��    ��ʽ������Ŀ¼���
	 */
	String PG_TITLE = "��ʽ�����涨����Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	
	String sDocID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DocID"));
	String sDirID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DirID"));
	if(sDocID == null) sDocID = "";
	if(sDirID == null) sDirID = "";

	String[][] sHeaders={
			{"DocID","������"},
			{"DirID","Ŀ¼���"},
			{"DirName","Ŀ¼����"},
			{"JspFileName","JSP�ļ�"},
			{"HTMLFileName","HTML�ļ�"},
			{"ArrangeAttr","��������"},
			{"CircleAttr","ѭ������"},
			{"Attribute1","����һ"},
			{"Attribute2","���Զ�"},
			{"OrgID","��������"},
			{"OrgName","��������"},
			{"UserID","��Ա���"},
			{"UserName","��Ա����"},
			{"InputDate","��������"},
			{"UpdateDate","��������"}
		};

	String sSql = "Select DocID,DirID,DirName,JspFileName,HTMLFileName,"+
			"ArrangeAttr,CircleAttr,Attribute1,Attribute2,"+
			"OrgID,getOrgName(OrgID) as OrgName,"+
			"UserID,getUserName(UserID) as UserName,"+
			"InputDate,UpdateDate "+
			"From FormatDoc_Def "+
			"where DocID='"+sDocID+"' and DirID='"+sDocID+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FormatDoc_Def";
	doTemp.setKey("DocID,DirID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("DocID,DirID"," style={width:60px} ");
	doTemp.setHTMLStyle("DirName"," style={width:180px} ");
	doTemp.setEditStyle("Attribute1,Attribute2,ArrangeAttr,CircleAttr","3");
	doTemp.setRequired("DocID,DirID,DirName",true);   //������
	doTemp.setVisible("OrgID,UserID",false);
	doTemp.setUpdateable("OrgName,UserName",false);
	doTemp.setReadOnly("OrgName,UserName,InputDate,UpdateDate",true);

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDocID+","+sDirID);
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
			if("<%=sDocID%>"!=""){
				setItemValue(0,0,"DocID","<%=sDocID%>");
			}
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>