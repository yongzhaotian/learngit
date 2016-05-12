<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginReport.jsp"%>
<%
/* Copyright 2001-2007 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: Harry Jiang,Jerrey Rink
 * Tester:
 * Content: 本行固定统计报表展示页面
 * Input Param:
 *		OrgID:				查询机构号
 *		InputDate:			查询时间
 *		DataSheetID:		查询报表编号
 *		Currecy:			查询币种
 *		ReportAction:		
 *		DisplayCriteria:	是否显示条件栏
 * Output param:
 *
 * History Log:
 *
 */
%>
<%!
	/**
	* parseUnitName , Map Unitcode to UnitName
	* sUnit, Unitcode
	* sInfo, CurrencyName
	*
	* @author zllin@amarsoft.com
	* @version 1.0 Mar 04,2005
	*/
	public String parseUnitName(String sUnit,String sInfo){
		String sUnitName = "单位("+sInfo+")：";
		switch (sUnit.length()){
			case 1:			//元
				sUnitName += "元";
				break;
			case 4:			//千元
				sUnitName += "千元";
				break;
			case 7:			//百万元
				sUnitName += "百万元";
				break;
			case 9:			//亿元
				sUnitName += "亿元";
				break;
			default:
				sUnitName += "万元";
		}
		return sUnitName;
	}
