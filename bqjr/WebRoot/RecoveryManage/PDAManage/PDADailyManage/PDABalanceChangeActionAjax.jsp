<%
/* Content:  由于抵债资产余额的变动，因而必须变更资产表余额
 * Input Param:
 *		SerialNo：资产流水号 
 * 		Interval_Value：变动金额的差额。因为可能含有修改的情况，这里的变动差值可能不是变动金额。
 *		ChangeType：变动方向
 * Output param		
 *		余额变动类型：出租和出售，BalanceChangeType
 *		资产表中资产余额y=资产表中抵入金额a-变动表中变动金额b.
 *		当资金流入b>0;otherwise b<0.
 */
%>
<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	String sSerialNo = CurPage.getParameter("SerialNo"); //资产流水号
	String sInterval_Value = CurPage.getParameter("Interval_Value"); //需要变动的值:有符号!
	String sChangeType = CurPage.getParameter("ChangeType"); //变动方向
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
		if ((sFlag == null) || (sFlag.equals(""))) sFlag = "010";  //这种情况不可能出现
	}
	rs.getStatement().close(); 

	Double vAssetBalance = new Double(sAssetBalance); 
	Double vOutNowBalance = new Double(sOutNowBalance); 
	
	if (sChangeType.equals("020")){ //增加
		if (sFlag.equals("010") ){//表内
			vValue = vAssetBalance.doubleValue() + vInterval_Value.doubleValue();  //计算余额.
		}else{
			vValue = vOutNowBalance.doubleValue() + vInterval_Value.doubleValue();  //计算余额.
		}
	}else{  //减少
		if (sFlag.equals("010")){ //表内
			vValue = vAssetBalance.doubleValue() - vInterval_Value.doubleValue();  //计算余额.
		}else{
			vValue = vOutNowBalance.doubleValue() - vInterval_Value.doubleValue();  //计算余额.
		}
	}

	if (sFlag.equals("010") ){//表内
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