<%@ include file="/IncludeBegin.jsp"%>
<%
String sDataSourceReport = CurConfig.getConfigure("DataSource_Report");
//如果报表的数据源和主系统的数据源一致，则不再重新获取数据库连接
if (!sDataSource.equals(sDataSourceReport)) {
	if(Sqlca != SqlcaRepository)
	{
	    Sqlca.commit();
	    Sqlca.disConnect();
	    Sqlca = null;
	}
	
	try{
	    Sqlca = new Transaction(sDataSourceReport);
	}catch(Exception ex){
		ex.printStackTrace();
	    throw new Exception("连接数据库失败！连接参数：<br>DataSource_Report:"+sDataSourceReport);
	}
}
%>