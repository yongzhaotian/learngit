<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "ʾ���б�ҳ��";

	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "FeeAuditCategoryList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			{"false","","Button","ʹ��ObjectViewer��","ʹ��ObjectViewer��","openWithObjectViewer()",sResourcesPath},
		};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">

	<%/*��¼��ѡ��ʱ�����¼�*/%>
	function mySelectRow(){
		var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
		if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0) {
			AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","rightdown","");
		}else{
			AsControl.OpenView("/SystemManage/CarManage/FeeAuditModelList.jsp","FlowNo="+sFlowNo,"rightdown","");
		}
	}
	
	function newRecord(){
		AsControl.OpenView("/SystemManage/CarManage/FeeAuditCategoryInfo.jsp","","_self","");
	}
	
	function deleteRecord(){
		var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
		if (typeof(sFlowNo)=="undefined" || sFlowNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")){
			RunMethod("���÷���", "DelByWhereClause", "Flow_Model,FlowNo='"+sFlowNo+"'");
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			parent.parent.reloadSelf();
		}
	}

	function viewAndEdit(){
		var sFlowNo = getItemValue(0,getRow(),"FLOWNO");
		if (typeof(sFlowNo)=="undefined" || sFlowNo.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		AsControl.OpenView("/SystemManage/CarManage/FeeAuditCategoryInfo.jsp","FlowNo="+sFlowNo,"_self","");
	}

	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>