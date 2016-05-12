<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.finance.*" %>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  
		Tester:	
		Content: --客户列表
		Input Param:
		                 --CustomerID：客户号
		                 --ReportCount ：报表期数
		                 --EntityCount ：客户数
		Output param:
			                
			               
		History Log: 
			DATE	CHANGER		CONTENT
			2005-7-21 fbkang	新版本的改写
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "指标分析"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
   //定义变量
    String sAccountMonths = "";//--报表年月 
    String sScopes = "" ;  //--报表范围
    String sMonthsScopes = "";//报表年月加口径
   	String sFinanceBelong = "";//--财务类型
	double dTemp;//--存放数字类型
	double dTempIndustry ;//--存放行业数据
    String sTemp="";//--存放的字符串类型
    String sTempsIndustry="";//--存放的字符串行业类型
    String sTrueFlag="FALSE" ;//--标志判断
	String sReportName = "";//--报表名称
	String sCustomerName = "";//--客户名称
	String sSql="";//--存放sql语句
	
   //获得页面参数，报表数、客户数、客户代码
	String sReportCount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReportCount"));
	String sEntityCount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityCount"));
	String sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	//获得组件参数
	
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=获取变量值;]~*/%>

<%
	ASResultSet rsTemp = Sqlca.getASResultSet(new SqlObject("select FinanceBelong from ENT_INFO where CustomerID= :CustomerID").setParameter("CustomerID",sCustomerID));
	if(rsTemp.next()) sFinanceBelong = rsTemp.getString(1);		
	rsTemp.getStatement().close();
	
	String sReportNo = sFinanceBelong + "9";
	sSql = "select ReportName from FINANCE_CATALOG where ReportNo = :ReportNo";
	rsTemp = Sqlca.getResultSet(new SqlObject(sSql).setParameter("ReportNo",sReportNo));
	if(rsTemp.next())
		sReportName = rsTemp.getString("ReportName");
	rsTemp.getStatement().close();
	
	sSql = "select CustomerName from CUSTOMER_INFO where CustomerID = :CustomerID";
	rsTemp = Sqlca.getResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	if(rsTemp.next())
		sCustomerName = rsTemp.getString(1);
	rsTemp.getStatement().close();
	
	int iSubTitleSpan = 0, iTitleSpan = 0;
	iSubTitleSpan = Integer.parseInt(sEntityCount) + 1;
	iTitleSpan = iSubTitleSpan * Integer.parseInt(sReportCount) + 1;
	
	String sTempNumber="";

	//时间排序(倒序）
	//假设传来的是顺序排列的：CurPage:AccountMonth1=2001/12,AccountMonth2=2002/12,AccountMonth3=2003/12
	//但数据界面上显示的是倒序,即前一年(2003/12)，前二年(2002/12)，前三年(2001/12)
	//但图形界面上显示的是顺序，即2001/12,2002/12,2003/12
	//aMonth放的是倒序,符合数据界面, 2003/12 2002/21 2001/12
	String aMonth[]=null,aScope[]=null;
	aMonth = new String[Integer.parseInt(sReportCount)+1];
	aScope = new String[Integer.parseInt(sReportCount)+1];
	for(int i=Integer.parseInt(sReportCount); i>=1; i--)
	{
		aMonth[Integer.parseInt(sReportCount)-i+1] = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth" + i));
		aScope[Integer.parseInt(sReportCount)-i+1] = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope" + i));
	}
	//第一个参数"2"表示指标分析，用ReportAnalyse提交指标分析的效率
	ReportAnalyse reportAnalyse = new ReportAnalyse("2",sCustomerID,sReportNo,sReportCount,aMonth,aScope,Sqlca);//@jlwu
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=主页面编写;]~*/%>
<HEAD>
	<title>指标分析</title>
