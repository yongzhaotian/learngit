<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: Ԥ�������б�
	 */
	String PG_TITLE = "Ԥ�������б�";
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","180");

	String sTempletNo = "AlarmScenarioList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(30);

	//��������¼�
	//dwTemp.setEvent("BeforeDelete","!Configurator.DelScenarioAll(#ScenarioID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","������������","�鿴/�޸ĳ���Ԥ�������","viewAndEditArg()",sResourcesPath},
		{"true","","Button","ģ�ͷ�������","�鿴/�޸ĳ�����ģ�ͷ���","viewAndEditGroup()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		PopComp("AlarmScenarioInfo","/Common/Configurator/AlarmManage/AlarmScenarioInfo.jsp","","dialogWidth=40;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");//OpenStyle
		reloadSelf();
	}
	
	function viewAndEdit(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
       if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
	    }
       PopComp("AlarmScenarioInfo","/Common/Configurator/AlarmManage/AlarmScenarioInfo.jsp","ScenarioID="+sScenarioID,"dialogWidth=40;dialogHeight=40;status:no;center:yes;help:no;minimize:yes;maximize:no;border:thin;statusbar:no");
		reloadSelf();
	}
    
    /*~[Describe=�鿴���޸�Ԥ������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEditArg(){
      	var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
      	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
          	return ;
		}
      	popComp("AlarmScenarioArgsList","/Common/Configurator/AlarmManage/AlarmScenarioArgsList.jsp","ScenarioID="+sScenarioID,"",OpenStyle);
	}

    /*~[Describe=�鿴���޸�ģ�ͷ�������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEditGroup(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
		if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
          	return ;
		}
    	popComp("AlarmGroupList","/Common/Configurator/AlarmManage/AlarmGroupList.jsp","ScenarioID="+sScenarioID,"",OpenStyle);
    }

	function deleteRecord(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
      	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
          	return ;
		}
		
		if(confirm(getHtmlMessage('45'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function mySelectRow(){
		var sScenarioID = getItemValue(0,getRow(),"ScenarioID");
      	if(typeof(sScenarioID)=="undefined" || sScenarioID.length==0) {
			OpenPage("/Blank.jsp?TextToShow=��ѡ��һ����¼","DetailFrame","");
			return;
		}
      	OpenComp("AlarmModelList","/Common/Configurator/AlarmManage/AlarmModelList.jsp","ScenarioID="+sScenarioID,"DetailFrame","");
	}

	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	mySelectRow();
	hideFilterArea();
</script>	
<%@ include file="/IncludeEnd.jsp"%>