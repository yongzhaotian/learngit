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
 * ������ȼ���ʹ�ã������������ʹ�á�
 * @author 
 * @history:
 *	2013-1-7
 */
public class CreditLine {
  
	private double dBusinessSum=0;//������
	public boolean bchBusinessSum=true;//�Ƿ������������
	public boolean bchExposureSum=true;//�Ƿ��ܳ��ڽ�����
	private double exposureSum=0;//���ڽ�� 
	private double freBusinessSum=0;//������ 
	private double freExposureSum=0;//���ڽ�� 
	private String cycleflag="";
	private String serialNo="";// �����ˮ�� 
	private BizObject bizCreditLine=null; 
	private List<CLDivide> lstDivide;
	private AccountManager accountManager = null;
	private CreditObjectAction curCreditObject = null;
	/**
	 * ��ʼ����Ȼ�����Ϣ,ֻ���ܶ��ʵ���BC���Լ����̱�BA��BAP���BizObject
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
			throw new JBOException("����Ƿ����ʵ�����");
		}
		init(); 
	} 
	/**
	 * ��������Ϣ
	 * @param serialNo ���Э���
	 * @throws JBOException
	 */
	public CreditLine(String serialNo) throws JBOException
	{
		bizCreditLine=JBOFactory.getBizObject("jbo.app.BUSINESS_CONTRACT", serialNo);
		init();
	}
	/**
	 * ��ʼ����ȳ��ڽ�������Ƿ�ѭ���ȡ�
	 * ��ʼ��ռ�ö��������
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
		
/*		Ŀǰֻ����ȫ������
 * 		if(objectType.equalsIgnoreCase("BusinessContract"))
		{ 
			freBusinessSum=bizCreditLine.getAttribute("FreBusinessSum").getDouble();
			freExposureSum=bizCreditLine.getAttribute("FreExposuresum").getDouble();
		}*/
		getAccountManager();
		curCreditObject = new CreditObjectAction(this.bizCreditLine);
 		
	}
	/**
	 * ���ж�ȼ��
	 * У���ȡ�ö����ҵ�񲢼���ʹ�ý��
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
	 * ��ȼ��
	 * @throws JBOException
	 */
	public void check() throws JBOException
	{
		check(null);
	}
	 
	/**
	 * ��ö�ȵ���ˮ��
	 * @return
	 */
	public String getSerialNo()
	{
		return this.serialNo;
	}
	
	/**
	 * �õ�����Ƿ�ѭ����true ѭ����false��ѭ��
	 * @return
	 */
	public boolean  getCycleFlag()
	{
		return  cycleflag.equals(ALSConst.CYCLEFLAG_CYCLE);
	}
	/**
	 * �ѱ�ռ�õ�������
	 * @return
	 * @throws JBOException 
	 */
	public double getUseBusinessSum() throws JBOException
	{
		 return accountManager.getUseBusinessSum();
	}
	
	/**
	 * �ѱ�ռ�õĳ��ڽ��
	 * @return
	 * @throws JBOException 
	 */
	public double getUseExposureSum() throws JBOException
	{
		 return accountManager.getUseExposureSum();
	}
	/**
	 * ���������
	 * @return
	 */
	public double getBusinessSum() {
		return dBusinessSum;
	}
	/**
	 * ��ó��ڽ��
	 * @return
	 */
	public double getExposureSum() {
		return exposureSum;
	}
	/**
	 * ��ö��������
	 * @param skeyName
	 * @return
	 * @throws JBOException 
	 */
	public DataElement getAttribute(String skeyName) throws JBOException
	{
		return this.bizCreditLine.getAttribute(skeyName);
	}
	  
	/**
	 * ��ȿ��õ�������
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
	 * ��ÿ��õĳ��ڽ��
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
	 * ��ö�ȵ�BizObject ����
	 * @return
	 */
	public BizObject getBizObject()
	{
		return this.bizCreditLine;
	}
	private StringBuffer logBuffer=new StringBuffer();
	
	/**
	 * ��õļ����־
	 * @return
	 */
	public String getLog()
	{
		return this.logBuffer.toString();
	}
	/**
	 * ��ö���������
	 * @return
	 */
	public double getFreBusinessSum() {
		return freBusinessSum;
	}
	/**
	 * ��ö��᳨�ڽ��
	 * @return
	 */
	public double getFreExposuresum() {
		return freExposureSum;
	}

	/**
	 * ��������ҵ����ռ�ý�����ʱ����ҵ�񽫲��������ڡ�
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
	 * ��ö�����µ�ҵ��
	 * @return
	 * @throws JBOException
	 */
	public  AccountManager getAccountManager() throws JBOException
	{
		if(accountManager==null) accountManager = new AccountManager(this);
		return this.accountManager;
	}

	/**
	 * ����ۺ����Ŷ���µ� ��Ʒ������Ϣ
	 * ��ʱֻȡ��һ��
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


