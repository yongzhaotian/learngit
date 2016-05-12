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
 * 基本利率表初始化
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
	 * @param Currency 币种 参见代码Currency
	 * @param baseRateType 利率类型：参见代码BaseRateType
	 * @param putOutDate  发放日期
	 * @param maturityDate 到期日
	 * @return 利率档次
	 * @throws Exception
	 */
	public static String getBaseRateGrade(String currency,String baseRateType,String putoutDate,String maturityDate,String effectDate) throws Exception{
		int term = DateFunctions.getUpMonths(putoutDate,maturityDate);//向上取整
		return RateConfig.getBaseRateGrade(currency, baseRateType, DateFunctions.TERM_UNIT_MONTH, term, effectDate);
	}
	
	/**
	 * @param Currency 币种 参见代码Currency
	 * @param baseRateType 利率类型：参见代码BaseRateType
	 * @param putOutDate  发放日期
	 * @param maturityDate 到期日
	 * @return 利率档次
	 * @throws Exception
	 */
	public static String getBaseRateGrade(String currency,String baseRateType,String termUnit,int term,String effectDate) throws Exception{
		
		ArrayList<ASValuePool> rateList = RateConfig.getBaseRateList(baseRateType,currency,effectDate);
		if(rateList == null || rateList.size() == 0) throw new Exception("未定义该基准利率类型【"+baseRateType+"】");
		//计算基准利率
		for(int i=0;i<rateList.size();i++){
			ASValuePool rateAttributes = (ASValuePool)rateList.get(i);
			if(DateFunctions.TERM_UNIT_DAY.equals(termUnit)){
				term = term/30;
			}else if(DateFunctions.TERM_UNIT_YEAR.equals(termUnit)){
				term = term*12;
			}
			//判断期限是否在利率参数内
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
	 * @param Currency 币种：参见代码Currency
	 * @param YearDays 年基准天数 英式币种 365 其他币种 360，这里传入主要是解决存量贷款的特殊要求 
	 * @param BaseRateType 利率类型：参见代码BaseRateType
	 * @param RateUnit 利率单位：参见代码RateUnit
	 * @param putOutDate  发放日期
	 * @param maturityDate 到期日
	 * @return 返回对应利率单位的利率值
	 * @throws Exception
	 */
	public static double getBaseRate(String currency,int yearDays,String baseRateType,String RateUnit,String putoutDate,String maturityDate,String effectDate) throws Exception{
		int term = DateFunctions.getUpMonths(putoutDate,maturityDate);//向上取整
		return RateConfig.getBaseRate(currency,yearDays,baseRateType,RateUnit, DateFunctions.TERM_UNIT_MONTH, term,effectDate);
	}
	
	/**
	 * @param Currency 币种：参见代码Currency
	 * @param YearDays 年基准天数 英式币种 365 其他币种 360，这里传入主要是解决存量贷款的特殊要求 
	 * @param BaseRateType 利率类型：参见代码BaseRateType
	 * @param RateUnit 利率单位：参见代码RateUnit
	 * @param TermUnit 期限单位：参见代码TermUnit
	 * @param Term 期限
	 * @return 返回对应利率单位的利率值
	 * @throws Exception
	 */
	public static double getBaseRate(String currency,int yearDays,String baseRateType,String RateUnit,String termUnit,int term,String effectDate) throws Exception{
		double baseRate = 0.0;
		ArrayList<ASValuePool> rateList = RateConfig.getBaseRateList(baseRateType,currency,effectDate);
		if(rateList == null || rateList.size() == 0) throw new Exception("未定义该基准利率类型【"+baseRateType+"】");
		//计算基准利率
		for(int i=0;i<rateList.size();i++){
			ASValuePool rateAttributes = (ASValuePool)rateList.get(i);
			if(DateFunctions.TERM_UNIT_DAY.equals(termUnit)){
				term = term/30;
			}else if(DateFunctions.TERM_UNIT_YEAR.equals(termUnit)){
				term = term*12;
			}
			//判断期限是否在利率参数内
			if(term <= Integer.parseInt(rateAttributes.getString("Term"))){
				if(i < rateList.size()-1 && term > Integer.parseInt(rateList.get(i+1).getString("Term")))
				{
					baseRate = Double.parseDouble(String.valueOf(rateAttributes.getAttribute("RateValue")));
					//进行利率单位转换
					baseRate = RateFunctions.getRate(yearDays, rateAttributes.getString("RateUnit"), baseRate, RateUnit);
					if(baseRate>0d)
						break;
				}
				else if(i == rateList.size()-1)
				{
					baseRate = Double.parseDouble(String.valueOf(rateAttributes.getAttribute("RateValue")));
					//进行利率单位转换
					baseRate = RateFunctions.getRate(yearDays, rateAttributes.getString("RateUnit"), baseRate, RateUnit);
					if(baseRate>0d)
						break;
				}
			}
		}
		if(baseRate<=0) throw new Exception("获取的基准利率为零，请检查！");
		return Arith.round(baseRate,8);
	}
	
	
	/**
	 * 获取汇率
	 * @param exchangeRateCatalog:汇率种类，如PCC等
	 * @param priceCurrency：计价币种
	 * @param baseCurrency：基准币种
	 * @param rateType：汇率类型：CCYRATE中间价；BUYRATE汇买价；SELLRATE汇卖价
	 * @return
	 * @throws Exception
	 */
	public static double getExchangeRate(String fromCurrency,String toCurrency) throws Exception{
		if(fromCurrency.equals(toCurrency)) return 1.0;
		double pricevalue = 1.0;//Price对人民币中间价
		double basevalue = 1.0;//base对人民币中间价
		ASValuePool priceerate = (ASValuePool) RateConfig.erateSet.getAttribute(fromCurrency);
		ASValuePool baseerate = (ASValuePool) RateConfig.erateSet.getAttribute(toCurrency);
		if(priceerate == null && !"01".equals(fromCurrency)) throw new Exception("未维护【"+CodeCache.getItemName("Currency",fromCurrency)+"】的汇率，请系统管理员检查！");
		else if("01".equals(fromCurrency))  pricevalue = 1.0;
		else pricevalue = Double.parseDouble(String.valueOf(priceerate.getAttribute("ExchangeValue")));
		
		if(baseerate == null && !"01".equals(toCurrency)) throw new Exception("未维护【"+CodeCache.getItemName("Currency",toCurrency)+"】的汇率，请系统管理员检查！");
		else if("01".equals(toCurrency))  pricevalue = 1.0;
		else basevalue = Double.parseDouble(String.valueOf(baseerate.getAttribute("ExchangeValue")));
		
		if(Math.abs(basevalue) < 0.0000001) throw new Exception("未维护【"+CodeCache.getItemName("Currency",toCurrency)+"】的汇率是【"+basevalue+"】，请系统管理员检查！");
		
		return pricevalue/basevalue;
	}
	
	/**
	 * 获取利率的javascript数值
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
	 * 清空缓存对象
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
	 * 加载利率参数定义信息
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
				rateAttributes.setAttribute("RateType", rateType); //利率类型
				rateAttributes.setAttribute("Currency", rs.getString("Currency"));
				rateAttributes.setAttribute("RateUnit", rs.getString("RateUnit")); //利率单位
				rateAttributes.setAttribute("Term", rs.getString("Term"));//期限
				rateAttributes.setAttribute("TermUnit", rs.getString("TermUnit"));//期限单位
				rateAttributes.setAttribute("RateValue", rs.getDouble("RateValue"));//利率
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
	 * 将利率类型的定义加载到缓存中，利率类型定义的参数可以扩展
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
			
			rateTypeDef.setAttribute("RateType", rateType); //利率类型
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
	 * 将利率类型的定义加载到缓存中，利率类型定义的参数可以扩展
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
			
			String attributes = rs.getString("RelativeCode");//扩展属性
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