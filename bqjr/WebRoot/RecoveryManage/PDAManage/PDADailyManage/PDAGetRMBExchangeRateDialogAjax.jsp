<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/* Content:  ����������ֵõ�������ҵı���(����)��
	 * Input Param:
	 *	AssetSerialNo	��������� 
	 * Output param	���ñ��ֶ�����ҵı���.
	 */
	String sReclaimCurrency	= CurPage.getParameter("ReclaimCurrency"); //�������
	//��ȡReclaimCurrency���ֶ�����ҵĻ���
	String	sSql = "";
	String	sUnit = "";
	String	sPrice = "";
	String sReturnValue="";
	double	ddUnit = 0;
	double  ddPrice = 0;
	double	dOldCurrencyRatio = 1;  //ReclaimCurrency���ֶ���Ԫ����
	double	dRMBCurrencyRatio = 1;  //����Ҷ���Ԫ����
	double	dCurrencyRatio = 1;  //ReclaimCurrency���ֶ�����ҵĻ���
	ASResultSet rs = null;
	SqlObject so = null;
	//ReclaimCurrency���ֶ���Ԫ����(???/$)
	sSql = " select Unit,Price,EfficientDate  from ERATE_INFO where  Currency = :Currency order by EfficientDate desc ";
	so = new SqlObject(sSql).setParameter("Currency",sReclaimCurrency);
	//��������ȡ��һ����¼,��Ϊ�������.
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

	//����Ҷ���Ԫ����(RMB/$)
	sSql = " select Unit,Price,EfficientDate  from ERATE_INFO where  Currency = '01' order by EfficientDate desc ";
	//��������ȡ��һ����¼,��Ϊ�������.
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

	//ReclaimCurrency���ֶ�����ҵĻ���(??/RMB)
	dCurrencyRatio = dOldCurrencyRatio/dRMBCurrencyRatio;

	String sCurrencyRatio=String.valueOf(dCurrencyRatio);
	ArgTool args = new ArgTool();
	args.addArg(sCurrencyRatio);
	args.addArg(sCurrencyRatio);
	sReturnValue = args.getArgString();
	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>