<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ����ģ���б�
	 */
	String PG_TITLE = "����ģ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	 
	String sTempletNo = "FlowCatalogList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelFlowModel(#FlowNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","����ģ���б�","�鿴/�޸�����ģ���б�","viewAndEdit2()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","ҵ��������Ϣ","�鿴��ѡ���̵�ҵ����Ϣ","viewInfo()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		AsControl.OpenView("/Common/Configurator/FlowManage/FlowCatalogInfo.jsp","","_self","");
	}
	
    /*~[Describe=�鿴���޸�����;]~*/
	function viewAndEdit(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       //openObject("FlowCatalogView",sFlowNo,"001");
       popComp("FlowCatalogView","/Common/Configurator/FlowManage/FlowCatalogView.jsp","ObjectNo="+sFlowNo+"&ItemID=0010","");
	}
    
    /*~[Describe=�鿴���޸�����;]~*/
	function viewAndEdit2(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       //popComp("FlowModelList","/Common/Configurator/FlowManage/FlowModelList.jsp","FlowNo="+sFlowNo,"");
       popComp("FlowCatalogView","/Common/Configurator/FlowManage/FlowCatalogView.jsp","ObjectNo="+sFlowNo+"&ItemID=0020","");
	}

	function deleteRecord(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('49'))){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	 /*~[Describe=�鿴��ѡ���̵�ҵ������;]~*/
	function viewInfo(){
		var sFlowNo = getItemValue(0,getRow(),"FlowNo");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		var sFlowType = "";		
		if(sFlowNo == "CreditFlow")//����������������
        	sFlowType = "01";
       if(sFlowNo == "ApproveFlow")//�������������������
        	sFlowType = "02";
       if(sFlowNo == "PutOutFlow")//ҵ�������������
        	sFlowType = "03";
       popComp("FlowFindList","/SystemManage/GeneralSetup/FlowFindList.jsp","FlowType="+sFlowType,"");
	}
	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>