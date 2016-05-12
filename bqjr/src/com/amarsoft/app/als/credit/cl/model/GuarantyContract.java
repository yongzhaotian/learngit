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
	protected LmtAccountInfo curLmtAccountInfo = null; //������ͬ��ǰ����ռ�ö���
	
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
	 * ��õ�����ͬ�ĵ������
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
	 * ��õ����µĵ���Ѻ����Ϣ
	 * @return
	 */
	public int getGuarantyNum()
	{
		return lstGuarantyInfo.size();
	}
	/**
	 * ��õ�����ͬ����
	 * @param attributename
	 * @return
	 * @throws JBOException
	 */
	public DataElement getAttribute(String attributename) throws JBOException
	{
		return bizGContract.getAttribute(attributename);
	}
	/**
	 * ��õ�����ͬ���µĵ���Ѻ����
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
	 * ��õ�������
	 * @return
	 */
	public BizObject getBizObject()
	{
		return this.bizGContract;
	}
	
	/**
	 * ��õ�����ͬ�µĵ���Ѻ����Ϣ�б�
	 * @return
	 */
	public List<BizObject> getGuarantyInfoList()
	{
		return lstGuarantyInfo;
	}
	
	 
	 /**
	  * ����ֽ���ȼ��ﵣ�����
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