</HEAD>
<body class="ReportPage" leftmargin="0" topmargin="0" onload="" style="overflow:auto" oncontextmenu="return false">
<form name="form0">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
	<tr height=1 valign=top id="buttonback" >
		<td>
			<table width="100%" >
			<tr>
				<td>
					<%=HTMLControls.generateButton("退&nbsp;出","关闭窗口","javascript:confirm('关闭当前窗口？')?top.close():''",sResourcesPath)%>
				</td>
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
			</table>
		</td>
	</tr>
	<tr valign="top" >
		<td style='BORDER-bottom: #000000 1px solid;' >
		<div id="reporttable">
			<script type="text/javascript">
				var aValues = new Array();
				var aNames = new Array();
			</script>
			<table border=1 cellpadding=0 cellspacing=0 width="100%" align="center" bgcolor="#F0F0F0">
			<%
				String sTempValues = "",sTempNames = "";
				String sTempValue = "";
				//表头
				String sAccountMonth = "", sScope = "", sUnit = "";
				sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth1"));
				sScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope1"));
				//FinanceAnalyse financeReport = new FinanceAnalyse(0, sCustomerID, sAccountMonth, sReportNo, sScope, Sqlca);@jlwu
				//sUnit = financeReport.FinanceUnit;@jlwu
			%>
				<tr>
					<td colspan="<%=iTitleSpan%>" align="center"><%=sReportName + "财务指标分析"%></td>
				</tr>
				<tr>
					<td colspan="<%=Math.floor(iTitleSpan/2)%>" align="left"><%="客户名称：" + sCustomerName%></td>
					<td colspan="<%=iTitleSpan - Math.floor(iTitleSpan/2)%>" align="right"><%="单位：人民币元"%> </td>
				</tr>
				<tr>
					<td rowspan="2" align="center" valign="center" nowrap>指标名称</td>
			<%
				for(int i=Integer.parseInt(sReportCount); i>=1; i--)
				{
					//sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth" + i));
					//sScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope" + i));
					sAccountMonth = aMonth[Integer.parseInt(sReportCount)-i+1];
					sScope = aScope[Integer.parseInt(sReportCount)-i+1];

					if(i!=1) sAccountMonths = sAccountMonths + sAccountMonth + "@";
					else     sAccountMonths = sAccountMonths + sAccountMonth ;
					
					if(i!=1) sScopes = sScopes + sScope + "@";
					else     sScopes = sScopes + sScope ;
					
					//月份加口径参数，用于多口径扩展	
					if(i!=1) sMonthsScopes = sMonthsScopes + sAccountMonth+" "+((sScope.equals("01"))?"合并":(sScope.equals("02")?"本部":"汇总"))+"@";
					else 	sMonthsScopes = sMonthsScopes + sAccountMonth+" "+((sScope.equals("01"))?"合并":(sScope.equals("02")?"本部":"汇总"));

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
				for(int i=1; i<=Integer.parseInt(sReportCount); i++)
				{
			%>
					<td align="center" nowrap>指标值</td>
			<%
					for(int j=1; j<=Integer.parseInt(sEntityCount); j++)
					{
						sEntityType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityType" + j));
						sEntityID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityID" + j));
						if(sEntityType.equals("Industry"))
							sSql = "select getIndustryName(:EntityID) from dual";
						else
							sSql = "select CustomerName from CUSTOMER_INFO where CustomerID = :EntityID";
						rsTemp = Sqlca.getResultSet(new SqlObject(sSql).setParameter("EntityID",sEntityID));
						if(rsTemp.next())
							sEntityName = rsTemp.getString(1);
						rsTemp.getStatement().close();
			%>
						<td align="center"><%=sEntityName%></td>
			<%
					}
				}
				
				//表身
				String sFinanceItemNo = "", sDisplayName = "", sFormatType = "";
				sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth" + sReportCount));
				sScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope" + sReportCount));
//暂时未处理 DisplayAttribute	//"1":有量纲,"2":百分比,"3":无量纲			
				String sNewSql = "select FD.FinanceItemNo,FD.DisplayName from Finance_Data FD where  FD.CustomerID = :CustomerID and FD.AccountMonth = :AccountMonth and FD.ModelNo = :ModelNo and FD.Scope = :Scope  order by FD.DisplayNo";
				SqlObject so = new SqlObject(sNewSql);
				so.setParameter("CustomerID",sCustomerID);
				so.setParameter("AccountMonth",sAccountMonth);
				so.setParameter("ModelNo",sReportNo);
				so.setParameter("Scope",sScope);
				rsTemp = Sqlca.getResultSet(so);

				int icount=0;
				while(rsTemp.next())
				{
					icount++;
					sFinanceItemNo = DataConvert.toString(rsTemp.getString(1));
					sDisplayName = DataConvert.toString(rsTemp.getString(2));
					sTempNames = sDisplayName+"@";
					
					//sFormatType = DataConvert.toString(rsTemp.getString(3));
					//if(sFormatType == null || sFormatType.equals(""))
						sFormatType = "2";
					
				if(sDisplayName.length() > 0)
				{
  				    sTempValues = "";					
					sDisplayName  = StringFunction.replace(sDisplayName," ","&nbsp;");
				if(sFinanceItemNo == null || sFinanceItemNo.equals(""))
				{
			%>
				<tr  bgcolor=<%=(icount%2==0)?"#F6F5FA":"#EDEBF6"%>>
					<td colspan="<%=iTitleSpan%>" align="left" nowrap><%=sDisplayName%></td>
				</tr>
			<%
				}
				else
				{
			%>
				<tr  bgcolor=<%=(icount%2==0)?"#F6F5FA":"#EDEBF6"%>>					
					<td align="left" nowrap>
						<input type=checkbox name ="checkbox<%=icount%>"  value=<%=sFinanceItemNo%> >
						<%=sDisplayName%>
					</td>
			<%
					for(int i=Integer.parseInt(sReportCount); i>=1; i--)
					{
						sTemp="";
						sTempsIndustry="";
						sTrueFlag="FALSE" ;
						sAccountMonth = aMonth[Integer.parseInt(sReportCount)-i+1];
						sScope = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Scope" + i));
                        //sTemp = FinanceAnalyse.getItemValue(0,sCustomerID, sAccountMonth, sReportNo, sScope, sFinanceItemNo, Sqlca);
                        sTemp = reportAnalyse.reportData[Integer.parseInt(sReportCount)-i].ParaValue.getAttribute(sFinanceItemNo).toString();//@jlwu
                        if(sTemp!=null&&!sTemp.equals(""))
                        { 
                          dTemp=Double.parseDouble(sTemp);
                        }
                        else
                        {
                          dTemp=Double.parseDouble("0");
                        }
                        if (i==Integer.parseInt(sReportCount))
                        {
							for(int j=1; j<=Integer.parseInt(sEntityCount); j++)
							{
								sEntityType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityType" + j));
								sEntityID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityID" + j));
								if(sEntityType.equals("Industry"))
								{
								   sTempsIndustry = ReportAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca);
								}
								if(sTempsIndustry!=null&&!sTempsIndustry.equals(""))
								{
									dTempIndustry=Double.parseDouble(sTempsIndustry);
									if (dTempIndustry!=0)
									{
										if(((dTemp-dTempIndustry)/dTempIndustry)>0.3||((dTemp-dTempIndustry)/dTempIndustry)<-0.3)
										{
										   sTrueFlag="TRUE";
										   continue;
										}
									}
								}
							}
						}
						sTempValue = ReportAnalyse.convertByUnit(reportAnalyse.reportData[Integer.parseInt(sReportCount)-i].ParaValue.getAttribute(sFinanceItemNo).toString(),"01");
						//"1":有量纲,"2":百分比,"3":无量纲
						sTempNumber = ReportAnalyse.applyFormat(sTempValue,sFormatType);
						if(sTempNumber!=null&&!sTempNumber.equals(""))
						{
							if(sFormatType.equals("3"))
								sTempValues = sTempValues + StringFunction.replace(FinanceAnalyse.formatNumber(Double.parseDouble(sTempValue)),",","") + "@";				
							else if(sFormatType.equals("2"))
								sTempValues = sTempValues + StringFunction.replace(FinanceAnalyse.formatNumber(Double.parseDouble(sTempValue)*100),",","") + "@";				
							else
								sTempValues = sTempValues + StringFunction.replace(FinanceAnalyse.formatNumber(Double.parseDouble(sTempValue)/10000),",","") + "@";				
						}
						else
							sTempValues = sTempValues + "@";
												
												
						//sTempNumber.equals("0.00%")?"":sTempNumber.equals("0.00%")?"":sTempNumber												
						 
			%>
						<td align="right" nowrap>
							<font color=<%=(sTrueFlag.equals("TRUE"))?"red":"black"%>> &nbsp;<%=sTempNumber%>
						</td>
			<%
						for(int j=1; j<=Integer.parseInt(sEntityCount); j++)
						{
							sEntityType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityType" + j));
							sEntityID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EntityID" + j));
							String sValue = "";
							if(sEntityType.equals("Industry"))
							{
								sValue = ReportAnalyse.applyFormat(ReportAnalyse.convertByUnit(FinanceAnalyse.getItemValue(0,sEntityID, StringFunction.getSeparate(sAccountMonth,"/",1), "0001", "01", sFinanceItemNo, Sqlca),"01"),sFormatType);
							}
							else
							{
								sValue = ReportAnalyse.applyFormat(ReportAnalyse.convertByUnit(FinanceAnalyse.getItemValue(0,sEntityID, sAccountMonth, sReportNo, sScope, sFinanceItemNo, Sqlca),"01"),sFormatType);
							}
							
							//sValue.equals("0.00%")?"":sValue.equals("0.00")?"":sValue
			%>
							<td align="right" nowrap>
								&nbsp;<%=sValue%>
							</td>
			<%
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
			%>
				</tr>
			</table>
		</div>
		</td>
	</tr>
</table>
</font>
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
	for(var k=0;k<cForms.elements.length;k++)
	{
		if (cForms.elements[k].checked)
		{
			sChecked += cForms.elements[k].value+"@";
			sItemNames  += aNames[parseInt(cForms.elements[k].name.substr(8,cForms.elements[k].name.length-1),10)];
			sItemValues += aValues[parseInt(cForms.elements[k].name.substr(8,cForms.elements[k].name.length-1),10)];
			
			iChecked ++ ;
		}
	}
	
	if(iChecked==0) 
	{
		alert(getBusinessMessage('174'));//至少要选一个指标进行图形展现！
		return;
	}

	if(iChecked>6)
	{
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
