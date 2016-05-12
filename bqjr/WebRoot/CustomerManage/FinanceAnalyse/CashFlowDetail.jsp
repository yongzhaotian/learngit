<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
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
	String PG_TITLE = "客户现金流测算详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","370");
	
    //定义变量
    ASResultSet rs = null;
	String sCustomerName = "",sReportScopeName="";
	SqlObject so = null;
	String sNewSql = "";
    //获得页面参数
	String sCustomerID  = DataConvert.toRealString(CurPage.getParameter("CustomerID"));
	String sBaseYear    = DataConvert.toRealString(CurPage.getParameter("BaseYear"));
	sBaseYear = sBaseYear.substring(0,4);//做个字符串转换，在double型转化为Integer时会报错
	String sYearCount   = DataConvert.toRealString(CurPage.getParameter("YearCount"));
	String sReportScope = DataConvert.toRealString(CurPage.getParameter("ReportScope"));
    //获得组件参数
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=获得变量值;]~*/%>
<%
	rs = Sqlca.getResultSet(new SqlObject("select EnterpriseName from ent_info where CustomerID = :CustomerID ").setParameter("CustomerID",sCustomerID));
	if(rs.next())
		sCustomerName = rs.getString(1);
	rs.getStatement().close();
	rs = Sqlca.getResultSet("select getItemName('ReportScope','"+sReportScope+"') from role_info ");
	if(rs.next())
		sReportScopeName = rs.getString(1);
	rs.getStatement().close();


	String sYear1,sYear2,sYear3,sYear4,sYear5,sMonth1,sMonth2,sMonth3,sMonth4,sMonth5;

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

	String sSql = "",sMessage = "";
	//5
	sNewSql = "select count(*) from customer_fsrecord " +
			" where CustomerID = :CustomerID and reportdate =:reportdate and ReportScope = :ReportScope ";
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth5);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth5+"无"+sReportScopeName+"报表";
	rs.getStatement().close();
	//4
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth4);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth4+"无"+sReportScopeName+"报表";
	rs.getStatement().close();
	//3
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth3);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth3+"无"+sReportScopeName+"报表";
	rs.getStatement().close();
	//2
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth2);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth2+"无"+sReportScopeName+"报表";
	rs.getStatement().close();
	//1
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth1);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth1+"无"+sReportScopeName+"报表";
	rs.getStatement().close();
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义数据对象;]~*/%>
<%
	String sHeaders1[][] =
	{
		{"ParameterCode","参数指标号"},
		{"ParameterName","参数名称"},
		{"Value1","前一年"},
		{"Value2","前二年"},
		{"Value3","前三年"},
		{"Value4","前二年"},
		{"Value5","前三年"},
		{"Valuea","平均值"},
		{"Value0","假定值"},
		{"name1","参数名称"}
	};

	sHeaders1[2][1]=sMonth1;
	sHeaders1[3][1]=sMonth2;
	sHeaders1[4][1]=sMonth3;
	sHeaders1[5][1]=sMonth4;
	sHeaders1[6][1]=sMonth5;

	sSql = 	"select CustomerID,BaseYear,ReportScope,ParameterNo,"+
			" ParameterCode,ParameterName,Value5,Value4,Value3,Value2,Value1,Valuea,Value0,ParameterName as name1 "+
			"  from CashFlow_Parameter " +
			" where CustomerID = '" + sCustomerID + "' " +
			"   and BaseYear = " + sBaseYear +
			"   and ReportScope = '" + sReportScope + "' " +
			"   and ParameterNo >= 1 " +
			" order by ParameterNo";

	//通过sql产生数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders1);
	doTemp.UpdateTable = "CashFlow_Parameter";
	doTemp.setKey("CustomerID,BaseYear,ReportScope,ParameterNo",true);
	//doTemp.setRequired("Value0",true); //通过js自己判断输入是否完全
	doTemp.setReadOnly("ParameterCode,ParameterName,Value5,Value4,Value3,Value2,Value1,Valuea,name1",true);
	doTemp.setVisible("CustomerID,BaseYear,ReportScope,ParameterNo,ParameterCode,name1",false);

	//设置html格式
	doTemp.setHTMLStyle("ParameterCode"," style={width:60px} ");
	doTemp.setHTMLStyle("ParameterName,name1"," style={width:280px} ");
	doTemp.setHTMLStyle("Value5,Value4,Value3,Value2,Value1,Valuea"," style={width:60px} ");
	doTemp.setHTMLStyle("Value0"," style={width:80px;background-color:#88FFFF;color:black} ");

	doTemp.setAlign("Value5,Value4,Value3,Value2,Value1,Valuea,Value0","3");
	doTemp.setType("BaseYear,ParameterNo,Value5,Value4,Value3,Value2,Value1,Valuea,Value0","Number");
	//doTemp.setCheckFormat("Value5,Value4,Value3,Value2,Value1,Valuea,Value0","2");


	//生成ASDataWindow对象
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "0"; //设置为只读
	Vector vPara = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vPara.size();i++) out.print((String)vPara.get(i));

	PG_TITLE = "</br>&nbsp报表口径："+sReportScopeName+" &nbsp;&nbsp;单位：人民币万元 &nbsp;&nbsp;<font color=red>注意："+sMessage+"</font></br>"+
				"&nbsp提示：所得税率的假定值主要参考核定的所得税率，有息债务总额的假定值以最近一年的为参考依据@PageTitle";

