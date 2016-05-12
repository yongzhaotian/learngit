<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<% 
	/*
		Author: 
		Tester:
		Describe: 显示客户相关的现金流预测
		Input Param:
			CustomerID ： 当前客户编号
			BaseYear   : 基准年份:距离现在最近的一年  
			YearCount  : 预测年数:default=1
			ReportScope: 报表口径
		Output Param:
			
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    新的版本的改写
	 */
  %>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户现金流测算"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
     int iCount = 0;
	 ASResultSet rs = null;
    //获得页面参数
 	 String sCustomerID = DataConvert.toRealString(CurPage.getParameter("CustomerID"));  
	 String sBaseYear = DataConvert.toRealString(CurPage.getParameter("BaseYear"));		
	 String sYearCount = DataConvert.toRealString(CurPage.getParameter("YearCount"));    
	 String sReportScope = DataConvert.toRealString(CurPage.getParameter("ReportScope"));
    //获得组件参数

%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=数据准备，测算;]~*/%>
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
			alert(getBusinessMessage('184'));//预测记录已存在，请重新增加记录！
			OpenPage("/CustomerManage/FinanceAnalyse/CashFlowList.jsp","_self","");
			//self.close();
		</script>
<%
		return;
	}

	String sSql = "";
	String sYear1,sYear2,sYear3,sYear4,sYear5,sYear6,sMonth1,sMonth2,sMonth3,sMonth4,sMonth5,sMonth6;
	String sReport1,sReport2,sReport3;

	sYear1 = sBaseYear;														//前一年
	sMonth1 = sYear1 + "/12";
	sYear2 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 1);		//前二年
	sMonth2 = sYear2 + "/12";
	sYear3 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 2);		//前三年
	sMonth3 = sYear3 + "/12";
	sYear4 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 3);		//前四年
	sMonth4 = sYear4 + "/12";
	sYear5 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 4);		//前五年
	sMonth5 = sYear5 + "/12";
	sYear6 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 5);		//前六年
	sMonth6 = sYear6 + "/12";

	//只有财务报表类型是“企业法人”(001)的客户才能做现金流预测！
	sReport1 = "%1";				//资产负债表
	sReport2 = "%2";				//损益表
	//sReport3 = "";				//一般行业补充数据

	//init 先计算前五年有几年有报表，用来做平均值
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
			alert(getBusinessMessage('185'));//至少需要近5年中的一年的财务报表才能进行现金流量的预测！
			alert("请先至少输入"+<%=sYear5%>+"、"+<%=sYear4%>+"、"+<%=sYear3%>+"、"+<%=sYear2%>+"和"+<%=sYear1%>+"年当中的一年的财务报表！");
			OpenPage("/CustomerManage/FinanceAnalyse/CashFlowList.jsp","_self","");
			//self.close();
		</script>
<%
		return;
	}


