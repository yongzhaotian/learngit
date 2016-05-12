<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.finance.*,java.text.DecimalFormat" %>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  --
		Tester:	
		Content: --客户财务报表分析
		Input Param:
			                 --CustomerID：客户号
			                 --ReportCount ：报表期数据
			                 --EntityCount ：客户数
			                 --ReportNo:报表号
		Output param:
			                     
		History Log: 
			DATE	CHANGER		CONTENT
			2005-7-21 fbkang	页面调整
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "趋势分析"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
	String sAccountMonths = "";//--报表年月 
	String sScopes = "" ;  //--报表范围
	String sMonthsScopes = "";//报表年月加口径
	int iSubTitleSpan = 0;//--计数器
	int iTitleSpan = 0;//--计数器
	String sReportName = "";//--报表名称
	String sCustomerName = "";//--客户名称
	String sSql="";//--存放sql语句
	double dTemp;//--存放数字类型
	double dTempIndustry ;//--存放行业数据
    String sTemp="";//--存放的字符串类型
    String sTempsIndustry="";//--存放的字符串行业类型
    String sTrueFlag="FALSE";//--标志判断
    String sTempValues="";//--显示字符串值
    String sTempNames="";//--显示名称
    String aMonth[]=null;//--定义存放月份的数组
    String aScope[]=null;//--定义存放范围的数组
 
    
    //获得页面参数，报表期数、客户数、客户代码、报表号码、分析类型
 	String sReportCount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportCount"));
	String sEntityCount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityCount"));
	String sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sReportNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportNo"));
	String sAnalyseType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AnalyseType"));
    //获得组件参数
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=获取变量值;]~*/%>

<%
	iSubTitleSpan = Integer.parseInt(sEntityCount) + 1;
	iTitleSpan    = iSubTitleSpan * Integer.parseInt(sReportCount) + 1;
	
	sSql = "select ReportName from FINANCE_CATALOG where ReportNo = :ReportNo";
	ASResultSet rsTemp = Sqlca.getResultSet(new SqlObject(sSql).setParameter("ReportNo",sReportNo));
	if(rsTemp.next())
		sReportName = rsTemp.getString("ReportName");
	rsTemp.getStatement().close();

	sSql = "select CustomerName from CUSTOMER_INFO where CustomerID = :CustomerID";
	rsTemp = Sqlca.getResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rsTemp.next())
		sCustomerName = rsTemp.getString(1);
	rsTemp.getStatement().close();

	//时间排序(倒序）
	//假设传来的是顺序排列的：CurPage:AccountMonth1=2001/12,AccountMonth2=2002/12,AccountMonth3=2003/12
	//但数据界面上显示的是倒序,即前一年(2003/12)，前二年(2002/12)，前三年(2001/12)
	//但图形界面上显示的是顺序，即2001/12,2002/12,2003/12
	//aMonth放的是倒序,符合数据界面, 2003/12 2002/21 2001/12
	
	aMonth = new String[Integer.parseInt(sReportCount)+1];
	aScope = new String[Integer.parseInt(sReportCount)+1];
	for(int i=Integer.parseInt(sReportCount); i>=1; i--){
		aMonth[Integer.parseInt(sReportCount)-i+1] = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth" + i));
		aScope[Integer.parseInt(sReportCount)-i+1] = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope" + i));
	}
	//第一个参数"3"表示结构分析,第二个参数表示分析方式
	ReportAnalyse reportAnalyse = new ReportAnalyse("3",sAnalyseType,sCustomerID,sReportNo,sReportCount,aMonth,aScope,Sqlca);//@jlwu
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=主页面的编写;]~*/%>
<HEAD>
	<title>趋势分析</title>
