<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "�����ֽ��׼��ͻ��б�";
 
 	String path = request.getContextPath(); 
	//��ȡ��Ŀ·�����ṩ����ʹ��
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/"; 

	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ResCashAccessList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","ģ������","excelģ������","getExcelMould()",sResourcesPath},
		{"true","","Button","excel����","excel����","importData()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"false","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
	};

	if (CurUser.hasRole("1035")||CurUser.hasRole("1036")) {
		sButtons[0][0] = "false";
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*
	 * excelģ������
	 */
	function getExcelMould(){
		var path = "<%=basePath %>FormatDoc/Excel/";
		var file = path + "customer.xls";

		var left = (window.screen.availWidth-600)/2;
    	var top = (window.screen.availHeight-400)/2;
    	var features ='left='+left+',top='+top+',width=600,height=400';
    	var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll=no;status=no,menubar=no,'+features;
    	
    	window.open(file,'searchWin',style);
    	
    	//-- ���·��������У�һֱ��ʾ�Ҳ��� --//
    	//var src = "/AppConfig/ControlCenter/LogManage/FileView.jsp";

    	//AsControl.OpenView(src, "file="+file+"&ViewType=view", "", style);
	}
	
	//excel����
	function importData(){
			if(confirm("�ϴ�����������ɾ������ȫ�����ݣ���ȷ�ϣ�")){
				var sFilePath = AsControl.PopView("/BusinessManage/StoreManage/FileSelectForDataImport.jsp", "", "dialogWidth=450px;dialogHeight=200px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
				if (typeof(sFilePath)=="undefined" || sFilePath.length==0 || sFilePath == "_none_") {
					// ����Excel�� alert("��ѡ���ļ���");
					return;
				}
				var outmsg = RunJavaMethodSqlca("com.amarsoft.app.billions.ResCashExcelImport", "dataImportResCash", "filePath="+sFilePath+",userid="+"<%=CurUser.getUserID()%>"+",orgid="+"<%=CurUser.getOrgID()%>"+",inputdate="+"<%=DateX.format(new java.util.Date(),"yyyy/MM/dd")%>");
				if(outmsg == null) {
					alert("����ʧ��");
				} else {
					alert(outmsg);
				}
			}
			reloadSelf();
		}
	
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
	
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			reloadSelf();
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		sCompID = "ResCashAccessInfo";
		sCompURL = "/BusinessManage/CarCashAccess/CarCashAccessInfo.jsp";
		sCompParam = "SerialNo="+sSerialNo; //��ֵ����
		
		var left = (window.screen.availWidth-800)/2;
		var top = (window.screen.availHeight-400)/2;
		var features ='left='+left+',top='+top+',width='+800+',height='+400;
		var style = 'toolbar=no,scrollbars=yes,resizable=yes,scroll:no;status=no,menubar=no,'+features;
		
		popComp(sCompID, sCompURL, sCompParam , style);
	}
	


	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>

