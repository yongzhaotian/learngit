<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	String PG_TITLE = "��ʾģ�����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	String sDONO = CurPage.getParameter("DONO");
	if(sDONO == null) sDONO = "";
    
 
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
  	String sTempletNo = "DataObjectLibraryList";//ģ�ͱ��
  	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
  	
    doTemp.setDDDWSql("DOCKID","select DockId,DockName from DATAOBJECT_GROUP where DONo='"+sDONO+"' order by SortNo");
    
    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sDONO);
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true", "All","Button","��������","��ǰҳ������","afterAdd()","","","","btn_icon_add"},
		{"true", "All","Button","���ٱ���","���ٱ��浱ǰҳ��","afterSave()","","","","btn_icon_save"},
		{"true", "All","Button","���ٸ���","���ٸ��Ƶ�ǰ��¼","quickCopy()","","","",""},
		{"true", "All", "Button", "ɾ��", "", "deleteRecord()", "", "", "", ""},
		{"true", "All", "Button", "������Ϣ����", "������Ϣ����", "setGroup()", "", "", "", "btn_icon_edit"},
	};
%>
<%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	var sDONO = "<%=sDONO%>";
	function afterSave(){
		as_save("myiframe0");
	}
	//��������
	function afterAdd(){
		as_add("myiframe0");
		//��������ʱ�����Ĭ��ֵ
		setItemValue(0,getRow(),"DONO",sDONO);
	}
	function quickCopy(){
//		if(as_isPageChanged()){
//			alert('ҳ���Ѿ��޸Ĺ��ˣ����ȱ��棡');
//		}else{
		var sColIndex = getItemValue(0,getRow(),"COLINDEX");
		var returnValue = RunJavaMethodTrans("com.amarsoft.app.util.DataObjectLibListAction","quickCopyLib","DONO="+sDONO+",ColIndex="+sColIndex);
		if(returnValue == 'SUCCESS'){
			alert('���Ƴɹ���');
			reloadSelf();
		}else alert('�Բ��𣬸���ʧ�ܣ�');
//		}
	}
	//����ɾ��
	function deleteRecord(){
		var sColIndex = getItemValue(0,getRow(),"COLINDEX");
		if (typeof(sColIndex)=="undefined" || sColIndex.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage("2"))){ //�������ɾ������Ϣ��
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function setGroup(){
		AsControl.PopView("/AppConfig/PageMode/DWConfig/DataObjectGroupList.jsp","DONo="+sDONO);
	}
</script>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>