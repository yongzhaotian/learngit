<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "�û���¼��Ϣһ��"; // ��������ڱ��� <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","230");

	String  sTempletNo="UserLogonWelcomeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) //Ĭ�ϲ���ѯ�κμ�¼
		doTemp.WhereClause+=" and 1=2 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(40); //��������ҳ
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","PlainText","���ڱ�ҳ��������������ͨ����ѯ������ѯ","���ڱ�ҳ��������������ͨ����ѯ������ѯ","style={color:red}",sResourcesPath}		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=ѡ��ĳ���û���½��Ϣ,������ʾ���û���½��������Ϣ;]~*/
	function mySelectRow(){
		var sUserID = getItemValue(0,getRow(),"UserID");
		if(typeof(sUserID)=="undefined" || sUserID.length==0) {}else{
			OpenPage("/Common/SecurityAudit/AuditUserLogonList.jsp?UserID="+sUserID,"DetailFrame","");
		}
	}

	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
	OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ���û���½��Ϣ!","DetailFrame","");
</script>
<%@include file="/IncludeEnd.jsp"%>