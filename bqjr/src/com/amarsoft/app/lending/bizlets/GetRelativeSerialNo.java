/*
 *	Author: zywei 2006-1-18
 *	Tester:
 *	Describe: 取得业务关联编号
 *	Input Param:
 *			ObjectType：对象类型
 *			RelaObjectType：关联对象类型
 *			ObjectNo：对象编号
 *	Output Param:
 *			SerialNo：业务关联编号
 *	HistoryLog:
 *
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetRelativeSerialNo extends Bizlet 
{
	public Object run(Transaction Sqlca) throws Exception
	{
		//获取参数
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sRelaObjectType = (String)this.getAttribute("RelaObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sRelaObjectType == null) sRelaObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//定义变量：SQL语句
		String sSerialNo = "";
		String sRelativeSerialNo = "";
		SqlObject so ;
		
		//查询申请相对应的业务对象流水号（授信额度流水号、资产重组方案）
		if(sObjectType.equals("CreditApply"))
		{	
			//关联对象为授信额度对象
			if(sRelaObjectType.equals("CreditLine"))
			{
				//根据申请流水号获得授信额度流水号
				so = new SqlObject("select CreditAggreement from BUSINESS_APPLY where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo =  Sqlca.getString(so);
			}

			//关联对象为资产重组方案对象
			if(sRelaObjectType.equals("NPAReformApply"))
			{
				//根据申请流水号获得资产重组方案流水号
				so = new SqlObject("select ObjectNo from APPLY_RELATIVE where SerialNo =:SerialNo and ObjectType = 'NPAReformApply'").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}
			
		}
		
		//查询最终审批意见相对应的业务对象流水号（授信额度流水号、资产重组方案）
		if(sObjectType.equals("ApproveApply") || sObjectType.equals("ApproveApplyNo"))
		{	
			//关联对象为申请对象
			if(sRelaObjectType.equals("CreditApply"))
			{
				//根据最终审批意见流水号获得申请流水号
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			if(sObjectType.equals("ApproveApply"))
			{			
				//关联对象为授信额度对象
				if(sRelaObjectType.equals("CreditLine"))
				{
					//根据最终审批意见流水号获得授信额度流水号
					so = new SqlObject("select CreditAggreement from BUSINESS_APPROVE where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
					sSerialNo = Sqlca.getString(so);
				}
	
				//关联对象为资产重组方案对象
				if(sRelaObjectType.equals("NPAReformApply"))
				{
					//根据最终审批意见流水号获得资产重组方案流水号
					so = new SqlObject("select ObjectNo from APPROVE_RELATIVE where SerialNo =:SerialNo and ObjectType = 'NPAReformApply'").setParameter("SerialNo", sObjectNo);
					sSerialNo = Sqlca.getString(so);
				}
			}			
		}
		
		//查询合同相对应的业务对象流水号（授信额度流水号、最终审批意见流水号、申请流水号、资产重组方案）
		if(sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan"))
		{
			
			//关联对象为申请对象
			if(sRelaObjectType.equals("CreditApply"))
			{
				//根据合同流水号获得最终审批意见流水号
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//根据最终审批意见流水号获得申请流水号
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
				IsPassApprove ipa = new IsPassApprove();
				ipa.setAttribute("ObjectNo", sObjectNo);
				if(ipa.run(Sqlca).equals("false")) sSerialNo = sRelativeSerialNo;//如果没有从批复表获取到数据，则可能是没有走批复流程，那么合同表的RelativeSerialNo就是申请流水号
			}
			
			//关联对象为最终审批意见对象
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//根据合同流水号获得最终审批意见流水号
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}

			//关联对象为授信额度对象
			if(sRelaObjectType.equals("CreditLine"))
			{
				//根据合同流水号获得最终审批意见流水号
				so = new SqlObject("select CreditAggreement from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}

			//关联对象为资产重组方案对象
			if(sRelaObjectType.equals("NPAReformApply"))
			{
				//根据合同流水号获得最终审批意见流水号
				so = new SqlObject("select ObjectNo from CONTRACT_RELATIVE where SerialNo =:SerialNo and ObjectType = 'NPAReformApply'").setParameter("SerialNo", sObjectNo);
				sSerialNo =  Sqlca.getString(so);
			}
			
		}
				
		//查询出帐相对应的业务对象流水号（合同、批复、申请）
		if(sObjectType.equals("PutOutApply"))
		{
			//关联对象为申请对象
			if(sRelaObjectType.equals("CreditApply"))
			{
				//根据出帐流水号获得合同流水号
				so = new SqlObject("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//根据合同流水号获得最终审批意见流水号
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//根据最终审批意见流水号获得申请流水号
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
				
			}
			
			//关联对象为最终审批意见对象
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//根据出帐流水号获得合同流水号
				so = new SqlObject("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				
				//根据合同流水号获得最终审批意见流水号
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			//关联对象为合同对象
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//根据出帐流水号获得合同流水号
				so = new SqlObject("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}						
		}
		
		//查询支付相对应的业务对象流水号（放贷、合同、批复、申请）
		if(sObjectType.equals("PaymentApply"))
		{
			//关联对象为申请对象
			if(sRelaObjectType.equals("CreditApply"))
			{
				//根据支付流水号获得出帐流水号
				so = new SqlObject("select distinct PutoutSerialNo from PAYMENT_INFO where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//根据出帐流水号获得合同流水号
				so = new SqlObject("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sRelativeSerialNo =  Sqlca.getString(so);
				//根据合同流水号获得最终审批意见流水号
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//根据最终审批意见流水号获得申请流水号
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			//关联对象为最终审批意见对象
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//根据支付流水号获得出帐流水号
				so = new SqlObject("select distinct PutoutSerialNo from PAYMENT_INFO where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//根据出帐流水号获得合同流水号
				so = new SqlObject("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//根据合同流水号获得最终审批意见流水号
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			//关联对象为合同对象
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//根据支付流水号获得出帐流水号
				so = new SqlObject("select distinct PutoutSerialNo from PAYMENT_INFO where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//根据出帐流水号获得合同流水号
				so = new SqlObject("select distinct ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			//关联对象为出帐对象
			if(sRelaObjectType.equals("PutOutApply"))
			{
				//根据支付流水号获得出帐流水号
				so = new SqlObject("select distinct PutoutSerialNo from PAYMENT_INFO where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}
		}
							
		//查询借据相对应的业务对象流水号（合同、出帐）
		if(sObjectType.equals("BusinessDueBill"))
		{
			//关联对象为申请对象
			if(sRelaObjectType.equals("CreditApply"))
			{
				//根据借据流水号获得合同流水号
				so = new SqlObject("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//根据合同流水号获得最终审批意见流水号
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//根据最终审批意见流水号获得申请流水号
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_APPROVE where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
				
			}
			
			//查询借据相对应的最终审批意见
			if(sRelaObjectType.equals("ApproveApply"))
			{
				//根据借据流水号获得合同流水号
				so = new SqlObject("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//根据合同流水号获得最终审批意见流水号
				so = new SqlObject("select distinct RelativeSerialNo from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			//关联对象为合同对象
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//根据出帐流水号获得合同流水号
				so = new SqlObject("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}
		}
		
		
		//查询减值准备相对应的业务对象流水号（合同、借据）
		if(sObjectType.equals("Reserve"))
		{
			//关联对象为借据对象
			if(sRelaObjectType.equals("BusinessDueBill"))
			{
				//根据申请流水号获得借据流水号
				so = new SqlObject("select distinct DuebillNo from RESERVE_APPLY where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}
			
			//查询申请相对应的合同
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//根据申请流水号获得借据流水号
				so = new SqlObject("select distinct DuebillNo from RESERVE_APPLY where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sRelativeSerialNo = Sqlca.getString(so);
				//根据借据流水号获得合同流水号
				so = new SqlObject("select distinct RelativeSerialNo2 from BUSINESS_DUEBILL where SerialNo =:SerialNo").setParameter("SerialNo", sRelativeSerialNo);
				sSerialNo = Sqlca.getString(so);
			}

		}	
		
		
		//查询担保合同变更相对应的业务对象流水号
		if(sObjectType.equals("TransformApply"))
		{
			//查询申请相对应的合同
			if(sRelaObjectType.equals("BusinessContract"))
			{
				//根据申请流水号获得借据流水号
				so = new SqlObject("select RelativeSerialNo from GUARANTY_TRANSFORM where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
				sSerialNo = Sqlca.getString(so);
			}
		}
		return sSerialNo;
	}
}