%>
<%
	final String QUERY_TERM_YEAR		= "4";
	final String QUERY_TERM_HALF_YEAR	= "3";
	final String QUERY_TERM_QUARTER		= "2";
	final String QUERY_TERM_MONTH		= "1";
	final String QUERY_TERM_DAY			= "0";
	//报表编号
	String sSheetID = DataConvert.toString(request.getParameter("SheetID"));

	//机构编号
	String sOrgID		= DataConvert.toString(request.getParameter("OrgID"));

	//机构名称
	String sOrgName		= DataConvert.toString(DataConvert.toRealString(iPostChange,request.getParameter("OrgName")));

	//查询日期
	String sInputDate	= DataConvert.toString(request.getParameter("InputDate"));

	//数量单位
	String sUnit		= DataConvert.toString(request.getParameter("Unit"));

	//查询频度
	String sQueryTerm	= DataConvert.toString(request.getParameter("QueryTerm"));

	//币种
	String sCurrency	= DataConvert.toString(DataConvert.toRealString(iPostChange,request.getParameter("Currency")));

	//是否显示条件栏
	String sDisplayCriteria = DataConvert.toString(request.getParameter("DisplayCriteria"));

	//是否重新读取数据
	String sRedoFlag	= DataConvert.toString(request.getParameter("RedoFlag"));

	//重新统计报表数据标识
	boolean bRedoFlag = sRedoFlag.equals("1") ? true : false;
	//
	String sCtrlSlt = QUERY_TERM_MONTH;		//上报频度控制标识
	String sCtrlQry = QUERY_TERM_MONTH;//频度查询控制标识

	//
	//String sReportDate = "";
	//报表期限
	//String sDataSheetTerm="",sTemp="";

	//定义DataSheet对象
	com.amarsoft.ars.core.DataSheet dataSheet = new com.amarsoft.ars.core.DataSheet(sSheetID,Sqlca.getConnection());

	//设置分页数据容量大小    since ars v 3
	dataSheet.setPageSize(100);

	/* 校验当前用户是否具备报表管理员权限的角色号 
	 * chkAdminRole(String1, String2)
	 * String1: 当前用户号
	 * String2: 具备报表管理权限的角色编号,格式如"000,100,200"
	 */
	dataSheet.chkAdminRole(CurUser.getUserID(), "000");

	/* 报表展现的字符集控制(com.amarsoft.ars.parse.chartset.ChartSet)
	 * ARS_CHARTSET_NONE	不做转换
	 * ARS_CHARTSET_GBK		转换成gbk
	 * ARS_CHARTSET_ISO		转换成iso8859-1
	 */
	dataSheet.setCharsetCode(com.amarsoft.ars.parse.chartset.ChartSet.ARS_CHARTSET_NONE);

	//报表标题
	String sSheetTitle = dataSheet.getSheetTitle();

	//解析币种信息
	String sCurrencyName = "";
	if (sCurrency != null && sCurrency.length() >= 5) {			//"Currency(2Bits),CurrencyName"
		sCurrencyName = sCurrency.substring(3);
		sCurrency = sCurrency.substring(0,2);
	}

	//汇率
	if (sCurrency.equals("C1")) {
		dataSheet.setParam("ERate","*ERateUSD ");
		dataSheet.setParam("ERateLM","*ERateUSDLM ");
		dataSheet.setParam("ERateLQ","*ERateUSDLQ ");
		dataSheet.setParam("ERateLH","*ERateUSDLH ");
		dataSheet.setParam("ERateLY","*ERateUSDLY ");
	} else if (sCurrency.equals("C2")) {
		dataSheet.setParam("ERate","*ERateRMB ");
		dataSheet.setParam("ERateLM","*ERateRMBLM ");
		dataSheet.setParam("ERateLQ","*ERateRMBLQ ");
		dataSheet.setParam("ERateLH","*ERateRMBLH ");
		dataSheet.setParam("ERateLY","*ERateRMBLY ");
	} else {
		dataSheet.setParam("ERate"," ");
		dataSheet.setParam("ERateLM"," ");
		dataSheet.setParam("ERateLQ"," ");
		dataSheet.setParam("ERateLH"," ");
		dataSheet.setParam("ERateLY"," ");
	}
	//币种条件
	if (sCurrency.equals("C1")) {
		dataSheet.setParam("CurrencyCondition"," AND BusinessCurrency!='01' ");
	} else if (sCurrency.equals("C2")) {
		dataSheet.setParam("CurrencyCondition","");
	} else {
		dataSheet.setParam("CurrencyCondition"," AND BusinessCurrency='"+sCurrency+"' ");
	}

	//减值计提报表币种条件
	if (sCurrency.equals("C1")) {
		dataSheet.setParam("Currency1"," AND Currency!='01' ");
	} else if (sCurrency.equals("C2")) {
		dataSheet.setParam("Currency1","");
	} else {
		dataSheet.setParam("Currency1"," AND Currency='"+sCurrency+"' ");
	}
	
	//机构条件
	if (sOrgID.equals("00")) {		//全行范围
		dataSheet.setParam("OrgCondition"," AND OrgID NOT LIKE '11%' ");
	} else if (sOrgID.length() == 2){		//一级机构
		dataSheet.setParam("OrgCondition"," AND OrgID LIKE '"+sOrgID+"%' ");
	} else {
		dataSheet.setParam("OrgCondition"," AND OrgID = '"+sOrgID+"' ");
	}

	//运算单位名称
	dataSheet.setParam("UnitName",parseUnitName(sUnit,sCurrencyName));
	dataSheet.setParam("CurrencyName",sCurrencyName);

	boolean bShowOrgID=true,bShowInputDate=true,bShowCurrency=true,bShowUnit=true;
	boolean bShowQueryTerm=false;

	//是否显现机构列表
	if (dataSheet.getProperty("ShowOrgID")!=null)
		if (dataSheet.getProperty("ShowOrgID").equals("false"))
			bShowOrgID=false;

	//是否显示日期输入框
	if (dataSheet.getProperty("ShowInputDate")!=null)
		if (dataSheet.getProperty("ShowInputDate").equals("false"))
			bShowInputDate=false;

	//是否显示币种
	if (dataSheet.getProperty("ShowCurrency")!=null)
		if (dataSheet.getProperty("ShowCurrency").equals("false"))
			bShowCurrency=false;

	//是否显示单位列表
	if (dataSheet.getProperty("ShowUnit")!=null)
		if (dataSheet.getProperty("ShowUnit").equals("false"))
			bShowUnit=false;

	//是否显示报表期限
	if (dataSheet.getProperty("ShowQueryTerm")!=null)
		if (dataSheet.getProperty("ShowQueryTerm").equals("true"))
			bShowQueryTerm=true;
