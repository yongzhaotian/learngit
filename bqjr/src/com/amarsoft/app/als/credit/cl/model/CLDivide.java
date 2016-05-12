package com.amarsoft.app.als.credit.cl.model;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.amarsoft.app.als.dict.ALSConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DataElement;

/**
 * 额度的分配信息
 * @author cjyu
 *
 */
public class CLDivide {
	private BizObject bizCL;
	private String Cycleflag="";
	private  AccountManager accountManager;//额度下账户管理对象
	private String sSerialNo;

	private double dBusinessSum=0;//名义金额 
	private double dExposuresum=0;//敞口金额 
	public boolean  bchBusinessSum=true;//名义金额 
	public boolean  bchExposureSum=true;//敞口金额   
	private List<CLDivide> lstDivide;
	
	/**
	 * 构造额度分配信息
	 * @param biz
	 */
	public CLDivide(BizObject _biz)  throws JBOException{
		bizCL=_biz;
		if(bizCL.getAttribute("Cycleflag").getString()==null)  Cycleflag = "";
		if(bizCL.getAttribute("BusinessSum").getString()==null) bchBusinessSum=false; 
		if(bizCL.getAttribute("Exposuresum").getString()==null) bchExposureSum=false;
		
		Cycleflag=bizCL.getAttribute("Cycleflag").getString();
		dBusinessSum=bizCL.getAttribute("BusinessSum").getDouble();
		dExposuresum=bizCL.getAttribute("Exposuresum").getDouble(); 
		
		if(accountManager==null) accountManager=new AccountManager(this);//cjyu 上层额度取得业务
	}
	
	/**
	 * 初始化额度切分的基本信息
	 * @throws JBOException 
	 */
	public void check(List<BizObject> lst) throws JBOException
	{
		if(accountManager==null) accountManager=new AccountManager(this);//cjyu 上层额度取得业务
		lstDivide=getRelativeDivideList(this);//cjyu 取得下层额度 
		for(CLDivide cdivide:lstDivide)
		{
			 
			cdivide.setOutAccount(lst);  
			cdivide.check();
		}
		setOutAccount(lst);
		accountManager.check();
  	}
	/**
	 * 初始化额度切分的基本信息
	 * @throws JBOException 
	 */
	public void check() throws JBOException
	{
		check(null);
  	}
	
	/**
	 * 获得业务是否循环标志
	 * @return
	 * @throws JBOException 
	 */
	public boolean getCycleflag() throws JBOException
	{
		if(bizCL.getAttribute("Cycleflag").getString()==null)  Cycleflag = "";
		return Cycleflag.equals(ALSConst.CYCLEFLAG_CYCLE);
	}
	
	/**
	 * 获得额度的相关基本信息
	 * @param skeyName
	 * @return
	 * @throws JBOException
	 */
	public DataElement getAttribute(String skeyName) throws JBOException
	{
		return bizCL.getAttribute(skeyName);
	}
	/**
	 * 获得额度切分的流水号
	 * @return
	 * @throws JBOException 
	 */
	public String getSerialNo() throws JBOException
	{
		if(sSerialNo==null) sSerialNo=this.bizCL.getAttribute("SerialNO").getString();
		return sSerialNo;
	}
	
	/**
	 * 已使用的金额
	 * @return
	 * @throws JBOException 
	 */
	public double getUseBusinessSum() throws JBOException
	{
		 return accountManager.getUseBusinessSum();
	}
	
	/**
	 * 已使用的金额
	 * @return
	 * @throws JBOException 
	 */
	public double getUseExposuresum() throws JBOException
	{
		 return accountManager.getUseExposureSum();
	}
	/**
	 * 获得名义金额
	 * @return
	 * @throws JBOException 
	 */
	public double getBusinessSum() throws JBOException {
		if(dBusinessSum==0) dBusinessSum=bizCL.getAttribute("BusinessSum").getDouble();
		return dBusinessSum;
	}
	/**
	 * 获得敞口金额
	 * @return
	 * @throws JBOException 
	 */
	public double getExposureSum() throws JBOException {
		if(dExposuresum==0) dExposuresum=bizCL.getAttribute("Exposuresum").getDouble(); 
		return dExposuresum;
	}
	/**
	 * 获得切分下可用的名义金额
	 * @return
	 * @throws JBOException 
	 */
	public double getUseAbleBusinessSum() throws JBOException
	{
		return this.getBusinessSum()-this.getUseBusinessSum();
	}
	
