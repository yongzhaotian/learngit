<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ��ʽ����������б�
	 */
	String PG_TITLE = "��ʽ����������б�"; // ��������ڱ��� <title> PG_TITLE </title>

	String[][] sHeaders={
		    {"OrgName","ʹ�û���"},
			{"DocID","������"},
			{"DefaultValue","ȱʡ�ڵ�"},
			{"DocName","��������"}
		};

	String sSql =  " select OrgID,getOrgName(OrgID) as OrgName,DocID,DefaultValue,DocName "+
			" from FormatDoc_Para where 1=1";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="FormatDoc_Para";
	doTemp.setKey("DocID,OrgID",true);
	doTemp.setHeader(sHeaders);
	
	doTemp.setVisible("OrgID",false);
	doTemp.setHTMLStyle("OrgName,DocID"," style={width:70px} ");
	doTemp.setHTMLStyle("DefaultValue,DocName"," style={width:240px} ");

	//��ѯ
 	doTemp.setColumnAttribute("OrgName,DocID,DocName","IsFilter","1");
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
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		sReturn=popComp("FormatdocParaInfo","/Common/Configurator/FormatDocManage/FormatdocParaInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
				if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
					OpenPage("/Common/Configurator/FormatDocManage/FormatdocParaList.jsp","_self","");    
                }
            }
        }
	}
	
	function viewAndEdit(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		var sOrgID = getItemValue(0,getRow(),"OrgID");
       if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       //openObject("FlowCatalogView",sFlowNo,"001");
       popComp("FormatdocParaInfo","/Common/Configurator/FormatDocManage/FormatdocParaInfo.jsp","DocID="+sDocID+"~"+"OrgID="+sOrgID,"");
	}

	function deleteRecord(){
		var sDocID = getItemValue(0,getRow(),"DocID");
		if(typeof(sDocID)=="undefined" || sDocID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('69'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>