</HEAD>
<body class="ReportPage" leftmargin="0" topmargin="0" onload="" style="overflow:auto" oncontextmenu="return false">
<form name="form0">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
	<tr id="DetailTitle" class="DetailTitle" >
		<td ></td>
	</tr>
	<tr height=1 valign=top id="buttonback" >
		<td>
			<%=HTMLControls.generateButton("转出至电子表格","转出至电子表格","javascript:excelShow();",sResourcesPath)%>
		</td>
		<td align=left>
			<span >
			<table width="100%" ><tr></td>
				选取图形展现方式：
				<select id="GraphType">
					<option value=0 >柱状图</option>
					<option value=6 >折线图</option>
				</select>
			</td></tr></table>
			</span>
		</td>
		<td align=left>
			<%=HTMLControls.generateButton("图形展现","图形展现","javascript:graphShow();",sResourcesPath)%>
		</td>
	</tr>
	<tr valign="top" >
		<td colspan =3 style='BORDER-bottom: #000000 1px solid;' id="reporttable">
			<script type="text/javascript">
				var aValues = new Array();
				var aNames = new Array();
			</script>
			
			<table border=1 cellpadding=0 cellspacing=0 width="100%" align="center" bgcolor="#F0F0F0">
			<%
				//表头
				String sAccountMonth = "", sScope = "", sUnit = "";
				sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth1"));
				sScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope1"));
				//FinanceAnalyse financeReport = new FinanceAnalyse(0, sCustomerID, sAccountMonth, sReportNo, sScope, Sqlca);
				//sUnit = financeReport.FinanceUnit;
			%>
				<tr>
					<td colspan="<%=iTitleSpan%>" align="center"><%=sReportName + "财务趋势分析(" + ReportAnalyse.getItemName("FinanceTrendAnalyse",sAnalyseType,Sqlca) + ")"%></td>
				</tr>
				<tr>
					<td colspan="<%=Math.floor(iTitleSpan/2)%>" align="left"><%="客户名称：" + sCustomerName%></td>
					<td colspan="<%=iTitleSpan - Math.floor(iTitleSpan/2)%>" align="right"><%="单位：人民币元"%> </td>
				</tr>
				<tr>
					<td rowspan="2" align="center" valign="center" nowrap>项目名称</td>
			<%
				for(int i=Integer.parseInt(sReportCount); i>=1; i--){
					sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth" + i));
					sScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope" + i));
					if (i!=1){
						if(i!=2) sAccountMonths = sAccountMonths + sAccountMonth + "@";
						else     sAccountMonths = sAccountMonths + sAccountMonth ;
						
						if(i!=2) sScopes = sScopes + sScope + "@";
						else     sScopes = sScopes + sScope ;
						
						//月份加口径参数，用于多口径扩展	
						if(i!=2) sMonthsScopes = sMonthsScopes + sAccountMonth+" "+((sScope.equals("01"))?"合并":(sScope.equals("02")?"本部":"汇总"))+"@";
						else 	sMonthsScopes = sMonthsScopes + sAccountMonth+" "+((sScope.equals("01"))?"合并":(sScope.equals("02")?"本部":"汇总"));
					}
			%>
					<td colspan="<%=iSubTitleSpan%>" align="center">
						<%=StringFunction.getSeparate(sAccountMonth,"/",1) + "年" + StringFunction.getSeparate(sAccountMonth,"/",2) + "月  "+((sScope.equals("01"))?"合并":(sScope.equals("02")?"本部":"汇总"))%>
					</td>
			<%
				}
			%>
				</tr>
				<tr>
			<%
				String sEntityType = "", sEntityID = "", sEntityName = "";
				for(int i=1; i<=Integer.parseInt(sReportCount); i++){
					if(i == Integer.parseInt(sReportCount)){
			%>
					<td align="center" nowrap>金额</td>
			<%
					}else{
			%>
					<td align="center" nowrap>变动率(%)</td>
			<%
					}

					for(int j=1; j<=Integer.parseInt(sEntityCount); j++){
						sEntityType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityType" + j));
						sEntityID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityID" + j));
						if(sEntityType.equals("Industry"))
							sSql = "select getIndustryName(:EntityID ) from dual";
						else
							sSql = "select CustomerName from CUSTOMER_INFO where CustomerID = :EntityID";
						rsTemp = Sqlca.getResultSet(new SqlObject(sSql).setParameter("EntityID",sEntityID));
						if(rsTemp.next())
							sEntityName = rsTemp.getString(1);
						rsTemp.getStatement().close();

						if(i == Integer.parseInt(sReportCount)){
			%>
						<td align="center"><%=sEntityName%></td>
			<%
						}else{
			%>
						<td align="center"><%=sEntityName + "(%)"%></td>
			<%
						}
					}
				}

				//表身
				String sFinanceItemNo = "", sDisplayName = "", sFormatType = "", sBaseAccountMonth = "", sBaseScope = "";
				sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth" + sReportCount));
				sScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope" + sReportCount));
				int icount=0;
				if(sReportNo.substring(3,4).equals("9")){
//暂时未处理 DisplayAttribute		//"1":有量纲,"2":百分比,"3":无量纲		
					sSql = "select FD.FinanceItemNo,FD.DisplayName from Finance_Data FD where  FD.CustomerID = :CustomerID and FD.AccountMonth = :AccountMonth and FD.ModelNo = :ModelNo and FD.Scope = :Scope  order by FD.DisplayNo";
					SqlObject so = new SqlObject(sSql);
					so.setParameter("CustomerID",sCustomerID);
					so.setParameter("AccountMonth",sAccountMonth);
					so.setParameter("ModelNo",sReportNo);
					so.setParameter("Scope",sScope);
					rsTemp = Sqlca.getResultSet(so);
					while(rsTemp.next()){
						icount++;
						sFinanceItemNo = DataConvert.toString(rsTemp.getString(1));
						sDisplayName = DataConvert.toString(rsTemp.getString(2));
						sTempNames = sDisplayName+"@";

						//sFormatType = DataConvert.toString(rsTemp.getString(3));
						//if(sFormatType == null || sFormatType.equals(""))
							sFormatType = "1";
						
						if(sDisplayName.length() > 0){
						  	sTempValues ="";
						  	sDisplayName  = StringFunction.replace(sDisplayName," ","&nbsp;");
							if(sFinanceItemNo == null || sFinanceItemNo.equals("")){
			%>
							<tr  bgcolor=<%=(icount%2==0)?"#F6F5FA":"#EDEBF6"%>>
								<td colspan="<%=iTitleSpan%>" align="left" nowrap>
									<input type=checkbox name ="checkbox<%=icount%>"  value=<%=sFinanceItemNo%> >
									<%=sDisplayName%>
								</td>
							</tr>
			<%
							}else{
			%>
							<tr  bgcolor=<%=(icount%2==0)?"#F6F5FA":"#EDEBF6"%>>
								<td align="left" nowrap>
									<input type=checkbox name ="checkbox<%=icount%>"  value=<%=sFinanceItemNo%> >
									<%=sDisplayName%>
								</td>
			<%
							for(int i=Integer.parseInt(sReportCount); i>=1; i--){
								sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth" + i));
								sScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope" + i));
								sTemp="";
								sTempsIndustry="";
								sTrueFlag="FALSE" ;
								if(i == 1){
			%>
								<td align="right" nowrap>
									&nbsp;<%=ReportAnalyse.applyFormat(ReportAnalyse.convertByUnit(reportAnalyse.reportData[Integer.parseInt(sReportCount)-i].ParaValue.getAttribute(sFinanceItemNo).toString(),"01"),sFormatType)%>
								</td>
			<%
								for(int j=1; j<=Integer.parseInt(sEntityCount); j++){
									sEntityType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityType" + j));
									sEntityID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityID" + j));
									String sValue = "";
									if(sEntityType.equals("Industry")){
										sValue = ReportAnalyse.applyFormat(ReportAnalyse.convertByUnit(ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca),"01"),sFormatType);
									}else{
										sValue = ReportAnalyse.applyFormat(ReportAnalyse.convertByUnit(ReportAnalyse.getItemValue(0,sEntityID, sAccountMonth, sReportNo, sScope, sFinanceItemNo, Sqlca),"01"),sFormatType);
									}
			%>
									<td align="right" nowrap>
										&nbsp;<%=sValue%>
									</td>
			<%
								}
								}else{
									//这里不用考虑定比分析还是环比分析，因为在类方法中计算变动率时已经考虑了是定比分析还是环比分析@jlwu
								/*if(sAnalyseType.equals("01"))		//定比
								{
									sBaseAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth1"));
									sBaseScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope1"));
								}
								else		//环比
								{
									sBaseAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth" + (i - 1)));
									sBaseScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope" + (i - 1)));
								}*/
								
								if(sFormatType.equals("2")||sFormatType.equals("3")) //百分比或者无量纲
								{
									//sTemp = FinanceAnalyse.getRatio2(FinanceAnalyse.getItemValue(0,sCustomerID, sBaseAccountMonth, sReportNo, sBaseScope, sFinanceItemNo, Sqlca),FinanceAnalyse.getItemValue(0,sCustomerID, sAccountMonth, sReportNo, sScope, sFinanceItemNo, Sqlca));
									if(sAnalyseType.equals("01"))
										sTemp = ReportAnalyse.getRatio2(reportAnalyse.reportData[Integer.parseInt(sReportCount)-1].ParaValue.getAttribute(sFinanceItemNo).toString(),reportAnalyse.reportData[Integer.parseInt(sReportCount)-i].ParaValue.getAttribute(sFinanceItemNo).toString());
									else
										sTemp = ReportAnalyse.getRatio2(reportAnalyse.reportData[Integer.parseInt(sReportCount)-i+1].ParaValue.getAttribute(sFinanceItemNo).toString(),reportAnalyse.reportData[Integer.parseInt(sReportCount)-i].ParaValue.getAttribute(sFinanceItemNo).toString());
								}//@jlwu当sFormatType为1时，类方法中已经出了目前这种分析方式定比或者环比分析的变动率所以可以直接取
								else	//有量纲
									//sTemp = FinanceAnalyse.getRatio(FinanceAnalyse.getItemValue(0,sCustomerID, sBaseAccountMonth, sReportNo, sBaseScope, sFinanceItemNo, Sqlca),FinanceAnalyse.getItemValue(0,sCustomerID, sAccountMonth, sReportNo, sScope, sFinanceItemNo, Sqlca));
									sTemp = reportAnalyse.reportData[Integer.parseInt(sReportCount)-i].ChangeRateValue.getAttribute(sFinanceItemNo).toString();
	                        		if(sTemp!=null&&!sTemp.equals("")){
			                          dTemp=Double.parseDouble(sTemp);
			                        }else{
			                          dTemp=Double.parseDouble("0");
			                        }
					            	sTempValues = sTempValues + StringFunction.getSeparate(ReportAnalyse.formatPercent1(sTemp),"%",1) + "@";
					             	
					            for(int j=1; j<=Integer.parseInt(sEntityCount); j++){
									sEntityType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityType" + j));
									sEntityID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityID" + j));
									String sValue = "";
									if(sEntityType.equals("Industry")){
										//sTempsIndustry = FinanceAnalyse.getRatio(FinanceAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sBaseAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca),FinanceAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca));
										if(sFormatType.equals("2")||sFormatType.equals("3")) //百分比或者无量纲
											sTempsIndustry = ReportAnalyse.getRatio2(ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sBaseAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca),ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca));
										else	//有量纲
											sTempsIndustry = ReportAnalyse.getRatio(ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sBaseAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca),ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca));
									}
									if(sTempsIndustry!=null&&!sTempsIndustry.equals("")){
										dTempIndustry=Double.parseDouble(sTempsIndustry);
										if (dTempIndustry!=0){
											if(((dTemp-dTempIndustry)/dTempIndustry)>0.3||((dTemp-dTempIndustry)/dTempIndustry)<-0.3){
											   sTrueFlag="TRUE";
											   continue;
											}
										}
									}
								 }

								String sShowTemp = "";

								if(sFormatType.equals("3")) //无量纲
								{
									DecimalFormat myFormatter = new DecimalFormat("##0.0");
									if(sTemp == null || sTemp.equals(""))
										sShowTemp = "";
									else
										sShowTemp = myFormatter.format(Double.parseDouble(sTemp));
								}else	//百分比 或者 有量纲
									sShowTemp = ReportAnalyse.formatPercent1(sTemp);
			%>
								<td align="right" nowrap>
								   <font color=<%=(dTemp>0.2||dTemp<-0.2)?"red":(sTrueFlag.equals("TRUE"))?"red":"black"%>>	&nbsp;<%=sShowTemp%>
								</td>
			<%
								for(int j=1; j<=Integer.parseInt(sEntityCount); j++){
									sEntityType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityType" + j));
									sEntityID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityID" + j));
									String sValue = "";
									if(sEntityType.equals("Industry")){
										//sValue = FinanceAnalyse.formatPercent1(FinanceAnalyse.getRatio(FinanceAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sBaseAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca),FinanceAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca)));
										if(sFormatType.equals("2")||sFormatType.equals("3")) //百分比或者无量纲
											sValue = ReportAnalyse.formatPercent1(ReportAnalyse.getRatio2(ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sBaseAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca),ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca)));
										else	//有量纲
											sValue = ReportAnalyse.formatPercent1(ReportAnalyse.getRatio(ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sBaseAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca),ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca)));
									}else{
										//sValue = FinanceAnalyse.formatPercent1(FinanceAnalyse.getRatio(FinanceAnalyse.getItemValue(0,sEntityID, sBaseAccountMonth, sReportNo, sBaseScope, sFinanceItemNo, Sqlca),FinanceAnalyse.getItemValue(0,sEntityID, sAccountMonth, sReportNo, sBaseScope, sFinanceItemNo, Sqlca)));
										if(sFormatType.equals("2")||sFormatType.equals("3")) //百分比或者无量纲
											sValue = ReportAnalyse.formatPercent1(ReportAnalyse.getRatio2(ReportAnalyse.getItemValue(0,sEntityID, sBaseAccountMonth, sReportNo, sBaseScope, sFinanceItemNo, Sqlca),ReportAnalyse.getItemValue(0,sEntityID, sAccountMonth, sReportNo, sBaseScope, sFinanceItemNo, Sqlca)));
										else	//有量纲
											sValue = ReportAnalyse.formatPercent1(ReportAnalyse.getRatio(ReportAnalyse.getItemValue(0,sEntityID, sBaseAccountMonth, sReportNo, sBaseScope, sFinanceItemNo, Sqlca),ReportAnalyse.getItemValue(0,sEntityID, sAccountMonth, sReportNo, sBaseScope, sFinanceItemNo, Sqlca)));
									}
			%>
									<td align="right" nowrap>
										&nbsp;<%=sValue%>
									</td>
			<%
								}
								}
							}
			%>
								<script type="text/javascript">
									aValues[<%=icount%>] = "<%=sTempValues%>";
									aNames[<%=icount%>] = "<%=sTempNames%>";
								</script>
							</tr>
			<%
						}
						}
					}
					rsTemp.getStatement().close();
				}else{
					sSql = "select FinanceItemNo,DisplayName from Finance_Data where CustomerID = :CustomerID and AccountMonth = :AccountMonth and ModelNo = :ModelNo and Scope = :Scope order by DisplayNo";
					SqlObject so = new SqlObject(sSql);
					so.setParameter("CustomerID",sCustomerID);
					so.setParameter("AccountMonth",sAccountMonth);
					so.setParameter("ModelNo",sReportNo);
					so.setParameter("Scope",sScope);
					rsTemp = Sqlca.getResultSet(so);
					int i=0;
					while(rsTemp.next()){
						icount++;
						sFinanceItemNo = DataConvert.toString(rsTemp.getString(1));
						sDisplayName = DataConvert.toString(rsTemp.getString(2));
						sTempNames = sDisplayName+"@";
						if(sFinanceItemNo.length() > 0 && sDisplayName.length() > 0){
						  sTempValues ="";
						  sDisplayName  = StringFunction.replace(sDisplayName," ","&nbsp;");
			%>
						<tr  bgcolor=<%=(icount%2==0)?"#F6F5FA":"#EDEBF6" %> >
							<td align="left" nowrap> 
								<input type=checkbox name ="checkbox<%=icount%>"  value=<%=sFinanceItemNo%> >
								<%=sDisplayName%>
							</td>
			<%
							for(i = Integer.parseInt(sReportCount); i>=1; i--){
								sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth" + i));
								sScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope" + i));
								
								sTemp="";
								sTempsIndustry="";
								sTrueFlag="FALSE" ;
								if(i == 1){
			%>
								<td align="right" nowrap>
									&nbsp;<%=ReportAnalyse.formatNumber(ReportAnalyse.convertByUnit(reportAnalyse.reportData[Integer.parseInt(sReportCount)-i].ParaValue.getAttribute(sFinanceItemNo).toString(), "01"))%>
								</td>
			<%
								for(int j=1; j<=Integer.parseInt(sEntityCount); j++){
									sEntityType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityType" + j));
									sEntityID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityID" + j));
									String sValue = "";
									if(sEntityType.equals("Industry")){
										sValue = ReportAnalyse.formatNumber(ReportAnalyse.convertByUnit(ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca), "01"));
									}else{
										sValue = ReportAnalyse.formatNumber(ReportAnalyse.convertByUnit(ReportAnalyse.getItemValue(0,sEntityID, sAccountMonth, sReportNo, sScope, sFinanceItemNo, Sqlca), "01"));
									}
			%>
									<td align="right" nowrap>
										&nbsp;<%=sValue%>
									</td>
			<%
								}
								}else{
									//在类方法中已经考虑了定比分析还是环比分析，并且计算出了变动率
	                                /*
									if(sAnalyseType.equals("01"))		//定比
									{
										sBaseAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth1"));
										sBaseScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope1"));
									}
									else		//环比
									{
										sBaseAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"+(i - 1)));
										sBaseScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope"+(i - 1)));
									}
									sTemp = FinanceAnalyse.getRatio(
										FinanceAnalyse.getItemValue(0,sCustomerID, sBaseAccountMonth, sReportNo, sBaseScope, sFinanceItemNo, Sqlca),
										FinanceAnalyse.getItemValue(0,sCustomerID, sAccountMonth, sReportNo, sScope, sFinanceItemNo, Sqlca));
									*/
									sTemp = reportAnalyse.reportData[Integer.parseInt(sReportCount)-i].ChangeRateValue.getAttribute(sFinanceItemNo).toString();
	                        		if(sTemp!=null&&!sTemp.equals("")){
			                          dTemp=Double.parseDouble(sTemp);
			                        }else{
			                          dTemp=Double.parseDouble("0");
			                        }
					             	sTempValues = sTempValues + StringFunction.getSeparate(ReportAnalyse.formatPercent1(sTemp),"%",1) + "@";
					             
					             	for(int j=1; j<=Integer.parseInt(sEntityCount); j++){
										sEntityType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityType" + j));
										sEntityID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityID" + j));
										String sValue = "";
										if(sEntityType.equals("Industry")){
											sTempsIndustry = ReportAnalyse.getRatio(
													ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sBaseAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca),
													ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca));
										}
										if(sTempsIndustry!=null&&!sTempsIndustry.equals("")){
											dTempIndustry=Double.parseDouble(sTempsIndustry);
											if (dTempIndustry!=0){
												if(((dTemp-dTempIndustry)/dTempIndustry)>0.3||((dTemp-dTempIndustry)/dTempIndustry)<-0.3){
												   sTrueFlag="TRUE";
												   continue;
												}
											}
										}
									 }
			%>
								<td align="right" nowrap>
								    <font color=<%=(dTemp>0.2||dTemp<-0.2)?"red":(sTrueFlag.equals("TRUE"))?"red":"black"%>>	&nbsp;<%=ReportAnalyse.formatPercent1(sTemp)%>
								</td>
			<%
								for(int j=1; j<=Integer.parseInt(sEntityCount); j++){
									sEntityType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityType" + j));
									sEntityID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityID" + j));
									String sValue = "";
									if(sEntityType.equals("Industry")){
										sValue = ReportAnalyse.formatPercent1(ReportAnalyse.getRatio(ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sBaseAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca),ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca)));
									}else{
										sValue = ReportAnalyse.formatPercent1(ReportAnalyse.getRatio(ReportAnalyse.getItemValue(0,sEntityID, sBaseAccountMonth, sReportNo, sBaseScope, sFinanceItemNo, Sqlca),ReportAnalyse.getItemValue(0,sEntityID, sAccountMonth, sReportNo, sScope, sFinanceItemNo, Sqlca)));
									}
			%>
									<td align="right" nowrap>
										&nbsp;<%=sValue%>
									</td>
			<%
								}
								}
							}
			%>
						<script type="text/javascript">
							aValues[<%=icount%>] = "<%=sTempValues%>";
							aNames[<%=icount%>] = "<%=StringFunction.replace(sTempNames,"\"","”")%>";
						</script>
						</tr>
			<%
						}
					}
					rsTemp.getStatement().close();
				}
			%>
			</table>
		</td>
	</tr>
