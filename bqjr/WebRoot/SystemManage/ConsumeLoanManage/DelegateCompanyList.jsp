<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String sTemp =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("temp"));
	String sSerialNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";
	if(sTemp==null) sTemp="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "DelegateCompanyList";//ģ�ͱ��
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"false","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
	};
	if(sTemp.equals("002")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	 /*~[Describe=��¼��ѡ�еĴ���ʱ��;InputParam=��;OutPutParam=��;]~*/
	function mySelectRow(){
		var sObjectNO = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sObjectNO)=="undefined" || sObjectNO.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","rightdown","");
		}else{
			AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCompanyCityList.jsp","ObjectNO="+sObjectNO+"&temp=<%=sTemp%>&SerialNo=<%=sSerialNo%>","rightdown","");
		}
	}

	function newRecord(){
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCompanyInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			as_del("myiframe0");
			// ����ɾ��ί�⹫˾��������
			RunMethod("���÷���", "DelByWhereClause", "DELEGATECOMPANY_RELATIVE,ObjectNo='"+sSerialNo+"'");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			parent.reloadSelf();
		}
	}

	function viewAndEdit(){
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/DelegateCompanyInfo.jsp","SerialNo="+sSerialNo,"_self","");
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
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>