<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<% 
	/*
		Author: 
		Tester:
		Describe: ��ʾ�ͻ���ص��ֽ���Ԥ��
		Input Param:
			CustomerID �� ��ǰ�ͻ����
			BaseYear   : ��׼���:�������������һ��  
			YearCount  : Ԥ������:default=1
			ReportScope: ����ھ�
		Output Param:
			
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    �µİ汾�ĸ�д
	 */
  %>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ��ֽ�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
     int iCount = 0;
	 ASResultSet rs = null;
    //���ҳ�����
 	 String sCustomerID = DataConvert.toRealString(CurPage.getParameter("CustomerID"));  
	 String sBaseYear = DataConvert.toRealString(CurPage.getParameter("BaseYear"));		
	 String sYearCount = DataConvert.toRealString(CurPage.getParameter("YearCount"));    
	 String sReportScope = DataConvert.toRealString(CurPage.getParameter("ReportScope"));
    //����������

%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=����׼��������;]~*/%>
<%
	String sNewSql = "select count(*) from CashFlow_Record where CustomerID = :CustomerID and BaseYear = :BaseYear and ReportScope = :ReportScope and FCN = :FCN" ;
	SqlObject so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("BaseYear",sBaseYear);
	so.setParameter("ReportScope",sReportScope);
	so.setParameter("FCN",sYearCount);
	rs = Sqlca.getResultSet(so);
	if(rs.next())
		iCount = rs.getInt(1);
	rs.getStatement().close();

	if(iCount > 0){
%>
		<script type="text/javascript">
			alert(getBusinessMessage('184'));//Ԥ���¼�Ѵ��ڣ����������Ӽ�¼��
			OpenPage("/CustomerManage/FinanceAnalyse/CashFlowList.jsp","_self","");
			//self.close();
		</script>
<%
		return;
	}

	String sSql = "";
	String sYear1,sYear2,sYear3,sYear4,sYear5,sYear6,sMonth1,sMonth2,sMonth3,sMonth4,sMonth5,sMonth6;
	String sReport1,sReport2,sReport3;

	sYear1 = sBaseYear;														//ǰһ��
	sMonth1 = sYear1 + "/12";
	sYear2 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 1);		//ǰ����
	sMonth2 = sYear2 + "/12";
	sYear3 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 2);		//ǰ����
	sMonth3 = sYear3 + "/12";
	sYear4 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 3);		//ǰ����
	sMonth4 = sYear4 + "/12";
	sYear5 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 4);		//ǰ����
	sMonth5 = sYear5 + "/12";
	sYear6 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 5);		//ǰ����
	sMonth6 = sYear6 + "/12";

	//ֻ�в��񱨱������ǡ���ҵ���ˡ�(001)�Ŀͻ��������ֽ���Ԥ�⣡
	sReport1 = "%1";				//�ʲ���ծ��
	sReport2 = "%2";				//�����
	//sReport3 = "";				//һ����ҵ��������

	//init �ȼ���ǰ�����м����б���������ƽ��ֵ
	int iReportCount = 0;
	sSql = 	"select count(distinct reportdate) "+
			"  from customer_fsrecord " +
			" where CustomerID = :CustomerID "+
			"   and reportdate in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) " +
			"   and ReportScope = :ReportScope";
	so=new SqlObject(sSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next())
		iReportCount = rs.getInt(1);
	rs.getStatement().close();
	if(iReportCount==0)
	{
%>
		<script type="text/javascript">
			alert(getBusinessMessage('185'));//������Ҫ��5���е�һ��Ĳ��񱨱���ܽ����ֽ�������Ԥ�⣡
			alert("������������"+<%=sYear5%>+"��"+<%=sYear4%>+"��"+<%=sYear3%>+"��"+<%=sYear2%>+"��"+<%=sYear1%>+"�굱�е�һ��Ĳ��񱨱�");
			OpenPage("/CustomerManage/FinanceAnalyse/CashFlowList.jsp","_self","");
			//self.close();
		</script>
<%
		return;
	}


