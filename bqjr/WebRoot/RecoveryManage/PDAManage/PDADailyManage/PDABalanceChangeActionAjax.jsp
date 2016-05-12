<%
/* Content:  ���ڵ�ծ�ʲ����ı䶯������������ʲ������
 * Input Param:
 *		SerialNo���ʲ���ˮ�� 
 * 		Interval_Value���䶯���Ĳ���Ϊ���ܺ����޸ĵ����������ı䶯��ֵ���ܲ��Ǳ䶯��
 *		ChangeType���䶯����
 * Output param		
 *		���䶯���ͣ�����ͳ��ۣ�BalanceChangeType
 *		�ʲ������ʲ����y=�ʲ����е�����a-�䶯���б䶯���b.
 *		���ʽ�����b>0;otherwise b<0.
 */
%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	String sSerialNo = CurPage.getParameter("SerialNo"); //�ʲ���ˮ��
	String sInterval_Value = CurPage.getParameter("Interval_Value"); //��Ҫ�䶯��ֵ:�з���!
	String sChangeType = CurPage.getParameter("ChangeType"); //�䶯����
	String sSql = "";

	Double vInterval_Value = new Double(sInterval_Value);	 
	String  sAssetBalance = "0";
	String  sOutNowBalance = "0";
	String  sFlag = "0";
	String sReturnValue="";
	double vValue = 0.0;
	ASResultSet rs = null;
	SqlObject so = null;

	sSql = " select AssetBalance,OutNowBalance,Flag from ASSET_INFO where SerialNo =:SerialNo and AssetAttribute = '01' ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sSerialNo));
	if(rs.next()){
	   	sAssetBalance = DataConvert.toString(rs.getString("AssetBalance"));	   	
		if((sAssetBalance == null) || (sAssetBalance.equals(""))) sAssetBalance = "0"; 
	   	sOutNowBalance = DataConvert.toString(rs.getString("OutNowBalance"));	   	
		if ((sOutNowBalance == null) || (sOutNowBalance.equals(""))) sOutNowBalance = "0"; 
	   	sFlag = DataConvert.toString(rs.getString("Flag"));	   	
		if ((sFlag == null) || (sFlag.equals(""))) sFlag = "010";  //������������ܳ���
	}
	rs.getStatement().close(); 

	Double vAssetBalance = new Double(sAssetBalance); 
	Double vOutNowBalance = new Double(sOutNowBalance); 
	
	if (sChangeType.equals("020")){ //����
		if (sFlag.equals("010") ){//����
			vValue = vAssetBalance.doubleValue() + vInterval_Value.doubleValue();  //�������.
		}else{
			vValue = vOutNowBalance.doubleValue() + vInterval_Value.doubleValue();  //�������.
		}
	}else{  //����
		if (sFlag.equals("010")){ //����
			vValue = vAssetBalance.doubleValue() - vInterval_Value.doubleValue();  //�������.
		}else{
			vValue = vOutNowBalance.doubleValue() - vInterval_Value.doubleValue();  //�������.
		}
	}

	if (sFlag.equals("010") ){//����
	    sSql = " UPDATE ASSET_INFO  SET AssetBalance =:AssetBalance WHERE  SerialNo =:SerialNo and AssetAttribute = '01' ";
	    so = new SqlObject(sSql).setParameter("AssetBalance",vValue).setParameter("SerialNo",sSerialNo);
	}else{
	    sSql = " UPDATE ASSET_INFO  SET OutNowBalance =:OutNowBalance WHERE  SerialNo =:SerialNo and AssetAttribute = '01' ";
	    so = new SqlObject(sSql).setParameter("OutNowBalance",vValue).setParameter("SerialNo",sSerialNo);
	}	
    Sqlca.executeSQL(so);
    sReturnValue="vValue";

	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>