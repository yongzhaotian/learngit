<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "用户登录信息一览"; // 浏览器窗口标题 <title> PG_TITLE </title>
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","230");

	String  sTempletNo="UserLogonWelcomeList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//生成查询框
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) //默认不查询任何记录
		doTemp.WhereClause+=" and 1=2 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(40); //服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","PlainText","由于本页面数据量过大，请通过查询条件查询","由于本页面数据量过大，请通过查询条件查询","style={color:red}",sResourcesPath}		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	/*~[Describe=选中某个用户登陆信息,联动显示该用户登陆的详情信息;]~*/
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
	OpenPage("/Blank.jsp?TextToShow=请先选择相应的用户登陆信息!","DetailFrame","");
</script>
<%@include file="/IncludeEnd.jsp"%>