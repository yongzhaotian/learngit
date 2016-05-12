package com.amarsoft.app.als.credit.cl.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
/**
 * 额度下账户管理类；
 * @author cjyu
 *
 */
public class AccountManager {

	/**
	 * 业务信息列表
	 * @
	 */
	private List<LmtAccountInfo> lstLmtAccountInfo;
	private boolean bcycleflag=true;//cjyu 是否循环标志
	private CreditLine creditLine;//cjyu 综合授信额度
	private CLDivide clDivide;//cjyu 综合授信额度下切分
	private double dUseBusinessSum=0;
	private double dUseExposureSum=0;
	private boolean bcheck=false;
	
	private Map<String,String> outMap=new HashMap<String,String>();
	
	public AccountManager()
	{
		lstLmtAccountInfo=new ArrayList<LmtAccountInfo>();
	}
	
	/**
	 * 初始化额度下的所有占用对象信息,此处可以扩展占用对象到在途申请、批复信息
	 * @param line
	 * @throws JBOException 
	 */
	@SuppressWarnings("unchecked")
	public AccountManager(CreditLine line) throws JBOException
	{
		this();
		creditLine=line; 
		bcycleflag=creditLine.getCycleFlag();
		String sSerialNo=line.getSerialNo();
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		//List<BizObject>  lstBc=m.createQuery(" Status in ('210','230')  and  SerialNo in (select C.ObjectNo  from jbo.app.CL_OCCUPY C where C.ObjectType='BusinessContract' and c.RelativeSerialNo=:serialNo)")
		List<BizObject>  lstBc=m.createQuery(" (FinishDate is null or FinishDate <> '')  and  SerialNo in (select C.ObjectNo  from jbo.app.CL_OCCUPY C where C.ObjectType='BusinessContract' and c.RelativeSerialNo=:serialNo)")
									.setParameter("serialNo", sSerialNo)
									.getResultList(true);
		for(BizObject biz:lstBc)
		{
			BusinessContractAccount binfo=new BusinessContractAccount(biz,this);
			addAccountInfo(binfo);
		} 
 	}
	
	/**
	 * 初始化额度额度切分下的业务
	 * @param line
	 * @throws JBOException 
	 */
	@SuppressWarnings("unchecked")
	public AccountManager(CLDivide divide) throws JBOException
	{
		this();
		clDivide=divide;
		bcycleflag=clDivide.getCycleflag();
		String sSerialNo=clDivide.getSerialNo();
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		//List<BizObject>  lstBc=m.createQuery("  Status in ('210','230') and SerialNo in (select C.ObjectNo from jbo.app.CL_OCCUPY C where C.ObjectType='BusinessContract' and C.RelativeDivNo like :divideNo)")
		List<BizObject>  lstBc=m.createQuery("  (FinishDate is null or FinishDate <> '') and SerialNo in (select C.ObjectNo from jbo.app.CL_OCCUPY C where C.ObjectType='BusinessContract' and C.RelativeDivNo like :divideNo)")
									.setParameter("divideNo", "%"+sSerialNo+"%")
									.getResultList(true);
		for(BizObject biz:lstBc)
		{
			BusinessContractAccount binfo=new BusinessContractAccount(biz,this);
			addAccountInfo(binfo);
		} 
 	}
	
	/**
	 * 
	 * @param binfo
	 */
	public void addAccountInfo(LmtAccountInfo lmtAccountInfo)
	{
		lstLmtAccountInfo.add(lmtAccountInfo);
	}
	
	/**
	 * 计算已使用的名义金额和敞口金额
	 * @throws JBOException 
	 */
	public  void check() throws JBOException
	{
		dUseBusinessSum=0;
		dUseExposureSum=0;
		for(LmtAccountInfo lmtAccount:lstLmtAccountInfo)
		{
			if(outMap.get(lmtAccount.getAccountNo())!=null) continue;
			dUseBusinessSum+=lmtAccount.getUseBusinessSum();
			dUseExposureSum+=lmtAccount.getUseExposureSum();
		}
		bcheck=true;
	}
	/**
	 * 获得额度、切分是否循环
	 * @return
	 */
	public boolean getLineCycleFlag()
	{
		return bcycleflag;
	}

	/**
	 * 获得项下所有占用对象已占用名义金额
	 * <li>可以直接获取，如果未曾计算，则会在获取时计算
	 * @return
	 * @throws JBOException 
	 */
	public double getUseBusinessSum() throws JBOException {
		if(!bcheck) check();
		return dUseBusinessSum;
	}
	/**
	 * 获得项下所有占用对象已占用敞口金额
	 * @return
	 * @throws JBOException 
	 */
	public double getUseExposureSum() throws JBOException {
		if(!bcheck) check();
		return dUseExposureSum;
	}
	/**
	 * 获得所有账号信息
	 * @return
	 */
	public List<LmtAccountInfo> getLmtAccountList()
	{
		return lstLmtAccountInfo;
	}
	
	/**
	 * 设置另外业务，该业务将不计算在内
	 * @param biz
	 * @return
	 * @throws JBOException 
	 */
	public boolean setOutAccount(BizObject biz) throws JBOException
	{
		if(biz==null) return false;
		outMap.put(biz.getAttribute("SerialNo").getString(),CLRelativeAction.getObjectType(biz));
		return true;
	}
}