//ע�⣺
//1������ʱϵͳҪ�����ڱ���λ�ͻ���ͳһΪ�������Ԫ��
//		System.out.println( CreditlineManage.getERate("14","01",Sqlca));
//		select geterate('14','01','2003/01/01') as a1 from dual;
//      select getreportcurrency('2002/12','010000000000392','02') as a2 from dual;
//	sSql = 	"select AccountMonth,geterate(getreportcurrency(AccountMonth,CustomerID,Scope),'01',AccountMonth)*Item2Value as a2 "+
//	sSql = 	"select AccountMonth,Item2Value as a2 "+
//2����ʾ������ʱ��������˵���⣬��"%"��ʾ������2λС����
//   ���û�и��ڱ�����ʾΪ��ֵ������и��ڱ�����û�и���ֵ����ʾΪ"0"��--->1.default=0,2.insert,3.if no month,then update set null

	//���£����ɲ���������


	//0 - ��Ӫҵ������ Sales (��������У����501)
	double p0_1 = 0, p0_2 = 0, p0_3 = 0, p0_4 = 0, p0_5 = 0, p0_6 = 0, p0_a = 0;

	sSql = 	"select AccountMonth,Item2Value as a2 "+
		"  from Finance_Data "+
		" where CustomerID = :CustomerID "+
		"   and AccountMonth in ( :sMonth6,:sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
		"   and ModelNo like :Report2  "+
		"   and Scope = :Scope "+
		"   and FinanceItemNo = '501'" +
		" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth6",sMonth6);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report2",sReport2);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth6)) p0_6 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth5)) p0_5 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) p0_4 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) p0_3 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) p0_2 = rs.getDouble(2)/10000;

		if(rs.getString(1).equals(sMonth1)) p0_1 = rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	p0_a = ( p0_1+p0_2+p0_3+p0_4+p0_5)/iReportCount;


	//1 - G ��Ӫҵ������������
	double p1_1 = 0, p1_2 = 0, p1_3 = 0, p1_4 = 0, p1_5 = 0, p1_a = 0;
	int iCC = 0;

	if(p0_2 != 0) { p1_1 = (p0_1 - p0_2)/p0_2; iCC++; } 			//ǰһ�����Ӫҵ������������
	if(p0_3 != 0) { p1_2 = (p0_2 - p0_3)/p0_3; iCC++; }             //ǰ�������Ӫҵ������������
	if(p0_4 != 0) { p1_3 = (p0_3 - p0_4)/p0_4; iCC++; }             //ǰ�������Ӫҵ������������
	if(p0_5 != 0) { p1_4 = (p0_4 - p0_5)/p0_5; iCC++; }             //ǰ�������Ӫҵ������������
	if(p0_6 != 0) { p1_5 = (p0_5 - p0_6)/p0_6; iCC++; }             //ǰ�������Ӫҵ������������
	if(iCC  != 0) p1_a = (p1_1+p1_2+p1_3+p1_4+p1_5)/iCC;            //ƽ����Ӫҵ������������

	//2 - ��Ӫҵ��ɱ� (��������У����502)
	double tp2_1 = 0,tp2_2 = 0,tp2_3 = 0,tp2_4 =0,tp2_5 = 0;

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report2  "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '502'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report2",sReport2);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp2_5 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp2_4 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp2_3 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp2_2 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp2_1 = rs.getDouble(2)/10000;
	}
	rs.getStatement().close();


	//Cost:��Ӫҵ��ɱ�/��Ӫҵ������
	double p2_1 = 0,p2_2 = 0,p2_3 = 0,p2_4 =0,p2_5=0, p2_a = 0;

	if(p0_1 != 0) p2_1 = tp2_1/p0_1;
	if(p0_2 != 0) p2_2 = tp2_2/p0_2;
	if(p0_3 != 0) p2_3 = tp2_3/p0_3;
	if(p0_4 != 0) p2_4 = tp2_4/p0_4;
	if(p0_5 != 0) p2_5 = tp2_5/p0_5;
	p2_a = (p2_1 + p2_2 + p2_3+p2_4+p2_5)/iReportCount;

	//3��Oper_tax����Ӫҵ��˰�𼰸���(�������504)/��Ӫҵ������(501)
	double tp3_1 = 0,tp3_2 = 0,tp3_3 = 0,tp3_4 =0,tp3_5 = 0;

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) " +
			"   and ModelNo like :Report2 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '504'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report2",sReport2);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp3_5 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp3_4 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp3_3 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp3_2 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp3_1 = rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	//Oper_tax����Ӫҵ��˰�𼰸���(�������504)/��Ӫҵ������(501)
	double p3_1 = 0,p3_2 = 0,p3_3 = 0,p3_4 =0,p3_5=0, p3_a = 0;

	if(p0_1 != 0) p3_1 = tp3_1/p0_1;
	if(p0_2 != 0) p3_2 = tp3_2/p0_2;
	if(p0_3 != 0) p3_3 = tp3_3/p0_3;
	if(p0_4 != 0) p3_4 = tp3_4/p0_4;
	if(p0_5 != 0) p3_5 = tp3_5/p0_5;
	p3_a = (p3_1 + p3_2 + p3_3+p3_4+p3_5)/iReportCount;

	//4��Sale_fee����Ӫҵ����(�������503)+������Ӫҵ��ɱ�(502)��/��Ӫҵ������
	double tp4_1 = 0,tp4_2 = 0,tp4_3 = 0,tp4_4 =0,tp4_5 = 0;

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report2  "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '503'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report2",sReport2);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);	
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp4_5 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp4_4 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp4_3 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp4_2 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp4_1 = rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report2 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '502'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report2",sReport2);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp4_5 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp4_4 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp4_3 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp4_2 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp4_1 += rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	//Oper_tax��
	double p4_1 = 0,p4_2 = 0,p4_3 = 0,p4_4 =0,p4_5=0, p4_a = 0;

	if(p0_1 != 0) p4_1 = tp4_1/p0_1;
	if(p0_2 != 0) p4_2 = tp4_2/p0_2;
	if(p0_3 != 0) p4_3 = tp4_3/p0_3;
	if(p0_4 != 0) p4_4 = tp4_4/p0_4;
	if(p0_5 != 0) p4_5 = tp4_5/p0_5;
	p4_a = (p4_1 + p4_2 + p4_3+p4_4+p4_5)/iReportCount;



	//5��General_fee���������(507)/��Ӫҵ������
	double tp5_1 = 0,tp5_2 = 0,tp5_3 = 0,tp5_4 =0,tp5_5 = 0;

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report2  "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '507'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report2",sReport2);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp5_5 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp5_4 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp5_3 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp5_2 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp5_1 = rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	//����:
	double p5_1 = 0,p5_2 = 0,p5_3 = 0,p5_4 =0,p5_5=0, p5_a = 0;

	if(p0_1 != 0) p5_1 = tp5_1/p0_1;
	if(p0_2 != 0) p5_2 = tp5_2/p0_2;
	if(p0_3 != 0) p5_3 = tp5_3/p0_3;
	if(p0_4 != 0) p5_4 = tp5_4/p0_4;
	if(p0_5 != 0) p5_5 = tp5_5/p0_5;
	p5_a = (p5_1 + p5_2 + p5_3+p5_4+p5_5)/iReportCount;

	//6��Other_income������ҵ������(506)/��Ӫҵ������
	double tp6_1 = 0,tp6_2 = 0,tp6_3 = 0,tp6_4 =0,tp6_5 = 0;

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report2  "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '506'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report2",sReport2);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp6_5 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp6_4 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp6_3 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp6_2 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp6_1 = rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	//����:
	double p6_1 = 0,p6_2 = 0,p6_3 = 0,p6_4 =0,p6_5=0, p6_a = 0;

	if(p0_1 != 0) p6_1 = tp6_1/p0_1;
	if(p0_2 != 0) p6_2 = tp6_2/p0_2;
	if(p0_3 != 0) p6_3 = tp6_3/p0_3;
	if(p0_4 != 0) p6_4 = tp6_4/p0_4;
	if(p0_5 != 0) p6_5 = tp6_5/p0_5;
	p6_a = (p6_1 + p6_2 + p6_3+p6_4+p6_5)/iReportCount;


	//7��CurrA���������ʲ�(801)�������ʽ�(101)�Ͷ���Ͷ��(102)��/��Ӫҵ������
	double tp7_1 = 0,tp7_2 = 0,tp7_3 = 0,tp7_4 =0,tp7_5 = 0;

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1  "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '801'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp7_5 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp7_4 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp7_3 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp7_2 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp7_1 = rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) " +
			"   and ModelNo like :Report1  "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '101'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp7_5 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp7_4 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp7_3 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp7_2 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp7_1 -= rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID  "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '102'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp7_5 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp7_4 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp7_3 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp7_2 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp7_1 -= rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	//����:
	double p7_1 = 0,p7_2 = 0,p7_3 = 0,p7_4 =0,p7_5=0, p7_a = 0;

	if(p0_1 != 0) p7_1 = tp7_1/p0_1;
	if(p0_2 != 0) p7_2 = tp7_2/p0_2;
	if(p0_3 != 0) p7_3 = tp7_3/p0_3;
	if(p0_4 != 0) p7_4 = tp7_4/p0_4;
	if(p0_5 != 0) p7_5 = tp7_5/p0_5;
	p7_a = (p7_1 + p7_2 + p7_3+p7_4+p7_5)/iReportCount;

	//8��CurrL����������ծ805�����ڽ��201��һ���ڵ��ڵĳ��ڸ�ծ211��/��Ӫҵ������
	double tp8_1 = 0,tp8_2 = 0,tp8_3 = 0,tp8_4 =0,tp8_5 = 0;

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '805'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp8_5 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp8_4 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp8_3 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp8_2 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp8_1 = rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1  "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '201'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp8_5 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp8_4 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp8_3 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp8_2 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp8_1 -= rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1   "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '211'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp8_5 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp8_4 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp8_3 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp8_2 -= rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp8_1 -= rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	//����:
	double p8_1 = 0,p8_2 = 0,p8_3 = 0,p8_4 =0,p8_5=0, p8_a = 0;

	if(p0_1 != 0) p8_1 = tp8_1/p0_1;
	if(p0_2 != 0) p8_2 = tp8_2/p0_2;
	if(p0_3 != 0) p8_3 = tp8_3/p0_3;
	if(p0_4 != 0) p8_4 = tp8_4/p0_4;
	if(p0_5 != 0) p8_5 = tp8_5/p0_5;
	p8_a = (p8_1 + p8_2 + p8_3+p8_4+p8_5)/iReportCount;

	//9��Long_asset���̶��ʲ���ֵ119�������ʲ�123/��Ӫҵ������
	double tp9_1 = 0,tp9_2 = 0,tp9_3 = 0,tp9_4 =0,tp9_5 = 0;

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '119'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp9_5 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp9_4 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp9_3 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp9_2 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp9_1 = rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1  "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '123'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp9_5 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp9_4 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp9_3 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp9_2 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp9_1 += rs.getDouble(2)/10000;
	}
	rs.getStatement().close();


	//����:
	double p9_1 = 0,p9_2 = 0,p9_3 = 0,p9_4 =0,p9_5=0, p9_a = 0;

	if(p0_1 != 0) p9_1 = tp9_1/p0_1;
	if(p0_2 != 0) p9_2 = tp9_2/p0_2;
	if(p0_3 != 0) p9_3 = tp9_3/p0_3;
	if(p0_4 != 0) p9_4 = tp9_4/p0_4;
	if(p0_5 != 0) p9_5 = tp9_5/p0_5;
	p9_a = (p9_1 + p9_2 + p9_3+p9_4+p9_5)/iReportCount;


	//10��D&A�������۾ɺ�̯���ܶ�109report3)/�����ĩƽ��(�̶��ʲ���ֵ+�����ʲ�)
	double tp10_1 = 0,tp10_2 = 0,tp10_3 = 0,tp10_4 =0,tp10_5 = 0;

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) " +
			"   and ModelNo like :Report1 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '109'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp10_5 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tp10_4 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tp10_3 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tp10_2 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) tp10_1 = rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	//���(�̶��ʲ���ֵ+�����ʲ�)--���������item1Value�������ڲ����룬����Ҫȡ������ĩ
	double tt9_1 = 0,tt9_2 = 0,tt9_3 = 0,tt9_4 =0,tt9_5 = 0;
	//�̶��ʲ���ֵ
	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth6,:sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '119'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth6",sMonth6);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth6)) tt9_5 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth5)) tt9_4 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tt9_3 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tt9_2 = rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tt9_1 = rs.getDouble(2)/10000;
	}
	rs.getStatement().close();
	//�����ʲ�
	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth6,:sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '123'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth6",sMonth6);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth6)) tt9_5 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth5)) tt9_4 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth4)) tt9_3 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth3)) tt9_2 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth2)) tt9_1 += rs.getDouble(2)/10000;
	}
	rs.getStatement().close();
	//���䣺�������������������ĩ����������ޱ������ñ�����ĩֵ
		sSql = 	"select count(*) from customer_fsrecord where CustomerID = :CustomerID and reportdate = :reportdate and ReportScope = :ReportScope  ";
		so = new SqlObject(sSql);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("reportdate",sMonth6);
		so.setParameter("ReportScope",sReportScope);
        rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) tt9_5 = tp9_5;
        rs.getStatement().close();
        so = new SqlObject(sSql);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("reportdate",sMonth5);
		so.setParameter("ReportScope",sReportScope);
        rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) tt9_4 = tp9_4;
        rs.getStatement().close();
        so = new SqlObject(sSql);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("reportdate",sMonth4);
		so.setParameter("ReportScope",sReportScope);
        rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) tt9_3 = tp9_3;
        rs.getStatement().close();
        so = new SqlObject(sSql);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("reportdate",sMonth3);
		so.setParameter("ReportScope",sReportScope);
        rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) tt9_2 = tp9_2;
        rs.getStatement().close();
        so = new SqlObject(sSql);
		so.setParameter("CustomerID",sCustomerID);
		so.setParameter("reportdate",sMonth2);
		so.setParameter("ReportScope",sReportScope);
        rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) tt9_1 = tp9_1;
        rs.getStatement().close();


	//����:
	double p10_1 = 0,p10_2 = 0,p10_3 = 0,p10_4 =0,p10_5=0, p10_a = 0;

	if( (tt9_1+tp9_1) != 0) p10_1 = tp10_1*2/(tt9_1+tp9_1);
	if( (tt9_2+tp9_2) != 0) p10_2 = tp10_2*2/(tt9_2+tp9_2);
	if( (tt9_3+tp9_3) != 0) p10_3 = tp10_3*2/(tt9_3+tp9_3);
	if( (tt9_4+tp9_4) != 0) p10_4 = tp10_4*2/(tt9_4+tp9_4);
	if( (tt9_5+tp9_5) != 0) p10_5 = tp10_5*2/(tt9_5+tp9_5);
	p10_a = (p10_1 + p10_2 + p10_3+p10_4+p10_5)/iReportCount;


	//11��Tax������˰�� = �����������˰(516)/�����ܶ�(515)
	//         ��ĳ�������˰�ʡ�0ʱ�������ݲ��μ�ƽ��ֵ���㣬����"0"ֵ��ʾ���˴���ʾ"��Ҫ�ο��˶�������˰����д�ٶ�ֵ"��
	//         �˴���ʾ"��Ҫ�ο��˶�������˰����д�ٶ�ֵ"��
	double tp11_1 = 0,tp11_2 = 0,tp11_3 = 0,tp11_4 =0,tp11_5 = 0;
	int i11Count = 0;
	//����:
	double p11_1 = 0,p11_2 = 0,p11_3 = 0,p11_4 =0,p11_5=0, p11_a = 0;

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report2 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '516'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report2",sReport2);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5)) tp11_5 = rs.getDouble(2);
		if(rs.getString(1).equals(sMonth4)) tp11_4 = rs.getDouble(2);
		if(rs.getString(1).equals(sMonth3)) tp11_3 = rs.getDouble(2);
		if(rs.getString(1).equals(sMonth2)) tp11_2 = rs.getDouble(2);
		if(rs.getString(1).equals(sMonth1)) tp11_1 = rs.getDouble(2);
	}
	rs.getStatement().close();

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth5,:sMonth4,:sMonth3,:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report2  "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '515'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth5",sMonth5);
	so.setParameter("sMonth4",sMonth4);
	so.setParameter("sMonth3",sMonth3);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report2",sReport2);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth5) && rs.getDouble(2)!=0 ){
			tp11_5 /= rs.getDouble(2);
			if(tp11_5<=0)  p11_5 = 0;
			else          {p11_5 = tp11_5 ;i11Count++; }
		}
		if(rs.getString(1).equals(sMonth4) && rs.getDouble(2)!=0 ){
			tp11_4 /= rs.getDouble(2);
			if(tp11_4<=0)  p11_4 = 0;
			else          {p11_4 = tp11_4 ;i11Count++; }
		}
		if(rs.getString(1).equals(sMonth3) && rs.getDouble(2)!=0 ){
			tp11_3 /= rs.getDouble(2);
			if(tp11_3<=0)  p11_3 = 0;
			else          {p11_3 = tp11_3 ;i11Count++; }
		}
		if(rs.getString(1).equals(sMonth2) && rs.getDouble(2)!=0 ){
			tp11_2 /= rs.getDouble(2);
			if(tp11_2<=0)  p11_2 = 0;
			else          {p11_2 = tp11_2 ;i11Count++; }
		}
		if(rs.getString(1).equals(sMonth1) && rs.getDouble(2)!=0 ){
			tp11_1 /= rs.getDouble(2);
			if(tp11_1<=0)  p11_1 = 0;
			else          {p11_1 = tp11_1 ;i11Count++; }
		}
	}
	rs.getStatement().close();

	if(i11Count!=0)
		p11_a = (p11_1 + p11_2 + p11_3+p11_4+p11_5)/i11Count;


	//12��debt����Ϣծ���ܶ���ڽ��201��һ���ڵ��ڵĳ��ڸ�ծ211�����ڽ��213��Ӧ��ծȯ214������Ӧ����215�����������������ĸ�ָ��ֵ��
	//         ��ʾ��"�ٶ�ֵ�����һ�����Ϣծ���ܶ�Ϊ�ο�����"����ʵ����ֵ�����ʾ��������λС����
	double p12_1 = 0,p12_2 = 0, p12_a = 0;
	int i12Count = 0;

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in (:sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '201'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth2)) { p12_2 = rs.getDouble(2)/10000;i12Count++;}
		if(rs.getString(1).equals(sMonth1)) { p12_1 = rs.getDouble(2)/10000;i12Count++;}
	}
	rs.getStatement().close();

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '211'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth2)) p12_2 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) p12_1 += rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '213'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth2)) p12_2 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) p12_1 += rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '214'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth2)) p12_2 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) p12_1 += rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth in ( :sMonth2,:sMonth1) "  +
			"   and ModelNo like :Report1 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '215'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("sMonth2",sMonth2);
	so.setParameter("sMonth1",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report1",sReport1);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	while(rs.next()){
		if(rs.getString(1).equals(sMonth2)) p12_2 += rs.getDouble(2)/10000;
		if(rs.getString(1).equals(sMonth1)) p12_1 += rs.getDouble(2)/10000;
	}
	rs.getStatement().close();

	if(i12Count!=0) p12_a = (p12_1+p12_2)/i12Count;

	//13��interest��ƽ�����ʣ��������(508)��2/��������Ϣծ���ܶ�p12_1��������Ϣծ���ܶ�p12_2����
	//              ��ĸΪ"0"��ƽ������<=0ʱ���ٶ�ֵ��0���㣬�������λ����ʾ��"��ĸΪ"0"��ƽ������<=0ʱ���ٶ�ֵ��0����"��
	double p13_1 = 0, p13_a = 0;

	sSql = 	"select AccountMonth,Item2Value as a2 "+
			"  from Finance_Data "+
			" where CustomerID = :CustomerID "+
			"   and AccountMonth =:AccountMonth " +
			"   and ModelNo like :Report2 "+
			"   and Scope = :Scope "+
			"   and FinanceItemNo = '508'" +
			" order by AccountMonth desc ";
	so=new SqlObject(sSql);
	so.setParameter("AccountMonth",sMonth1);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("Report2",sReport2);
	so.setParameter("Scope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next())
		p13_1 = rs.getDouble(2)/10000;
	rs.getStatement().close();

	if(p12_a!=0) p13_1 = p13_1/p12_a;
	else         p13_1 = 0;
	p13_a = p13_1;


	//�������Kn
	double Kn,temp = 1;
	for(int i=0;i<Integer.valueOf(sYearCount).intValue();i++)
		temp *= (1 + p1_a);
	if (p1_a !=0)	Kn = (1 + p1_a)*(temp - 1)/p1_a;
	else Kn=0;

//2����ʾ������ʱ��������˵���⣬��"%"��ʾ������2λС����
//   ���û�и��ڱ�����ʾΪ��ֵ������и��ڱ�����û�и���ֵ����ʾΪ"0"��--->1.default=0,2.insert,3.if no month,then update set null

	//��ɾ������������
	sNewSql = "delete from CashFlow_Parameter "+
			  "  where CustomerID = :CustomerID "+
			  "    and BaseYear = :BaseYear "+
			  "    and ReportScope = :ReportScope ";
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("BaseYear",sBaseYear);
	so.setParameter("ReportScope",sReportScope);
	Sqlca.executeSQL(so);
					
	sNewSql = "delete from CashFlow_Record "+
			  "  where CustomerID = :CustomerID "+
			  "    and BaseYear = :BaseYear"+
			  "    and ReportScope = :ReportScope " +
			  "    and FCN = :FCN";
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("BaseYear",sBaseYear);
	so.setParameter("ReportScope",sReportScope);
	so.setParameter("FCN",sYearCount);
	Sqlca.executeSQL(so);					

	//�ٲ�����ز���
	/* ��Ӫҵ������,value0ȡvalue1,�����һ���ֵ
	*/
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,value3,value4,value5,valuea,value0) "+
			  " values(:customerid,:baseyear,:reportscope,0,'Sales','��Ӫҵ������(��Ԫ)',:value1,:value2,:value3,:value4,:value5,:valuea,:value0)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p0_1);
	so.setParameter("value2",p0_2);
	so.setParameter("value3",p0_3);
	so.setParameter("value4",p0_4);
	so.setParameter("value5",p0_5);
	so.setParameter("valuea",p0_a);
	so.setParameter("value0",p0_1);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,value3,value4,value5,valuea) "+
			  " values(:customerid,:baseyear,:reportscope,1,'G','��Ӫҵ������������(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p1_1*100);
	so.setParameter("value2",p1_2*100);
	so.setParameter("value3",p1_3*100);
	so.setParameter("value4",p1_4*100);
	so.setParameter("value5",p1_5*100);
	so.setParameter("valuea",p1_a*100);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,value3,value4,value5,valuea) "+
			  " values(:customerid,:baseyear,:reportscope,2,'Cost','��Ӫҵ��ɱ�/��Ӫҵ������(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p2_1*100);
	so.setParameter("value2",p2_2*100);
	so.setParameter("value3",p2_3*100);
	so.setParameter("value4",p2_4*100);
	so.setParameter("value5",p2_5*100);
	so.setParameter("valuea",p2_a*100);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,value3,value4,value5,valuea) "+
			  " values(:customerid,:baseyear,:reportscope,3,'Oper_tax','��Ӫҵ��˰�𼰸���/��Ӫҵ������(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p3_1*100);
	so.setParameter("value2",p3_2*100);
	so.setParameter("value3",p3_3*100);
	so.setParameter("value4",p3_4*100);
	so.setParameter("value5",p3_5*100);
	so.setParameter("valuea",p3_a*100);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,value3,value4,value5,valuea) "+
			  " values(:customerid,:baseyear,:reportscope,4,'Sale_fee','��Ӫҵ����+������Ӫҵ��ɱ���/��Ӫҵ������(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p4_1*100);
	so.setParameter("value2",p4_2*100);
	so.setParameter("value3",p4_3*100);
	so.setParameter("value4",p4_4*100);
	so.setParameter("value5",p4_5*100);
	so.setParameter("valuea",p4_a*100);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,value3,value4,value5,valuea) "+
			  " values(:customerid,:baseyear,:reportscope,5,'General_fee','�������/��Ӫҵ������(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p5_1*100);
	so.setParameter("value2",p5_2*100);
	so.setParameter("value3",p5_3*100);
	so.setParameter("value4",p5_4*100);
	so.setParameter("value5",p5_5*100);
	so.setParameter("valuea",p5_a*100);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,value3,value4,value5,valuea) "+
			  " values(:customerid,:baseyear,:reportscope,6,'Other_income','����ҵ������/��Ӫҵ������(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p6_1*100);
	so.setParameter("value2",p6_2*100);
	so.setParameter("value3",p6_3*100);
	so.setParameter("value4",p6_4*100);
	so.setParameter("value5",p6_5*100);
	so.setParameter("valuea",p6_a*100);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,value3,value4,value5,valuea) "+
			  " values(:customerid,:baseyear,:reportscope,7,'CurrA','�������ʲ��������ʽ�Ͷ���Ͷ�ʣ�/��Ӫҵ������(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p7_1*100);
	so.setParameter("value2",p7_2*100);
	so.setParameter("value3",p7_3*100);
	so.setParameter("value4",p7_4*100);
	so.setParameter("value5",p7_5*100);
	so.setParameter("valuea",p7_a*100);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,value3,value4,value5,valuea) "+
			  " values(:customerid,:baseyear,:reportscope,8,'Curr_L','��������ծ�����ڽ���һ���ڵ��ڵĳ��ڸ�ծ��/��Ӫҵ������(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p8_1*100);
	so.setParameter("value2",p8_2*100);
	so.setParameter("value3",p8_3*100);
	so.setParameter("value4",p8_4*100);
	so.setParameter("value5",p8_5*100);
	so.setParameter("valuea",p8_a*100);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,value3,value4,value5,valuea) "+
			  " values(:customerid,:baseyear,:reportscope,9,'Long_asset','�̶��ʲ���ֵ�������ʲ�/��Ӫҵ������(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p9_1*100);
	so.setParameter("value2",p9_2*100);
	so.setParameter("value3",p9_3*100);
	so.setParameter("value4",p9_4*100);
	so.setParameter("value5",p9_5*100);
	so.setParameter("valuea",p9_a*100);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,value3,value4,value5,valuea) "+
			  " values(:customerid,:baseyear,:reportscope,10,'D&A','�����۾ɺ�̯���ܶ�/�����ĩƽ��(�̶��ʲ���ֵ+�����ʲ�)(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p10_1*100);
	so.setParameter("value2",p10_2*100);
	so.setParameter("value3",p10_3*100);
	so.setParameter("value4",p10_4*100);
	so.setParameter("value5",p10_5*100);
	so.setParameter("valuea",p10_a*100);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,value3,value4,value5,valuea) "+
			  " values(:customerid,:baseyear,:reportscope,11,'Tax','����˰��(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p11_1*100);
	so.setParameter("value2",p11_2*100);
	so.setParameter("value3",p11_3*100);
	so.setParameter("value4",p11_4*100);
	so.setParameter("value5",p11_5*100);
	so.setParameter("valuea",p11_a*100);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,valuea) "+
			  " values(:customerid,:baseyear,:reportscope,12,'debt','��Ϣծ���ܶ�(��Ԫ)',:value1,:value2,:valuea)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p12_1);
	so.setParameter("value2",p12_2);
	so.setParameter("valuea",p12_a);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,valuea) "+
			  " values(:customerid,:baseyear,:reportscope,13,'interest','ƽ������(%)',:value1,:valuea)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("value1",p13_1*100);
	so.setParameter("valuea",p13_a*100);
	Sqlca.executeSQL(so);

	sNewSql = "insert into CashFlow_Record(customerid,baseyear,reportscope,fcn,kn,recorddate,orgid,userid) "+
			  " values(:customerid,:baseyear,:reportscope,:fcn,:kn,:recorddate,:orgid,:userid)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	so.setParameter("kn",Kn);
	so.setParameter("recorddate",StringFunction.getToday());
	so.setParameter("orgid",CurOrg.getOrgID());
	so.setParameter("userid",CurUser.getUserID());
	Sqlca.executeSQL(so);

	//�ٲ�������
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  " values(:customerid,:baseyear,:reportscope,:fcn,1,'��������',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,2,'��Ӫҵ��ɱ�',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
		  	  " values(:customerid,:baseyear,:reportscope,:fcn,3,'��Ӫҵ��˰��͸���',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
		  	  " values(:customerid,:baseyear,:reportscope,:fcn,4,'Ӫҵ���ú�������Ӫҵ��ɱ�',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,5,'�������',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,6,'����ҵ������',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	 		  " values(:customerid,:baseyear,:reportscope,:fcn,7,'EBIT',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
		  	  " values(:customerid,:baseyear,:reportscope,:fcn,8,'Ϣǰ������',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);	
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,9,'�۾ɺ�̯��',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,10,'Ӫ���ʽ�仯',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,11,'��Ӫ��������ֽ���',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,12,'�ʱ�֧������',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,13,'�����ֽ���',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);


	//2����ʾ������ʱ��������˵���⣬��"%"��ʾ������2λС����----��Ӫҵ������,��Ϣծ���ܶ�,
	//   ���û�и��ڱ�����ʾΪ��ֵ������и��ڱ�����û�и���ֵ����ʾΪ"0"��--->1.default=0,2.insert,3.if no month,then update set null
	//ͨ��accountmonth�ж��е������Ƿ�Ϊnull��value5,value4,value3,value2,value1
	//5
	sSql = 	"select count(*) from customer_fsrecord" +
			" where CustomerID = :CustomerID and reportdate =:reportdate and ReportScope = :ReportScope ";
	so=new SqlObject(sSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth5);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0)
		Sqlca.executeSQL(new SqlObject("update CashFlow_Parameter set value5=null where CustomerID = :CustomerID and BaseYear = :BaseYear and ReportScope = :ReportScope ").setParameter("CustomerID",sCustomerID).setParameter("BaseYear",sBaseYear).setParameter("ReportScope",sReportScope));
	rs.getStatement().close();
	//4
	so=new SqlObject(sSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth4);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0)
		Sqlca.executeSQL(new SqlObject("update CashFlow_Parameter set value4=null where CustomerID = :CustomerID and BaseYear = :BaseYear and ReportScope = :ReportScope ").setParameter("CustomerID",sCustomerID).setParameter("BaseYear",sBaseYear).setParameter("ReportScope",sReportScope));
	rs.getStatement().close();
	//3
	so=new SqlObject(sSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth3);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0)
		Sqlca.executeSQL(new SqlObject("update CashFlow_Parameter set value3=null where CustomerID = :CustomerID and BaseYear = :BaseYear and ReportScope = :ReportScope ").setParameter("CustomerID",sCustomerID).setParameter("BaseYear",sBaseYear).setParameter("ReportScope",sReportScope));
	rs.getStatement().close();
	//2
	so=new SqlObject(sSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth2);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0)
		Sqlca.executeSQL(new SqlObject("update CashFlow_Parameter set value2=null where CustomerID = :CustomerID and BaseYear = :BaseYear and ReportScope = :ReportScope ").setParameter("CustomerID",sCustomerID).setParameter("BaseYear",sBaseYear).setParameter("ReportScope",sReportScope));
	rs.getStatement().close();
	//1
	so=new SqlObject(sSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth1);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0)
		Sqlca.executeSQL(new SqlObject("update CashFlow_Parameter set value1=null where CustomerID = :CustomerID and BaseYear = :BaseYear and ReportScope = :ReportScope ").setParameter("CustomerID",sCustomerID).setParameter("BaseYear",sBaseYear).setParameter("ReportScope",sReportScope));
	rs.getStatement().close();

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���¸�ҳ��;]~*/%>
<script type="text/javascript">

	alert(getBusinessMessage('186'));//�������ֽ���Ԥ������ļٶ�ֵ���������ֽ���Ԥ�⣡
	OpenPage("/CustomerManage/FinanceAnalyse/CashFlowDetail.jsp?CustomerID=<%=sCustomerID%>&ReportScope=<%=sReportScope%>&BaseYear=<%=sBaseYear%>&YearCount=<%=sYearCount%>&rand="+randomNumber(),"_self");
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