	/**
	 * 获得切分下可用的敞口金额
	 * @return
	 * @throws JBOException 
	 */
	public double getUseAbleExposuresum() throws JBOException
	{
		return this.getExposureSum()-this.getUseExposuresum();
	}
	
	/**
	 * 额度是否循环名称
	 * @return
	 * @throws JBOException 
	 */
	public String getCycleName() throws JBOException
	{
		if(this.getCycleflag())	return "是";
		return "否";
	}
	
	public AccountManager getAccountManager() throws JBOException
	{
		if(accountManager==null) accountManager=new AccountManager(this);
		return accountManager;
	}
	/**
	 * 设置例外业务，占用余额计算时，该业务将不计算在内
	 * @return
	 * @throws JBOException 
	 */
	public boolean setOutAccount(BizObject biz) throws JBOException
	{
		return this.accountManager.setOutAccount(biz);
	}
	/**
	 * 设置例外业务，占用余额计算时，该业务将不计算在内
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
	 * 设置额度下业务
	 * @param business
	 * @throws JBOException 
	 */
	@SuppressWarnings("unchecked")
	public void setBusiness(AccountManager bus) throws JBOException
	{
	  this.accountManager=bus;
	  List<LmtAccountInfo> lstBusinessInfo=accountManager.getLmtAccountList();
//	  for(BusinessInfo binfo:bus.getBusinessInfo())
//	  {
//		  boolean bexists=CLRelativeAction.bizDivide(this, binfo.getBizObject());//检查是否存在该项业务
//		  if(!bexists) this.business.remove(binfo);
//	  }
	  //解决以上代码可能出现 的ConcurrentModificationException lrguo 20120525
	  for (Iterator iterator = lstBusinessInfo.iterator(); iterator.hasNext();) {
		BusinessContractAccount binfo = (BusinessContractAccount) iterator.next();
		boolean bexists=isBizInDivide(binfo.getBizObject());//检查是否存在该项业务
		if(!bexists)iterator.remove();
	  }
	}
	
	/**
	 * 获得下层额度分配
	 * @return
	 * @throws JBOException 
	 */
	public List<CLDivide> getRelativeDivide() throws JBOException
	{
		if(lstDivide==null) lstDivide=getRelativeDivideList(this);
		return this.lstDivide;
	}
	
	/**
	 * 获得产品分配名称
	 * @return
	 * @throws JBOException
	 */
	public String getDivideName() throws JBOException
	{
		String sdivideName=this.getAttribute("dividename").getString();
		if(sdivideName.indexOf("|")>-1){
			sdivideName=sdivideName.substring(0,sdivideName.indexOf("|"));
		}
		return sdivideName;
	}
	
	public BizObject getCurBiz(){
		return this.bizCL;
	}
	
	/**
	 * 获得综合授信额度下的 产品分配信息
	 * @throws JBOException 
	 * 
	 */
	@SuppressWarnings("unchecked")
	private   List<CLDivide> getRelativeDivideList(CLDivide divide) throws JBOException
	{
		String sSerialNo=divide.getSerialNo();  
		List<CLDivide> list=new ArrayList<CLDivide>();
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.CL_DIVIDE");
		List<BizObject>  lstClInfo=m.createQuery(" RelativeSerialNo=:serialNo") 
									.setParameter("serialNo", sSerialNo)
									.getResultList(true);
		for(BizObject biz:lstClInfo)
		{
			CLDivide cl=new CLDivide(biz);
			cl.setBusiness(divide.getAccountManager());
			list.add(cl);
		} 
		return list; 
	}
	
	/**
	 * 查看传入biz是否占用该切分额度
	 * @return
	 * @throws JBOException 
	 */
	protected boolean isBizInDivide(BizObject biz) throws JBOException
	{
		boolean bfalg=false;
		String sDivideType= bizCL.getAttribute("DivideType").getString();
		String sDivideCode=bizCL.getAttribute("Dividecode").getString();  
		String sBusinessType=biz.getAttribute("BusinessType").getString(); 
		String sCustomerID=biz.getAttribute("CustomerID").getString();
		if(sDivideType.equals("1"))
		{
			if(sDivideCode.indexOf(sBusinessType)>=0)
			{
				bfalg=true;
			}
		}else if(sDivideType.equals("2")){
			if(sDivideCode.indexOf(sCustomerID)>=0)
			{
				bfalg=true;
			}
		} 
		return bfalg;
	}
}


