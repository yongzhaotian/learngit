<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ���ݶ���Ŀ¼�б�
	 */
	String PG_TITLE = "���ݶ���Ŀ¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	//����������	
	String sDoNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo"));
	String sDoName =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoName"));
	String sDoNo2 =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DoNo2"));
	if(sDoNo==null) sDoNo="";
	if(sDoName==null) sDoName="";
	if(sDoNo2==null) sDoNo2=""; 
	
	String sTempletNo="DataObjectList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(50);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelDOLibrary(#DoNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","��Ԫ��������","��Ԫ��������","generateFromMetaData()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		OpenComp("DataObjectView","/Common/Configurator/DataObject/DataObjectView.jsp","","");
		reloadSelf();
	}
	
	function viewAndEdit(){
       var sDoNo = getItemValue(0,getRow(),"DoNo");
       if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		openObject("DataObject",sDoNo,"001");
	}
    
	function deleteRecord(){
		var sDoNo = getItemValue(0,getRow(),"DoNo");
       if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('45'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	function generateFromMetaData(){
		var sDoNo = getItemValue(0,getRow(),"DoNo");
      	if(typeof(sDoNo)=="undefined" || sDoNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		sMetaData = popComp("MetaTableSelect","/Common/Configurator/MetaDataManage/MetaTableSelectionList.jsp","","");
		if(typeof(sMetaData)=="undefined" || sMetaData=="_CANCEL_") return;
		alert(sMetaData);
		sMetaDatas = sMetaData.split("@");
		sMetaDatabase = sMetaDatas[0];
		sMetaTable = sMetaDatas[1];
		sReturn = PopPageAjax("/Common/Configurator/DataObject/GenerateFromMetaDataAjax.jsp?DatabaseID="+sMetaDatabase+"&TableID="+sMetaTable+"&DoNo="+sDoNo,"","");
		if(sReturn=="succeeded"){
			if(confirm("�ɹ��������ݶ���\n\n�򿪱༭��")) viewAndEdit();
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
<%
    if(!doTemp.haveReceivedFilterCriteria()) {
%>
	showFilterArea();
<%
	}	
%>
</script>	
<%@ include file="/IncludeEnd.jsp"%>