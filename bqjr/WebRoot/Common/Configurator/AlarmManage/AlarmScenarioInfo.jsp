<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content:    Ԥ��������Ϣ����
		Input Param:
                    ScenarioID��    Ԥ���������
	 */
	String PG_TITLE = "Ԥ��������Ϣ����@PageTitle";
	//����������	
	String sScenarioID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ScenarioID"));
	if(sScenarioID==null) sScenarioID="";

	String sTempletNo = "AlarmScenarioInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//���Ϊ����ҳ�棬�������޸ĳ������
	if(!sScenarioID.equals("")){
		doTemp.setReadOnly("ScenarioID",true);
	}
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sScenarioID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","�����޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�رձ�ҳ��","back()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function saveRecord(){
        as_save("myiframe0","");
	}
	
	function back(){
		self.close();
	}

	function initRow(){
		if (getRowCount(0)==0){
			as_add("myiframe0");
			setItemValue(0,0,"InputUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.getOrgID()%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.getOrgName()%>");
			setItemValue(0,0,"InputTime","<%=StringFunction.getTodayNow()%>");
			setItemValue(0,0,"UpdateUser","<%=CurUser.getUserID()%>");
			setItemValue(0,0,"UpdateUserName","<%=CurUser.getUserName()%>");
			setItemValue(0,0,"UpdateTime","<%=StringFunction.getTodayNow()%>");
			bIsInsert = true;
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow();
</script>	
<%@ include file="/IncludeEnd.jsp"%>