package com.amarsoft.app.als.credit.cl.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.dict.ALSConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DataElement;

/**
 * 额度下账户信息
 * <li>在该类能计算账户占用的名义金额和敞口金额。
 * @author cjyu 
 *
 */
public class BusinessContractAccount extends LmtAccountInfo{

	private String serialNo=""; //占用对象-合同的主键
	private GuarantyManager guarantyManager;
	private BizObject bizObject; 
	
	private String accountNo = ""; //账号
	private final String accountType = LmtAccountInfo.LMTACCOUNTTYPE_BC; //账户类型

	private double businessSum=0;//名义金额 
	private double exposureSum=0;//敞口金额  
	private double bdBailSum=0;//借据表的保证金金额
	private double bcBailSum=0;//BC表中的约定保证金金额
	private double gcBailSum=0;//GC表中的约定保证金金额
	private double bailSum=0;
  	private boolean bcycleFlag=false;//额度是否循环 
  	private List<BizObject> lstDueBill=new ArrayList<BizObject>();
  	
	/**
	 * 传入合同流水号，初始化合同的信息
	 * @param serialNo
	 * @throws JBOException
	 */
	public BusinessContractAccount(String serialNo) throws JBOException
	{
		this.serialNo=serialNo;
		this.bizObject=JBOFactory.getBizObject("jbo.app.BUSINESS_CONTRACT", serialNo);
	}	
	/**
	 * 传入BizObject，初始化基本信息
	 * @param biz
	 * @throws JBOException 
	 */
	public BusinessContractAccount(BizObject biz,AccountManager accountManager) throws JBOException
	{
		this(biz,accountManager.getLineCycleFlag()); 
	}
	/**
	 * 通过业务初始化业务信息，如此可得到业务的敞口金额和名义金额
	 * @param biz  业务对象 Business_Contract 或者 Business_apply 或者Business_Approve
	 * @param cycflag 额度是否循环 
	 * @throws JBOException 
	 */
	public BusinessContractAccount(BizObject biz,boolean cycflag) throws JBOException
	{
		bizObject=biz;
		bcycleFlag=cycflag; 
		this.setGuarantyManager(new GuarantyManager(this));//初始化账户下押品
		calculate();
	}
	/**
	 * 初始化业务基本信息
	 * 得到该笔业务应计算出的名义金额
	 * @throws JBOException 
	 */
	private void calculate() throws JBOException
	{
		lstDueBill=BusinessSumUnilt.getDueBillList(serialNo); 
		businessSum=BusinessSumUnilt.getBusinessSum(bcycleFlag, bizObject);
		
		this.bailSum=getBailSum();
		
		exposureSum=businessSum-bailSum-guarantyManager.getGCExposureSum();//计算敞口金额
		exposureSum=Math.max(0,exposureSum);
	}
 
	/**
	 * 获得已占用敞口金额
	 * @return
	 */
	public double getUseExposureSum()
	{ 
		return exposureSum;
	}
	
	/**
	 * 获得已占用名义金额
	 * @return
	 * @throws JBOException 
	 */
	public double getUseBusinessSum()
	{
		return businessSum;
	}
	
	/**
	 * 获得账号
	 */
	public String getAccountNo(){
		try {
			accountNo = this.bizObject.getAttribute("SerialNo").getString();
		} catch (JBOException e) {
			e.printStackTrace();
		}
		
		return accountNo;
	}
	
	/**
	 * 获得账户类型
	 */
	public String getAccountType(){
		return this.accountType;
	}
	
	/**
	 * 获得基本信息
	 * @return
	 */
	public BizObject getBizObject()
	{
		return bizObject;
	}
	
	/**
	 * 获得保证金
	 * <li>检查是否已经全部发放，如全部发放，则检查是否有保证金，如有保证金则以借据保证金为准
	 * <li>如不满足以上条件，则考虑以下条件：GC表中是否有保证金，如有则以GC表保证金为准，否则以合同约定的保证金为准。
	 * @return
	 * @throws JBOException
	 */
	public double getBailSum() throws JBOException
	{
		bcBailSum=bizObject.getAttribute("BailSum").getDouble();
		double dBCBusienssSum=bizObject.getAttribute("BusinessSum").getDouble();
		bailSum=bcBailSum;
		gcBailSum=guarantyManager.getBailSum();
		if(gcBailSum>0) bailSum=gcBailSum;
		
		bdBailSum=getDueBillTotalSum("BailSum");
		double dBDBusinessSum=getDueBillTotalSum("BusinessSum");
		if(lstDueBill.size()==0)//部分发放
		{
			if(gcBailSum>0) bailSum=gcBailSum;
			//TODO dGCBailSum 为0的情况，以合同约定的保证金为准。
		}else if(dBDBusinessSum>=dBCBusienssSum)//全部发放
		{
			if(bdBailSum>0)  bailSum=bdBailSum;
		}
		return bailSum;
	}
	/**
	 * 获得借据下金额汇总
	 * @param attributename
	 * @return
	 * @throws JBOException
	 */
	public double getDueBillTotalSum(String attributename) throws JBOException
	{
		double dTotalSum=0;
		for(BizObject bo:lstDueBill)
		{
			dTotalSum+=bo.getAttribute(attributename).getDouble();
		}
		return dTotalSum;
	}
	
	public GuarantyManager getGuarantyManager() {
		return guarantyManager;
	}
	public void setGuarantyManager(GuarantyManager guarantyManager) {
		this.guarantyManager = guarantyManager;
	}
	
	/**
	 * 获得账户基本信息
	 * @param skeyName
	 * @return
	 * @throws JBOException 
	 */
	public DataElement getAttribute(String skeyName) throws JBOException
	{
		return this.getBizObject().getAttribute(skeyName);
	}
	
	/**
	 * 获得业务是否循环
	 * <li>循环为 true
	 * <li>非循环为 false
	 * @return
	 * @throws JBOException 
	 */
	public boolean getCycleflag()
	{
		boolean cycleFlag = false;
		try {
			if(this.getBizObject().getAttribute("CycleFlag").getString()==null) cycleFlag = false;
			else cycleFlag = this.getBizObject().getAttribute("CycleFlag").getString().equals(ALSConst.CYCLEFLAG_CYCLE);
		} catch (JBOException e) {
			// TODO Auto-generated catch block
		}
		return cycleFlag;
	}
	
	public String getCycleName() throws JBOException
	{
		boolean bcyc=getCycleflag();
		if(bcyc) return "是"; 
		return "否";
	}
	
	/**
	 * 获取占用对象实体
	 */
	@Override
	public BizObject getCreditObject() {
		return this.getBizObject();
	}
	
}
