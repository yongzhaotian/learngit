<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: ����������ͳ�ƹ���
	 */
	String PG_TITLE = "����������ͳ�ƹ���"; // ��������ڱ��� <title> PG_TITLE </title>
	//�������
	String sSql;
	//����������	
	String sInputUser =  CurPage.getParameter("InputUser");
	if(sInputUser==null) sInputUser="";
	String sOrgID =  CurPage.getParameter("OrgID");

	//ͨ����ʾģ�����ASDataObject����doTemp
    String sHeaders[][] = {
							   {"ApplyNO","������"},
							   {"ApplicantID","�����˱��"},
                           {"ApplicantName","����������"},
                           {"ApplyType","��������"},
                           {"OccurType","��������"},
                           {"ApplyDate","��������"},
                           {"ApplyTime","����ʱ��[Сʱ]"},
                           };
	String sTempletFilter = "1=1"; //�й�������ע�ⲻҪ�����ݹ���������
	sSql = " select ApplyNO,ApplicantID,ApplicantName,getItemName('OccurType',OccurType) as OccurType,ApplyDate ,"+
			"24*( to_date(max(endTime),'YYYY/mm/dd HH24:MI:SS')-to_date(min(beginTime),'YYYY/mm/dd HH24:MI:SS')) as ApplyTime "+
			"from APPLY_INFO AI,Flow_Record FR where OrgID like '"+sOrgID+"%' and FR.ObjectNo=AI.ApplyNo "+
			"group by ApplyNO,ApplicantID,ApplicantName,OccurType,ApplyDate ";
				
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setColumnAttribute("ApplyNO","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.UpdateTable="EXAMPLE_INFO";
	doTemp.setKey("ExampleID",true);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	if(!sInputUser.equals("")) doTemp.WhereClause += " and InputUser = '"+sInputUser+"'";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	String sButtons[][] = {
	};	
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function mySelectRow(){
		sApplyNO = getItemValue(0,getRow(),"ApplyNO");	
		OpenPage("/CreditManage/ApprovalPFM/ApplyInfoTime.jsp?OrgID=<%=sOrgID%>&ApplyNO="+sApplyNO,"_self","");
	}
	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%@ include file="/IncludeEnd.jsp"%>