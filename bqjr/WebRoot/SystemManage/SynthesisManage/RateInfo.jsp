<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	//ҳ��Title
	String PG_TITLE = "��������";

	//���ҳ�����	
	String sRateType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RateType"));
	String sTermUnit = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("TermUnit"));
	String sTerm = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Term"));
	String sRateUnit = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RateUnit"));
	String sEffectDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EffectDate"));
	if (sRateType == null) sRateType = "N";	
	if (sTermUnit == null) sTermUnit = "N";	
	if (sTerm == null) sTerm = "0";	
	if (sRateUnit == null) sRateUnit = "N";	
	if (sEffectDate == null) sEffectDate = "N";

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "RateInfo";
	String sTempletFilter = "1=1";
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);

	ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
	dwTemp.Style = "2";//����DW���
	dwTemp.ReadOnly = "0";//�����Ƿ�ֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sRateType+","+sTermUnit+","+sTerm+","+sRateUnit+","+sEffectDate);
	for (int i = 0; i < vTemp.size(); i++)
	out.print((String) vTemp.get(i));

	String sButtons[][] = { 
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath },
	};
	%> 


	<%@include file="/Resources/CodeParts/Info05.jsp"%>


<script language=javascript>
	//ҳ��װ��ʱ����DW���г�ʼ��
	
	var isInsert = false;
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function saveRecord()
	{
	
		if(!vI_all("myiframe0"))
		{
			return;
		}
		if(!isInsert)
		{
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=SystemConfig.getBusinessTime()%>");
		}
			
		as_save("myiframe0","");
	}
	/*~[Describe=��ʼ���û�������;InputParam=��;OutPutParam=��;]~*/
	function initRow(){
		if (getRowCount(0)==0){ //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
			as_add("myiframe0");//������¼
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=SystemConfig.getBusinessTime()%>");
			isInsert = true;
		}
    }
</script>


<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>

<%@ include file="/IncludeEnd.jsp"%>
