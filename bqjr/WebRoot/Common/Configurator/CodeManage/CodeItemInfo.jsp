<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ���������
		Input Param:
                    CodeNo��    ������
                    ItemNo��    ��Ŀ��ţ������ǲ����룩
	 */
	String PG_TITLE = "���������"; // ��������ڱ��� <title> PG_TITLE </title>

	//�������
	String sDiaLogTitle = "";
	
	//����������	
	String sCodeNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeNo"));
	String sItemNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo"));
	String sCodeName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeName"));
	//����ֵת��Ϊ���ַ���
	if(sCodeNo == null) sCodeNo = "";
	if(sItemNo == null) sItemNo = "";
	if(sCodeName == null) sCodeName = "";
	
	if(sCodeNo.equals("")){
		sDiaLogTitle = "�� ������������� ��";
	}else{
		if(sItemNo==null || sItemNo.equals("")){
			sItemNo="";
			sDiaLogTitle = "��"+sCodeName+"�����룺��"+sCodeNo+"����������";
		}else{
			sDiaLogTitle = "��"+sCodeName+"�����룺��"+sCodeNo+"���鿴�޸�����";
		}
	}
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CodeItemInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
		
	if(!sCodeNo.equals("")){
		doTemp.setVisible("CodeNo",false); 
	}else{
		doTemp.setRequired("CodeNo",true);
	} 
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.setEvent("AfterUpdate","!Configurator.UpdateCodeCatalogUpdateTime("+StringFunction.getTodayNow()+","+CurUser.getUserID()+","+sCodeNo+")");
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCodeNo+","+sItemNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {		
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","���沢����","���������","saveAndNew()",sResourcesPath}			
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(sPostEvents){
		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
		setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()%>");
		as_save("myiframe0",sPostEvents);
	}
	
	function saveAndNew(){
		saveRecord("newRecord()");
	}
   
	function newRecord(){
        OpenComp("CodeItemInfo","/Common/Configurator/CodeManage/CodeItemInfo.jsp","CodeNo=<%=sCodeNo%>&CodeName=<%=sCodeName%>","_self");
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"CodeNo","<%=sCodeNo%>");
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