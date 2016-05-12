package com.amarsoft.app.accounting.config.loader;

import java.io.ByteArrayInputStream;
import java.util.ArrayList;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.util.RateFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;
import com.amarsoft.dict.als.cache.CodeCache;


/**
 * The persistent class for the ACC_RATE_INFO database table.
 * �������ʱ��ʼ��
 */
public class RateConfig extends AbstractCache{
	private static ASValuePool rateSet;
	private static ASValuePool rateTypeSet;
	private static ASValuePool erateSet;
	private static ASValuePool interestConfigSet;
	
	public static ASValuePool getRateTypeSet() {
		return rateTypeSet;
	}
	
	public static ASValuePool getInterestConfigSet() {
		return interestConfigSet;
	}

	public static void setRateTypeSet(ASValuePool rateTypeSet) {
		RateConfig.rateTypeSet = rateTypeSet;
	}

	/**
	 * @param Currency ���� �μ�����Currency
	 * @param baseRateType �������ͣ��μ�����BaseRateType
	 * @param putOutDate  ��������
	 * @param maturityDate ������
	 * @return ���ʵ���
	 * @throws Exception
	 */
	public static String getBaseRateGrade(String currency,String baseRateType,String putoutDate,String maturityDate,String effectDate) throws Exception{
		int term = DateFunctions.getUpMonths(putoutDate,maturityDate);//����ȡ��
		return RateConfig.getBaseRateGrade(currency, baseRateType, DateFunctions.TERM_UNIT_MONTH, term, effectDate);
	}
	
	/**
	 * @param Currency ���� �μ�����Currency
	 * @param baseRateType �������ͣ��μ�����BaseRateType
	 * @param putOutDate  ��������
	 * @param maturityDate ������
	 * @return ���ʵ���
	 * @throws Exception
	 */
	public static String getBaseRateGrade(String currency,String baseRateType,String termUnit,int term,String effectDate) throws Exception{
		
		ArrayList<ASValuePool> rateList = RateConfig.getBaseRateList(baseRateType,currency,effectDate);
		if(rateList == null || rateList.size() == 0) throw new Exception("δ����û�׼�������͡�"+baseRateType+"��");
		//�����׼����
		for(int i=0;i<rateList.size();i++){
			ASValuePool rateAttributes = (ASValuePool)rateList.get(i);
			if(DateFunctions.TERM_UNIT_DAY.equals(termUnit)){
				term = term/30;
			}else if(DateFunctions.TERM_UNIT_YEAR.equals(termUnit)){
				term = term*12;
			}
			//�ж������Ƿ������ʲ�����
			if(term <= Integer.parseInt(rateAttributes.getString("Term"))){
				if(i < rateList.size()-1 && term > Integer.parseInt(rateList.get(i+1).getString("Term")))
				{
					return rateAttributes.getInt("Term")+"@"+rateAttributes.getString("TermUnit");
				}
				else if(i == rateList.size()-1)
				{
					return rateAttributes.getInt("Term")+"@"+rateAttributes.getString("TermUnit");
				}
			}
		}
		return "@";
	}
	
	/**
	 * @param Currency ���֣��μ�����Currency
	 * @param YearDays ���׼���� Ӣʽ���� 365 �������� 360�����ﴫ����Ҫ�ǽ���������������Ҫ�� 
	 * @param BaseRateType �������ͣ��μ�����BaseRateType
	 * @param RateUnit ���ʵ�λ���μ�����RateUnit
	 * @param putOutDate  ��������
	 * @param maturityDate ������
	 * @return ���ض�Ӧ���ʵ�λ������ֵ
	 * @throws Exception
	 */
	public static double getBaseRate(String currency,int yearDays,String baseRateType,String RateUnit,String putoutDate,String maturityDate,String effectDate) throws Exception{
		int term = DateFunctions.getUpMonths(putoutDate,maturityDate);//����ȡ��
		return RateConfig.getBaseRate(currency,yearDays,baseRateType,RateUnit, DateFunctions.TERM_UNIT_MONTH, term,effectDate);
	}
	
