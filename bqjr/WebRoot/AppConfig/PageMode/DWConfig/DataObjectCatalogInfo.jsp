 <%@ page contentType="text/html; charset=GBK"%>
 <%@ include file="/IncludeBegin.jsp"%>
 <%
   	String PG_TITLE = "��ʾģ��Ŀ¼��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
   	CurPage.setAttribute("ShowDetailArea","true");
   	CurPage.setAttribute("DetailAreaHeight","250");
    	
	//��ò���	
	String sDoNo = CurPage.getParameter("DONO");
	if(sDoNo==null) sDoNo = "";
   
  //ͨ��DWģ�Ͳ���ASDataObject����doTemp
  	String sTempletNo = "DataObjectCatalogInfo";//ģ�ͱ��
  	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
        
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
        
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDoNo);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));    
    
    String sButtons[][] = {
        {"true","All","Button","����","���������޸�","as_save(0)","","","","btn_icon_save"},
    };
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">	
	setDialogTitle("��ʾģ������");
	AsOne.AsInit();
	init();
	bFreeFormMultiCol=true;
	my_load(2,0,'myiframe0');
	OpenComp("DataObjectLibraryList","/AppConfig/PageMode/DWConfig/DataObjectLibraryList.jsp","DONO=<%=sDoNo%>","DetailFrame",""); 
</script>	
<%@ include file="/IncludeEnd.jsp"%>