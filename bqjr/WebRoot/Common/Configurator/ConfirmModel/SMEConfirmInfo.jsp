<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "��С��ҵ��׼ģ������ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>

	//���ҳ�����	
	String sScope =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope"));
	if(sScope==null) sScope="";
	String sIndustryType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IndustryType"));
	if(sIndustryType==null) sIndustryType="";
	
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "SMEConModelInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sIndustryType+","+sScope);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents){
		as_save("myiframe0",sPostEvents);		
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputUserID","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"EntKind","<%=sIndustryType%>");
			setItemValue(0,0,"EntScope","<%=sScope%>");
		}
    }
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>