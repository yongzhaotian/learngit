package com.amarsoft.app.als.credit.cl.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.util.GetCompareERate;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DataElement;

public class GuarantyContract {

	BizObject bizGContract;
	double dguarantyValue=0;
	double dguarantyInfoValue=0;
	private List<BizObject> lstGuarantyInfo=new ArrayList<BizObject>();
	protected LmtAccountInfo curLmtAccountInfo = null; //担保合同当前所属占用对象
	
	public GuarantyContract(BizObject bizgc,LmtAccountInfo lmtAccountInfo) throws JBOException{
		bizGContract=bizgc;
		this.curLmtAccountInfo = lmtAccountInfo;
		lstGuarantyInfo=GuarantyRelative.getGuarantyInfo(bizGContract);
		dguarantyValue=bizGContract.getAttribute("GuarantyValue").getDouble();
	}
	
	public GuarantyContract(String serialNo,LmtAccountInfo lmtAccountInfo) throws JBOException{
		this.curLmtAccountInfo = lmtAccountInfo;
		this.bizGContract=JBOFactory.getBizObjectManager("jbo.app.GUARANTY_CONTRACT").createQuery("serialNO=:serialNo")
		.setParameter("serialNo", serialNo).getSingleResult(false);
	}
	
	/**
	 * 获得担保合同的担保金额
	 * @author cjyu
	 * @return
	 * @throws JBOException 
	 */
	public double getGuarantyValue() throws JBOException
	{
		if(dguarantyValue==0) {
			dguarantyValue=bizGContract.getAttribute("GuarantyValue").getDouble();
			String sBusinessCurrency=bizGContract.getAttribute("Guarantycurrency").getString();
			if(sBusinessCurrency==null) sBusinessCurrency="01";
			dguarantyValue*=GetCompareERate.getConvertToRMBERate(sBusinessCurrency);
		} 
		return dguarantyValue;
	}
	/**
	 * 获得担保下的抵质押物信息
	 * @return
	 */
	public int getGuarantyNum()
	{
		return lstGuarantyInfo.size();
	}
	/**
	 * 获得担保合同属性
	 * @param attributename
	 * @return
	 * @throws JBOException
	 */
	public DataElement getAttribute(String attributename) throws JBOException
	{
		return bizGContract.getAttribute(attributename);
	}
	/**
	 * 获得担保合同项下的抵质押物金额
	 * @return
	 * @throws JBOException 
	 */
	public   double getGuarantInfoValue() throws JBOException
	{
		dguarantyInfoValue=0;
		String sCurrency=""; 
		for(BizObject biz:lstGuarantyInfo)
		{
			sCurrency=biz.getAttribute("Currency").getString();
			dguarantyInfoValue+=biz.getAttribute("Confirmvalue").getDouble()*GetCompareERate.getConvertToRMBERate(sCurrency);; ;
		}
		return dguarantyInfoValue;
	}
	
	/**
	 * 获得担保对象
	 * @return
	 */
	public BizObject getBizObject()
	{
		return this.bizGContract;
	}
	
	/**
	 * 获得担保合同下的抵质押物信息列表
	 * @return
	 */
	public List<BizObject> getGuarantyInfoList()
	{
		return lstGuarantyInfo;
	}
	
	 
	 /**
	  * 获得现金类等价物担保金额
	  * @return
	 * @throws JBOException 
	  */
	 public  double getLowRiskSum() throws JBOException
	 {
		 double dLowRiskSum=0; 
		 String sGuarantyType="",sCurrency=""; 
		 for(BizObject biz:this.lstGuarantyInfo)
		 {
			 sGuarantyType=biz.getAttribute("GuarantyType").getString();
			 sCurrency=biz.getAttribute("Currency").getString();
			 if(!sGuarantyType.startsWith("00200040")) continue;
			 dLowRiskSum+=biz.getAttribute("Confirmvalue").getDouble()*GetCompareERate.getConvertToRMBERate(sCurrency);; 
		 }
		 return dLowRiskSum;  
	 } 
}
