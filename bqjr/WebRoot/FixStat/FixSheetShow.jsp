<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginReport.jsp"%>
<%
/* Copyright 2001-2007 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: Harry Jiang,Jerrey Rink
 * Tester:
 * Content: ���й̶�ͳ�Ʊ���չʾҳ��
 * Input Param:
 *		OrgID:				��ѯ������
 *		InputDate:			��ѯʱ��
 *		DataSheetID:		��ѯ������
 *		Currecy:			��ѯ����
 *		ReportAction:		
 *		DisplayCriteria:	�Ƿ���ʾ������
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
		String sUnitName = "��λ("+sInfo+")��";
		switch (sUnit.length()){
			case 1:			//Ԫ
				sUnitName += "Ԫ";
				break;
			case 4:			//ǧԪ
				sUnitName += "ǧԪ";
				break;
			case 7:			//����Ԫ
				sUnitName += "����Ԫ";
				break;
			case 9:			//��Ԫ
				sUnitName += "��Ԫ";
				break;
			default:
				sUnitName += "��Ԫ";
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
	//������
	String sSheetID = DataConvert.toString(request.getParameter("SheetID"));

	//�������
	String sOrgID		= DataConvert.toString(request.getParameter("OrgID"));

	//��������
	String sOrgName		= DataConvert.toString(DataConvert.toRealString(iPostChange,request.getParameter("OrgName")));

	//��ѯ����
	String sInputDate	= DataConvert.toString(request.getParameter("InputDate"));

	//������λ
	String sUnit		= DataConvert.toString(request.getParameter("Unit"));

	//��ѯƵ��
	String sQueryTerm	= DataConvert.toString(request.getParameter("QueryTerm"));

	//����
	String sCurrency	= DataConvert.toString(DataConvert.toRealString(iPostChange,request.getParameter("Currency")));

	//�Ƿ���ʾ������
	String sDisplayCriteria = DataConvert.toString(request.getParameter("DisplayCriteria"));

	//�Ƿ����¶�ȡ����
	String sRedoFlag	= DataConvert.toString(request.getParameter("RedoFlag"));

	//����ͳ�Ʊ������ݱ�ʶ
	boolean bRedoFlag = sRedoFlag.equals("1") ? true : false;
	//
	String sCtrlSlt = QUERY_TERM_MONTH;		//�ϱ�Ƶ�ȿ��Ʊ�ʶ
	String sCtrlQry = QUERY_TERM_MONTH;//Ƶ�Ȳ�ѯ���Ʊ�ʶ

	//
	//String sReportDate = "";
	//��������
	//String sDataSheetTerm="",sTemp="";

	//����DataSheet����
	com.amarsoft.ars.core.DataSheet dataSheet = new com.amarsoft.ars.core.DataSheet(sSheetID,Sqlca.getConnection());

	//���÷�ҳ����������С    since ars v 3
	dataSheet.setPageSize(100);

	/* У�鵱ǰ�û��Ƿ�߱��������ԱȨ�޵Ľ�ɫ�� 
	 * chkAdminRole(String1, String2)
	 * String1: ��ǰ�û���
	 * String2: �߱��������Ȩ�޵Ľ�ɫ���,��ʽ��"000,100,200"
	 */
	dataSheet.chkAdminRole(CurUser.getUserID(), "000");

	/* ����չ�ֵ��ַ�������(com.amarsoft.ars.parse.chartset.ChartSet)
	 * ARS_CHARTSET_NONE	����ת��
	 * ARS_CHARTSET_GBK		ת����gbk
	 * ARS_CHARTSET_ISO		ת����iso8859-1
	 */
	dataSheet.setCharsetCode(com.amarsoft.ars.parse.chartset.ChartSet.ARS_CHARTSET_NONE);

	//�������
	String sSheetTitle = dataSheet.getSheetTitle();

	//����������Ϣ
	String sCurrencyName = "";
	if (sCurrency != null && sCurrency.length() >= 5) {			//"Currency(2Bits),CurrencyName"
		sCurrencyName = sCurrency.substring(3);
		sCurrency = sCurrency.substring(0,2);
	}

	//����
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
	//��������
	if (sCurrency.equals("C1")) {
		dataSheet.setParam("CurrencyCondition"," AND BusinessCurrency!='01' ");
	} else if (sCurrency.equals("C2")) {
		dataSheet.setParam("CurrencyCondition","");
	} else {
		dataSheet.setParam("CurrencyCondition"," AND BusinessCurrency='"+sCurrency+"' ");
	}

	//��ֵ���ᱨ���������
	if (sCurrency.equals("C1")) {
		dataSheet.setParam("Currency1"," AND Currency!='01' ");
	} else if (sCurrency.equals("C2")) {
		dataSheet.setParam("Currency1","");
	} else {
		dataSheet.setParam("Currency1"," AND Currency='"+sCurrency+"' ");
	}
	
	//��������
	if (sOrgID.equals("00")) {		//ȫ�з�Χ
		dataSheet.setParam("OrgCondition"," AND OrgID NOT LIKE '11%' ");
	} else if (sOrgID.length() == 2){		//һ������
		dataSheet.setParam("OrgCondition"," AND OrgID LIKE '"+sOrgID+"%' ");
	} else {
		dataSheet.setParam("OrgCondition"," AND OrgID = '"+sOrgID+"' ");
	}

	//���㵥λ����
	dataSheet.setParam("UnitName",parseUnitName(sUnit,sCurrencyName));
	dataSheet.setParam("CurrencyName",sCurrencyName);

	boolean bShowOrgID=true,bShowInputDate=true,bShowCurrency=true,bShowUnit=true;
	boolean bShowQueryTerm=false;

	//�Ƿ����ֻ����б�
	if (dataSheet.getProperty("ShowOrgID")!=null)
		if (dataSheet.getProperty("ShowOrgID").equals("false"))
			bShowOrgID=false;

	//�Ƿ���ʾ���������
	if (dataSheet.getProperty("ShowInputDate")!=null)
		if (dataSheet.getProperty("ShowInputDate").equals("false"))
			bShowInputDate=false;

	//�Ƿ���ʾ����
	if (dataSheet.getProperty("ShowCurrency")!=null)
		if (dataSheet.getProperty("ShowCurrency").equals("false"))
			bShowCurrency=false;

	//�Ƿ���ʾ��λ�б�
	if (dataSheet.getProperty("ShowUnit")!=null)
		if (dataSheet.getProperty("ShowUnit").equals("false"))
			bShowUnit=false;

	//�Ƿ���ʾ��������
	if (dataSheet.getProperty("ShowQueryTerm")!=null)
		if (dataSheet.getProperty("ShowQueryTerm").equals("true"))
			bShowQueryTerm=true;
