<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: �ֻ�����������б�ҳ��
	 */
	String PG_TITLE = "�ֻ�����������б�ҳ��";
 
	String path = request.getContextPath(); 
	//��ȡ��Ŀ·�����ṩ����ʹ��
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "GrayListMobile";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) {
		// doTemp.WhereClause+=" and 1=2"; // �������������ʱ��Ĭ�ϲ���ѯ���ݣ�����������ݲ�ѯ�Ỻ����
	}
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","excel����","excel����","importRecords()",sResourcesPath},
		{"true","","Button","excelģ������","excelģ������","downExcelMould()",sResourcesPath},
		{"false","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
/*
 * excelģ������
 */
function downExcelMould() {
	var file = "<%=basePath %>/FormatDoc/Excel/graylistmobile.xls";

	var left = (window.screen.availWidth-600)/2;
	var top = (window.screen.availHeight-400)/2;
	var features ='left='+left+',top='+top+',width=600,height=400';
	var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll=no;status=no,menubar=no,'+features;
	
	window.open(file,'searchWin',style);
	
	//-- ���·��������У�һֱ��ʾ�Ҳ��� --//
	//var src = "/AppConfig/ControlCenter/LogManage/FileView.jsp";
	//AsControl.OpenView(src, "file="+file+"&ViewType=view", "", style);
}

	function newRecord(){
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/GrayListMobileInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			RunMethod("GrayList_MODEL","delData","GrayListMobile,"+sSerialNo);
			//as_del("myiframe0");
			//as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/CustomerFinanceManage/GrayListMobileInfo.jsp","SERIALNO="+sSerialNo,"_self","");
	}
	function importRecords(){
		var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sFilePath)=="undefined" || sFilePath.length==0 || sFilePath=="_none_") {
			// ����Excel�� alert("��ѡ���ļ���");
			return;
		}
		RunJavaMethodSqlca("com.amarsoft.app.billions.ExcelDataImport", "importGrayListMobileModel", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=StringFunction.getTodayNow()%>");
		//���������ظ�������
	    RunMethod("GrayList_MODEL","delMulti_1","GrayListMobile,PHONE");
		reloadSelf();
	}
	
	<%/*~[Describe=ʹ��ObjectViewer��;InputParam=��;OutPutParam=��;]~*/%>
	function openWithObjectViewer(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		AsControl.OpenObject("Example",sExampleId,"001");//ʹ��ObjectViewer����ͼ001��Example��
	}
	
	checkMobile = function(v){}

	$(document).ready(function(){
		AsOne.AsInit();
//		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
