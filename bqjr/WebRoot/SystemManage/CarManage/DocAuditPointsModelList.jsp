<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%>
 
 <%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  xswang 2015/05/25
		Tester:
		Content: �ļ�����������Ҫ�����
		Input Param:
		Output param:
		History Log: 
	*/
	%>
 <%/*~END~*/%>
 
 <%
	/*
		--ҳ��˵��: ʾ���б�ҳ��--
	 */
	String PG_TITLE = "�ļ�����������Ҫ�����";
	//���ҳ�����
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "ImageTypeListAuditPoints1";//ģ�ͱ��
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
	var sTypeNo = getItemValue(0,getRow(),"TypeNo");
	if(typeof(sTypeNo)=="undefined" || sTypeNo.length==0 || typeof(sTypeNo) == "undefined" || sTypeNo.length == 0) {
		AsControl.OpenView("/Blank.jsp","TextToShow=����ѡ����Ӧ����Ϣ!","frameright","");
	}else{
		 AsControl.OpenView("/SystemManage/CarManage/DocAuditPointsModelInfoAdd.jsp","TypeNo="+sTypeNo,"frameright","");
	}
}

$(document).ready(function(){
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
});
</script>	
<%@ include file="/IncludeEnd.jsp"%>