</table>
</body>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List05;Describe=自定义函数;]~*/%>
<script>
//---------------------定义按钮事件------------------------------------
/*~[Describe=导出excel;InputParam=无;OutPutParam=无;]~*/
function excelShow()
{
	var mystr = document.getElementById('reporttable').innerHTML;
	spreadsheetTransfer(mystr.replace(/type=checkbox/g,"type=hidden"));
}
/*~[Describe=生成图像;InputParam=无;OutPutParam=无;]~*/
function graphShow()
{
	var sChecked = "",iChecked = 0,sItemNames="",sItemValues="";
	
	var cForms = document.forms["form0"];
	//循环取出所有选中的复选框，返回其由value值组成的返回串
	for(var k=0;k<cForms.elements.length;k++){
		if (cForms.elements[k].checked){
			sChecked += cForms.elements[k].value+"@";
			sItemNames  += aNames[parseInt(cForms.elements[k].name.substr(8,cForms.elements[k].name.length-1),10)];
			sItemValues += aValues[parseInt(cForms.elements[k].name.substr(8,cForms.elements[k].name.length-1),10)];
			iChecked ++ ;
		}
	}
	
	if(iChecked==0){
		alert(getBusinessMessage('174'));//至少要选一个指标进行图形展现！
		return;
	}

	if(iChecked>6){
		alert(getBusinessMessage('175'));//一次点选不超过6个项目,请去掉一些项目再进行图形展现！
		return;
	}

	sChecked = sChecked.substr(0,sChecked.length-1);
	sItemNames = sItemNames.substr(0,sItemNames.length-1);
	sItemValues = sItemValues.substr(0,sItemValues.length-1);
	sGraphType = document.getElementById("GraphType").value;
	sScreenWidth = screen.availWidth-40;
	sScreenHeight = screen.availHeight-40;
    PopPage("/CustomerManage/FinanceAnalyse/ShowGraph.jsp?GraphType="+sGraphType+"&MonthsScopes=<%=sMonthsScopes%>&ItemNames="+sItemNames+"&ItemValues="+sItemValues+"&ScreenWidth="+sScreenWidth+"&ScreenHeight="+sScreenHeight+"&rand="+randomNumber(),"_blank",sDefaultDialogStyle);
}
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
