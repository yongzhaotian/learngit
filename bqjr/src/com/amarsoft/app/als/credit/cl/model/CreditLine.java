package com.amarsoft.app.als.credit.cl.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.credit.common.model.CreditConst;
import com.amarsoft.app.als.credit.model.CreditObjectAction;
import com.amarsoft.app.als.dict.ALSConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.util.Arith;

/**
 * 仅供额度计算使用，其他情况不得使用。
 * @author 
 * @history:
 *	2013-1-7
 */
public class CreditLine {
  
	private double dBusinessSum=0;//名义金额
	public boolean bchBusinessSum=true;//是否受名义金额控制
	public boolean bchExposureSum=true;//是否受敞口金额控制
	private double exposureSum=0;//敞口金额 
	private double freBusinessSum=0;//名义金额 
	private double freExposureSum=0;//敞口金额 
	private String cycleflag="";
	private String serialNo="";// 额度流水号 
	private BizObject bizCreditLine=null; 
	private List<CLDivide> lstDivide;
	private AccountManager accountManager = null;
	private CreditObjectAction curCreditObject = null;
	/**
	 * 初始化额度基本信息,只接受额度实体表BC，以及过程表BA，BAP表的BizObject
	 * @param biz
	 * @throws JBOException
	 */
	public CreditLine(BizObject biz) throws JBOException
	{
		if(biz.getBizObjectClass().getName().equalsIgnoreCase("BUSINESS_APPLY") ||
				biz.getBizObjectClass().getName().equalsIgnoreCase("BUSINESS_APPROVE") ||
				biz.getBizObjectClass().getName().equalsIgnoreCase("BUSINESS_CONTRACT")){
			bizCreditLine=biz;
		}else{
			throw new JBOException("传入非法额度实体对象");
		}
		init(); 
	} 
	/**
	 * 构造额度信息
	 * @param serialNo 额度协议号
	 * @throws JBOException
	 */
	public CreditLine(String serialNo) throws JBOException
	{
		bizCreditLine=JBOFactory.getBizObject("jbo.app.BUSINESS_CONTRACT", serialNo);
		init();
	}
	/**
	 * 初始化额度敞口金额，名义金额，是否循环等。
	 * 初始化占用对象管理类
	 * @throws JBOException 
	 */
	private void init() throws JBOException
	{
		serialNo=bizCreditLine.getAttribute("SerialNo").getString();
		cycleflag=bizCreditLine.getAttribute("Cycleflag").getString();
		if(cycleflag==null) cycleflag="1";
		if(bizCreditLine.getAttribute("BusinessSum").getString()==null) bchBusinessSum=false;
		this.dBusinessSum=bizCreditLine.getAttribute("BusinessSum").getDouble();
		if(bizCreditLine.getAttribute("Exposuresum").getString()==null) bchExposureSum=false; 
		exposureSum=bizCreditLine.getAttribute("Exposuresum").getDouble();
		
/*		目前只考虑全部冻结
 * 		if(objectType.equalsIgnoreCase("BusinessContract"))
		{ 
			freBusinessSum=bizCreditLine.getAttribute("FreBusinessSum").getDouble();
			freExposureSum=bizCreditLine.getAttribute("FreExposuresum").getDouble();
		}*/
		getAccountManager();
		curCreditObject = new CreditObjectAction(this.bizCreditLine);
 		
	}
	/**
	 * 进行额度检查
	 * 校验会取得额度下业务并计算使用金额
	 * @throws JBOException
	 */
	public void check(List<BizObject> lst) throws JBOException
	{
		this.setOutAccount(lst);
		
		lstDivide=getDivideList();
		accountManager = getAccountManager();
		accountManager.check();
		for(CLDivide divide:lstDivide)
		{
			divide.check(lst);
		}
	}
	/**
	 * 额度检查
	 * @throws JBOException
	 */
	public void check() throws JBOException
	{
		check(null);
	}
	 
	/**
	 * 获得额度的流水号
	 * @return
	 */
	public String getSerialNo()
	{
		return this.serialNo;
	}
	
