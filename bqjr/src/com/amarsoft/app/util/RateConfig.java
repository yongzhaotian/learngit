package com.amarsoft.app.util;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.dict.als.manage.CodeManager;

public class RateConfig {
	
	private static ArrayList<RateInfo> rateList = new ArrayList<RateInfo>();
	
	private String TermDay;
	private String RateType;
	private String Currency; 
	private String BusinessType;
	
	
	public String getBusinessType() {
		return BusinessType;
	}

	public void setBusinessType(String businessType) {
		BusinessType = businessType;
	}

	public String getTermDay() {
		return TermDay;
	}

	public void setTermDay(String termDay) {
		TermDay = termDay;
	}

	public String getRateType() {
		return RateType;
	}

	public void setRateType(String rateType) {
		RateType = rateType;
	}

	public String getCurrency() {
		return Currency;
	}

	public void setCurrency(String currency) {
		Currency = currency;
	}

	//Loan利率数据
	public static boolean load() throws JBOException 
	{
		rateList = new ArrayList<RateInfo>();
		BizObjectManager mri = JBOFactory.getFactory().getManager("jbo.sys.RATE_INFO");
		List<BizObject> boList= mri.createQuery("Status = '1' order by efficientDate,RateType,Currency ").getResultList(false);
		for(BizObject bo:boList)
		{
			RateInfo ri = new RateInfo();
			ri.setCurrency(bo.getAttribute("Currency").getString());
			ri.setEfficientDate(bo.getAttribute("EfficientDate").getString());
			ri.setRateType(bo.getAttribute("RateType").getString());
			ri.setTermUnit(bo.getAttribute("TermUnit").getString());
			ri.setTerm(bo.getAttribute("Term").getInt());
			ri.setRate(bo.getAttribute("Rate").getDouble());
			
			rateList.add(ri);
		}
		
		return true;
	}
	
	public String getBaseRateType() throws Exception
	{
		String sReturn = "";
		
		if("2010030".equals(this.BusinessType))
		{
			sReturn += "020,"+CodeManager.getItemName("BaseRateType", "020")+",";
		}
		else
		{
			BizObjectManager mri = JBOFactory.getFactory().getManager("jbo.sys.RATE_INFO");
			List<BizObject> boList= mri.createQuery("select distinct RateType from o where" +
					" Status = '1' and Currency = :Currency and RateType not in('020','030') ").setParameter("Currency", this.Currency).getResultList();
			for(BizObject bo:boList)
			{
				sReturn += bo.getAttribute("RateType").getString()+","+CodeManager.getItemName("BaseRateType", bo.getAttribute("RateType").getString())+",";
			}
		}
		return sReturn;
	}
	
	
	public String getBaseRate() throws Exception
	{
		String svalue="";
		try{
			svalue=String.valueOf(getBaseRate(this.RateType,this.Currency,Integer.parseInt(this.TermDay)));
		}catch(Exception e)
		{
			e.printStackTrace();
			svalue="-9999";
		} 
		return svalue;
	}
	
	public static double getBaseRate(String RateType,String Currency,int TermDay) throws Exception
	{
		double dRate = 0.0;
		if(TermDay <= 0 ) throw new Exception("期限天数必须大于零！");
		load();
		//取利率
		for(RateInfo ri:rateList)
		{
			if(ri.getCurrency().equalsIgnoreCase(Currency) && ri.getRateType().equalsIgnoreCase(RateType))//同币种、同基准利率类型
			{
				if("010".equals(ri.getTermUnit()) && TermDay <= ri.getTerm())//日利率
				{
					dRate = ri.getRate();
					break;
				}
				else if("020".equals(ri.getTermUnit()) && TermDay <= ri.getTerm()*30)//月利率
				{
					dRate = ri.getRate();
					break;
				}
				else if("030".equals(ri.getTermUnit()) && TermDay <= ri.getTerm()*360)//年利率
				{
					dRate = ri.getRate();
					break;
				}
			}
		}
		if(dRate <= 0.0) throw new Exception("未找到对应利率！");
		
		return dRate;
	}
	
	

}
