<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ����Ŀ¼�б�
	 */
	String PG_TITLE = "����Ŀ¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>

	//���ҳ�����	
	String sCodeTypeOne =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeTypeOne"));
	String sCodeTypeTwo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeTypeTwo"));
	//����ֵת��Ϊ���ַ���	
	if (sCodeTypeOne == null) sCodeTypeOne = ""; 
	if (sCodeTypeTwo == null) sCodeTypeTwo = ""; 

	
 	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
 	String sTempletNo = "CodeCatalogList";//ģ�ͱ��
 	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
 	doTemp.multiSelectionEnabled=false;//?
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
 		
	if(sCodeTypeOne!=null && !sCodeTypeOne.equals("")) doTemp.WhereClause+=" and CodeTypeOne='"+sCodeTypeOne+"'";
	if(sCodeTypeTwo!=null && !sCodeTypeTwo.equals("")) doTemp.WhereClause+=" and CodeTypeTwo='"+sCodeTypeTwo+"'";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelCodeLibrary(#CodeNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","�����б�","�鿴/�޸Ĵ�������","viewAndEditCode()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","����","������ѡ�еļ�¼","exportDataObject()",sResourcesPath},
		{"true","","Button","����SortNo","����SortNo","GenerateCodeCatalogSortNo()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("CodeCatalogInfo","/Common/Configurator/CodeManage/CodeCatalogInfo.jsp","CodeTypeOne=<%=sCodeTypeOne%>&CodeTypeTwo=<%=sCodeTypeTwo%>","");
		reloadSelf();        
	}
	
	function viewAndEdit(){
       var sCodeNo = getItemValue(0,getRow(),"CodeNo");
       if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
  		popComp("CodeCatalogInfo","/Common/Configurator/CodeManage/CodeCatalogInfo.jsp","CodeNo="+sCodeNo,"");
	}
    
    /*~[Describe=�鿴���޸Ĵ�������;InputParam=��;OutPutParam=��;]~*/
	function viewAndEditCode(){
       var sCodeNo = getItemValue(0,getRow(),"CodeNo");
       var sCodeName = getItemValue(0,getRow(),"CodeName");
       if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		popComp("CodeItem","/Common/Configurator/CodeManage/CodeItemList.jsp","CodeNo="+sCodeNo+"&CodeName="+sCodeName,"");  
	}

	function deleteRecord(){
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
		if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('45'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function exportDataObject(){
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
       if(typeof(sCodeNo)=="undefined" || sCodeNo.length==0 ){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		sServerRoot = "";
		sReturn = PopPageAjax("/Common/Configurator/ObjectExim/ExportDataObjectAjax.jsp?ObjectType=Code&ObjectNo="+sCodeNo+"&ServerRootPath="+sServerRoot,"","");
		if(sReturn=="succeeded"){
			alert("�ɹ��������ݣ�");
		}
	}
	
	function GenerateCodeCatalogSortNo(){
		RunMethod("Configurator","GenerateCodeCatalogSortNo","");
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>