<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ��ѯ�б���Ϣ����
		Input Param:
			   ObjectType����������
               RelationShip��������ϵ
	 */
	String PG_TITLE = "��������Tab��������"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//���ҳ�����	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sRelationShip =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RelationShip"));
	if(sObjectType == null) sObjectType = "";
	if(sRelationShip == null) sRelationShip = "";	
	
 	String sTempletNo = "ObjTypeRelaInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca); 
  			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+","+sRelationShip);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecordAndReturn(){
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","doReturn();");        
	}
    
	function saveRecordAndAdd(){
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
        as_save("myiframe0","newRecord()");
	}

    function doReturn(sIsRefresh){
		OpenPage("/Common/Configurator/ObjectManage/ObjTypeRelaList.jsp","_self","");
	}
    
	function newRecord(){
		OpenPage("/Common/Configurator/ObjectManage/ObjTypeRelaInfo.jsp","_self","");
	}
	
	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");				
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();  
</script>	
<%@ include file="/IncludeEnd.jsp"%>