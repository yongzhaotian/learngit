package com.amarsoft.app.als.credit.cl.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.util.GetCompareERate;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;

/**
 * ������Ҫ����ҵ���µ��� ��Ϣ��
 * <li>����ҵ���ͬ���,bizObject
 * <li>��������������ֽ��ൣ��Ʒռ�õ��ܽ��
 * @author cjyu 
 *
 */
public class GuarantyManager {
	
	/**
	 * ������ͬ��Ϣ
	 * @author cjyu
	 */
	 BizObject bizGuaranty;

	 private boolean bcheck=false;
	 private double dBailSum=0;//gc���еı�֤����
	 /**
	  * ����������ռ�ö���
	  */
	 private LmtAccountInfo lmtAccountInfo;
	 
 	 /**
	  * ҵ��Ʒ��
	  */
	 private List<BizObject> lstGuaranty;
	 

 	 /**
	  * ҵ��Ʒ��
	  */
	 private List<GuarantyContract> lstGcontract;
	 
	 /**
	  * �ֽ��ൣ��Ʒ���
	  * @category
	  */
	 private double dGIExposuresum=0;
	 /**
	  * ����ҵ����󣬳�ʼ��ҵ����ˮ��
	  * ����Ϊ���롢��������ͬ�ȶ���
	  * @param bizObject
	  * @throws JBOException
	  */
	 public GuarantyManager(LmtAccountInfo businessInfo) throws JBOException
	 {
		 this.lmtAccountInfo=businessInfo;
		 initGuarantyManager();
  	 }
	 
	 /**
	  * ���ҵ���µĵ�����ͬ��Ϣ
	  * @throws JBOException
	  */
	 private  void initGuarantyManager() throws JBOException
	 {
		 lstGcontract=new ArrayList<GuarantyContract>();
		 lstGuaranty=GuarantyRelative.getGuarantyContract(lmtAccountInfo);
		 for(BizObject biz:lstGuaranty)
		 {
			 GuarantyContract g=new GuarantyContract(biz,lmtAccountInfo);
			 lstGcontract.add(g);
		 }
		 dGIExposuresum=calGuaranty();
		 bcheck=true;
	 }
 
	 /**
	  * ���׼�ֽ��ൣ��Ʒ����������֤��
	  * @return
	 * @throws JBOException 
	  */
	 public   double getGCExposureSum() throws JBOException
	 {
		 if(!bcheck) initGuarantyManager();
		 return dGIExposuresum;
	 }
	 
	 /**
	  * ���㵣����ͬ�µ��ֽ��ൣ��Ʒ���
	 * @throws JBOException 
	  */
	 private  double  calGuaranty() throws JBOException
	 {
		 String sGuarantyType="",sContractType="",sCurrency="";
		 double dGuarantyValue=0;
		 double dGuarantySum=0;
		 for(GuarantyContract  gcontract:lstGcontract)
		 {
			 sGuarantyType=gcontract.getAttribute("GuarantyType").getString();
			 sContractType=gcontract.getAttribute("ContractType").getString();
			 dGuarantyValue=gcontract.getAttribute("GuarantyValue").getDouble();
			 sCurrency=gcontract.getAttribute("Guarantycurrency").getString();
			 if(sGuarantyType.startsWith("0030"))//cjyu ��֤����Ϣ
			 {
				 dBailSum+=dGuarantyValue*GetCompareERate.getConvertToRMBERate(sCurrency);
				 continue;
			 }
 			 if(!sGuarantyType.startsWith("0020")) continue;//���ֽ��ൣ��Ʒ
 			 
 			 if("020".equals(sContractType))//��߶����ͬ
			 { 
				 double dthisGuarantySum=GuarantyRelative.getBusinessUseSum(gcontract.getBizObject(), lmtAccountInfo);//java.lang.Math.min(dALLOCSUM, dBusinessSum);
				 dGuarantySum+=dthisGuarantySum*gcontract.getLowRiskSum()/dGuarantyValue; //(����߶����ͬ��׼�ֽ���ѺƷ������ֵ���з�̯ȡֵ)
			 }else{
				 dGuarantySum+=gcontract.getLowRiskSum();
			 }
		 }
		 return dGuarantySum;
	 }
	
	 /**
	  * ��ñ�֤����
	  * @return
	  */
	 public double getBailSum()
	 {
		 return this.dBailSum;
	 }
	 
	 
	 
}

