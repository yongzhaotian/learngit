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
 * ��ȵķ�����Ϣ
 * @author cjyu
 *
 */
public class CLDivide {
	private BizObject bizCL;
	private String Cycleflag="";
	private  AccountManager accountManager;//������˻��������
	private String sSerialNo;

	private double dBusinessSum=0;//������ 
	private double dExposuresum=0;//���ڽ�� 
	public boolean  bchBusinessSum=true;//������ 
	public boolean  bchExposureSum=true;//���ڽ��   
	private List<CLDivide> lstDivide;
	
	/**
	 * �����ȷ�����Ϣ
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
		
		if(accountManager==null) accountManager=new AccountManager(this);//cjyu �ϲ���ȡ��ҵ��
	}
	
	/**
	 * ��ʼ������зֵĻ�����Ϣ
	 * @throws JBOException 
	 */
	public void check(List<BizObject> lst) throws JBOException
	{
		if(accountManager==null) accountManager=new AccountManager(this);//cjyu �ϲ���ȡ��ҵ��
		lstDivide=getRelativeDivideList(this);//cjyu ȡ���²��� 
		for(CLDivide cdivide:lstDivide)
		{
			 
			cdivide.setOutAccount(lst);  
			cdivide.check();
		}
		setOutAccount(lst);
		accountManager.check();
  	}
	/**
	 * ��ʼ������зֵĻ�����Ϣ
	 * @throws JBOException 
	 */
	public void check() throws JBOException
	{
		check(null);
  	}
	
	/**
	 * ���ҵ���Ƿ�ѭ����־
	 * @return
	 * @throws JBOException 
	 */
	public boolean getCycleflag() throws JBOException
	{
		if(bizCL.getAttribute("Cycleflag").getString()==null)  Cycleflag = "";
		return Cycleflag.equals(ALSConst.CYCLEFLAG_CYCLE);
	}
	
	/**
	 * ��ö�ȵ���ػ�����Ϣ
	 * @param skeyName
	 * @return
	 * @throws JBOException
	 */
	public DataElement getAttribute(String skeyName) throws JBOException
	{
		return bizCL.getAttribute(skeyName);
	}
	/**
	 * ��ö���зֵ���ˮ��
	 * @return
	 * @throws JBOException 
	 */
	public String getSerialNo() throws JBOException
	{
		if(sSerialNo==null) sSerialNo=this.bizCL.getAttribute("SerialNO").getString();
		return sSerialNo;
	}
	
	/**
	 * ��ʹ�õĽ��
	 * @return
	 * @throws JBOException 
	 */
	public double getUseBusinessSum() throws JBOException
	{
		 return accountManager.getUseBusinessSum();
	}
	
	/**
	 * ��ʹ�õĽ��
	 * @return
	 * @throws JBOException 
	 */
	public double getUseExposuresum() throws JBOException
	{
		 return accountManager.getUseExposureSum();
	}
	/**
	 * ���������
	 * @return
	 * @throws JBOException 
	 */
	public double getBusinessSum() throws JBOException {
		if(dBusinessSum==0) dBusinessSum=bizCL.getAttribute("BusinessSum").getDouble();
		return dBusinessSum;
	}
	/**
	 * ��ó��ڽ��
	 * @return
	 * @throws JBOException 
	 */
	public double getExposureSum() throws JBOException {
		if(dExposuresum==0) dExposuresum=bizCL.getAttribute("Exposuresum").getDouble(); 
		return dExposuresum;
	}
	/**
	 * ����з��¿��õ�������
	 * @return
	 * @throws JBOException 
	 */
	public double getUseAbleBusinessSum() throws JBOException
	{
		return this.getBusinessSum()-this.getUseBusinessSum();
	}
	
	/**
	 * ����з��¿��õĳ��ڽ��
	 * @return
	 * @throws JBOException 
	 */
	public double getUseAbleExposuresum() throws JBOException
	{
		return this.getExposureSum()-this.getUseExposuresum();
	}
	
	/**
	 * ����Ƿ�ѭ������
	 * @return
	 * @throws JBOException 
	 */
	public String getCycleName() throws JBOException
	{
		if(this.getCycleflag())	return "��";
		return "��";
	}
	
	public AccountManager getAccountManager() throws JBOException
	{
		if(accountManager==null) accountManager=new AccountManager(this);
		return accountManager;
	}
	/**
	 * ��������ҵ��ռ��������ʱ����ҵ�񽫲���������
	 * @return
	 * @throws JBOException 
	 */
	public boolean setOutAccount(BizObject biz) throws JBOException
	{
		return this.accountManager.setOutAccount(biz);
	}
	/**
	 * ��������ҵ��ռ��������ʱ����ҵ�񽫲���������
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
	 * ���ö����ҵ��
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
//		  boolean bexists=CLRelativeAction.bizDivide(this, binfo.getBizObject());//����Ƿ���ڸ���ҵ��
//		  if(!bexists) this.business.remove(binfo);
//	  }
	  //������ϴ�����ܳ��� ��ConcurrentModificationException lrguo 20120525
	  for (Iterator iterator = lstBusinessInfo.iterator(); iterator.hasNext();) {
		BusinessContractAccount binfo = (BusinessContractAccount) iterator.next();
		boolean bexists=isBizInDivide(binfo.getBizObject());//����Ƿ���ڸ���ҵ��
		if(!bexists)iterator.remove();
	  }
	}
	
	/**
	 * ����²��ȷ���
	 * @return
	 * @throws JBOException 
	 */
	public List<CLDivide> getRelativeDivide() throws JBOException
	{
		if(lstDivide==null) lstDivide=getRelativeDivideList(this);
		return this.lstDivide;
	}
	
	/**
	 * ��ò�Ʒ��������
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
	 * ����ۺ����Ŷ���µ� ��Ʒ������Ϣ
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
	 * �鿴����biz�Ƿ�ռ�ø��зֶ��
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


