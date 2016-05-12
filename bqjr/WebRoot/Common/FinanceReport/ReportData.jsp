<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.biz.finance.*" %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<% 
	/*
		Author: RCZhu  2004-12-16 20:15
		Tester:
		Describe: 显示和操作指定报表流水号的财务报表
		Input Param:
			ReportNo： 指定报表流水号
			Operation: 操作类型
		Output Param:无	
	
		HistoryLog: sxjiang  2010/07/22  统一财务报表单位（元、千元、万元）与精度（小数点后位数）的规范  去掉DataConvert.toMoney函数
	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~不可编辑区~[Editable=true;Describe=动态滚动条;]~*/%>
	<span id="waitingInfo" style="display:none">
	<table align="center"><tr><td>
	正在处理数据, 请稍候......
	<div style="font-size:2pt;padding:2px;border:solid black 1px">
	<span id="progress1">&nbsp; &nbsp;</span>
	<span id="progress2">&nbsp; &nbsp;</span>
	<span id="progress3">&nbsp; &nbsp;</span>
	<span id="progress4">&nbsp; &nbsp;</span>
	<span id="progress5">&nbsp; &nbsp;</span>
	<span id="progress6">&nbsp; &nbsp;</span>
	<span id="progress7">&nbsp; &nbsp;</span>
	<span id="progress8">&nbsp; &nbsp;</span>
	<span id="progress9">&nbsp; &nbsp;</span>
	<span id="progress10">&nbsp; &nbsp;</span>
	<span id="progress11">&nbsp; &nbsp;</span>
	<span id="progress12">&nbsp; &nbsp;</span>
	<span id="progress13">&nbsp; &nbsp;</span>
	<span id="progress14">&nbsp; &nbsp;</span>
	<span id="progress15">&nbsp; &nbsp;</span>
	<span id="progress16">&nbsp; &nbsp;</span>
	<span id="progress17">&nbsp; &nbsp;</span>
	<span id="progress18">&nbsp; &nbsp;</span>	
	</div>
	</td></tr></table>
	</span>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户当期财务报表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<script type="text/javascript" src="<%=sResourcesPath%>/financecheck.js"></script>

