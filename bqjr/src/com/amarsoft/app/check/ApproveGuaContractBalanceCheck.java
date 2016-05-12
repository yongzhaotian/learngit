package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * <p>
 * 检查最高额担保合同余额是否大于批复金额<br/>
 * 1.取出该笔批复关联的所有担保合同<br/>
 * 2.分别计算这两笔担保合同的担保余额<br/>
 * 3.取余额较低的担保合同余额作担保余额<br/>
 * 4.比较担保余额是否大于批复金额，若大于则通过<br/>
 * </p>
 * <p>
 * 考虑到担保合同有两种方式新增<br/>
 * 1.新增的最高担保合同（未签合同）<br/>
 * 2.引入的最高担保合同（已签合同）<br/>
 * 对于未签合同的最高担保合同，不作最检查，只对引入的最高担保合同才作检查
 * </p>
 * @author djia
 * @since 2009/11/03
 * @history syang 2009/11/10
 */

public class ApproveGuaContractBalanceCheck extends AlarmBiz{
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/* 取参数 */
		BizObject jboApprove = (BizObject)this.getAttribute("BusinessApprove");					//取业务批复
		BizObject[] jboGuarantys = (BizObject[])this.getAttribute("GuarantyContract");		//取担保合同，担保合同可能有多个存在的情况
		double dBusinessSum = jboApprove.getAttribute("BusinessSum").getDouble();				//批复金额
		
		/* 变量定义 */
		String sSql="";
		String sTmp = "";
		double dUsedLimit = 0.0;			//已占用额度
	 	double dGuarantySum = 0.0;			//总担保额度
	 	double dMinGuarantyBalance = 0.0;	//所有担保合同中，最低担保余额
	 	
		for(int i=0;i<jboGuarantys.length;i++){
			BizObject jboGuaranty = jboGuarantys[i];
			String sContractType = jboGuaranty.getAttribute("ContractType").getString();	//合同类型
			String sContractStatus = jboGuaranty.getAttribute("ContractStatus").getString();//合同状态
			//为担保合同，且已签合同
			if(sContractType.equals("020")&&sContractStatus.equals("020")){
				String sGuarantyNo = jboGuaranty.getAttribute("SerialNo").getString();	//担保合同号
				dGuarantySum = jboGuaranty.getAttribute("GuarantyValue").getDouble();	//担保合用总额
			 	
			 	//查询该笔担保关联的所有业务合同，并出取出有效合同，计算他们的总额
				sSql = "select sum(Balance*GetErate(businesscurrency,'01','')) from BUSINESS_CONTRACT BC "
			 			+" where SerialNo in("
			 			+" select SerialNo from Contract_Relative "
			 			+" where objecttype='GuarantyContract' "
			 			+" and ObjectNo=:ObjectNo"
			 			+")"
			 			+" and (BC.FinishDate is null or BC.FinishDate = '' or BC.FinishDate = ' ')"
			 			;
				SqlObject so = new SqlObject(sSql);
				so.setParameter("ObjectNo", sGuarantyNo);
		 	    sTmp = Sqlca.getString(so);
			 	if(sTmp == null) sTmp = "0";
			 	dUsedLimit = Double.parseDouble(sTmp);
			 	
			 	//计算担保余额
			 	double dGuarantyBalance = dGuarantySum - dUsedLimit;
			 	//取第一个值
			 	if(i == 0){dMinGuarantyBalance = dGuarantyBalance;}
			 	//取最小值
			 	if(dMinGuarantyBalance>dGuarantyBalance){
			 		dMinGuarantyBalance = dGuarantyBalance;
			 	}
			}
		}
		if((dMinGuarantyBalance- dBusinessSum) < 0){
			putMsg("批复金额大于最高额担保合同余额");	
		}	

		/** 返回结果处理 **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}

}
