<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ��ѯ����ѡ��
	 */
	String PG_TITLE = "��ѯ����ѡ��"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String sTempletNo = "TreeViewSelectList"; //ģ����
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);	

	//��ѯ
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		OpenPage("/Common/Configurator/SelectManage/TreeViewSelectInfo.jsp","_self","");      
	}
	
	function viewAndEdit(){
		var sSelName = getItemValue(0,getRow(),"SelName");
		if(typeof(sSelName) == "undefined" || sSelName.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		OpenPage("/Common/Configurator/SelectManage/TreeViewSelectInfo.jsp?SelName="+sSelName,"_self","");           
	}
    
	function deleteRecord(){
		var sSelName = getItemValue(0,getRow(),"SelName");
		if(typeof(sSelName) == "undefined" || sSelName.length == 0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('45'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function exportAll(){
		amarExport("myiframe0");
	}	
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>