<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 
		Input Param:
		Output param:
		History Log: xswang 20150505 CCS-637 PRM-293 ��˹��������Ҫ�㹦��ά��
	 */
	%>
 <%/*~END~*/%>
 
 <%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "ʾ���б�ҳ��";
	//���ҳ�����
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "AuditConfigurationList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);

	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
<%/*��¼��ѡ��ʱ�����¼�*/%>
function mySelectRow(){
	var sFlowNo = getItemValue(0,getRow(),"FlowNo");
	var sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
	if(typeof(sFlowNo)=="undefined" || sFlowNo.length==0 || typeof(sPhaseNo) == "undefined" || sPhaseNo.length == 0) {
		AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","frameright","");
	}else{
		// edit by xswang 20150505 CCS-637 PRM-293 ��˹��������Ҫ�㹦��ά��
		 AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelFrame.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"frameright","");
		/* AsControl.OpenView("/SystemManage/CarManage/AuditPointsModelInfoAdd.jsp","FlowNo="+sFlowNo+"&PhaseNo="+sPhaseNo,"frameright",""); */
		// end by xswang 20150505
	}
}

$(document).ready(function(){
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