<style type="text/css">
<!--
.thisinput {border-style:none;border-width:thin;border-color:#e9e9e9}
.thistable {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}
.thistd {  border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px}
.thisinputnumber {border-style:none;border-width:thin;border-color:#e9e9e9;text-align:right;}
.FSPage{background-color:#DCDCDC;background-image:url(GridBG_everbright.gif);margin-top:0px;margin-left:0px;margin-bottom:0px;margin-right:0px;}
.FSTable{}
.FSHeaderTR{text-align:left;}
.FSHeaderTDText{background-color:#CCC8EB;background-image:url(FSHeaderBG.gif);height:24px;color:black;padding-left:2px;}
.FSTR{}
.FSTD{}
.FSInput1{border-style:none;border-color:#e9e9e9;background-color:#F6F5FA;}
.FSInput2{border-style:none;border-color:#e9e9e9;background-color:#EDEBF6;}
.FSInputNumber1{border-style:none;border-color:#e9e9e9;text-align:right;background-color:#F6F5FA;}
.FSInputNumber2{border-style:none;border-color:#e9e9e9;text-align:right;background-color:#EDEBF6;}
.FSInputNote1{border-style:none;border-color:#e9e9e9;color:red;text-align:right;background-color:#F6F5FA;}
.FSInputNote2{border-style:none;border-color:#e9e9e9;color:red;text-align:right;background-color:#EDEBF6;}
.FSHighLightInput{border-style:none;border-color:#DCDCDC;text-align:right;background-color:#DCDCDC;}
-->
</style> 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	int i = 0,iColCount = 0,iHalfRowCount = 0;
	String sAlertStirng = "",sCustomerName = "";
	String sCreditColumn1Value = "",sCreditColumn2Value = "",sDebitColumn1Value = "",sDebitColumn2Value = "";
	String[] sTitle = null;
	Report rReport = null;
	double dDiff1 = 0.00,dDiff2 = 0.00;
	String sStyle = "";
	boolean isEditable=true;
	SqlObject so = null;
	String sNewSql = "";	
		
	//获得组件参数
	String sReportNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportNo"));
	String sRole = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Role"));
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sRecordNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RecordNo"));
	String sEditable =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Editable"));
	if("false".equals(sEditable))isEditable=false;
		
	//将空值转化为空字符串
	if(sReportNo == null) sReportNo = "";
	if(sRole == null) sRole = "";
	if(sCustomerID == null) sCustomerID = "";	
	if(sRecordNo == null) sRecordNo = "";
	
	//获得页面参数
	String sOperation = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Operation"));
	//将空值转化为空字符串
	if(sOperation == null) sOperation="";
	
	rReport = new Report(sReportNo,Sqlca);
	
	//获得客户名称
	ASResultSet rsTemp = Sqlca.getResultSet(new SqlObject("select CustomerName from CUSTOMER_INFO where CustomerID=:CustomerID").setParameter("CustomerID",rReport.ObjectNo));
	if(rsTemp.next()) sCustomerName = rsTemp.getString(1);
	rsTemp.getStatement().close();
	
	String sReportUnitName = "元";
	rsTemp = Sqlca.getResultSet(new SqlObject("select ItemName from CODE_LIBRARY where CodeNo='ReportUnit' and ItemNo=:ItemNo and IsInUse = '1' ").setParameter("ItemNo",rReport.ReportUnit));
	if(rsTemp.next()) sReportUnitName = rsTemp.getString(1);
	rsTemp.getStatement().close();
	
	String sReportPeriodName = "";
	rsTemp = Sqlca.getResultSet(new SqlObject("select getItemName('ReportPeriod',ReportPeriod) from CUSTOMER_FSRECORD where CustomerID=:CustomerID and ReportDate = :ReportDate").setParameter("CustomerID",rReport.ObjectNo).setParameter("ReportDate",rReport.ReportDate));
	if(rsTemp.next()) sReportPeriodName = rsTemp.getString(1);
	rsTemp.getStatement().close();
	
	String sReportName = "";
	rsTemp = Sqlca.getResultSet(new SqlObject("select ReportName from REPORT_RECORD where ReportNo = :ReportNo").setParameter("ReportNo",sReportNo));
	if(rsTemp.next()) sReportName = rsTemp.getString(1);
	rsTemp.getStatement().close();
	
	java.text.NumberFormat nf = java.text.NumberFormat.getInstance();
	if(sReportUnitName.equals("元")){
		nf.setMinimumFractionDigits(2);
		nf.setMaximumFractionDigits(2);
	}else if(sReportUnitName.equals("千元")){
		nf.setMinimumFractionDigits(4);
		nf.setMaximumFractionDigits(4);
	}else{
		nf.setMinimumFractionDigits(5);
		nf.setMaximumFractionDigits(5);
	}
%>
<%/*~END~*/%>

<%
	if(sOperation.equals("delete")){
		rReport.delete();
		%> 
		<script type="text/javascript">
			alert("报表删除成功");
			window.close();
		</script>
		<%
	}else if( sOperation.equals("save")){
		rReport.updateRows(request);
		rReport.save();	
		sNewSql = "Update CUSTOMER_FSRECORD set OrgID=:OrgID,UserID=:UserID,UpdateDate=:UpdateDate where RecordNo=:RecordNo";
		so = new SqlObject(sNewSql);
		so.setParameter("OrgID",CurOrg.getOrgID());
		so.setParameter("UserID",CurUser.getUserID());
		so.setParameter("UpdateDate",StringFunction.getToday());
		so.setParameter("RecordNo",sRecordNo);
		Sqlca.executeSQL(so);
		sAlertStirng = "报表保存成功";
		%>
		<script type="text/javascript">
			alert("<%=sAlertStirng%>");
		</script>
		<%	
	}else if(sOperation.equals("calc")){
		rReport.updateRows(request);
		rReport.calculate();
		//判断是否为资产负债表
		if(rReport.getReportRowBySubject("804")==null||rReport.getReportRowBySubject("807")==null){
			sNewSql = "Update CUSTOMER_FSRECORD set OrgID=:OrgID,UserID=:UserID,UpdateDate=:UpdateDate where RecordNo=:RecordNo";
			so = new SqlObject(sNewSql);
			so.setParameter("OrgID",CurOrg.getOrgID());
			so.setParameter("UserID",CurUser.getUserID());
			so.setParameter("UpdateDate",StringFunction.getToday());
			so.setParameter("RecordNo",sRecordNo);
    		Sqlca.executeSQL(so);
    		sAlertStirng = "报表测算成功";
		}else{
			//取得总资产
			sCreditColumn1Value = rReport.getReportRowBySubject("804").ColDisplay[0]; //期初数
			sCreditColumn2Value = rReport.getReportRowBySubject("804").ColDisplay[1]; //期末数
			//取得总负债
			sDebitColumn1Value = rReport.getReportRowBySubject("809").ColDisplay[0]; //期初数
			sDebitColumn2Value = rReport.getReportRowBySubject("809").ColDisplay[1]; //期末数

			//期初数比较
			dDiff1 = Double.parseDouble(sCreditColumn1Value) - Double.parseDouble(sDebitColumn1Value);
			//期末数比较
			dDiff2 = Double.parseDouble(sCreditColumn2Value) - Double.parseDouble(sDebitColumn2Value);
			if(Math.abs(dDiff1) > 0.00001 ){
			   	sAlertStirng = sAlertStirng+"年初值：负债比资产小"+DataConvert.toMoney(dDiff1);
			}
			if(Math.abs(dDiff2) > 0.00001 ){
			   	sAlertStirng = "  "+sAlertStirng+"    期末值：负债比资产小"+DataConvert.toMoney(dDiff2);
			}
			if(sAlertStirng==null||sAlertStirng.equals("")){
				sAlertStirng = "报表平衡！";
			}else{
				sAlertStirng = "报表不平衡!  "+sAlertStirng;
			}
		}
		%>
		<script type="text/javascript">
			alert("<%=sAlertStirng%>");
		</script>
		<%
	}
	
	// 获得报表显示方式

	if(rReport.DisplayMethod.equals("1")) iColCount = 4; // 单栏
	else if (rReport.DisplayMethod.equals("2"))  iColCount = 8; // 双栏
	else iColCount = 3;  // 单项
	
	sTitle = new String[iColCount];
	
	//获得表头
	StringTokenizer st = new StringTokenizer(rReport.HeaderMethod,"&");
	while (st.hasMoreTokens()){
		sTitle[i++] = st.nextToken("&");	
	}
	%>
<body leftmargin="0" topmargin="0" bgcolor="#FFFFFF" <%=sStyle%>>
<table id="amarhidden" cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
  <tr>
  <td valign="top" >
  <table>
    <tr> 
    <td width="1" height="17">&nbsp; </td>
    <td align="left" width="450" height="17" bgcolor="#FFFFFF"> 
     <%=sCustomerName+" >> "+rReport.ReportDate+" >> "+((rReport.ReportScope.equals("01"))?"合并":(rReport.ReportScope.equals("02")?"本部":"汇总"))+" >> "+rReport.ReportName+"   单位:"+sReportUnitName+"  >>  "+sReportPeriodName%>&nbsp;</td>
    <td align="right" width="560" height="17"> 
      <table width="300" border="0" cellspacing="0" cellpadding="0" height="30">
        <tr>
        <%
            if(sRole.equals("has")){
            	if(isEditable){
        %>
          <td>
						<%=HTMLControls.generateButton("导&nbsp;入","导入财务报表数据","javascript:importReport()",sResourcesPath)%>
		  </td>
          <td>
						<%=HTMLControls.generateButton("清&nbsp;空","清空财务报表","javascript:clearReport()",sResourcesPath)%>
		  </td>
          <td>
						<%=HTMLControls.generateButton("保&nbsp;存","保存财务报表","javascript:saveReport()",sResourcesPath)%>
		  </td>
		  <td>
						<%=HTMLControls.generateButton("测&nbsp;算","测算财务报表","javascript:calcReport()",sResourcesPath)%>
		  </td>
		  <%	}
            }%>
		  <td>
						<%=HTMLControls.generateButton("转出至电子表格","转出至电子表格","javascript:spreadsheetTransfer(formatContent());",sResourcesPath)%>
		  </td>
		  <td>&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>

   <!--    <td>&nbsp; &nbsp; &nbsp;<a href="javascript:deleteReport();"> 删除 </a>&nbsp; &nbsp; &nbsp; </td>
        
          <td>&nbsp; &nbsp; &nbsp;<a href="javascript:closeSelf()">关闭 </a>&nbsp; &nbsp; &nbsp;</td>
   -->          
        </tr>
      </table>
    </td>
    <td align="center" colspan="2" height="17" width="1">&nbsp; </td>
  </tr>
  <tr> 
    <td width="1"></td>
    <td align="left" colspan="4" valign="top"> 
      
        <!-- 报表显示 -->
        <form name="report" Method="post" action="" >
          <table border=1 cellpadding=0 cellspacing=0 align="center" class="thistable">
   	  <input type=hidden name="Operation" value="">
   	  <input type=hidden name=CompClientID value='<%=SpecialTools.amarsoft2Real(sCompClientID)%>'>
        <!-- 显示表头 --> 
            <tr align="center" bgcolor="#CCCCCC"> 
			<%
				for(i=0;i<iColCount;i++){
			%>
				 	<td class="thistd" nowrap><%=sTitle[i]%></td>
			<%
				}
			%>
			</tr>
<%
     	String sRowAttribute,sStyle1,sStyle2,sReadOnly1,sReadOnly2,sNameC,sNameC2,sName1,sName2,sName3,sName4;
     	String sCol1Value,sCol2Value;
     	String rowNameL = null;//当单列的时候，只使用rowNameL
		String rowNameR = null;
     	
	// 生成表样及每个字段的名称
	if (rReport.DisplayMethod.equals("1") || rReport.DisplayMethod.equals("3")){
		// 单栏/单项显示
		for(i=0;i<rReport.ReportRows.length;i++){ 
		      sRowAttribute = DataConvert.toString(rReport.ReportRows[i].RowAttribute);
		      sStyle1 = StringFunction.getProfileString(sRowAttribute,"style");
		      sReadOnly1 = StringFunction.getProfileString(sRowAttribute,"readonly");
		      sReadOnly1= sReadOnly1.trim().equals("true")?"readonly":"";
		      	      
		      sNameC = "R" + String.valueOf(i+1) + "CC";
		      sName1 = "R" + String.valueOf(i+1) + "C1";
		      sName2 = "R" + String.valueOf(i+1) + "C2";
		      rowNameL = StringFunction.replace(DataConvert.toRealString(iPostChange,rReport.ReportRows[i].RowName)," ","&nbsp;");
		      rowNameL = rowNameL == null ? "" : rowNameL;
		      if( rReport.DisplayMethod.equals("1")){
		      %> 
		            <tr align="center">
		              <td class="thistd"  width=216 style="<%=sStyle1%>" align=left wrap > 
		              	<%=StringFunction.replace(DataConvert.toRealString(iPostChange,rReport.ReportRows[i].RowName)," ","&nbsp;")%>
		                <input class="thisinput" style="<%=sStyle1%>" type=hidden readonly size="36" value='<%=DataConvert.toRealString(iPostChange,rReport.ReportRows[i].RowName)%>' title='<%=DataConvert.toString(rReport.ReportRows[i].RowName)%>' name=<%=sNameC%> >
		              </td>
		              <td class="thistd" > 
		                <input class="thisinput" style="<%=sStyle1%>;width:100px" type=text readonly size="4"  value='<%=i+1%>' name="text2">
		              </td>
		              <td class="thistd"> 
		                <input class="thisinputnumber" onKeyDown="gridValueChange()"  onblur="javascript:amarMoneyControl('<%=sName1%>');unsetHighLight(this,'<%=sReportName %>','<%=sReportUnitName %>');" <%=sReadOnly1%> onfocus="setHighLight(this);this.select();" style="<%=sStyle1%>" type=text  size="18" onKeyUp="moveFocus('<%=sName1%>')" name=<%=sName1%> value='<%=nf.format(Double.parseDouble(rReport.ReportRows[i].ColDisplay[0]))%>'>
		              </td>
		              <td class="thistd"> 
		                <input class="thisinputnumber" onKeyDown="gridValueChange()"  onblur="javascript:amarMoneyControl('<%=sName2%>');unsetHighLight(this,'<%=sReportName %>','<%=sReportUnitName %>');" <%=sReadOnly1%> onfocus="setHighLight(this);this.select();" style="<%=sStyle1%>" type=text  size="18" onKeyUp="moveFocus('<%=sName2%>')" name=<%=sName2%> value='<%=nf.format(Double.parseDouble(rReport.ReportRows[i].ColDisplay[1]))%>'>
		              </td>
		            </tr>
		      <%
		      } 
		      if( rReport.DisplayMethod.equals("3")){
		      %> 
		            <input class="thisinput" style="<%=sStyle1%>" type=hidden  size="18" name=<%=sName1%> value='<%=DataConvert.toMoney(rReport.ReportRows[i].ColDisplay[0])%>'>         
		            <tr align="center"> 
		              <td class="thistd" width=288 style="<%=sStyle1%>" align=left wrap > 
						<%=rowNameL%>
						<input class="thisinput" style="<%=sStyle1%>" type=hidden readonly size="48" value='<%=DataConvert.toRealString(iPostChange,rReport.ReportRows[i].RowName)%>' name=<%=sNameC%> >
		              </td>
		              <td class="thistd" > 
		                <input class="thisinput" style="<%=sStyle1%>;width=80px" type=text readonly size="4"  value='<%=i+1%>' name="text2">
		              </td>
		              <td class="thistd"> 
		              	<% if(sReportName.indexOf("指标表") > -1){%>
		                	<input class="thisinputnumber" onKeyDown="gridValueChange()"  onblur="javascript:amarMoneyControl('<%=sName2%>');unsetHighLight(this,'<%=sReportName %>','<%=sReportUnitName %>');" <%=sReadOnly1%> onfocus="setHighLight(this);this.select();" style="<%=sStyle1%>" type=text  size="18" onKeyUp="moveFocus('<%=sName2%>')" name=<%=sName2%> value='<%=DataConvert.toMoney(Double.parseDouble(rReport.ReportRows[i].ColDisplay[1]))%>'>
		              	<%}else{ %>
		              		<input class="thisinputnumber" onKeyDown="gridValueChange()"  onblur="javascript:amarMoneyControl('<%=sName2%>');unsetHighLight(this,'<%=sReportName %>','<%=sReportUnitName %>');" <%=sReadOnly1%> onfocus="setHighLight(this);this.select();" style="<%=sStyle1%>" type=text  size="18" onKeyUp="moveFocus('<%=sName2%>')" name=<%=sName2%> value='<%=nf.format(Double.parseDouble(rReport.ReportRows[i].ColDisplay[1]))%>'>
		              	<%} %>
		              </td>
		            </tr>
		      <%
		      }
		}
	}else{ // 双栏显示
		iHalfRowCount = rReport.ReportRows.length/2;
		for(i=0;i<iHalfRowCount;i++){ 
		      sRowAttribute = DataConvert.toString(rReport.ReportRows[i].RowAttribute);
		      sStyle1 = StringFunction.getProfileString(sRowAttribute,"style");
		      if (sStyle1.equals("")) sStyle1 = "thisinput";
		      
		      sReadOnly1 = StringFunction.getProfileString(sRowAttribute,"readonly");
		      sReadOnly1 = sReadOnly1.trim().equals("true")?"readonly":"";
		      
		      sRowAttribute = DataConvert.toString(rReport.ReportRows[i+iHalfRowCount].RowAttribute);
		      sStyle2 = StringFunction.getProfileString(sRowAttribute,"style");
		      if (sStyle2.equals("")) sStyle2 = "thisinput";
		      
		      sReadOnly2 = StringFunction.getProfileString(sRowAttribute,"readonly");
		      sReadOnly2 = sReadOnly2.trim().equals("true")?"readonly":"";
		      
		      sNameC = "R" + String.valueOf(i+1) + "CC";
		      sName1 = "R" + String.valueOf(i+1) + "C1";
		      sName2 = "R" + String.valueOf(i+1) + "C2";
		      sNameC2 = "R" + String.valueOf(i+1+iHalfRowCount) + "CC";
		      sName3 = "R" + String.valueOf(i+1+iHalfRowCount) + "C1";
		      sName4 = "R" + String.valueOf(i+1+iHalfRowCount) + "C2";
		      rowNameL = StringFunction.replace(DataConvert.toRealString(iPostChange,rReport.ReportRows[i].RowName)," ","&nbsp;");
		      rowNameR = StringFunction.replace(DataConvert.toRealString(iPostChange,rReport.ReportRows[i+iHalfRowCount].RowName)," ","&nbsp;");
		      rowNameL = rowNameL == null ? "" : rowNameL;
		      rowNameR = rowNameR == null ? "" : rowNameR;
		    %> 
	            <tr align="center">
	              <td class="thistd"  width=216 style="<%=sStyle1%>" align=left wrap > 
	              	<%=rowNameL%>
	                <input class="thisinput" style="<%=sStyle1%>" type=hidden readonly size="36"  value='<%=DataConvert.toString(rReport.ReportRows[i].RowName)%>' title='<%=DataConvert.toString(rReport.ReportRows[i].RowName)%>' name=<%=sNameC%> >
	              </td>
	              <td class="thistd" > 
	                <input class="thisinput" style="<%=sStyle1%>" type=text readonly size="4"  value='<%=i+1%>' name="text2">
	              </td>
	              <td class="thistd"> 
	                <input class="thisinputnumber" onKeyDown="gridValueChange()"  onblur="javascript:amarMoneyControl('<%=sName2%>');unsetHighLight(this,'<%=sReportName %>','<%=sReportUnitName %>');" <%=sReadOnly1%> onfocus="setHighLight(this);this.select();" style="<%=sStyle1%>" type=text  size="16" onKeyUp="moveFocus('<%=sName2%>')" name=<%=sName2%> value='<%=nf.format(Double.parseDouble(rReport.ReportRows[i].ColDisplay[1]))%>'>
	              </td>
	              <td class="thistd"> 
	                <input class="thisinputnumber" onKeyDown="gridValueChange()"  onblur="javascript:amarMoneyControl('<%=sName1%>');unsetHighLight(this,'<%=sReportName %>','<%=sReportUnitName %>');" <%=sReadOnly1%> onfocus="setHighLight(this);this.select();" style="<%=sStyle1%>" type=text  size="16" onKeyUp="moveFocus('<%=sName1%>')" name=<%=sName1%> value='<%=nf.format(Double.parseDouble(rReport.ReportRows[i].ColDisplay[0]))%>'>
	              </td>
	              
	              <td class="thistd"  width=216 style="<%=sStyle2%>" align=left wrap > 
	              	<%=rowNameR%>
	                <input class="thisinput" style="<%=sStyle2%>" type=hidden readonly size="34" value='<%=DataConvert.toString(rReport.ReportRows[i+iHalfRowCount].RowName)%>' title='<%=DataConvert.toString(rReport.ReportRows[i+iHalfRowCount].RowName)%>' name=<%=sNameC2%> >
	              </td>
	              <td class="thistd"> 
	                <input class="thisinput" style="<%=sStyle2%>" type=text readonly size="4"  value='<%=i+1+iHalfRowCount%>' name="text2">
	              </td>
	               <td class="thistd"> 
	                <input class="thisinputnumber" onKeyDown="gridValueChange()"  <%=sReadOnly2%> onblur="javascript:amarMoneyControl('<%=sName4%>');unsetHighLight(this,'<%=sReportName %>','<%=sReportUnitName %>');" onfocus="setHighLight(this);this.select();" style="<%=sStyle2%>" type=text  size="16" onKeyUp="moveFocus('<%=sName4%>')"name=<%=sName4%> value='<%=nf.format(Double.parseDouble(rReport.ReportRows[i+iHalfRowCount].ColDisplay[1]))%>'>
	              </td>
	              <td class="thistd"> 
	                <input class="thisinputnumber" onKeyDown="gridValueChange()"  <%=sReadOnly2%> onblur="javascript:amarMoneyControl('<%=sName3%>');unsetHighLight(this,'<%=sReportName %>','<%=sReportUnitName %>');" onfocus="setHighLight(this);this.select();" style="<%=sStyle2%>" type=text  size="16" onKeyUp="moveFocus('<%=sName3%>')" name=<%=sName3%> value='<%=nf.format(Double.parseDouble(rReport.ReportRows[i+iHalfRowCount].ColDisplay[0]))%>'>
	              </td>
	            </tr>
	            <%
	        }     
	}
	%>
      		</table>
        </form>
    </td>
 </td>
 </tr>
    <tr> 
    <td width="1" height="17">&nbsp; </td>
    <td align="left" width="450" height="17" bgcolor="#FFFFFF"> 
<%--      <%=rReport.ReportNo%> >> 财务报表 >> <%=rReport.ReportDate+" >> "+rReport.ReportName%>&nbsp;</td> --%>
     <%=sCustomerName+" >> "+rReport.ReportDate+" >> "+((rReport.ReportScope.equals("01"))?"合并":(rReport.ReportScope.equals("02")?"本部":"汇总"))+" >> "+rReport.ReportName+"   单位:"+sReportUnitName+"  >>  "+sReportPeriodName%>&nbsp;</td>
    <td align="right" width="560" height="17"> 
      <table width="300" border="0" cellspacing="0" cellpadding="0" height="30">
        <tr>
        <%
            if(sRole.equals("has")){
            	if(isEditable){
        %>
          <!--<td>
						<%=HTMLControls.generateButton("导&nbsp;入","导入财务报表数据","javascript:importReport()",sResourcesPath)%>
		  </td>
		  <td>
						<%=HTMLControls.generateButton("清&nbsp;空","清空财务报表","javascript:clearReport()",sResourcesPath)%>
		  </td>-->
          <td>
						<%=HTMLControls.generateButton("保&nbsp;存","保存财务报表","javascript:saveReport()",sResourcesPath)%>
		  </td>
		  <td>
						<%=HTMLControls.generateButton("测&nbsp;算","测算财务报表","javascript:calcReport()",sResourcesPath)%>
		  </td>
		 <% 	}
            }%>
		  <td>
						<%=HTMLControls.generateButton("转出至电子表格","转出至电子表格","javascript:spreadsheetTransfer(formatContent());",sResourcesPath)%>
		  </td>
		  <td>&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
      </table>
    </td>
    <td align="center" colspan="2" height="17" width="1">&nbsp; </td>
  </tr>
</table>

 <script type="text/javascript">
	function deleteReport(){
	   	if (confirm("将要删除该报表，继续吗？")){
			document.report.action="<%=sWebRootPath%>/Common/FinanceReport/ReportData.jsp?ReportNo=<%=sReportNo%>&rand="+randomNumber();
		   	document.report.elements["Operation"].value = "delete";
		   	document.report.submit(); 
	   	}     
	}
   
	function saveReport(){
	   	//控制显示	
	   	amarhidden.style.display = "none";
	   	var sUrl = "<%=sWebRootPath%>/Common/FinanceReport/ReportData.jsp?ReportNo=<%=sReportNo%>&rand="+randomNumber();
	   	//[20:15:31.529] ID/NAME 所引用的元素位于全局范围。请使用 W3C 的标准形式 document.getElementById() 。 @ http://localhost:8080/ALS7C3/ao?aoID=C2013041520151002199676787100015:1892
		document.report.elements["Operation"].value = "save";
	   	//事件：参见common.js   	---这个函数是用于OpenPage()---onSubmit(sUrl,sParameter);
	   	onFromAction(sUrl,'report');   
   	}
   	   
   	function calcReport(){
	   	//控制显示	
	   	amarhidden.style.display = "none";
	   	var sUrl = "<%=sWebRootPath%>/Common/FinanceReport/ReportData.jsp?ReportNo=<%=sReportNo%>&rand="+randomNumber();
	   	document.report.elements["Operation"].value = "calc";
	   	//事件：参见common.js   	---这个函数是用于OpenPage()---onSubmit(sUrl,sParameter)
	   	//onFromAction 包装了document.formname.action 需要提交表单的调用这个函数,否则调用onSubmit(sUrl,sParameter)
	   	onFromAction(sUrl,'report');  
   	}

   	function clearReport(){
    	var iRowCount = <%=rReport.ReportRows.length%>;
    	var vMethod = <%=rReport.DisplayMethod%>;
	   	if(confirm("清空财务报表数据，确认？")){
			if(vMethod == "1" || vMethod=="2"){
				for(var i=1; i<=iRowCount; i++){
					document.report.elements("R" + i + "C1").value = "0.00";
					document.report.elements("R" + i + "C2").value = "0.00";
					}
			}else{
				for(var i=1; i<=iRowCount; i++)
					document.report.elements("R" + i + "C2").value = "0.00";
			}
		}
	   	//saveReport();
   	}

	function moveFocus(sName)
	{
	   	iRowCount = <%=rReport.ReportRows.length%>;
	   	//取得当前位置   	
	   	iRowPos = sName.indexOf("R");
		iColPos = sName.indexOf("C");
		iRow = parseInt(sName.substring(iRowPos+1,iColPos-iRowPos)); 
		iCol = parseInt(sName.substring(iColPos+1)); 
		sRow = sName.substring(iRowPos,iColPos-iRowPos);
		sCol = sName.substring(iColPos); 	
		
	   	if(event.keyCode==38) //向上移动
	   	{
			if(iRow>1){
				iRow--;
			  	sName = "R" + new String(iRow) + sCol;
			  	document.report.elements(sName).focus();
			}
	   	}else if(event.keyCode==40 || event.keyCode==13) //向下移动
	   	{
	   		if(iRow<iRowCount){
	   			iRow++;
			  	sName = "R" + new String(iRow) + sCol;
			  	document.report.elements(sName).focus();
			}
	   	}
		if("<%=rReport.DisplayMethod%>" != "3"){ //双值的情况下
	   		if(event.keyCode==37 || event.keyCode==39){ 
	   			if(sName.indexOf("C2") > 0){
	       			sName = sName.replace("C2","C1");
	      		}else if(sName.indexOf("C1") > 0){
	       			sName = sName.replace("C1","C2");
	      		}
	   			document.report.elements(sName).focus();
	     	}
		 }
	}
	
	//导入报表
	function importReport(){
		OpenComp("ReportImport","/Common/FinanceReport/ReportImport.jsp","ReportNo=<%=sReportNo%>&CustomerName=<%=sCustomerName%>&CustomerID=<%=sCustomerID%>&ReportDate=<%=rReport.ReportDate%>&ModelNo=<%=rReport.ModelNo%>","_blank","OpenStyle");
		//reloadSelf();
		//改为调用父页面的函数以达到刷新的目的
		parent.doTabAction("<%=sReportNo%>");
	}
   
	function closeSelf(){
		if(confirm("确定关闭本窗口吗？")){
			window.close();
		}
	}

	function amarMoneyControl(sName){
		dMoney = parseFloat(document.report.elements(sName).value.replace(/,/g, ""));
		if(dMoney==0)	return;
		if (dMoney==null || dMoney=="" || typeof(dMoney)=='undefined' || dMoney=="-NaN.Na" || dMoney=="NaN" || isNaN(dMoney)){
			document.report.elements(sName).value = "";
			return "";
		}
	
		var sMoney="",i,sTemp="",itemCount,iLength,digit=3,sign="",s1="",s2="";
		
		if(dMoney>=0){
			dMoney = dMoney + 0.00000005;
			sign = "";
		}else{
			dMoney = Math.abs(dMoney - 0.00000005);
			sign = "-";
		}
		sMoney=dMoney.toString(10);
		var digits = sMoney.indexOf(".");
		if("<%=sReportUnitName%>"=="元"){
			if(digits >0){ //有小数位
				s2 = sMoney.substring(sMoney.indexOf(".")+1,sMoney.indexOf(".")+3);//取小数点后面两位的意思
			}else{
				s2 = "00";
			}	
		}else if("<%=sReportUnitName%>"=="千元"){
			if(digits >0){ //有小数位
				if(("<%=sReportName%>").indexOf("指标表") >-1 ){
					s2 = sMoney.substring(sMoney.indexOf(".")+1,sMoney.indexOf(".")+3);
				}else
				s2 = sMoney.substring(sMoney.indexOf(".")+1,sMoney.indexOf(".")+5);
			}else{
				s2 = "0000";
			}		
		}else{
			if(digits >0){ //有小数位
				if(("<%=sReportName%>").indexOf("指标表") >-1 ){
					s2 = sMoney.substring(sMoney.indexOf(".")+1,sMoney.indexOf(".")+3);
				}else
				s2 = sMoney.substring(sMoney.indexOf(".")+1,sMoney.indexOf(".")+6);
			}else{
				s2 = "00000";
			}	
		}
		sMoney=parseInt(dMoney,10).toString(10);
		iLength = sMoney.length;
		itemCount = parseInt((iLength-1) / digit,10) ;		
		for (i=0;i<itemCount;i++){
			sTemp = ","+sMoney.substring(iLength-digit*(i+1),iLength-digit*i)+sTemp;
		}		
		sMoney = sign+sMoney.substring(0,iLength-digit*i)+sTemp+"."+s2;	
		document.report.elements(sName).value = sMoney;
		
		return sMoney;		
	}
	
	function formatNull(sNull){
		if(sNull==null || sNull=="")
			return("");//return("&nbsp;");
		else
			return(sNull.replace(/ /g,"&nbsp;"));
	}

	function formatNumber2(sNull){
		if(sNull=="undefined")
			return "";
		else
			return sNull;
	}
		
	function formatContent(){
		var sContentNew = "",i=0;
		var iRowCount = <%=rReport.ReportRows.length%>;
		var iColCount = <%=iColCount%>;
		var sHeader = "<%=sCustomerName%> <%=rReport.ReportDate%> <%=rReport.ReportName%>";

		sContentNew += "<STYLE>";
		sContentNew += ".table {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}";
		sContentNew += ".td {  font-size: 9pt;border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px}.inputnumber {border-style:none;border-width:thin;border-color:#e9e9e9;text-align:right;}.pt16songud{font-family: '黑体','宋体';font-size: 16pt;font-weight:bold;text-decoration: none}.myfont{font-family: '黑体','宋体';font-size: 9pt;font-weight:bold;text-decoration: none}"
		sContentNew += "</STYLE>";

		sContentNew += "<table align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF >";
		sContentNew += "<tr>";
		sContentNew += "    <td colspan="+iColCount+" align=middle >"+sHeader+"</td>";
		sContentNew += "</tr>";
		sContentNew += "<tr>";
<%		for(i=0;i<iColCount;i++) { %>
		sContentNew += "    <td align=left  style='background-color:#CCC8EB;color:black;padding-left:2px;' ><%=sTitle[i]%></td>";
<%		} %>
		sContentNew += "</tr>";
		
<%
		if(rReport.DisplayMethod.equals("1")){
%>		
			for(i=1;i<=iRowCount;i++){
				var sStyle = " style=\" "+document.forms["report"].elements("R"+i+"CC").style.cssText+" \" ";
				sContentNew += "<tr>";
				sContentNew += "    <td align=left  "+sStyle+" >"+formatNull(document.forms["report"].elements("R"+i+"CC").value)+"</td>";
				sContentNew += "    <td align=middle  "+sStyle+" >"+i+"</td>";
				sContentNew += "    <td align=right  "+sStyle+" >"+formatNumber2(document.forms["report"].elements("R"+i+"C1").value)+"</td>";
				sContentNew += "    <td align=right  "+sStyle+" >"+formatNumber2(document.forms["report"].elements("R"+i+"C2").value)+"</td>";
				sContentNew += "</tr>";
			}
<%			
		}else if(rReport.DisplayMethod.equals("3")){
%>		
			for(i=1;i<=iRowCount;i++){
				var sStyle = " style=\" "+document.forms["report"].elements("R"+i+"CC").style.cssText+" \" ";
				sContentNew += "<tr>";
				sContentNew += "    <td align=left "+sStyle+" >"+formatNull(document.forms["report"].elements("R"+i+"CC").value)+"</td>";
				sContentNew += "    <td align=middle  "+sStyle+" >"+i+"</td>";
				sContentNew += "    <td align=right  "+sStyle+" >"+formatNumber2(document.forms["report"].elements("R"+i+"C2").value)+"</td>";
				sContentNew += "</tr>";
			}		
<%			
		}else{
%>		
			for(i=1;i<=iRowCount/2;i++){
				var sStyle =  " style=\" "+document.forms["report"].elements("R"+i+"CC").style.cssText+" \" ";
				var sStyle2 = " style=\" "+document.forms["report"].elements("R"+(i+iRowCount/2)+"CC").style.cssText+" \" ";
				sContentNew += "<tr>";
				sContentNew += "    <td align=left "+sStyle+" >"+formatNull(document.forms["report"].elements("R"+i+"CC").value)+"</td>";
				sContentNew += "    <td align=middle "+sStyle+" >"+i+"</td>";
				//位置调整
				sContentNew += "    <td align=right "+sStyle+" >"+formatNumber2(document.forms["report"].elements("R"+i+"C2").value)+"</td>";
				sContentNew += "    <td align=right "+sStyle+" >"+formatNumber2(document.forms["report"].elements("R"+i+"C1").value)+"</td>";
				sContentNew += "    <td align=left  "+sStyle2+" >"+formatNull(document.forms["report"].elements("R"+(i+iRowCount/2)+"CC").value)+"</td>";
				sContentNew += "    <td align=middle  "+sStyle2+" >"+(i+iRowCount/2)+"</td>";
				//位置调整
				sContentNew += "    <td align=right  "+sStyle2+" >"+formatNumber2(document.forms["report"].elements("R"+(i+iRowCount/2)+"C2").value)+"</td>";
				sContentNew += "    <td align=right  "+sStyle2+" >"+formatNumber2(document.forms["report"].elements("R"+(i+iRowCount/2)+"C1").value)+"</td>";
				sContentNew += "</tr>";
			}
<%			
		}
%>
		sContentNew += "</table>";
		//防止财务报表数据量太小，导出EXCEL时变成乱码
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
						+ "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
						+ "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
						+ "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
						+ "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
						+ "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
						+ "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		return(sContentNew);		
	}

	var dataModified = false; //数据是否被修改过
	function gridValueChange(){
		dataModified = true;
	}
</script>
</body>
<%@ include file="/IncludeEnd.jsp"%>