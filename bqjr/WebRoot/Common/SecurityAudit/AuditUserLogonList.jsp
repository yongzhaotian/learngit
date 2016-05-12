<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	String PG_TITLE = "用户访问时间日志"; // 浏览器窗口标题 <title> PG_TITLE </title>

	//获得页面参数：用户号
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("UserID"));
	if(sUserID == null) sUserID = "";
                      
	String sHeaders[][] = {
								{"ListID","序号"},
								{"UserID","用户号"},
								{"UserName","用户名称"},
								{"OrgID","机构号"},
								{"OrgName","机构名称"},
								{"BeginTime","开始访问时间"},
								{"EndTime","退出系统时间(空值表示在线或异常退出)"},
							}; 

 	String sSql = "select SessionID,UserID,UserName,OrgID,OrgName,BeginTime,EndTime from USER_LIST where UserId='"+sUserID+"'";
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);	
	doTemp.UpdateTable = "USER_LIST";
	doTemp.setKey("SessionID",true);
	doTemp.setVisible("SessionID",false);	
	
	doTemp.setHTMLStyle("UserName"," style={width:120px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:160px} ");
	doTemp.setHTMLStyle("UserID,OrgID"," style={width:60px} ");
	
	//doTemp.setCheckFormat("BeginTime,EndTime","3");
	//生成查询框
	//doTemp.setColumnAttribute("UserName,OrgID,OrgName,BeginTime,EndTime","IsFilter","1");
	//doTemp.generateFilters(Sqlca);
	//doTemp.parseFilterData(request,iPostChange);
	//CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//if(!doTemp.haveReceivedFilterCriteria()) 
	//    doTemp.WhereClause+=" and BeginTime like '"+StringFunction.getToday()+"%' and EndTime is null ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(40); //服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"false","","PlainText","由于本页面数据量过大，请通过查询条件查询","由于本页面数据量过大，请通过查询条件查询","style={color:red}",sResourcesPath}		
	};
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%@include file="/IncludeEnd.jsp"%>