<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
	//if(sInputUser==null) sInputUser="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "CommecialConsultList";//ģ�ͱ��
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
		{"false","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"false","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"false","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
		{"false","","Button","����","�鿴����¼��/�޸�����","viewAndEdit()",sResourcesPath},
		{"false","","Button","¼�������ʷ","¼�������ʷ","newRecord()",sResourcesPath},
		{"false","","Button","������ʷ��ѯ","������ʷ��ѯ","newRecord()",sResourcesPath},
		{CurUser.getRoleTable().contains("2001")?"true":"false","","Button","����EXCEL","����EXCEL","exportExcel()",sResourcesPath},

	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	
	//Excel����������	
	function exportExcel(){
		<%
			//����Excelʱֻ������Ӧ���ֶ�CSS-776
			doTemp.setVisible("PHONE", true);
			dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
			dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
			dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
			dwTemp.setPageSize(10);  //��������ҳ
			dwTemp.genHTMLDataWindow("");
		%>
	
		amarExport("myiframe0");
	}

	function newRecord(){
		AsControl.OpenView("/FrameCase/ExampleInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sExampleId = getItemValue(0,getRow(),"ExampleId");
		if (typeof(sExampleId)=="undefined" || sExampleId.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/CustomService/BusinessConsult/ReservCommecialConsultInfo.jsp","SerialNo="+sSerialNo+"&ViewId=02","_self","");
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

	$(document).ready(function(){
		showFilterArea();
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>