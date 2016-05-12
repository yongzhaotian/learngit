package com.amarsoft.app.als.credit.cl.model;

import java.util.List;

import com.amarsoft.app.als.credit.model.CreditObjectAction;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;

/**
 * ��ͬ��Ч�������Ч����
 * �����Ч��Ҫ���Ĵ���
 * <li>�����Ч��ʽ������������
 * <li>�����Ч��ʽ������������
 * 
 * @author cjyu
 *
 */
public class ContractEffect {

	BizObject bizContract;
	private CreditLine ncreditLine;
	private String ObjectType="";
	/**
	 * ��������Ϣ
	 * @param biz
	 * @throws JBOException 
	 */
	public ContractEffect(BizObject  biz) throws JBOException
	{
		bizContract=biz;
		ObjectType=CLRelativeAction.getObjectType(biz); 
		//ncreditLine=new CreditLine(bizContract);
	}
	/**
	 * ��ͬ��Ч����
	 * ��Ҫ����һ���¼�
	 * <li>���϶���滻
	 * <li>�����ȳ�Ա�ۺ����Ŷ�Ȼ��ܵ��������С�
	 * <li>
	 * @param tx
	 * @throws Exception 
	 */
	public void startFinish(JBOTransaction tx) throws Exception
	{
		updateGroupLine(bizContract, tx);
		replace(tx);
	}
	/**
	 * �������Ҫ�滻��ҵ����й���
	 * @throws Exception 
	 * @athor cjyu
	 */
	@SuppressWarnings("unchecked")
	public int replace(JBOTransaction tx) throws Exception
	{
		int icount=0; 
		String sPutOutDate=this.bizContract.getAttribute("PutOutDate").getString();
		int ioverday=sPutOutDate.compareTo(DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.CL_Replace");
		tx.join(m);
		List<BizObject> lst=m.createQuery("ObjectNo=:objectNo and ObjectType=:objectType")
							 .setParameter("objectNo", ncreditLine.getSerialNo())
							 .setParameter("objectType", ObjectType).getResultList(false);
		//cjyu �ô����������飬m2������������Manager�����Ķ���
		BizObjectManager m2=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		tx.join(m2);
		for(BizObject biz:lst)
		{
			String sRelativeSerialNo=biz.getAttribute("Relativeserialno").getString();
			CreditLine oldLine=new CreditLine(sRelativeSerialNo); 
			
			icount+=CLRelativeAction.newReplace(ncreditLine.getCurCreditObject(), oldLine, tx);
			BizObject bizLine=oldLine.getBizObject();
			if(ioverday<=0)//cjyu ������Ч 2012-2-13 20:03:33
			 {
				bizLine.setAttributeValue("status", "360");//���϶����ʧЧ���� 2012-2-13 20:13:15
				m2.saveObject(bizLine); 	 
			 }
		}
		return icount;
	}
	
	/**
	 * �����Ա���ۺ����Ŷ�ȴ���
	 * @author cjyu
	 * @throws JBOException 
	 */
	private void updateGroupLine(BizObject biz,JBOTransaction tx) throws JBOException
	{    
		//TODO ��ʱע��
//		String sCustomerID=biz.getAttribute("CustomerID").getString();
//		double dBusinessSum=biz.getAttribute("BusinessSum").getDouble();
//		String  sBusinessType=biz.getAttribute("BusinessType").getString();
//		//cjyu 2012-2-13 19:48:00 ���ۺ����Ŷ�Ȳ����д���
//		if(!sBusinessType.equals("3010020")) return ; 
//		double dExposureSum=biz.getAttribute("ExposureSum").getDouble();
//		String sGroupID = GetApplyParams.getGroupID(sCustomerID,"0210");
//		//cjyu ���Ϊ���ҵ�����ͻ����򲻼������� 2012-2-13 19:45:59 
//		if(sGroupID==null || "".equals(sGroupID)) return ;
//		BizObject bgroup=GroupCreditLine.getGroupMemberLine(sGroupID);
//		double dGroupBusinessSum=bgroup.getAttribute("BusinessSum").getDouble();
//		double dGroupExposureSum=bgroup.getAttribute("ExposureSum").getDouble();
//		dGroupBusinessSum=dGroupBusinessSum+dBusinessSum;
//		dGroupExposureSum=dGroupExposureSum+dExposureSum;
//		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
//		tx.join(m);
//		List<BizObject> lstGroup=CLRelativeAction.getCustomerCredit(sGroupID,m);
//		for(BizObject bizgroup:lstGroup)
//		{
//			bizgroup.setAttributeValue("BusinessSum", dGroupBusinessSum);
//			bizgroup.setAttributeValue("ExposureSum", dGroupExposureSum);
//			m.saveObject(bizgroup);
//		} 
	}
	 
	/**
	 * ��ҵ������ҵ����й�������������
	 * <li> �����ҵ��Ӧ��������ʱ���Ѿ����ȹ����ˣ��˴�����Ҫ�������зֶ�Ƚ��й�����
	 * <li> ������ڽ��������Ķ�ȣ���Ȼ���δ��Ч�׶Σ�ҲӦ�����ҵ����й���
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public int newCLOccupy(JBOTransaction tx) throws Exception
	{
		int icount=0;
		
		BizObjectManager m=JBOFactory.getBizObjectManager("jbo.app.CL_OCCUPY");
		tx.join(m);
		List<BizObject> lst=m.createQuery("select O.RelativeSerialNo from O,jbo.app.BUSINESS_CONTRACT BC WHERE O.RelativeSerialNo=BC.SerialNo " +
							"and ObjectType=:objectType and ObjectNo=:objectNo")
							.setParameter("objectType", ObjectType)
							.setParameter("objectNo", bizContract.getAttribute("SerialNo").getString()).getResultList(false);
		for(BizObject boccupy:lst)
		{
			String sLineNo=boccupy.getAttribute("RelativeSerialNo").getString(); //cjyu �����ˮ��
			CreditObjectAction creditObject=new CreditObjectAction(sLineNo,"BusinessContract"); //���Ŷ��Ҳ�������Ŷ���---��ͬ��һ�֡�
			icount+=CLRelativeAction.newCLOccupy(creditObject, bizContract, tx);//ҵ����ö�����½�����ϵ����Ҫ����Ҫ���зֽ��й���(CL_OCCUPY��relativeDivNo)			
		}
		return 0;
	}
	
	
}
