<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: Ԥ��ģ���б�
	 */
	String PG_TITLE = "Ԥ��ģ���б�";
	
    //���ҳ�����	
	String sScenarioID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ScenarioID"));
	if (sScenarioID == null) sScenarioID = "";
	
	String sTempletNo = "AlarmModelList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(200);
    
	//��������¼�
	//dwTemp.setEvent("BeforeDelete","!Configurator.DelAlarmModel(#AlarmModelNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sScenarioID);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		popComp("AlarmModelInfo","/Common/Configurator/AlarmManage/AlarmModelInfo.jsp","ScenarioID=<%=sScenarioID%>","");
		reloadSelf();
	}
	
	function viewAndEdit(){
		var sModelID = getItemValue(0,getRow(),"ModelID");
       if(typeof(sModelID)=="undefined" || sModelID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        	return ;
		}
       popComp("AlarmModelInfo","/Common/Configurator/AlarmManage/AlarmModelInfo.jsp","ScenarioID=<%=sScenarioID%>&ModelID="+sModelID,"");
		reloadSelf();
	}

	function deleteRecord(){
		var sModelID = getItemValue(0,getRow(),"ModelID");
		if(typeof(sModelID)=="undefined" || sModelID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
        	return ;
		}
		
		if(confirm(getHtmlMessage('45'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"AlarmModelNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}

	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	hideFilterArea();
</script>
<%@ include file="/IncludeEnd.jsp"%>