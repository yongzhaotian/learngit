<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
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
	String PG_TITLE = "�ͻ��ֽ�����������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	CurPage.setAttribute("ShowDetailArea","true");
	CurPage.setAttribute("DetailAreaHeight","370");
	
    //�������
    ASResultSet rs = null;
	String sCustomerName = "",sReportScopeName="";
	SqlObject so = null;
	String sNewSql = "";
    //���ҳ�����
	String sCustomerID  = DataConvert.toRealString(CurPage.getParameter("CustomerID"));
	String sBaseYear    = DataConvert.toRealString(CurPage.getParameter("BaseYear"));
	sBaseYear = sBaseYear.substring(0,4);//�����ַ���ת������double��ת��ΪIntegerʱ�ᱨ��
	String sYearCount   = DataConvert.toRealString(CurPage.getParameter("YearCount"));
	String sReportScope = DataConvert.toRealString(CurPage.getParameter("ReportScope"));
    //����������
%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ñ���ֵ;]~*/%>
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

	String sSql = "",sMessage = "";
	//5
	sNewSql = "select count(*) from customer_fsrecord " +
			" where CustomerID = :CustomerID and reportdate =:reportdate and ReportScope = :ReportScope ";
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth5);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth5+"��"+sReportScopeName+"����";
	rs.getStatement().close();
	//4
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth4);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth4+"��"+sReportScopeName+"����";
	rs.getStatement().close();
	//3
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth3);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth3+"��"+sReportScopeName+"����";
	rs.getStatement().close();
	//2
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth2);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth2+"��"+sReportScopeName+"����";
	rs.getStatement().close();
	//1
	so = new SqlObject(sNewSql);
	so.setParameter("CustomerID",sCustomerID);
	so.setParameter("reportdate",sMonth1);
	so.setParameter("ReportScope",sReportScope);
	rs = Sqlca.getResultSet(so);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth1+"��"+sReportScopeName+"����";
	rs.getStatement().close();
%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders1[][] =
	{
		{"ParameterCode","����ָ���"},
		{"ParameterName","��������"},
		{"Value1","ǰһ��"},
		{"Value2","ǰ����"},
		{"Value3","ǰ����"},
		{"Value4","ǰ����"},
		{"Value5","ǰ����"},
		{"Valuea","ƽ��ֵ"},
		{"Value0","�ٶ�ֵ"},
		{"name1","��������"}
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

	//ͨ��sql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders1);
	doTemp.UpdateTable = "CashFlow_Parameter";
	doTemp.setKey("CustomerID,BaseYear,ReportScope,ParameterNo",true);
	//doTemp.setRequired("Value0",true); //ͨ��js�Լ��ж������Ƿ���ȫ
	doTemp.setReadOnly("ParameterCode,ParameterName,Value5,Value4,Value3,Value2,Value1,Valuea,name1",true);
	doTemp.setVisible("CustomerID,BaseYear,ReportScope,ParameterNo,ParameterCode,name1",false);

	//����html��ʽ
	doTemp.setHTMLStyle("ParameterCode"," style={width:60px} ");
	doTemp.setHTMLStyle("ParameterName,name1"," style={width:280px} ");
	doTemp.setHTMLStyle("Value5,Value4,Value3,Value2,Value1,Valuea"," style={width:60px} ");
	doTemp.setHTMLStyle("Value0"," style={width:80px;background-color:#88FFFF;color:black} ");

	doTemp.setAlign("Value5,Value4,Value3,Value2,Value1,Valuea,Value0","3");
	doTemp.setType("BaseYear,ParameterNo,Value5,Value4,Value3,Value2,Value1,Valuea,Value0","Number");
	//doTemp.setCheckFormat("Value5,Value4,Value3,Value2,Value1,Valuea,Value0","2");


	//����ASDataWindow����
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "0"; //����Ϊֻ��
	Vector vPara = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vPara.size();i++) out.print((String)vPara.get(i));

	PG_TITLE = "</br>&nbsp����ھ���"+sReportScopeName+" &nbsp;&nbsp;��λ���������Ԫ &nbsp;&nbsp;<font color=red>ע�⣺"+sMessage+"</font></br>"+
				"&nbsp��ʾ������˰�ʵļٶ�ֵ��Ҫ�ο��˶�������˰�ʣ���Ϣծ���ܶ�ļٶ�ֵ�����һ���Ϊ�ο�����@PageTitle";