/*
	boolean bShowIndustryType=false,bShowBusinessType=false,bShowCustomer=false,bShowClassify=false,bShowEndDate=false;
	
	//是否显示行业分类
	if (dataSheet.getProperty("ShowIndustryType")!=null)
		if (dataSheet.getProperty("ShowIndustryType").equals("true"))
			bShowIndustryType=true;
	
	//是否显示表外业务品种
	if (dataSheet.getProperty("ShowBusinessType")!=null)
		if (dataSheet.getProperty("ShowBusinessType").equals("true"))
			bShowBusinessType=true;
	
	//是否显示大授信客户
	if (dataSheet.getProperty("ShowCustomer")!=null)
		if (dataSheet.getProperty("ShowCustomer").equals("true"))
			bShowCustomer=true;
	
	//是否显示风险分类
	if (dataSheet.getProperty("ShowClassify")!=null)
		if (dataSheet.getProperty("ShowClassify").equals("true"))
			bShowClassify=true;
*/
	String sDataSheetTerm = (String) dataSheet.getProperty("ReportTerm");
%>
<html>
<head>
<title>信贷业务固定统计报表</title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style>
</head>
<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">
<table border="0" width="100%" height="100%" cellspacing="0"
	cellpadding="0" bgcolor='#DCDCDC'>
	<tr height=0 valign=top>
		<td><%@ include file="FixSheetBanner.jsp"%>
		</td>
	</tr>
	<tr height=100% valign=top>
		<td><%@ include file="FixSheetBody.jsp"%>
		</td>
	</tr>
