<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    �༰������¼����
		Input Param:
                    ClassName��    ������
                    MethodName��   ��������
	 */
	String PG_TITLE = "�༰������¼����"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sDiaLogTitle;
	
	//����������	
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassName"));
	String sMethodName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("MethodName"));
	String sClassDescribe =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ClassDescribe"));
	if(sClassName==null) sClassName="";
	if(sClassName==null) sClassName="";
	if(sMethodName==null) sMethodName="";
	if (sClassName.equals("")){
		sDiaLogTitle = "�� �����·����������� ��";	
	}else{
		if(sMethodName.equals("")){
			sDiaLogTitle = "����"+sClassDescribe+"��["+ sClassName +"]��������������";
		}else{
			sDiaLogTitle = "����"+sClassDescribe+"��["+ sClassName +"]���ġ� "+sMethodName+" �������鿴�޸�����";
		}
	}

  //ͨ��DWģ�Ͳ���ASDataObject����doTemp
  	String sTempletNo = "ClassMethodInfo";//ģ�ͱ��
  	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca); 
   	
  	if (!sClassName.equals("")) {
		doTemp.setVisible("CLASSNAME",false);    	
	   	doTemp.setRequired("CLASSNAME",false);
	}
   	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sClassName+","+sMethodName);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","���沢����","�����޸Ĳ�����","saveRecordAndReturn()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecordAndReturn(){
        setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.getUserName()%>");
        setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
        as_save("myiframe0","doReturn('Y');");
	}
    
	function saveRecordAndAdd(){
        setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
        setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.getUserName()%>");
        setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
        as_save("myiframe0","newRecord()");
	}

	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"CLASSNAME");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
    
	function newRecord(){
        sClassName = getItemValue(0,getRow(),"CLASSNAME");
        OpenComp("ClassMethodInfo","/Common/Configurator/ClassManage/ClassMethodInfo.jsp","ClassName="+sClassName,"_self","");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			if ("<%=sClassName%>" !=""){
				setItemValue(0,0,"CLASSNAME","<%=sClassName%>");
			}
			setItemValue(0,0,"INPUTUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"INPUTUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"INPUTORG","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"INPUTORGNAME","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"INPUTTIME","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UPDATEUSER","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UPDATEUSERNAME","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UPDATETIME","<%=StringFunction.getToday()%>");
			
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
 	setDialogTitle("<%=sDiaLogTitle%>");   
</script>	
<%@ include file="/IncludeEnd.jsp"%>