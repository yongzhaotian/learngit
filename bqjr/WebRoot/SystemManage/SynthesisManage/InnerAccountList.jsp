<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "�ڲ��˻��б�"; // ��������ڱ��� <title> PG_TITLE </title>

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "InnerAccountList";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
    //���ӹ�����	
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
    dwTemp.setPageSize(200);

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!SystemManage.DeleteOrgBelong(#OrgID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
		};
	%> 


	<%@include file="/Resources/CodeParts/List05.jsp"%>


	<script type="text/javascript">
    var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		AsControl.PopView("/SystemManage/SynthesisManage/InnerAccountInfo.jsp","","dialogWidth="+(screen.availWidth*0.3)+"px;dialogHeight="+(screen.availHeight*0.4)+"px;resizable=yes;maximize:yes;help:no;status:no;"); 
		reloadSelf();            
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sAccountNo = getItemValue(0,getRow(),"CoreAccountNo");	//�ʺ�
		var sOrgID = getItemValue(0,getRow(),"OrgID");	//����
		var sCurrency = getItemValue(0,getRow(),"Currency");	//����
		var sAccountType = getItemValue(0,getRow(),"AccountType");   //�˻�����
        if(typeof(sOrgID)=="undefined" || sOrgID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}

        AsControl.PopView("/SystemManage/SynthesisManage/InnerAccountInfo.jsp",
                "CoreAccountNo="+sAccountNo+"&OrgID="+sOrgID+"&Currency="+sCurrency,+"&AccountType="+sAccountType,
                "dialogWidth="+(screen.availWidth*0.3)+"px;dialogHeight="+(screen.availHeight*0.4)+"px;resizable=yes;maximize:yes;help:no;status:no;"); 
        reloadSelf();       
	}
    
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sOrgID = getItemValue(0,getRow(),"OrgID");
        if(typeof(sOrgID) == "undefined" || sOrgID.length == 0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
		
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	</script>


<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	

<%@ include file="/IncludeEnd.jsp"%>
