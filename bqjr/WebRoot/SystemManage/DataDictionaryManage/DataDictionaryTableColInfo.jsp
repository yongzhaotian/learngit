<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ���ֶ�����ҳ��
		author:yzheng
		date:2013-6-8
	 */
	String PG_TITLE = "���ֶ�����ҳ��";

	//���ҳ�����
	String tableNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("TableNo"));
	String colName =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ColName"));
	String viewType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ViewType"));

	if(viewType==null) viewType="";
	if(colName==null) colName="";
	if(tableNo==null) tableNo="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "TableColInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(tableNo + "," + colName);//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
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
		if("<%=viewType%>" == "1"){
			AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTableColList.jsp","TableNo=<%=tableNo%>","_self");
		}
		else{
			AsControl.OpenView("/SystemManage/DataDictionaryManage/DataDictionaryTableColList.jsp","","_self");
		}
	}

	<%/*~[Describe=ִ�в������ǰִ�еĴ���;]~*/%>
	function beforeInsert(){
<%-- 		setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>"); --%>
<%-- 		setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>"); --%>
<%-- 		setItemValue(0,0,"InputTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>"); --%>
		bIsInsert = false;
	}
	
	<%/*~[Describe=ִ�и��²���ǰִ�еĴ���;]~*/%>
	function beforeUpdate(){
<%-- 		setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>"); --%>
<%-- 		setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>"); --%>
<%-- 		setItemValue(0,0,"UpdateTime","<%=DateX.format(new java.util.Date(),"yyyy/MM/dd hh:mm:ss")%>"); --%>
	}

	function initRow(){
		if (getRowCount(0)==0){//�統ǰ�޼�¼��������һ��
			as_add("myiframe0");
			setItemValue(0,0,"TableNo","<%=tableNo%>");
			bIsInsert = true;
		}
    }
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		bFreeFormMultiCol = false;
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>
<%@ include file="/IncludeEnd.jsp"%>