	/**
	 * @param Currency ���֣��μ�����Currency
	 * @param YearDays ���׼���� Ӣʽ���� 365 �������� 360�����ﴫ����Ҫ�ǽ���������������Ҫ�� 
	 * @param BaseRateType �������ͣ��μ�����BaseRateType
	 * @param RateUnit ���ʵ�λ���μ�����RateUnit
	 * @param TermUnit ���޵�λ���μ�����TermUnit
	 * @param Term ����
	 * @return ���ض�Ӧ���ʵ�λ������ֵ
	 * @throws Exception
	 */
	public static double getBaseRate(String currency,int yearDays,String baseRateType,String RateUnit,String termUnit,int term,String effectDate) throws Exception{
		double baseRate = 0.0;
		ArrayList<ASValuePool> rateList = RateConfig.getBaseRateList(baseRateType,currency,effectDate);
		if(rateList == null || rateList.size() == 0) throw new Exception("δ����û�׼�������͡�"+baseRateType+"��");
		//�����׼����
		for(int i=0;i<rateList.size();i++){
			ASValuePool rateAttributes = (ASValuePool)rateList.get(i);
			if(DateFunctions.TERM_UNIT_DAY.equals(termUnit)){
				term = term/30;
			}else if(DateFunctions.TERM_UNIT_YEAR.equals(termUnit)){
				term = term*12;
			}
			//�ж������Ƿ������ʲ�����
			if(term <= Integer.parseInt(rateAttributes.getString("Term"))){
				if(i < rateList.size()-1 && term > Integer.parseInt(rateList.get(i+1).getString("Term")))
				{
					baseRate = Double.parseDouble(String.valueOf(rateAttributes.getAttribute("RateValue")));
					//�������ʵ�λת��
					baseRate = RateFunctions.getRate(yearDays, rateAttributes.getString("RateUnit"), baseRate, RateUnit);
					if(baseRate>0d)
						break;
				}
				else if(i == rateList.size()-1)
				{
					baseRate = Double.parseDouble(String.valueOf(rateAttributes.getAttribute("RateValue")));
					//�������ʵ�λת��
					baseRate = RateFunctions.getRate(yearDays, rateAttributes.getString("RateUnit"), baseRate, RateUnit);
					if(baseRate>0d)
						break;
				}
			}
		}
		if(baseRate<=0) throw new Exception("��ȡ�Ļ�׼����Ϊ�㣬���飡");
		return Arith.round(baseRate,8);
	}
	
	
	/**
	 * ��ȡ����
	 * @param exchangeRateCatalog:�������࣬��PCC��
	 * @param priceCurrency���Ƽ۱���
	 * @param baseCurrency����׼����
	 * @param rateType���������ͣ�CCYRATE�м�ۣ�BUYRATE����ۣ�SELLRATE������
	 * @return
	 * @throws Exception
	 */
	public static double getExchangeRate(String fromCurrency,String toCurrency) throws Exception{
		if(fromCurrency.equals(toCurrency)) return 1.0;
		double pricevalue = 1.0;//Price��������м��
		double basevalue = 1.0;//base��������м��
		ASValuePool priceerate = (ASValuePool) RateConfig.erateSet.getAttribute(fromCurrency);
		ASValuePool baseerate = (ASValuePool) RateConfig.erateSet.getAttribute(toCurrency);
		if(priceerate == null && !"01".equals(fromCurrency)) throw new Exception("δά����"+CodeCache.getItemName("Currency",fromCurrency)+"���Ļ��ʣ���ϵͳ����Ա��飡");
		else if("01".equals(fromCurrency))  pricevalue = 1.0;
		else pricevalue = Double.parseDouble(String.valueOf(priceerate.getAttribute("ExchangeValue")));
		
		if(baseerate == null && !"01".equals(toCurrency)) throw new Exception("δά����"+CodeCache.getItemName("Currency",toCurrency)+"���Ļ��ʣ���ϵͳ����Ա��飡");
		else if("01".equals(toCurrency))  pricevalue = 1.0;
		else basevalue = Double.parseDouble(String.valueOf(baseerate.getAttribute("ExchangeValue")));
		
		if(Math.abs(basevalue) < 0.0000001) throw new Exception("δά����"+CodeCache.getItemName("Currency",toCurrency)+"���Ļ����ǡ�"+basevalue+"������ϵͳ����Ա��飡");
		
		return pricevalue/basevalue;
	}
	
