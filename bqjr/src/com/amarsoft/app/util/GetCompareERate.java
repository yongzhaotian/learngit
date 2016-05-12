package com.amarsoft.app.util;

import com.amarsoft.app.als.sadre.util.DateUtil;
import com.amarsoft.app.als.sadre.util.DecimalUtil;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 取相对汇率
 *   先取"待取相对汇率币种"的汇率dFromERateValue,再取"基准币种"的汇率dToERateValue,
 *   二者比较既得相对汇率
 * 
 * @author hwang 2011-03-03
 *
 */
public class GetCompareERate {
	/**
	 * 取相对汇率
	 * @return dCompareERate相对汇率
	 * @throws Exception 
	 */
	public static double getCompareERate(String sFromCurrency,String sToCurrency){
		double dFromERateValue = 0.0;
		double dToERateValue = 0.0;
		double dCompareERate = 0.0;
		if(sFromCurrency==null || "".equals(sFromCurrency)) sFromCurrency="01";
		if(sToCurrency==null || "".equals(sToCurrency)) sToCurrency="01";
		try {
			if( sFromCurrency.equals(sToCurrency) ) return 1.00 ;
			//取需转换的币种汇率
			if("01".equals(sFromCurrency)){
				dFromERateValue=1.0;
			}else{
				dFromERateValue=getExchangeValue(sFromCurrency);
			}
			//取转换目标币种汇率
			if("01".equals(sToCurrency)){
				dToERateValue=1.0;
			}else{
				dToERateValue=getExchangeValue(sToCurrency);
			}
			//获取相对汇率
//			dCompareERate=dFromERateValue/dToERateValue;
			dCompareERate=DecimalUtil.divide(dFromERateValue, dToERateValue);
		} catch (JBOException e) {
			ARE.getLog().warn("获取相对利率出错,sFromCurrency=["+sFromCurrency+"],sToCurrency=["+sToCurrency+"]");
			e.printStackTrace();
		}
		return dCompareERate;
	}
	/**
	 * 获取币种转成人民币最新汇率
	 * @param sCurrency
	 * @return
	 */
	public static double getConvertToRMBERate(String sCurrency){
		return getCompareERate(sCurrency,"01");
	}
	/**
	 * 获取币种换算成人民币后汇率
	 * @param sCurrency
	 * @return
	 * @throws JBOException
	 */
	private static double getExchangeValue(String sCurrency) throws JBOException{
		double dERateValue=0.0;
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.sys.ERATE_INFO");
		BizObjectQuery bq = bm.createQuery("Currency=:Currency and EfficientDate<=:Now order by EfficientDate desc");
		bq.setParameter("Currency",sCurrency).setParameter("Now",DateUtil.getToday());
		BizObject bo = bq.getSingleResult(false);
		if(bo != null){
			dERateValue = bo.getAttribute("ExchangeValue").getDouble();
		}else{//币种没有配置有效的汇率信息,默认为人民币
			dERateValue=1.0;
			ARE.getLog().warn("汇率表中没有找到该币种有效的汇率信息!"+sCurrency);
		}
		return dERateValue;
	}
}
