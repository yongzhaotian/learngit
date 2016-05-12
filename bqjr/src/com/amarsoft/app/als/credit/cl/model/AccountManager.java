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
 * ������˻������ࣻ
 * @author cjyu
 *
 */
public class AccountManager {

	/**
	 * ҵ����Ϣ�б�
	 * @
	 */
	private List<LmtAccountInfo> lstLmtAccountInfo;
	private boolean bcycleflag=true;//cjyu �Ƿ�ѭ����־
	private CreditLine creditLine;//cjyu �ۺ����Ŷ��
	private CLDivide clDivide;//cjyu �ۺ����Ŷ�����з�
	private double dUseBusinessSum=0;
	private double dUseExposureSum=0;
	private boolean bcheck=false;
	
	private Map<String,String> outMap=new HashMap<String,String>();
	
	public AccountManager()
	{
		lstLmtAccountInfo=new ArrayList<LmtAccountInfo>();
	}
	
	/**
	 * ��ʼ������µ�����ռ�ö�����Ϣ,�˴�������չռ�ö�����;���롢������Ϣ
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
	 * ��ʼ����ȶ���з��µ�ҵ��
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
	 * ������ʹ�õ�������ͳ��ڽ��
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
	 * ��ö�ȡ��з��Ƿ�ѭ��
	 * @return
	 */
	public boolean getLineCycleFlag()
	{
		return bcycleflag;
	}

	/**
	 * �����������ռ�ö�����ռ��������
	 * <li>����ֱ�ӻ�ȡ�����δ�����㣬����ڻ�ȡʱ����
	 * @return
	 * @throws JBOException 
	 */
	public double getUseBusinessSum() throws JBOException {
		if(!bcheck) check();
		return dUseBusinessSum;
	}
	/**
	 * �����������ռ�ö�����ռ�ó��ڽ��
	 * @return
	 * @throws JBOException 
	 */
	public double getUseExposureSum() throws JBOException {
		if(!bcheck) check();
		return dUseExposureSum;
	}
	/**
	 * ��������˺���Ϣ
	 * @return
	 */
	public List<LmtAccountInfo> getLmtAccountList()
	{
		return lstLmtAccountInfo;
	}
	
	/**
	 * ��������ҵ�񣬸�ҵ�񽫲���������
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