%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��

	String sButtons[][] = {
		{"true","","Button","�ֽ���Ԥ��","�����ֽ���Ԥ��","my_compute()",sResourcesPath},
		{"true","","Button","ת�������ӱ��","ת�������ӱ��","my_export()",sResourcesPath},
		{"true","","Button","����","�����ֽ���Ԥ���б�","my_close()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<script type="text/javascript">
	AsOne.AsInit();
	init();
</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=�Զ��庯��;]~*/%>
<script type="text/javascript">
   //---------------------���尴ť�¼�------------------------------------
   /*~[Describe=���������ӱ��;InputParam=�����¼�;OutPutParam=��;]~*/
	function my_export()
	{
		var mystr = my_load_save(2,0,"myiframe0");
		spreadsheetTransfer(mystr);
	}
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function my_compute()
	{
		for(ii=0;ii<getRowCount(0);ii++)
		{
			if(getItemValue(0,ii,"Value0")+"A"=="A")
			{
				alert("�������"+(parseInt(ii,10)+1)+"�У���"+getItemValue(0,ii,"ParameterName")+"���ļٶ�ֵ��");
				return;
			}
		}
		as_save('myiframe0','my_compute2()');
		reloadSelf();
	}
	/*~[Describe=�򿪴���;InputParam=��;OutPutParam=��;]~*/
	function my_compute2()
	{
		sReturn = RunJavaMethodSqlca("com.amarsoft.app.als.finance.analyse.CashFlowCompute","compute","CustomerID=<%=sCustomerID%>,BaseYear=<%=sBaseYear%>,ReportScope=<%=sReportScope%>,YearCount=<%=sYearCount%>");
		if(sReturn="succeed"){
			return sReturn;
			//AsControl.OpenView("/CustomerManage/FinanceAnalyse/CashFlowResult.jsp","CustomerID=<%=sCustomerID%>&BaseYear=<%=sBaseYear%>&ReportScope=<%=sReportScope%>&YearCount=<%=sYearCount%>","DetailFrame","")
		}else{
			alert("����ʧ�ܣ�");
		}
	}
    /*~[Describe=�رմ���;InputParam=��;OutPutParam=��;]~*/
	function my_close()
	{
		OpenPage("/CustomerManage/FinanceAnalyse/CashFlowList.jsp?","_self","");
	}

</script>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=��ҳ���һЩ����;]~*/%>

<script type="text/javascript">
//	bSavePrompt = false;
//	bHighlight = false;
	

	//��Ҫ����
//	needReComputeIndex[0]=0;
//	needReComputeIndex[1]=0;   
	
	my_load(2,0,'myiframe0',1);  //1 for change
	//my_load(2,0,'myiframe1');
	//OpenPage("/Blank.jsp?TextToShow=����ѡ����Ӧ�ĵ�����Ϣ!","DetailFrame","");
	AsControl.OpenView("/CustomerManage/FinanceAnalyse/CashFlowResult.jsp","CustomerID=<%=sCustomerID%>&BaseYear=<%=sBaseYear%>&ReportScope=<%=sReportScope%>&YearCount=<%=sYearCount%>","DetailFrame","")
//	AsMaxWindow();
	for(ii=0;ii<getRowCount(0);ii++)
		getASObject(0,ii,"Value0").style.cssText = getASObject(0,ii,"Value0").style.cssText + ";width:80px;background-color:#88FFFF;color:black";
	setItemFocus(0,0,'Value0');

	//����func,Ϊ�˿����븺��
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