	/**
	 * 得到额度是否循环，true 循环，false非循环
	 * @return
	 */
	public boolean  getCycleFlag()
	{
		return  cycleflag.equals(ALSConst.CYCLEFLAG_CYCLE);
	}
	/**
	 * 已被占用的名义金额
	 * @return
	 * @throws JBOException 
	 */
	public double getUseBusinessSum() throws JBOException
	{
		 return accountManager.getUseBusinessSum();
	}
	
	/**
	 * 已被占用的敞口金额
	 * @return
	 * @throws JBOException 
	 */
	public double getUseExposureSum() throws JBOException
	{
		 return accountManager.getUseExposureSum();
	}
	/**
	 * 获得名义金额
	 * @return
	 */
	public double getBusinessSum() {
		return dBusinessSum;
	}
	/**
	 * 获得敞口金额
	 * @return
	 */
	public double getExposureSum() {
		return exposureSum;
	}
	/**
	 * 获得对象的数据
	 * @param skeyName
	 * @return
	 * @throws JBOException 
	 */
	public DataElement getAttribute(String skeyName) throws JBOException
	{
		return this.bizCreditLine.getAttribute(skeyName);
	}
	  
	/**
	 * 额度可用的名义金额
	 * @return
	 * @throws JBOException 
	 */
	public double getUsableBusinessSum() throws JBOException
	{
		double result = 0.0;
		result = Arith.sub(Arith.sub(getBusinessSum(), freBusinessSum), getUseBusinessSum());
		if(Math.abs(result) < CreditConst.LINE_PRECISION) return 0.0;
		else return result;
	}
	/**
	 * 获得可用的敞口金额
	 * @return
	 * @throws JBOException 
	 */
	public double getUsableExposureSum() throws JBOException
	{
		double result = 0.0;
		result = Arith.sub(Arith.sub(getExposureSum(), freExposureSum), getUseExposureSum());
		if(Math.abs(result) < CreditConst.LINE_PRECISION) return 0.0;
		else return result;
	}
	/**
	 * 获得额度的BizObject 对象
	 * @return
	 */
	public BizObject getBizObject()
	{
		return this.bizCreditLine;
	}
	private StringBuffer logBuffer=new StringBuffer();
	
	/**
	 * 获得的检查日志
	 * @return
	 */
	public String getLog()
	{
		return this.logBuffer.toString();
	}
	/**
	 * 获得冻结名义金额
	 * @return
	 */
	public double getFreBusinessSum() {
		return freBusinessSum;
	}
	/**
	 * 获得冻结敞口金额
	 * @return
	 */
	public double getFreExposuresum() {
		return freExposureSum;
	}

	/**
	 * 设置例外业务，在占用金额计算时，该业务将不计算在内。
	 * @param biz
	 * @return
	 * @throws JBOException
	 */
	public boolean setOutAccount(List<BizObject> lst) throws JBOException
	{
		if(lst==null) return false;
		for(BizObject biz:lst)
		{
			accountManager.setOutAccount(biz);
		} 
		return true;
	}
	
	/**
	 * 获得额度项下的业务
	 * @return
	 * @throws JBOException
	 */
	public  AccountManager getAccountManager() throws JBOException
	{
		if(accountManager==null) accountManager = new AccountManager(this);
		return this.accountManager;
	}

	/**
	 * 获得综合授信额度下的 产品分配信息
	 * 暂时只取第一层
	 * @throws JBOException 
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List<CLDivide> getDivideList() throws JBOException
	{
		List<CLDivide> list=new ArrayList<CLDivide>();
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.CL_DIVIDE");
		List<BizObject>  lstClInfo=m.createQuery("ObjectType=:objectType and ObjectNo=:serialNo and RelativeSerialNo is null")
									.setParameter("objectType", curCreditObject.getRealCreditObjectType())
									.setParameter("serialNo", curCreditObject.getCreditObjectNo())
									.getResultList(true);
		for(BizObject biz:lstClInfo)
		{
			CLDivide cl=new CLDivide(biz);
			list.add(cl);
		} 
		return list; 
	}
	public CreditObjectAction getCurCreditObject() {
		return curCreditObject;
	}
}


