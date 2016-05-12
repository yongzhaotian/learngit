package com.amarsoft.app.als.credit.cl.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.util.GetCompareERate;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;

/**
 * 该类主要管理业务下担保 信息，
 * <li>传入业务合同编号,bizObject
 * <li>将计算出担保的现金类担保品占用的总金额
 * @author cjyu 
 *
 */
public class GuarantyManager {
	
	/**
	 * 担保合同信息
	 * @author cjyu
	 */
	 BizObject bizGuaranty;

	 private boolean bcheck=false;
	 private double dBailSum=0;//gc表中的保证金金额
	 /**
	  * 担保关联的占用对象
	  */
	 private LmtAccountInfo lmtAccountInfo;
	 
 	 /**
	  * 业务品种
	  */
	 private List<BizObject> lstGuaranty;
	 

 	 /**
	  * 业务品种
	  */
	 private List<GuarantyContract> lstGcontract;
	 
	 /**
	  * 现金类担保品金额
	  * @category
	  */
	 private double dGIExposuresum=0;
	 /**
	  * 出入业务对象，初始化业务流水号
	  * 可以为申请、批复、合同等对象
	  * @param bizObject
	  * @throws JBOException
	  */
	 public GuarantyManager(LmtAccountInfo businessInfo) throws JBOException
	 {
		 this.lmtAccountInfo=businessInfo;
		 initGuarantyManager();
  	 }
	 
	 /**
	  * 获得业务下的担保合同信息
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
	  * 获得准现金类担保品金额，不包括保证金
	  * @return
	 * @throws JBOException 
	  */
	 public   double getGCExposureSum() throws JBOException
	 {
		 if(!bcheck) initGuarantyManager();
		 return dGIExposuresum;
	 }
	 
	 /**
	  * 计算担保合同下的现金类担保品金额
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
			 if(sGuarantyType.startsWith("0030"))//cjyu 保证金信息
			 {
				 dBailSum+=dGuarantyValue*GetCompareERate.getConvertToRMBERate(sCurrency);
				 continue;
			 }
 			 if(!sGuarantyType.startsWith("0020")) continue;//非现金类担保品
 			 
 			 if("020".equals(sContractType))//最高额担保合同
			 { 
				 double dthisGuarantySum=GuarantyRelative.getBusinessUseSum(gcontract.getBizObject(), lmtAccountInfo);//java.lang.Math.min(dALLOCSUM, dBusinessSum);
				 dGuarantySum+=dthisGuarantySum*gcontract.getLowRiskSum()/dGuarantyValue; //(将最高额担保合同的准现金类押品担保价值进行分摊取值)
			 }else{
				 dGuarantySum+=gcontract.getLowRiskSum();
			 }
		 }
		 return dGuarantySum;
	 }
	
	 /**
	  * 获得保证金金额
	  * @return
	  */
	 public double getBailSum()
	 {
		 return this.dBailSum;
	 }
	 
	 
	 
}

