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
 * ȡ��Ի���
 *   ��ȡ"��ȡ��Ի��ʱ���"�Ļ���dFromERateValue,��ȡ"��׼����"�Ļ���dToERateValue,
 *   ���߱Ƚϼȵ���Ի���
 * 
 * @author hwang 2011-03-03
 *
 */
public class GetCompareERate {
	/**
	 * ȡ��Ի���
	 * @return dCompareERate��Ի���
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
			//ȡ��ת���ı��ֻ���
			if("01".equals(sFromCurrency)){
				dFromERateValue=1.0;
			}else{
				dFromERateValue=getExchangeValue(sFromCurrency);
			}
			//ȡת��Ŀ����ֻ���
			if("01".equals(sToCurrency)){
				dToERateValue=1.0;
			}else{
				dToERateValue=getExchangeValue(sToCurrency);
			}
			//��ȡ��Ի���
//			dCompareERate=dFromERateValue/dToERateValue;
			dCompareERate=DecimalUtil.divide(dFromERateValue, dToERateValue);
		} catch (JBOException e) {
			ARE.getLog().warn("��ȡ������ʳ���,sFromCurrency=["+sFromCurrency+"],sToCurrency=["+sToCurrency+"]");
			e.printStackTrace();
		}
		return dCompareERate;
	}
	/**
	 * ��ȡ����ת����������»���
	 * @param sCurrency
	 * @return
	 */
	public static double getConvertToRMBERate(String sCurrency){
		return getCompareERate(sCurrency,"01");
	}
	/**
	 * ��ȡ���ֻ��������Һ����
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
		}else{//����û��������Ч�Ļ�����Ϣ,Ĭ��Ϊ�����
			dERateValue=1.0;
			ARE.getLog().warn("���ʱ���û���ҵ��ñ�����Ч�Ļ�����Ϣ!"+sCurrency);
		}
		return dERateValue;
	}
}
