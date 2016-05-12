package com.amarsoft.app.check;


import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;

public class CheckRPTCInfo extends AlarmBiz {

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		
	   //获取参数
		String objectType=(String)this.getAttribute("ObjectType");
		if(objectType==null||objectType.length()==0) throw new Exception("传入参数错误，不能为空！参数：ObjectType:{"+objectType+"}");
		String objectNo=(String)this.getAttribute("ObjectNo");
		if(objectNo==null||objectNo.length()==0) throw new Exception("传入参数错误，不能为空！参数：objectNo:{"+objectNo+"}");
		
		AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
		//合同登记阶段还款信息校验
		if("ApproveApply".equals(objectType)){
			BusinessObject businessApprove = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_approve, objectNo);
			String applyType = businessApprove.getString("ApplyType");
			//贷款申请信息还款方式组件
			if("DependentApply".equals(applyType)||"IndependentApply".equals(applyType)){
				
				ASValuePool as = new ASValuePool();
				as.setAttribute("ObjectNo", objectNo);
				as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_approve);
				List<BusinessObject> applyRPTList =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
				if(applyRPTList==null||applyRPTList.isEmpty()){
					this.putMsg("批复意见信息-【还款信息】未填写");
				}else{
					String payMentFrequencyType = ((BusinessObject)applyRPTList.get(0)).getString("PayMentFrequencyType");
					if(payMentFrequencyType==null||payMentFrequencyType.length()==0){
						this.putMsg("批复意见信息-【还款信息】不完整");
					}
				}
			}
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