//注意：
//1、计算时系统要将各期报表单位和汇率统一为人民币万元。
//		System.out.println( CreditlineManage.getERate("14","01",Sqlca));
//		select geterate('14','01','2003/01/01') as a1 from dual;
//      select getreportcurrency('2002/12','010000000000392','02') as a2 from dual;
//	sSql = 	"select AccountMonth,geterate(getreportcurrency(AccountMonth,CustomerID,Scope),'01',AccountMonth)*Item2Value as a2 "+
//	sSql = 	"select AccountMonth,Item2Value as a2 "+
//2、显示计算结果时，除特殊说明外，以"%"显示，保留2位小数，
//   如果没有该期报表，显示为空值。如果有该期报表，但没有该数值，显示为"0"。--->1.default=0,2.insert,3.if no month,then update set null

	//以下：生成参数表数据


	//0 - 主营业务收入 Sales (在损益表中，编号501)
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


	//1 - G 主营业务收入增长率
	double p1_1 = 0, p1_2 = 0, p1_3 = 0, p1_4 = 0, p1_5 = 0, p1_a = 0;
	int iCC = 0;

	if(p0_2 != 0) { p1_1 = (p0_1 - p0_2)/p0_2; iCC++; } 			//前一年的主营业务收入增长率
	if(p0_3 != 0) { p1_2 = (p0_2 - p0_3)/p0_3; iCC++; }             //前二年的主营业务收入增长率
	if(p0_4 != 0) { p1_3 = (p0_3 - p0_4)/p0_4; iCC++; }             //前三年的主营业务收入增长率
	if(p0_5 != 0) { p1_4 = (p0_4 - p0_5)/p0_5; iCC++; }             //前四年的主营业务收入增长率
	if(p0_6 != 0) { p1_5 = (p0_5 - p0_6)/p0_6; iCC++; }             //前五年的主营业务收入增长率
	if(iCC  != 0) p1_a = (p1_1+p1_2+p1_3+p1_4+p1_5)/iCC;            //平均主营业务收入增长率

	//2 - 主营业务成本 (在损益表中，编号502)
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


	//Cost:主营业务成本/主营业务收入
	double p2_1 = 0,p2_2 = 0,p2_3 = 0,p2_4 =0,p2_5=0, p2_a = 0;

	if(p0_1 != 0) p2_1 = tp2_1/p0_1;
	if(p0_2 != 0) p2_2 = tp2_2/p0_2;
	if(p0_3 != 0) p2_3 = tp2_3/p0_3;
	if(p0_4 != 0) p2_4 = tp2_4/p0_4;
	if(p0_5 != 0) p2_5 = tp2_5/p0_5;
	p2_a = (p2_1 + p2_2 + p2_3+p2_4+p2_5)/iReportCount;

	//3、Oper_tax：主营业务税金及附加(损益表中504)/主营业务收入(501)
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

	//Oper_tax：主营业务税金及附加(损益表中504)/主营业务收入(501)
	double p3_1 = 0,p3_2 = 0,p3_3 = 0,p3_4 =0,p3_5=0, p3_a = 0;

	if(p0_1 != 0) p3_1 = tp3_1/p0_1;
	if(p0_2 != 0) p3_2 = tp3_2/p0_2;
	if(p0_3 != 0) p3_3 = tp3_3/p0_3;
	if(p0_4 != 0) p3_4 = tp3_4/p0_4;
	if(p0_5 != 0) p3_5 = tp3_5/p0_5;
	p3_a = (p3_1 + p3_2 + p3_3+p3_4+p3_5)/iReportCount;

	//4、Sale_fee：（营业费用(损益表中503)+其他主营业务成本(502)）/主营业务收入
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

	//Oper_tax：
	double p4_1 = 0,p4_2 = 0,p4_3 = 0,p4_4 =0,p4_5=0, p4_a = 0;

	if(p0_1 != 0) p4_1 = tp4_1/p0_1;
	if(p0_2 != 0) p4_2 = tp4_2/p0_2;
	if(p0_3 != 0) p4_3 = tp4_3/p0_3;
	if(p0_4 != 0) p4_4 = tp4_4/p0_4;
	if(p0_5 != 0) p4_5 = tp4_5/p0_5;
	p4_a = (p4_1 + p4_2 + p4_3+p4_4+p4_5)/iReportCount;



	//5、General_fee：管理费用(507)/主营业务收入
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

	//比例:
	double p5_1 = 0,p5_2 = 0,p5_3 = 0,p5_4 =0,p5_5=0, p5_a = 0;

	if(p0_1 != 0) p5_1 = tp5_1/p0_1;
	if(p0_2 != 0) p5_2 = tp5_2/p0_2;
	if(p0_3 != 0) p5_3 = tp5_3/p0_3;
	if(p0_4 != 0) p5_4 = tp5_4/p0_4;
	if(p0_5 != 0) p5_5 = tp5_5/p0_5;
	p5_a = (p5_1 + p5_2 + p5_3+p5_4+p5_5)/iReportCount;

	//6、Other_income：其他业务利润(506)/主营业务收入
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

	//比例:
	double p6_1 = 0,p6_2 = 0,p6_3 = 0,p6_4 =0,p6_5=0, p6_a = 0;

	if(p0_1 != 0) p6_1 = tp6_1/p0_1;
	if(p0_2 != 0) p6_2 = tp6_2/p0_2;
	if(p0_3 != 0) p6_3 = tp6_3/p0_3;
	if(p0_4 != 0) p6_4 = tp6_4/p0_4;
	if(p0_5 != 0) p6_5 = tp6_5/p0_5;
	p6_a = (p6_1 + p6_2 + p6_3+p6_4+p6_5)/iReportCount;


	//7、CurrA：（流动资产(801)－货币资金(101)和短期投资(102)）/主营业务收入
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

	//比例:
	double p7_1 = 0,p7_2 = 0,p7_3 = 0,p7_4 =0,p7_5=0, p7_a = 0;

	if(p0_1 != 0) p7_1 = tp7_1/p0_1;
	if(p0_2 != 0) p7_2 = tp7_2/p0_2;
	if(p0_3 != 0) p7_3 = tp7_3/p0_3;
	if(p0_4 != 0) p7_4 = tp7_4/p0_4;
	if(p0_5 != 0) p7_5 = tp7_5/p0_5;
	p7_a = (p7_1 + p7_2 + p7_3+p7_4+p7_5)/iReportCount;

	//8、CurrL：（流动负债805－短期借款201和一年内到期的长期负债211）/主营业务收入
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

	//比例:
	double p8_1 = 0,p8_2 = 0,p8_3 = 0,p8_4 =0,p8_5=0, p8_a = 0;

	if(p0_1 != 0) p8_1 = tp8_1/p0_1;
	if(p0_2 != 0) p8_2 = tp8_2/p0_2;
	if(p0_3 != 0) p8_3 = tp8_3/p0_3;
	if(p0_4 != 0) p8_4 = tp8_4/p0_4;
	if(p0_5 != 0) p8_5 = tp8_5/p0_5;
	p8_a = (p8_1 + p8_2 + p8_3+p8_4+p8_5)/iReportCount;

	//9、Long_asset：固定资产净值119和无形资产123/主营业务收入
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


	//比例:
	double p9_1 = 0,p9_2 = 0,p9_3 = 0,p9_4 =0,p9_5=0, p9_a = 0;

	if(p0_1 != 0) p9_1 = tp9_1/p0_1;
	if(p0_2 != 0) p9_2 = tp9_2/p0_2;
	if(p0_3 != 0) p9_3 = tp9_3/p0_3;
	if(p0_4 != 0) p9_4 = tp9_4/p0_4;
	if(p0_5 != 0) p9_5 = tp9_5/p0_5;
	p9_a = (p9_1 + p9_2 + p9_3+p9_4+p9_5)/iReportCount;


	//10、D&A：本年折旧和摊销总额109report3)/年初年末平均(固定资产净值+无形资产)
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

	//年初(固定资产净值+无形资产)--本来年初是item1Value，但现在不输入，所以要取上年年末
	double tt9_1 = 0,tt9_2 = 0,tt9_3 = 0,tt9_4 =0,tt9_5 = 0;
	//固定资产净值
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
	//无形资产
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
	//补充：关于年初，现在用上年末，如果上年无报表，就用本年年末值
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


	//比例:
	double p10_1 = 0,p10_2 = 0,p10_3 = 0,p10_4 =0,p10_5=0, p10_a = 0;

	if( (tt9_1+tp9_1) != 0) p10_1 = tp10_1*2/(tt9_1+tp9_1);
	if( (tt9_2+tp9_2) != 0) p10_2 = tp10_2*2/(tt9_2+tp9_2);
	if( (tt9_3+tp9_3) != 0) p10_3 = tp10_3*2/(tt9_3+tp9_3);
	if( (tt9_4+tp9_4) != 0) p10_4 = tp10_4*2/(tt9_4+tp9_4);
	if( (tt9_5+tp9_5) != 0) p10_5 = tp10_5*2/(tt9_5+tp9_5);
	p10_a = (p10_1 + p10_2 + p10_3+p10_4+p10_5)/iReportCount;


	//11、Tax：所得税率 = 损益表中所得税(516)/利润总额(515)
	//         当某年的所得税率≤0时，该数据不参加平均值计算，并以"0"值显示。此处提示"主要参考核定的所得税率填写假定值"。
	//         此处提示"主要参考核定的所得税率填写假定值"。
	double tp11_1 = 0,tp11_2 = 0,tp11_3 = 0,tp11_4 =0,tp11_5 = 0;
	int i11Count = 0;
	//比例:
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


	//12、debt：有息债务总额＝短期借款201＋一年内到期的长期负债211＋长期借款213＋应付债券214＋长期应付款215，仅仅计算最近两年的该指标值。
	//         提示："假定值以最近一年的有息债务总额为参考依据"。按实际数值金额显示，保留两位小数。
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

	//13、interest：平均利率＝财务费用(508)×2/（本年有息债务总额p12_1＋上年有息债务总额p12_2）。
	//              分母为"0"或平均利率<=0时，假定值以0计算，并在鼠标位置提示："分母为"0"或平均利率<=0时，假定值以0计算"。
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


	//计算参数Kn
	double Kn,temp = 1;
	for(int i=0;i<Integer.valueOf(sYearCount).intValue();i++)
		temp *= (1 + p1_a);
	if (p1_a !=0)	Kn = (1 + p1_a)*(temp - 1)/p1_a;
	else Kn=0;

