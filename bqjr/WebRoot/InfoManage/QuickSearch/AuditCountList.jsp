<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		ҳ��˵��: ʾ���б�ҳ��
	 */
	String PG_TITLE = "���Աͳ��";
	//���ҳ�����
	//String sInputUser =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("InputUser"));
    String sInputUser =CurUser.getUserID();
	
	//ͨ��DWģ�Ͳ���ASDataObject����doTemp
	String sTempletNo = "AuditCountList";//ģ�ͱ��
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	//CCS-164 ���ݲ�ͬ���ŵ�¼��Ա��ѯ�Ը���������������Ϣ  20150615 huzp
    if(CurUser.getOrgID().equals("10")){
    	doTemp.WhereClause=" where begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and (endTime = '' or endTime is null) and u.userid in (select userid from USER_INFO where BelongOrg in (select OrgID from ORG_INFO where SortNo like '101%') and isCar = '02')";
    }else if(CurUser.getOrgID().equals("11")){
    	doTemp.WhereClause=" where begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and (endTime = '' or endTime is null) and u.userid in (select userid from USER_INFO where BelongOrg in (select OrgID from ORG_INFO where SortNo like '102%') and isCar = '02')";
    }else{
    	doTemp.WhereClause=" where begintime <= to_char(sysdate, 'yyyy/mm/dd HH24:MI:SS') and begintime >= to_char(sysdate - 1, 'yyyy/mm/dd HH24:MI:SS') and (endTime = '' or endTime is null) and u.userid in (select userid from USER_INFO where BelongOrg in (select OrgID from ORG_INFO where SortNo in ('101','102') and isCar = '02'))";
 	}
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//CCS-732 update huzp 20150507  ��ҳÿҳ��ʾ15����¼
	dwTemp.setPageSize(15);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sInputUser);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","Button","����","����","newRecord()",sResourcesPath}
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
    function initRow(){
    	setTimeout("reloadSelf()", "60000");
    }

	$(document).ready(function(){
		AsOne.AsInit();
		showFilterArea();
		init();
		my_load(2,0,'myiframe0');
		initRow();
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>