<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "Ӱ�������б�";
	//���ҳ�����
	String sStartWithId = CurComp.getParameter("StartWithId");
	if (sStartWithId == null) sStartWithId = "";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ImageTypeList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca, "0020", "TypeName", "Operators=EqualsString,BeginsWith;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	doTemp.setReadOnly("TypeNo", true);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	String sParam = "";
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�����¼","saveRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function newRecord(){
		as_add( "myiframe0" );
		var param = "StartWithId=<%=sStartWithId%>";
		var sNewExampleTypeNo = RunJavaMethodSqlca( "com.amarsoft.app.als.image.ImageUtil", "GetNewTypeNo", param );
		setItemValue( 0, getRow(), "TypeNo", sNewExampleTypeNo );
	}
	
	function saveRecord(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		var sTypeName = getItemValue(0,getRow(),"TypeNo");
		if( (typeof sTypeNo !="undefined") && (sTypeNo == "" || sTypeName == "") ){
			alert( "���ͱ�š��������Ʋ�����Ϊ��" );
			return;
		}else{
			as_save("myiframe0")
			parent.frames["frameleft"].reloadSelf();
		}
			
	}
	
	function deleteRecord(){
		var sTypeNo = getItemValue(0,getRow(),"TypeNo");
		if (typeof(sTypeNo)=="undefined" || sTypeNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			param = "imageTypeNo="+sTypeNo;
			RunJavaMethodSqlca( "com.amarsoft.app.als.image.ManagePRDImageRela", "delRelationByImageTypeNo", param );
		}
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
