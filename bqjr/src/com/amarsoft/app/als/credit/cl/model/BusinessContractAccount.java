package com.amarsoft.app.als.credit.cl.model;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.dict.ALSConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.DataElement;

/**
 * ������˻���Ϣ
 * <li>�ڸ����ܼ����˻�ռ�õ�������ͳ��ڽ�
 * @author cjyu 
 *
 */
public class BusinessContractAccount extends LmtAccountInfo{

	private String serialNo=""; //ռ�ö���-��ͬ������
	private GuarantyManager guarantyManager;
	private BizObject bizObject; 
	
	private String accountNo = ""; //�˺�
	private final String accountType = LmtAccountInfo.LMTACCOUNTTYPE_BC; //�˻�����

	private double businessSum=0;//������ 
	private double exposureSum=0;//���ڽ��  
	private double bdBailSum=0;//��ݱ�ı�֤����
	private double bcBailSum=0;//BC���е�Լ����֤����
	private double gcBailSum=0;//GC���е�Լ����֤����
	private double bailSum=0;
  	private boolean bcycleFlag=false;//����Ƿ�ѭ�� 
  	private List<BizObject> lstDueBill=new ArrayList<BizObject>();
  	
	/**
	 * �����ͬ��ˮ�ţ���ʼ����ͬ����Ϣ
	 * @param serialNo
	 * @throws JBOException
	 */
	public BusinessContractAccount(String serialNo) throws JBOException
	{
		this.serialNo=serialNo;
		this.bizObject=JBOFactory.getBizObject("jbo.app.BUSINESS_CONTRACT", serialNo);
	}	
	/**
	 * ����BizObject����ʼ��������Ϣ
	 * @param biz
	 * @throws JBOException 
	 */
	public BusinessContractAccount(BizObject biz,AccountManager accountManager) throws JBOException
	{
		this(biz,accountManager.getLineCycleFlag()); 
	}
	/**
	 * ͨ��ҵ���ʼ��ҵ����Ϣ����˿ɵõ�ҵ��ĳ��ڽ���������
	 * @param biz  ҵ����� Business_Contract ���� Business_apply ����Business_Approve
	 * @param cycflag ����Ƿ�ѭ�� 
	 * @throws JBOException 
	 */
	public BusinessContractAccount(BizObject biz,boolean cycflag) throws JBOException
	{
		bizObject=biz;
		bcycleFlag=cycflag; 
		this.setGuarantyManager(new GuarantyManager(this));//��ʼ���˻���ѺƷ
		calculate();
	}
	/**
	 * ��ʼ��ҵ�������Ϣ
	 * �õ��ñ�ҵ��Ӧ�������������
	 * @throws JBOException 
	 */
	private void calculate() throws JBOException
	{
		lstDueBill=BusinessSumUnilt.getDueBillList(serialNo); 
		businessSum=BusinessSumUnilt.getBusinessSum(bcycleFlag, bizObject);
		
		this.bailSum=getBailSum();
		
		exposureSum=businessSum-bailSum-guarantyManager.getGCExposureSum();//���㳨�ڽ��
		exposureSum=Math.max(0,exposureSum);
	}
 
	/**
	 * �����ռ�ó��ڽ��
	 * @return
	 */
	public double getUseExposureSum()
	{ 
		return exposureSum;
	}
	
	/**
	 * �����ռ��������
	 * @return
	 * @throws JBOException 
	 */
	public double getUseBusinessSum()
	{
		return businessSum;
	}
	
	/**
	 * ����˺�
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
	 * ����˻�����
	 */
	public String getAccountType(){
		return this.accountType;
	}
	
	/**
	 * ��û�����Ϣ
	 * @return
	 */
	public BizObject getBizObject()
	{
		return bizObject;
	}
	
	/**
	 * ��ñ�֤��
	 * <li>����Ƿ��Ѿ�ȫ�����ţ���ȫ�����ţ������Ƿ��б�֤�����б�֤�����Խ�ݱ�֤��Ϊ׼
	 * <li>�粻����������������������������GC�����Ƿ��б�֤����������GC��֤��Ϊ׼�������Ժ�ͬԼ���ı�֤��Ϊ׼��
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
		if(lstDueBill.size()==0)//���ַ���
		{
			if(gcBailSum>0) bailSum=gcBailSum;
			//TODO dGCBailSum Ϊ0��������Ժ�ͬԼ���ı�֤��Ϊ׼��
		}else if(dBDBusinessSum>=dBCBusienssSum)//ȫ������
		{
			if(bdBailSum>0)  bailSum=bdBailSum;
		}
		return bailSum;
	}
	/**
	 * ��ý���½�����
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
	 * ����˻�������Ϣ
	 * @param skeyName
	 * @return
	 * @throws JBOException 
	 */
	public DataElement getAttribute(String skeyName) throws JBOException
	{
		return this.getBizObject().getAttribute(skeyName);
	}
	
	/**
	 * ���ҵ���Ƿ�ѭ��
	 * <li>ѭ��Ϊ true
	 * <li>��ѭ��Ϊ false
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
		if(bcyc) return "��"; 
		return "��";
	}
	
	/**
	 * ��ȡռ�ö���ʵ��
	 */
	@Override
	public BizObject getCreditObject() {
		return this.getBizObject();
	}
	
}
