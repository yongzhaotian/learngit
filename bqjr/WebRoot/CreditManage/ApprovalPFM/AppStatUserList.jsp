<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 审批工作量统计管理
	 */
	String PG_TITLE = "审批工作量统计管理"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//定义变量
	String sSql;
	//获得组件参数	
	String sInputUser =  CurPage.getParameter("InputUser");
	if(sInputUser==null) sInputUser="";
	String sOrgID =  CurPage.getParameter("OrgID");

	//通过显示模版产生ASDataObject对象doTemp
    String sHeaders[][] = {
							   {"ApplyNO","申请编号"},
							   {"ApplicantID","申请人编号"},
                           {"ApplicantName","申请人名称"},
                           {"ApplyType","申请类型"},
                           {"OccurType","申请性质"},
                           {"ApplyDate","申请日期"},
                           {"ApplyTime","审批时间[小时]"},
                           };
	String sTempletFilter = "1=1"; //列过滤器，注意不要和数据过滤器混淆
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
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写

	//生成HTMLDataWindow
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