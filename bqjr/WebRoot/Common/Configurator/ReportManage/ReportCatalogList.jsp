<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ����ģ��Ŀ¼�б�
	 */
	String PG_TITLE = "����ģ��Ŀ¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>

	String sTempletNo = "ReportCatalogList"; //ģ����
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//��ѯ
	doTemp.generateFilters(Sqlca);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelReportModel(#MODELNO)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ģ���б�","�鿴/�޸�ģ���б�","viewAndEdit2()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("ReportCatalogInfo","/Common/Configurator/ReportManage/ReportCatalogInfo.jsp","","");
		reloadSelf(); 
		//�������ݺ�ˢ���б�
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
			sReturnValues = sReturn.split("@");
			if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
				OpenPage("/Common/Configurator/ReportManage/ReportCatalogList.jsp","_self",""); 
			}
		}     
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sModelNo = getItemValue(0,getRow(),"MODELNO");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		//openObject("ReportCatalogView",sModelNo,"001");
		popComp("ReportCatalogView","/Common/Configurator/ReportManage/ReportCatalogView.jsp","ObjectNo="+sModelNo+"&ItemID=0010","");
	}
    
	/*~[Describe=�鿴���޸�ģ���б�;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2(){
		var sModelNo = getItemValue(0,getRow(),"MODELNO");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		//popComp("ReportModelList","/Common/Configurator/ReportManage/ReportModelList.jsp","ModelNo="+sModelNo,"");
		popComp("ReportCatalogView","/Common/Configurator/ReportManage/ReportCatalogView.jsp","ObjectNo="+sModelNo+"&ItemID=0020","");
	}

	function deleteRecord(){
		var sModelNo = getItemValue(0,getRow(),"MODELNO");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('49'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>