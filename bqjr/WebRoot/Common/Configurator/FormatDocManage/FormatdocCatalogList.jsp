<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ��ʽ������ģ���б�
	 */
	String PG_TITLE = "��ʽ������ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	
	String[][] sHeaders={
			{"DocID","������"},
			{"DocName","��������"}
		};

	String sSql =  " select DocID,DocName from FormatDoc_Catalog where 1=1";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FormatDoc_Catalog";
	doTemp.setKey("DocID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("DocID"," style={width:50px} ");
	doTemp.setHTMLStyle("DocName"," style={width:220px} ");

	//��ѯ
 	doTemp.setColumnAttribute("DocID,DocName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelFormatDocCatalog(#DocID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","��ʽ�����涨���б�","�鿴/�޸ĸ�ʽ�����涨���б�","viewAndEdit2()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("FormatdocCatalogInfo","/Common/Configurator/FormatDocManage/FormatdocCatalogInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/FormatDocManage/FormatdocCatalogList.jsp","_self","");    
                }
            }
        }
	}
	
	function viewAndEdit(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       //openObject("FlowCatalogView",sFlowNo,"001");
       popComp("FormatdocCatalogInfo","/Common/Configurator/FormatDocManage/FormatdocCatalogInfo.jsp","DocID="+sDocID,"");
	}
    
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       popComp("FormatdocDefList","/Common/Configurator/FormatDocManage/FormatdocDefList.jsp","DocID="+sDocID,"");
	}

	function deleteRecord(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('67'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>