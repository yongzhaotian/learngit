<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ������ģ��Ŀ¼�б�
	 */
	String PG_TITLE = "������ģ��Ŀ¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	

 	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
 	String sTempletNo = "ClassifyCatalogList";//ģ�ͱ��
 	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
 	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
   	dwTemp.setPageSize(200);

	//��������¼�
	dwTemp.setEvent("BeforeDelete","!Configurator.DelClassifyModel(#ModelNo)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ģ���б�","�鿴/�޸�ģ���б�","viewAndEdit2()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		var sReturn=popComp("ClassifyCatalogInfo","/Common/Configurator/ClassifyManage/ClassifyCatalogInfo.jsp","","");
		if (typeof(sReturn)!='undefined' && sReturn.length!=0){
  	    	//�������ݺ�ˢ���б�
  	    	if (typeof(sReturn)!='undefined' && sReturn.length!=0){
    	    	sReturnValues = sReturn.split("@");
    	    	if (sReturnValues[0].length !=0 && sReturnValues[1]=="Y"){
    	    	    OpenPage("/Common/Configurator/ClassifyManage/ClassifyCatalogList.jsp","_self","");    
    	    	}
  	    	}
       	}
	}
	
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
       //openObject("ClassifyCatalogView",sModelNo,"001");
       popComp("ClassifyCatalogView","/Common/Configurator/ClassifyManage/ClassifyCatalogView.jsp","ObjectNo="+sModelNo+"&ItemID=0010","");
	}
    
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit2(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
          	return ;
		}
       //popComp("ClassifyModelList","/Common/Configurator/ClassifyManage/ClassifyModelList.jsp","ModelNo="+sModelNo,"");
       popComp("ClassifyCatalogView","/Common/Configurator/ClassifyManage/ClassifyCatalogView.jsp","ObjectNo="+sModelNo+"&ItemID=0020","");
	}

	function deleteRecord(){
		var sModelNo = getItemValue(0,getRow(),"ModelNo");
		if(typeof(sModelNo)=="undefined" || sModelNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('51'))){
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