<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String sMatchType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MatchType"));
	String sInputDate =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputDate"));
	
	if(sMatchType == null) sMatchType="";
	if(sInputDate == null) sInputDate="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "TackbackFileList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sInputDate+","+sMatchType);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		//  ����  ����  �ر�  ��ʱ�ر�  ȡ���ر�
<<<<<<< .mine
		{"false","","Button","�ֹ�ƥ��","�ֹ�ƥ�仹��","newRecord()",sResourcesPath},
		{"false","","Button","����","�����Ѿ��ֹ�ƥ��Ļ���","deleteRecord()",sResourcesPath},
=======
		{"false","","Button","�ֹ�ƥ��","�鿴����","newRecord()",sResourcesPath},
>>>>>>> .r2300
	};
<<<<<<< .mine
	if ("01".equals(sMatchType)) sButtons[0][0] = "true";
	if ("03".equals(sMatchType)) sButtons[1][0] = "true";
=======
	if ("1".equals(sMatchType)) sButtons[0][0] = "true";
>>>>>>> .r2300
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	function newRecord(){
<<<<<<< .mine
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
=======
		var Serialno = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(Serialno)=="undefined" || Serialno.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/BankLinkInfo.jsp","SerialNo="+Serialno,"_self","");
>>>>>>> .r2300
	}
	
	function deleteRecord(){
		alert("�����Ѿ��ֹ�ƥ��Ļ��");
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/BusinessManage/RetailManage/RetailInfoTab.jsp","RSerialNo="+sSerialNo,"_blank","");
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

	$(document).ready(function(){
		AsOne.AsInit();
		//showFilterArea();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>