<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "��ʾģ�������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	String sDONo = CurPage.getParameter("DONo");
	if(sDONo == null) sDONo = "";
	
        
  //ͨ��DWģ�Ͳ���ASDataObject����doTemp
  	String sTempletNo = "DataObjectGroupList";//ģ�ͱ��
  	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
   	
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
        
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDONo);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true", "All","Button","��������","��ǰҳ������","afterAdd()","","",""},
		{"true", "All","Button","���ٱ���","���ٱ��浱ǰҳ��","afterSave()","","",""},
		{"true", "All", "Button", "ɾ��", "", "deleteRecord()", "", "", ""},
	};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	var sDONo = "<%=sDONo%>";
	function afterSave(){
		as_save("myiframe0");
	}
	
	//��������
	function afterAdd(){
		as_add("myiframe0");
		//��������ʱ�����Ĭ��ֵ
		setItemValue(0,getRow(),"DONO",sDONo);
	}
	
	//����ɾ��
	function deleteRecord(){
		var sDockId = getItemValue(0,getRow(),"DOCKID");
		if (typeof(sDockId)=="undefined" || sDockId.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage("2"))){ //�������ɾ������Ϣ��
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@ include file="/IncludeEnd.jsp"%>