//2、显示计算结果时，除特殊说明外，以"%"显示，保留2位小数，
//   如果没有该期报表，显示为空值。如果有该期报表，但没有该数值，显示为"0"。--->1.default=0,2.insert,3.if no month,then update set null

	//先删除参数表数据
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

	//再插入相关参数
	/* 主营业务收入,value0取value1,即最近一年的值
	*/
	sNewSql = "insert into CashFlow_Parameter(customerid,baseyear,reportscope,parameterno,parametercode,parametername,"+
			  " value1,value2,value3,value4,value5,valuea,value0) "+
			  " values(:customerid,:baseyear,:reportscope,0,'Sales','主营业务收入(万元)',:value1,:value2,:value3,:value4,:value5,:valuea,:value0)";
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
			  " values(:customerid,:baseyear,:reportscope,1,'G','主营业务收入增长率(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
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
			  " values(:customerid,:baseyear,:reportscope,2,'Cost','主营业务成本/主营业务收入(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
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
			  " values(:customerid,:baseyear,:reportscope,3,'Oper_tax','主营业务税金及附加/主营业务收入(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
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
			  " values(:customerid,:baseyear,:reportscope,4,'Sale_fee','（营业费用+其他主营业务成本）/主营业务收入(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
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
			  " values(:customerid,:baseyear,:reportscope,5,'General_fee','管理费用/主营业务收入(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
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
			  " values(:customerid,:baseyear,:reportscope,6,'Other_income','其他业务利润/主营业务收入(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
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
			  " values(:customerid,:baseyear,:reportscope,7,'CurrA','（流动资产－货币资金和短期投资）/主营业务收入(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
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
			  " values(:customerid,:baseyear,:reportscope,8,'Curr_L','（流动负债－短期借款和一年内到期的长期负债）/主营业务收入(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
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
			  " values(:customerid,:baseyear,:reportscope,9,'Long_asset','固定资产净值和无形资产/主营业务收入(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
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
			  " values(:customerid,:baseyear,:reportscope,10,'D&A','本年折旧和摊销总额/年初年末平均(固定资产净值+无形资产)(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
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
			  " values(:customerid,:baseyear,:reportscope,11,'Tax','所得税率(%)',:value1,:value2,:value3,:value4,:value5,:valuea)";
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
			  " values(:customerid,:baseyear,:reportscope,12,'debt','有息债务总额(万元)',:value1,:value2,:valuea)";
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
			  " values(:customerid,:baseyear,:reportscope,13,'interest','平均利率(%)',:value1,:valuea)";
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

	//再插入数据
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
			  " values(:customerid,:baseyear,:reportscope,:fcn,1,'销售收入',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,2,'主营业务成本',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
		  	  " values(:customerid,:baseyear,:reportscope,:fcn,3,'主营业务税金和附加',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
		  	  " values(:customerid,:baseyear,:reportscope,:fcn,4,'营业费用和其他主营业务成本',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,5,'管理费用',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,6,'其他业务利润',null)";
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
		  	  " values(:customerid,:baseyear,:reportscope,:fcn,8,'息前净利润',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);	
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,9,'折旧和摊销',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,10,'营运资金变化',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,11,'经营活动产生的现金流',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,12,'资本支出增加',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);
	sNewSql = "insert into CashFlow_Data(customerid,baseyear,reportscope,fcn,itemno,itemname,itemvalue) "+
	  		  " values(:customerid,:baseyear,:reportscope,:fcn,13,'自由现金流',null)";
	so = new SqlObject(sNewSql);
	so.setParameter("customerid",sCustomerID);
	so.setParameter("baseyear",sBaseYear);
	so.setParameter("reportscope",sReportScope);
	so.setParameter("fcn",sYearCount);
	Sqlca.executeSQL(so);


	//2、显示计算结果时，除特殊说明外，以"%"显示，保留2位小数，----主营业务收入,有息债务总额,
	//   如果没有该期报表，显示为空值。如果有该期报表，但没有该数值，显示为"0"。--->1.default=0,2.insert,3.if no month,then update set null
	//通过accountmonth判断列的内容是否为null：value5,value4,value3,value2,value1
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

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=打开下个页面;]~*/%>
<script type="text/javascript">

	alert(getBusinessMessage('186'));//请输入现金流预测参数的假定值，并进行现金流预测！
	OpenPage("/CustomerManage/FinanceAnalyse/CashFlowDetail.jsp?CustomerID=<%=sCustomerID%>&ReportScope=<%=sReportScope%>&BaseYear=<%=sBaseYear%>&YearCount=<%=sYearCount%>&rand="+randomNumber(),"_self");
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

