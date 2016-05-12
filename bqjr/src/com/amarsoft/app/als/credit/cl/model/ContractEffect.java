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
 * 合同生效，额度生效处理
 * 额度生效所要做的处理
 * <li>额度生效方式，接续、调整
 * <li>额度生效方式，接续、调整
 * 
 * @author cjyu
 *
 */
public class ContractEffect {

	BizObject bizContract;
	private CreditLine ncreditLine;
	private String ObjectType="";
	/**
	 * 构造额度信息
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
	 * 合同生效处理
	 * 需要处理一下事件
	 * <li>新老额度替换
	 * <li>集体额度成员综合授信额度汇总到集体额度中。
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
	 * 将额度需要替换的业务进行关联
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
		//cjyu 该处可能有争议，m2保存的是另外的Manager产生的对象
		BizObjectManager m2=JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		tx.join(m2);
		for(BizObject biz:lst)
		{
			String sRelativeSerialNo=biz.getAttribute("Relativeserialno").getString();
			CreditLine oldLine=new CreditLine(sRelativeSerialNo); 
			
			icount+=CLRelativeAction.newReplace(ncreditLine.getCurCreditObject(), oldLine, tx);
			BizObject bizLine=oldLine.getBizObject();
			if(ioverday<=0)//cjyu 立即生效 2012-2-13 20:03:33
			 {
				bizLine.setAttributeValue("status", "360");//将老额度做失效处理 2012-2-13 20:13:15
				m2.saveObject(bizLine); 	 
			 }
		}
		return icount;
	}
	
	/**
	 * 集体成员的综合授信额度处理
	 * @author cjyu
	 * @throws JBOException 
	 */
	private void updateGroupLine(BizObject biz,JBOTransaction tx) throws JBOException
	{    
		//TODO 暂时注释
//		String sCustomerID=biz.getAttribute("CustomerID").getString();
//		double dBusinessSum=biz.getAttribute("BusinessSum").getDouble();
//		String  sBusinessType=biz.getAttribute("BusinessType").getString();
//		//cjyu 2012-2-13 19:48:00 非综合授信额度不进行处理
//		if(!sBusinessType.equals("3010020")) return ; 
//		double dExposureSum=biz.getAttribute("ExposureSum").getDouble();
//		String sGroupID = GetApplyParams.getGroupID(sCustomerID,"0210");
//		//cjyu 如果为能找到集体客户，则不继续进行 2012-2-13 19:45:59 
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
	 * 将业务与额度业务进行关联，考虑问题
	 * <li> 额度下业务应该在申请时就已经与额度关联了，此处还需要与额度下切分额度进行关联。
	 * <li> 如果存在接续产生的额度，额度还在未生效阶段，也应该与该业务进行管理
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
			String sLineNo=boccupy.getAttribute("RelativeSerialNo").getString(); //cjyu 额度流水号
			CreditObjectAction creditObject=new CreditObjectAction(sLineNo,"BusinessContract"); //授信额度也属于授信对象---合同的一种。
			icount+=CLRelativeAction.newCLOccupy(creditObject, bizContract, tx);//业务与该额度重新建立关系，主要是需要与切分进行关联(CL_OCCUPY的relativeDivNo)			
		}
		return 0;
	}
	
	
}
