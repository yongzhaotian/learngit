<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵����    
	 */
	String PG_TITLE = "��ɫ����";
	
	//���ҳ�����
	String sRoleID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RoleID"));
	if(sRoleID==null) sRoleID="";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "RoleInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sRoleID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{(CurUser.hasRole("099")?"true":"false"),"","Button","����","�����޸�","saveRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    var sCurRoleID=""; //��¼��ǰ��ѡ���еĴ����

	function saveRecord(){
		var sRoleID = getItemValue(0,getRow(),"RoleID");
		if(sRoleID!="<%=sRoleID%>"){
			sReturn=RunMethod("PublicMethod","GetColValue","RoleID,ROLE_INFO,String@RoleID@"+sRoleID);
			if(typeof(sReturn) != "undefined" && sReturn != ""){
				alert("������Ľ�ɫ���ѱ�ʹ�ã�");
				return;
			}
		}
        setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0","doReturn('Y');");
	}
    
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"RoleID");
        parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"RoleAttribute","2");
			bIsInsert = true;
		}
		sRoleAttribute = getItemValue(0,getRow(),"RoleAttribute");
		if(sRoleAttribute==""|| sRoleAttribute == null){
			setItemValue(0,0,"RoleAttribute","2");
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>