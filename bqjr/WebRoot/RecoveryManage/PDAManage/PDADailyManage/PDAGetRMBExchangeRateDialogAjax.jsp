<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/* Content:  根据输入币种得到对人民币的比例(汇率)。
	 * Input Param:
	 *	AssetSerialNo	：输入币种 
	 * Output param	：该币种对人民币的比例.
	 */
	String sReclaimCurrency	= CurPage.getParameter("ReclaimCurrency"); //输入币种
	//获取ReclaimCurrency币种对人民币的汇率
	String	sSql = "";
	String	sUnit = "";
	String	sPrice = "";
	String sReturnValue="";
	double	ddUnit = 0;
	double  ddPrice = 0;
	double	dOldCurrencyRatio = 1;  //ReclaimCurrency币种对美元汇率
	double	dRMBCurrencyRatio = 1;  //人民币对美元汇率
	double	dCurrencyRatio = 1;  //ReclaimCurrency币种对人民币的汇率
	ASResultSet rs = null;
	SqlObject so = null;
	//ReclaimCurrency币种对美元汇率(???/$)
	sSql = " select Unit,Price,EfficientDate  from ERATE_INFO where  Currency = :Currency order by EfficientDate desc ";
	so = new SqlObject(sSql).setParameter("Currency",sReclaimCurrency);
	//降序排列取第一个记录,便为最近日期.
	rs = Sqlca.getASResultSet(so);
	if (rs.next()){
		sUnit = rs.getString(1);	
		sPrice = rs.getString(2);	
		if (sUnit == null || sUnit == "") sUnit = "1";
		if (sPrice == null || sPrice == "") sPrice = "1";

		Double dUnit = new Double(sUnit);	
		Double dPrice = new Double(sPrice);	
		ddUnit = dUnit.doubleValue();
		ddPrice = dPrice.doubleValue();
		if (ddUnit < 0.0001) ddUnit = 1;
		if (ddPrice < 0.0001) ddPrice = 1;
		dOldCurrencyRatio = ddUnit/ddPrice;
	}else
		dOldCurrencyRatio = 1;
	rs.getStatement().close(); 

	//人民币对美元汇率(RMB/$)
	sSql = " select Unit,Price,EfficientDate  from ERATE_INFO where  Currency = '01' order by EfficientDate desc ";
	//降序排列取第一个记录,便为最近日期.
	rs = Sqlca.getASResultSet(sSql);
	if (rs.next()){
		sUnit = rs.getString(1);	
		sPrice = rs.getString(2);	
		if (sUnit == null || sUnit == "") sUnit = "1";
		if (sPrice==null || sPrice=="") sPrice = "1";

		Double dUnit = new Double(sUnit);	
		Double dPrice = new Double(sPrice);	
		ddUnit = dUnit.doubleValue();
		ddPrice = dPrice.doubleValue();
		if (ddUnit < 0.0001) ddUnit = 1;
		if (ddPrice < 0.0001) ddPrice = 1;
		dRMBCurrencyRatio = ddUnit/ddPrice;
	}else
		dRMBCurrencyRatio = 1;
	rs.getStatement().close(); 

	//ReclaimCurrency币种对人民币的汇率(??/RMB)
	dCurrencyRatio = dOldCurrencyRatio/dRMBCurrencyRatio;

	String sCurrencyRatio=String.valueOf(dCurrencyRatio);
	ArgTool args = new ArgTool();
	args.addArg(sCurrencyRatio);
	args.addArg(sCurrencyRatio);
	sReturnValue = args.getArgString();
	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>