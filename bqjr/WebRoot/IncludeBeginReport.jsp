<%@ include file="/IncludeBegin.jsp"%>
<%
String sDataSourceReport = CurConfig.getConfigure("DataSource_Report");
//������������Դ����ϵͳ������Դһ�£��������»�ȡ���ݿ�����
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
	    throw new Exception("�������ݿ�ʧ�ܣ����Ӳ�����<br>DataSource_Report:"+sDataSourceReport);
	}
}
%>