	/**
	 * ��ȡ���ʵ�javascript��ֵ
	 */
	public static String createJSArray(String currency) throws Exception{
		StringBuffer sb = new StringBuffer();
		sb.append(" var rateArray = new Array(); ");
		Object[] os = rateSet.getKeys();
		int m = 0;
		for(int i = 0; i < os.length; i++)
		{
			String key = (String)os[i];
			ArrayList<ASValuePool> list = (ArrayList<ASValuePool>)rateSet.getAttribute(key);
			String effectDate = "";
			for(int j = 0; j < list.size() ; j++)
			{
				String rateCurrency =list.get(j).getString("Currency");
				
				if((rateCurrency==null||rateCurrency.length()==0||rateCurrency.indexOf(currency)>=0) && list.get(j).getString("EffectDate").compareTo(SystemConfig.getBusinessDate()) <= 0)
				{
					effectDate = list.get(j).getString("EffectDate");
					break;
				}
			}
			for(int j = 0; j < list.size() ; j++)
			{
				String rateCurrency =list.get(j).getString("Currency");
				if((rateCurrency==null||rateCurrency.length()==0||rateCurrency.indexOf(currency)>=0) && effectDate.equals(list.get(j).getString("EffectDate")))
				{
					sb.append("  rateArray["+m+"]=new Array(\""+key+"\",\""+list.get(j).getInt("Term")+"@"+list.get(j).getString("TermUnit")+"\",\""+list.get(j).getInt("Term")+CodeCache.getItemName("TermUnit",list.get(j).getString("TermUnit"))+"\");");
					m++;
				}
			}
		}
		return sb.toString();
	}

	/*
	 * ��ջ������
	 * @see com.amarsoft.dict.als.cache.AbstractCache#clear()
	 */
	public void clear() throws Exception {
		
	}
	
	private static ArrayList<ASValuePool> getBaseRateList(String baseRateType,String currency, String effectDate) throws Exception{
		ArrayList<ASValuePool> rateList = (ArrayList<ASValuePool>) RateConfig.rateSet.getAttribute(baseRateType);
		ArrayList<ASValuePool> baseRateList = new ArrayList<ASValuePool>();
		if(rateList == null) return null;
		for(ASValuePool rateSegment : rateList) {
			if(!baseRateType.equals(rateSegment.getString("RateType"))) continue;
			if(effectDate.compareTo(rateSegment.getString("EffectDate"))<0) continue;
			String baseRateCurrency = rateSegment.getString("Currency");
			if(baseRateCurrency!=null && baseRateCurrency.length() > 0 && baseRateCurrency.indexOf(currency) < 0) continue;
			baseRateList.add(rateSegment);
		}
		return baseRateList;
	}

