<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: Excel�ļ������б�ҳ��
	 */
	String PG_TITLE = "Excel�ļ�����";
	
	String sHeaders[][] = {     
                            {"ID","���"},
                            {"Name","����"}
			          	  };   	  		   		
	String sSql = " select ID,Name from TEST_FILE ";
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "TEST_FILE";
	doTemp.setKey("ID",true);	 //Ϊ�����ɾ��
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����ظ�����Ϣ","newRecord()",sResourcesPath},		
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","�������ļ�","�������ļ�����Ϣ","getConfigInfo()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		popComp("FileChooseDialog","/Frame/Test/file/FileChooseDialog.jsp","","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	function getConfigInfo(){
		popComp("ReadConfigFile","/Frame/Test/file/ReadConfigFile.jsp","","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	function deleteRecord(){
		var sID = getItemValue(0,getRow(),"ID");
		if (typeof(sID)=="undefined" || sID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>