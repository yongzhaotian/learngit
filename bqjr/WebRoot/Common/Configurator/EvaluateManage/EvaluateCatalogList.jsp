<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ����ģ��Ŀ¼�б�
	 */
	String PG_TITLE = "����ģ��Ŀ¼�б�";

	//����������	
	String sType =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));
	if(sType == null) sType = "";	 
	 
	String sTempletNo = "EvaluateCatalogList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//ģ�����Ͳμ�����EvaluateModelType
		if(sType.equals("Classify")) //�ʲ����շ���
			doTemp.WhereClause += " Where ModelType = '020' ";
		if(sType.equals("Risk")) //���ն�����
			doTemp.WhereClause += " Where ModelType = '030' ";	
		if(sType.equals("CreditLine")) //����ۺ����Ŷ�Ȳο�
			doTemp.WhereClause += " Where ModelType = '080' ";
		if(sType.equals("CreditLevel")) //���õȼ�����	(��˾�ͻ��͸���)
			doTemp.WhereClause += " Where (ModelType ='010' or ModelType = '015') ";	
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);
	
	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelEvaluateModel(#ModelNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"false","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ģ���б�","�鿴/�޸�ģ���б�","viewAndEdit2()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	function newRecord(){
		var sReturn=popComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
            //�������ݺ�ˢ���б�
			if (typeof(sReturn)!='undefined' && sReturn.length!=0){
				sReturnValues = sReturn.split("@");
              if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
                    OpenPage("/Common/Configurator/EvaluateManage/EvaluateCatalogList.jsp","_self","");    
                }
            }
        }
	}
	
    /*~[Describe=�鿴���޸�����;]~*/
	function viewAndEdit(){
        var sModelNo = getItemValue(0,getRow(),"ModelNo");
        if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        //openObject("EvaluateCatalogView",sModelNo,"001");
        popComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","ModelNo="+sModelNo);
	}
    
    /*~[Describe=�鿴/�޸�ģ���б�;]~*/
	function viewAndEdit2(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		popComp("EvaluateModelList","/Common/Configurator/EvaluateManage/EvaluateModelList.jsp","ModelNo="+sModelNo,"");
	}

	function deleteRecord(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
       if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('50'))){
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