<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
		/*
		Content:    �༰����Ŀ¼����
		Input Param:
                    ClassName��    ������
	 */
	String PG_TITLE = "�༰����Ŀ¼����"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sDiaLogTitle;
	
	//����������	
	String sClassName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassName"));
	String sClassDescribe =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ClassDescribe"));
	if(sClassName==null){
		sClassName="";
		sDiaLogTitle = "�� ������ ��";
	}else{
		sDiaLogTitle = "��"+sClassDescribe+"����������"+sClassName+"���鿴�޸�����";	
	}
 
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ClassCatalogInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
 	if (sClassName != "")	doTemp.setReadOnly("ClassName",true);
 
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sClassName);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","���沢����","�����޸Ĳ�������һ����¼","saveRecordAndAdd()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    var sCurClassName=""; //��¼��ǰ��ѡ���еĴ����

	function saveRecord(){
		if(!checkName()){
			alert("������������ѱ�ʹ�ã�");
			return;
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0","");
	}
	
	function saveRecordAndBack(){
		if(!checkName()){
			alert("������������ѱ�ʹ�ã�");
			return;
		}
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
       setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
       setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
       as_save("myiframe0","doReturn('Y');");
	}

	function saveRecordAndAdd(){
		if(!checkName()){
			alert("������������ѱ�ʹ�ã�");
			return;
		}
       setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
       setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
       setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
       as_save("myiframe0","newRecord()");
	}

	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ClassName");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
	
	function checkName(){
		sClassName = getItemValue(0,getRow(),"ClassName");
		sReturn=RunMethod("PublicMethod","GetColValue","ClassName,CLASS_CATALOG,String@ClassName@"+sClassName);
		if(typeof(sReturn) != "undefined" && sReturn != ""){
			return false;
		}
		return true;
	}
	function newRecord(){
		OpenComp("ClassCatalogInfo","/Common/Configurator/ClassManage/ClassCatalogInfo.jsp","","_self","");
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
 	setDialogTitle("<%=sDiaLogTitle%>");   
</script>	
<%@ include file="/IncludeEnd.jsp"%>