<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

	<%
	String PG_TITLE = "ҵ���������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	

	//��ȡ�������
	
	//��ȡҳ�����
	String sBookType  = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BookType")));
	

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "AccountCodeConfigList";
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
	Vector vTemp = dwTemp.genHTMLDataWindow("AccountCodeConfig,"+sBookType);
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
		AsControl.OpenView("/Accounting/Config/AccountCodeConfigInfo.jsp","BookType=<%=sBookType%>","_self","");          
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sItemNo = getItemValue(0,getRow(),"ItemNo");	//���������
        if(typeof(sItemNo)=="undefined" || sItemNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        AsControl.OpenView("/Accounting/Config/AccountCodeConfigInfo.jsp","ItemNo="+sItemNo+"&BookType=<%=sBookType%>","_self","");
	}
    
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sItemNo = getItemValue(0,getRow(),"ItemNo");	//���������
        if(typeof(sItemNo) == "undefined" || sItemNo.length == 0) {
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
