<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: Ԥ�������б�
		Input Param:
                  ScenarioID��	����ID
	 */
	String PG_TITLE = "Ԥ�������б�@PageTitle";
    //���ҳ�����	
	String sScenarioID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ScenarioID"));
	if (sScenarioID == null) sScenarioID = "";
	
	String sTempletNo = "AlarmScenarioArgsList";
 	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
 	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(30);
    
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
		popComp("AlarmScenarioArgsInfo","/Common/Configurator/AlarmManage/AlarmScenarioArgsInfo.jsp","ScenarioID=<%=sScenarioID%>","dialogWidth=40;dialogHeight=50;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		reloadSelf();
	}
	
	function viewAndEdit(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
		var sAlarmArgID = getItemValue(0,getRow(),"AlarmArgID");
       if(typeof(sAlarmArgID)=="undefined" || sAlarmArgID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       popComp("AlarmScenarioArgsInfo","/Common/Configurator/AlarmManage/AlarmScenarioArgsInfo.jsp","ScenarioID="+sScenarioID+"&AlarmArgID="+sAlarmArgID,"dialogWidth=40;dialogHeight=50;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		reloadSelf();
	}

	function deleteRecord(){
		var sAlarmArgID = getItemValue(0,getRow(),"AlarmArgID");
       if(typeof(sAlarmArgID)=="undefined" || sAlarmArgID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('2'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"ScenarioID");
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