</table>
<%
	//将参数设置到报表中
	//报表编号
	dataSheet.setParam("SheetID",sSheetID);
	dataSheet.setCondition("SheetID",sSheetID);
	//统计日期
	dataSheet.setParam("InputDate",sInputDate);
	dataSheet.setCondition("InputDate",sInputDate);
	//机构编号
	dataSheet.setParam("OrgID",sOrgID);
	dataSheet.setCondition("OrgID",sOrgID);
	//单位
	dataSheet.setParam("Unit",sUnit);
	dataSheet.setCondition("Unit",sUnit);
	//币种
	dataSheet.setParam("Currency",sCurrency);
	dataSheet.setCondition("Currency",sCurrency);

	if (sInputDate.length()!=0){
		String sTomorrow	= "";
		String sYesterday	= "";
		String sNextMonth	= "";
		String sPreMonth	= "";
		String sCurrentMonth	= "";
		String sCurrentMonthEnd	= "";
		String sPreQuarter	= "";
		String sPreQuarter2	= "";
		String sPreQuarter3	= "";
		String sPreQuarter4	= "";
		String sNextQuarter	= "";
		String sLastYear	= "";
		String sThisYear	= "";
		String sNextYear	= "";
		String sPreYearEnd	= "";
		String sPreHalfYear	= "";
		String sNextHalfYear	= "";
		/*cell变量              
		String sQuarterName	= "";
		String sDateName	= "";
		String sOrgName		= "";
		String sMonthOnly	= "";
		String sYearOnly	= "";
		*/                      
		String sFillinQuarter	= "";
		String sFillinDate	= "";
		String sFillinOrgName	= "";
		String sFillinMonthOnly	= "";
		String sFillinYearOnly	= "";
		String sFillinQueryTerm = "";
		//文件所处的相对路径
		String sBasePath = application.getRealPath("/FixStat/Data");
		//文件名
		String sCurFileName = new java.io.File(request.getRequestURI()).getName();

		String sDataItemJs = "";
		//dataSheet.setParam("Total","合计：");
		dataSheet.setParam("OrgLevel",""+sOrgID.length()/3);
		
		//设定截至日期变量 
		/*
		if (bShowEndDate && sEndDate.length()!=0){
			dataSheet.setParam("FillinEndDate",com.amarsoft.ars.utils.DateUtils.getFillInDate(sInputDate));
		}
		*/
		if(sInputDate.length() == 4){
			//去年同期
			dataSheet.setParam("PreSyncTerm",com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, -1, 0,"yyyy"));
			//明年同期
			dataSheet.setParam("NextSyncTerm",com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 1, 0,"yyyy"));
		}else{
			//设定日期所需变量
			if (sInputDate.length() == 7) {
				//去年同期
				dataSheet.setParam("PreSyncTerm",com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, -1, 0));
				//明年同期
				dataSheet.setParam("NextSyncTerm",com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 1, 0));
			}else{
				//去年同期
				dataSheet.setParam("PreSyncTerm",com.amarsoft.ars.utils.DateUtils.getRelativeDate(sInputDate, -1, 0, 0));
				//明年同期
				dataSheet.setParam("NextSyncTerm",com.amarsoft.ars.utils.DateUtils.getRelativeDate(sInputDate, 1, 0, 0));
			}
			//填报日期
			//out.println(dataSheet.charsetCode());
			sTomorrow		= com.amarsoft.ars.utils.DateUtils.getRelativeDate(sInputDate, 0, 0, 1);	//明日
			sYesterday		= com.amarsoft.ars.utils.DateUtils.getRelativeDate(sInputDate, 0, 0, -1);	//昨日
			sNextMonth		= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 0, 1);		//下月
			sPreMonth		= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 0, -1);		//上月
			sCurrentMonth	= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 0, 0);			//当月
			sCurrentMonthEnd= com.amarsoft.ars.utils.DateUtils.getRelativeDate(sNextMonth+"/01",0,0,-1);	//当月月末
			sPreQuarter		= com.amarsoft.ars.utils.DateUtils.getQuaterInfo(sInputDate, -1);		//上季
			sPreQuarter2	= com.amarsoft.ars.utils.DateUtils.getQuaterInfo(sInputDate, -2);		//上2季
			sPreQuarter3	= com.amarsoft.ars.utils.DateUtils.getQuaterInfo(sInputDate, -3);		//上3季
			sPreQuarter4	= com.amarsoft.ars.utils.DateUtils.getQuaterInfo(sInputDate, -4);		//上4季
			sNextQuarter	= com.amarsoft.ars.utils.DateUtils.getQuaterInfo(sInputDate, 1);		//下季
			sLastYear		= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, -1, 0,"yyyy");	//去年
			sThisYear		= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 0, 0,"yyyy");	//今年
			sNextYear		= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 1, 0,"yyyy");	//明年
			sPreYearEnd		= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, -1, 0).substring(0, 4) + "/12";	//上年末
			sPreHalfYear	= com.amarsoft.ars.utils.DateUtils.getYearInfo(sInputDate, -1);		//前半年期
			sNextHalfYear	= com.amarsoft.ars.utils.DateUtils.getYearInfo(sInputDate, 1);		//后半年期
			//cell变量
			sFillinQuarter	= com.amarsoft.ars.utils.DateUtils.getQuaterName(sInputDate);
			sFillinDate		= com.amarsoft.ars.utils.DateUtils.getFillInDate(sInputDate);		//填报日期所属季度
			sFillinOrgName	= "填报机构："+com.amarsoft.ars.utils.StringUtils.getOrgName(sOrgID,Sqlca.getConnection(),"");	//填报机构
			sFillinMonthOnly= com.amarsoft.ars.utils.DateUtils.getFillinParam(sInputDate,2);	//填报所处月份
			sFillinYearOnly	= com.amarsoft.ars.utils.DateUtils.getFillinParam(sInputDate,1);
			sFillinQueryTerm= sFillinDate;
			/*
			sFillinQuarter	= sQuarterName;	//com.amarsoft.ars.utils.CharSetUtils.convertString(sQuarterName,com.amarsoft.ars.utils.CharSetUtils.ARS_CHARSET_COVERT_GBK_TO_ISO8859);
			sFillinDate		= sDateName;	//com.amarsoft.ars.utils.CharSetUtils.convertString(sDateName,com.amarsoft.ars.utils.CharSetUtils.ARS_CHARSET_COVERT_GBK_TO_ISO8859);
			sFillinOrgName	= "填报机构："+sOrgName;//com.amarsoft.ars.utils.CharSetUtils.convertString("填报机构：",com.amarsoft.ars.utils.CharSetUtils.ARS_CHARSET_COVERT_GBK_TO_ISO8859)+sOrgName;
			sFillinMonthOnly= sMonthOnly;	//com.amarsoft.ars.utils.CharSetUtils.convertString(sMonthOnly,com.amarsoft.ars.utils.CharSetUtils.ARS_CHARSET_COVERT_GBK_TO_ISO8859);
			sFillinYearOnly	= sYearOnly;	//com.amarsoft.ars.utils.CharSetUtils.convertString(sYearOnly,com.amarsoft.ars.utils.CharSetUtils.ARS_CHARSET_COVERT_GBK_TO_ISO8859);
			*/
			dataSheet.setParam("CurrentMonth"	, sCurrentMonth);
			dataSheet.setParam("Yesterday"		, sYesterday);
			dataSheet.setParam("Tomorrow"		, sTomorrow);
			dataSheet.setParam("PreMonth"		, sPreMonth);
			dataSheet.setParam("NextMonth"		, sNextMonth);
			dataSheet.setParam("CurrentMonthEnd", sCurrentMonthEnd);
			dataSheet.setParam("PreQuar"		, sPreQuarter);
			dataSheet.setParam("PreQuar2"		, sPreQuarter2);
			dataSheet.setParam("PreQuar3"		, sPreQuarter3);
			dataSheet.setParam("PreQuar4"		, sPreQuarter4);
			dataSheet.setParam("NextQuar"		, sNextQuarter);
			dataSheet.setParam("LastYear"		, sLastYear);
			dataSheet.setParam("ThisYear"		, sThisYear);
			dataSheet.setParam("NextYear"		, sNextYear);
			dataSheet.setParam("PreYearEnd"		, sPreYearEnd);
			dataSheet.setParam("PreHalfYear"	, sPreHalfYear);
			dataSheet.setParam("NextHalfYear"	, sNextHalfYear);
			dataSheet.setParam("FillinDate"		, sFillinDate);
			dataSheet.setParam("FillinQuarter"	, sFillinQuarter);
			dataSheet.setParam("FillinOrgName"	, sFillinOrgName);
			dataSheet.setParam("FillinMonthOnly", sFillinMonthOnly);
		}
		//填报所处年份
		dataSheet.setParam("FillinYearOnly"		, sFillinYearOnly);
		String sLastTermFlag	= "M";
		String sPreQueryTerm	= sPreMonth;
		String sNextQueryTerm	= sNextMonth;
		String sTermName		= "(月报)";
		if(sCtrlQry.equals(QUERY_TERM_YEAR)){
			sLastTermFlag	= "Y";
			sPreQueryTerm	= sLastYear;
			sNextQueryTerm	= sNextYear;
			sTermName		= "(年报)";
			sFillinQueryTerm= sThisYear+" 年";
		}else if(sCtrlQry.equals(QUERY_TERM_HALF_YEAR)){
			sLastTermFlag	= "H";
			sPreQueryTerm	= sPreHalfYear;
			sNextQueryTerm	= sNextHalfYear;
			sTermName		= "(半年报)";
		}else if(sCtrlQry.equals(QUERY_TERM_QUARTER)){
			sLastTermFlag	= "Q";
			sPreQueryTerm	= sPreQuarter;
			sNextQueryTerm	= sNextQuarter;
			sTermName		= "(季报)";
			sFillinQueryTerm= sFillinQuarter;
		}else if(sCtrlQry.equals(QUERY_TERM_DAY)){
			sLastTermFlag	= "D";
			sPreQueryTerm	= sYesterday;
			sNextQueryTerm	= sTomorrow;
			sTermName		= "(日报)";
		}
		dataSheet.setParam("Term"			,sLastTermFlag);
		dataSheet.setParam("PreQueryTerm"	,sPreQueryTerm);
		dataSheet.setParam("NextQueryTerm"	,sNextQueryTerm);
		dataSheet.setParam("TermName"		,sTermName);
		dataSheet.setParam("FillinQueryTerm",sFillinQueryTerm);
		try{
			/* 逐个解析报表元素定义 */
			dataSheet.compileDataItem();
			/* 生成查询结果并输出到客户端展示 */
			dataSheet.genSheetResultJS(sBasePath,out,bRedoFlag);
			//客户端展示脚本
			out.println(dataSheet.genOutPrintJS());
		}catch(Exception e){
			e.printStackTrace();
			throw new Error(e.getMessage());
		}finally{
			if(dataSheet != null) {
				dataSheet.close();
				dataSheet = null;
			}
		}
	}
	%>
<script>
	div_owc.style.display="block";
	div_param.style.display="block";
	div_process.style.display="none";
</script>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>