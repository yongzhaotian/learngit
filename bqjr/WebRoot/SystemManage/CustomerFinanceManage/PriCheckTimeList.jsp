<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*
		Author:  xswang 2015/07/16
		Tester:
		Content: �������ʱ������
		Input Param:
		Output param:
		History Log: 
	*/
	String PG_TITLE = "�������ʱ������";

	// ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "PriCheckTimeInfo";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      // ����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; // �����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");//�������,���ŷָ�
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����һ�����ȼ�ʱ��������Ϣ","my_add()",sResourcesPath},
		{"true","","Button","����","�鿴���޸�","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","DeleteRecord()",sResourcesPath},
	};
%>
<%@include file="/Resources/CodeParts/Info05.jsp"%>
<script type="text/javascript">
	//����
	function my_add() {
		sCompID = "";
		sCompURL = "/SystemManage/CustomerFinanceManage/PriCheckTimeAdd.jsp";
		sParamString = "";
		popComp(sCompID,sCompURL,sParamString,"dialogWidth=550px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	//����
	function viewAndEdit() {
		var sPriority =getItemValue(0,getRow(),"Priority");
		var sTime =getItemValue(0,getRow(),"Time");
		if (typeof(sPriority)=="undefined" || sPriority.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "PriCheckTimeAdd";
		sCompURL = "/SystemManage/CustomerFinanceManage/PriCheckTimeAdd.jsp";
		sParamString = "Priority="+sPriority+"&Time="+sTime;
		popComp(sCompID,sCompURL,sParamString,"dialogWidth=550px;dialogHeight=500px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		reloadSelf();
	}
	
	//ɾ��
	function DeleteRecord() {
		var sPriority =getItemValue(0,getRow(),"Priority");
		if (typeof(sPriority)=="undefined" || sPriority.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm("ȷʵɾ���ü�¼��")){
			RunMethod("���÷���","DelByWhereClause","PriCheckTimeInfo,Priority='"+sPriority+"'");
			as_del("myiframe0");
			reloadSelf();
		}
	}
</script>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script type="text/javascript">	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>