<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	String PG_TITLE = "ҵ���������б�"; // ��������ڱ��� <title> PG_TITLE </title>

	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "TermConfigList";
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
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("TermType");
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

	function newRecord()
	{ 
		AsControl.OpenView("/Accounting/Config/TermConfigInfo.jsp","","_self","");        
	}
	
	function viewAndEdit()
	{
		var sItemNo = getItemValue(0,getRow(),"ItemNo");	//���������
        if(typeof(sItemNo)=="undefined" || sItemNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
            return ;
		}
        AsControl.OpenView("/Accounting/Config/TermConfigInfo.jsp","ItemNo="+sItemNo,"_self","");   
	}
    
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