/*
	boolean bShowIndustryType=false,bShowBusinessType=false,bShowCustomer=false,bShowClassify=false,bShowEndDate=false;
	
	//�Ƿ���ʾ��ҵ����
	if (dataSheet.getProperty("ShowIndustryType")!=null)
		if (dataSheet.getProperty("ShowIndustryType").equals("true"))
			bShowIndustryType=true;
	
	//�Ƿ���ʾ����ҵ��Ʒ��
	if (dataSheet.getProperty("ShowBusinessType")!=null)
		if (dataSheet.getProperty("ShowBusinessType").equals("true"))
			bShowBusinessType=true;
	
	//�Ƿ���ʾ�����ſͻ�
	if (dataSheet.getProperty("ShowCustomer")!=null)
		if (dataSheet.getProperty("ShowCustomer").equals("true"))
			bShowCustomer=true;
	
	//�Ƿ���ʾ���շ���
	if (dataSheet.getProperty("ShowClassify")!=null)
		if (dataSheet.getProperty("ShowClassify").equals("true"))
			bShowClassify=true;
*/
	String sDataSheetTerm = (String) dataSheet.getProperty("ReportTerm");
%>
<html>
<head>
<title>�Ŵ�ҵ��̶�ͳ�Ʊ���</title>
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
	//���������õ�������
	//������
	dataSheet.setParam("SheetID",sSheetID);
	dataSheet.setCondition("SheetID",sSheetID);
	//ͳ������
	dataSheet.setParam("InputDate",sInputDate);
	dataSheet.setCondition("InputDate",sInputDate);
	//�������
	dataSheet.setParam("OrgID",sOrgID);
	dataSheet.setCondition("OrgID",sOrgID);
	//��λ
	dataSheet.setParam("Unit",sUnit);
	dataSheet.setCondition("Unit",sUnit);
	//����
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
		/*cell����              
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
		//�ļ����������·��
		String sBasePath = application.getRealPath("/FixStat/Data");
		//�ļ���
		String sCurFileName = new java.io.File(request.getRequestURI()).getName();

		String sDataItemJs = "";
		//dataSheet.setParam("Total","�ϼƣ�");
		dataSheet.setParam("OrgLevel",""+sOrgID.length()/3);
		
		//�趨�������ڱ��� 
		/*
		if (bShowEndDate && sEndDate.length()!=0){
			dataSheet.setParam("FillinEndDate",com.amarsoft.ars.utils.DateUtils.getFillInDate(sInputDate));
		}
		*/
		if(sInputDate.length() == 4){
			//ȥ��ͬ��
			dataSheet.setParam("PreSyncTerm",com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, -1, 0,"yyyy"));
			//����ͬ��
			dataSheet.setParam("NextSyncTerm",com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 1, 0,"yyyy"));
		}else{
			//�趨�����������
			if (sInputDate.length() == 7) {
				//ȥ��ͬ��
				dataSheet.setParam("PreSyncTerm",com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, -1, 0));
				//����ͬ��
				dataSheet.setParam("NextSyncTerm",com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 1, 0));
			}else{
				//ȥ��ͬ��
				dataSheet.setParam("PreSyncTerm",com.amarsoft.ars.utils.DateUtils.getRelativeDate(sInputDate, -1, 0, 0));
				//����ͬ��
				dataSheet.setParam("NextSyncTerm",com.amarsoft.ars.utils.DateUtils.getRelativeDate(sInputDate, 1, 0, 0));
			}
			//�����
			//out.println(dataSheet.charsetCode());
			sTomorrow		= com.amarsoft.ars.utils.DateUtils.getRelativeDate(sInputDate, 0, 0, 1);	//����
			sYesterday		= com.amarsoft.ars.utils.DateUtils.getRelativeDate(sInputDate, 0, 0, -1);	//����
			sNextMonth		= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 0, 1);		//����
			sPreMonth		= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 0, -1);		//����
			sCurrentMonth	= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 0, 0);			//����
			sCurrentMonthEnd= com.amarsoft.ars.utils.DateUtils.getRelativeDate(sNextMonth+"/01",0,0,-1);	//������ĩ
			sPreQuarter		= com.amarsoft.ars.utils.DateUtils.getQuaterInfo(sInputDate, -1);		//�ϼ�
			sPreQuarter2	= com.amarsoft.ars.utils.DateUtils.getQuaterInfo(sInputDate, -2);		//��2��
			sPreQuarter3	= com.amarsoft.ars.utils.DateUtils.getQuaterInfo(sInputDate, -3);		//��3��
			sPreQuarter4	= com.amarsoft.ars.utils.DateUtils.getQuaterInfo(sInputDate, -4);		//��4��
			sNextQuarter	= com.amarsoft.ars.utils.DateUtils.getQuaterInfo(sInputDate, 1);		//�¼�
			sLastYear		= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, -1, 0,"yyyy");	//ȥ��
			sThisYear		= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 0, 0,"yyyy");	//����
			sNextYear		= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, 1, 0,"yyyy");	//����
			sPreYearEnd		= com.amarsoft.ars.utils.DateUtils.getRelativeMonth(sInputDate, -1, 0).substring(0, 4) + "/12";	//����ĩ
			sPreHalfYear	= com.amarsoft.ars.utils.DateUtils.getYearInfo(sInputDate, -1);		//ǰ������
			sNextHalfYear	= com.amarsoft.ars.utils.DateUtils.getYearInfo(sInputDate, 1);		//�������
			//cell����
			sFillinQuarter	= com.amarsoft.ars.utils.DateUtils.getQuaterName(sInputDate);
			sFillinDate		= com.amarsoft.ars.utils.DateUtils.getFillInDate(sInputDate);		//�������������
			sFillinOrgName	= "�������"+com.amarsoft.ars.utils.StringUtils.getOrgName(sOrgID,Sqlca.getConnection(),"");	//�����
			sFillinMonthOnly= com.amarsoft.ars.utils.DateUtils.getFillinParam(sInputDate,2);	//������·�
			sFillinYearOnly	= com.amarsoft.ars.utils.DateUtils.getFillinParam(sInputDate,1);
			sFillinQueryTerm= sFillinDate;
			/*
			sFillinQuarter	= sQuarterName;	//com.amarsoft.ars.utils.CharSetUtils.convertString(sQuarterName,com.amarsoft.ars.utils.CharSetUtils.ARS_CHARSET_COVERT_GBK_TO_ISO8859);
			sFillinDate		= sDateName;	//com.amarsoft.ars.utils.CharSetUtils.convertString(sDateName,com.amarsoft.ars.utils.CharSetUtils.ARS_CHARSET_COVERT_GBK_TO_ISO8859);
			sFillinOrgName	= "�������"+sOrgName;//com.amarsoft.ars.utils.CharSetUtils.convertString("�������",com.amarsoft.ars.utils.CharSetUtils.ARS_CHARSET_COVERT_GBK_TO_ISO8859)+sOrgName;
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
		//��������
		dataSheet.setParam("FillinYearOnly"		, sFillinYearOnly);
		String sLastTermFlag	= "M";
		String sPreQueryTerm	= sPreMonth;
		String sNextQueryTerm	= sNextMonth;
		String sTermName		= "(�±�)";
		if(sCtrlQry.equals(QUERY_TERM_YEAR)){
			sLastTermFlag	= "Y";
			sPreQueryTerm	= sLastYear;
			sNextQueryTerm	= sNextYear;
			sTermName		= "(�걨)";
			sFillinQueryTerm= sThisYear+" ��";
		}else if(sCtrlQry.equals(QUERY_TERM_HALF_YEAR)){
			sLastTermFlag	= "H";
			sPreQueryTerm	= sPreHalfYear;
			sNextQueryTerm	= sNextHalfYear;
			sTermName		= "(���걨)";
		}else if(sCtrlQry.equals(QUERY_TERM_QUARTER)){
			sLastTermFlag	= "Q";
			sPreQueryTerm	= sPreQuarter;
			sNextQueryTerm	= sNextQuarter;
			sTermName		= "(����)";
			sFillinQueryTerm= sFillinQuarter;
		}else if(sCtrlQry.equals(QUERY_TERM_DAY)){
			sLastTermFlag	= "D";
			sPreQueryTerm	= sYesterday;
			sNextQueryTerm	= sTomorrow;
			sTermName		= "(�ձ�)";
		}
		dataSheet.setParam("Term"			,sLastTermFlag);
		dataSheet.setParam("PreQueryTerm"	,sPreQueryTerm);
		dataSheet.setParam("NextQueryTerm"	,sNextQueryTerm);
		dataSheet.setParam("TermName"		,sTermName);
		dataSheet.setParam("FillinQueryTerm",sFillinQueryTerm);
		try{
			/* �����������Ԫ�ض��� */
			dataSheet.compileDataItem();
			/* ���ɲ�ѯ�����������ͻ���չʾ */
			dataSheet.genSheetResultJS(sBasePath,out,bRedoFlag);
			//�ͻ���չʾ�ű�
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