	/*
	 * �������ʲ���������Ϣ
	 * @see com.amarsoft.dict.als.cache.AbstractCache#load(com.amarsoft.awe.util.Transaction)
	 */
	public synchronized boolean load(Transaction transaction) throws Exception {
		try
		{
			ASValuePool rateSet = new ASValuePool();
			ASResultSet rs=transaction.getASResultSet("select * from RATE_INFO where Status = '1'  order by Currency desc, EffectDate desc,RateType,Term desc ");
			while(rs.next()){
				String rateType = rs.getString("RateType");
				ArrayList<ASValuePool> rateList = (ArrayList<ASValuePool>) rateSet.getAttribute(rateType);
				if(rateList==null) {
					rateList = new ArrayList<ASValuePool>();
					rateSet.setAttribute(rateType, rateList);
				}
				ASValuePool rateAttributes=new ASValuePool();
				rateAttributes.setAttribute("RateType", rateType); //��������
				rateAttributes.setAttribute("Currency", rs.getString("Currency"));
				rateAttributes.setAttribute("RateUnit", rs.getString("RateUnit")); //���ʵ�λ
				rateAttributes.setAttribute("Term", rs.getString("Term"));//����
				rateAttributes.setAttribute("TermUnit", rs.getString("TermUnit"));//���޵�λ
				rateAttributes.setAttribute("RateValue", rs.getDouble("RateValue"));//����
				rateAttributes.setAttribute("EffectDate", rs.getString("EffectDate"));
				rateList.add(rateAttributes);
			}
			rs.close();
			
			ASValuePool erateSet = new ASValuePool();
			rs = transaction.getASResultSet("select * from ERATE_INFO order by EfficientDate,Currency ");
			while(rs.next()){
				String currency = rs.getString("Currency");
				ASValuePool erate=new ASValuePool();
				erate.setAttribute("ExchangeValue",rs.getDouble("ExchangeValue"));
				erate.setAttribute("Currency",rs.getString("Currency"));
				erate.setAttribute("EfficientDate",rs.getString("EfficientDate"));
				erate.setAttribute("Unit",rs.getString("Unit"));
				erate.setAttribute("Price", rs.getString("Price"));
				erateSet.setAttribute(currency, erate);
			}
			RateConfig.rateSet = rateSet;
			RateConfig.erateSet = erateSet;
			loadRateType(transaction);
			loadInterestConfig(transaction);
	   return true;
		}catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
	}
	
	
	/**
	 * ���������͵Ķ�����ص������У��������Ͷ���Ĳ���������չ
	 * @param transaction
	 * @return
	 * @throws Exception
	 */
	public boolean loadRateType(Transaction transaction) throws Exception {
		rateTypeSet = new ASValuePool();
		ASResultSet rs=transaction.getASResultSet("select * from CODE_LIBRARY where CodeNo = 'RateType' and IsInUse = '1' ");
		while(rs.next()){
			String rateType = rs.getString("ItemNo");
			ASValuePool rateTypeDef = (ASValuePool)rateTypeSet.getAttribute(rateType);
			if(rateTypeDef==null) {
				rateTypeDef = new ASValuePool();
				rateTypeSet.setAttribute(rateType, rateTypeDef);
			}
			
			rateTypeDef.setAttribute("RateType", rateType); //��������
			String ex_attributes = rs.getString("RelativeCode");
			if(ex_attributes!=null&&ex_attributes.length()>0){
				String[] s= ex_attributes.split(";");
				for(String s1:s){
					String[] s2=s1.split("=");
					rateTypeDef.setAttribute(s2[0].trim(),s1.substring(s1.indexOf("=")+1).trim());
				}
			}
			rateTypeSet.setAttribute(rateType, rateTypeDef);
		}
		rs.close();
		return true;
	}
	
	/**
	 * ���������͵Ķ�����ص������У��������Ͷ���Ĳ���������չ
	 * @param transaction
	 * @return
	 * @throws Exception
	 */
	public boolean loadInterestConfig(Transaction transaction) throws Exception {
		interestConfigSet = new ASValuePool();
		ASResultSet rs=transaction.getASResultSet("select * from CODE_LIBRARY where CodeNo = 'InterestConfig' and IsInUse = '1' ");
		while(rs.next()){
			String interestType = rs.getString("ItemNo");
			ASValuePool interestConfig = (ASValuePool)interestConfigSet.getAttribute(interestType);
			if(interestConfig==null) {
				interestConfig = new ASValuePool();
				interestConfigSet.setAttribute(interestType, interestConfig);
			}
			
			String attributes = rs.getString("RelativeCode");//��չ����
			if(attributes==null||attributes.trim().length()==0) continue;
			ARE.getLog().debug(attributes);
			ByteArrayInputStream inputStream = new ByteArrayInputStream(attributes.getBytes());
			Document d= new Document(inputStream);
			interestConfig.setAttribute("XMLDocument", d);
			interestConfigSet.setAttribute(interestType, interestConfig);
		}
		rs.close();
		return true;
	}
	
	public static String getInterestConfig(String interestType,String attributeID) throws Exception{
		Document d = (Document)((ASValuePool)interestConfigSet.getAttribute(interestType)).getAttribute("XMLDocument");
		if(d==null) return "";
		String value = d.getRootElement().getAttributeValue(attributeID);
		if(value==null||value.length()==0) value = d.getRootElement().getChildTextTrim(attributeID);
		return value;
	}
}