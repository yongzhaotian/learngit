<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	String sExecutorCode =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ExecutorCode"));//һ���ж�����
	String sIsSelected =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IsSelected"));//һ���ж�����
	if(sExecutorCode==null) sExecutorCode="";
	if(sIsSelected==null)sIsSelected="";
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ActionCodeList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
 
	if(sIsSelected.equals("true")){
		doTemp.multiSelectionEnabled=true;
		doTemp.WhereClause+=" and CodeCategory='"+sExecutorCode+"'";
	}
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
		{"false","","Button","ȷ��","���ض����ж�����","returnSubExecutorCode()",sResourcesPath},
	};
	
	if(sIsSelected.equals("true")){
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[3][0]="true";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function returnSubExecutorCode(){
		var sSubExecutorCode = getItemValueArray(0,"Describe");//�����ж�����
		if(sSubExecutorCode.length!=1){
			 alert("������ֻ�ܹ�ѡһ��ί���ʲ����÷�");
			 return;
		 }
		else if(sSubExecutorCode[0]==""||sSubExecutorCode[0]==null){
			alert("�ü�¼�еĶ����ж����벻��Ϊ��!");
			return;
		}
		self.returnValue=sSubExecutorCode[0];
		self.close();
	}
	function newRecord(){
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/ActionCodeInfo.jsp","","_self","");
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
		}
	}

	function viewAndEdit(){
		
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/ConsumeLoanManage/ActionCodeInfo.jsp","SerialNo="+sSerialNo,"_self","");
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