%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
	<%
	//依次为：
		//0.是否显示
		//1.注册目标组件号(为空则自动取当前组件)
		//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.按钮文字
		//4.说明文字
		//5.事件
		//6.资源图片路径

	String sButtons[][] = {
		{"true","","Button","现金流预测","进行现金流预测","my_compute()",sResourcesPath},
		{"true","","Button","转出至电子表格","转出至电子表格","my_export()",sResourcesPath},
		{"true","","Button","返回","返回现金流预测列表","my_close()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<script type="text/javascript">
	AsOne.AsInit();
	init();
</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List05;Describe=自定义函数;]~*/%>
<script type="text/javascript">
   //---------------------定义按钮事件------------------------------------
   /*~[Describe=导出到电子表格;InputParam=后续事件;OutPutParam=无;]~*/
	function my_export()
	{
		var mystr = my_load_save(2,0,"myiframe0");
		spreadsheetTransfer(mystr);
	}
    /*~[Describe=计算;InputParam=后续事件;OutPutParam=无;]~*/
	function my_compute()
	{
		for(ii=0;ii<getRowCount(0);ii++)
		{
			if(getItemValue(0,ii,"Value0")+"A"=="A")
			{
				alert("请输入第"+(parseInt(ii,10)+1)+"行：“"+getItemValue(0,ii,"ParameterName")+"”的假定值！");
				return;
			}
		}
		as_save('myiframe0','my_compute2()');
		reloadSelf();
	}
	/*~[Describe=打开窗口;InputParam=无;OutPutParam=无;]~*/
	function my_compute2()
	{
		sReturn = RunJavaMethodSqlca("com.amarsoft.app.als.finance.analyse.CashFlowCompute","compute","CustomerID=<%=sCustomerID%>,BaseYear=<%=sBaseYear%>,ReportScope=<%=sReportScope%>,YearCount=<%=sYearCount%>");
		if(sReturn="succeed"){
			return sReturn;
			//AsControl.OpenView("/CustomerManage/FinanceAnalyse/CashFlowResult.jsp","CustomerID=<%=sCustomerID%>&BaseYear=<%=sBaseYear%>&ReportScope=<%=sReportScope%>&YearCount=<%=sYearCount%>","DetailFrame","")
		}else{
			alert("测算失败！");
		}
	}
    /*~[Describe=关闭窗口;InputParam=无;OutPutParam=无;]~*/
	function my_close()
	{
		OpenPage("/CustomerManage/FinanceAnalyse/CashFlowList.jsp?","_self","");
	}

</script>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=对页面的一些操作;]~*/%>

<script type="text/javascript">
//	bSavePrompt = false;
//	bHighlight = false;
	

	//不要排序
//	needReComputeIndex[0]=0;
//	needReComputeIndex[1]=0;   
	
	my_load(2,0,'myiframe0',1);  //1 for change
	//my_load(2,0,'myiframe1');
	//OpenPage("/Blank.jsp?TextToShow=请先选择相应的担保信息!","DetailFrame","");
	AsControl.OpenView("/CustomerManage/FinanceAnalyse/CashFlowResult.jsp","CustomerID=<%=sCustomerID%>&BaseYear=<%=sBaseYear%>&ReportScope=<%=sReportScope%>&YearCount=<%=sYearCount%>","DetailFrame","")
//	AsMaxWindow();
	for(ii=0;ii<getRowCount(0);ii++)
		getASObject(0,ii,"Value0").style.cssText = getASObject(0,ii,"Value0").style.cssText + ";width:80px;background-color:#88FFFF;color:black";
	setItemFocus(0,0,'Value0');

	//重新func,为了可输入负数
	function reg_Num(str)
	{
		var Letters = "-1234567890.,";
		var j = 0;
		if(str=="" || str==null) return true;
		for (i=0;i<str.length;i++)
		{
			var CheckChar = str.charAt(i);
			if (Letters.indexOf(CheckChar) == -1){return false;}
			if (CheckChar == "."){j = j + 1;}
		}
		if (j > 1){return false;}

		return true;
	}

	//document.frames["myiframe1"].document.body.onmousedown = Function("return false;");
	//document.frames["myiframe1"].document.body.onKeyUp = Function("return false;");
	
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
