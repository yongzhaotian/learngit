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
		
	   //��ȡ����
		String objectType=(String)this.getAttribute("ObjectType");
		if(objectType==null||objectType.length()==0) throw new Exception("����������󣬲���Ϊ�գ�������ObjectType:{"+objectType+"}");
		String objectNo=(String)this.getAttribute("ObjectNo");
		if(objectNo==null||objectNo.length()==0) throw new Exception("����������󣬲���Ϊ�գ�������objectNo:{"+objectNo+"}");
		
		AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
		//��ͬ�Ǽǽ׶λ�����ϢУ��
		if("ApproveApply".equals(objectType)){
			BusinessObject businessApprove = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_approve, objectNo);
			String applyType = businessApprove.getString("ApplyType");
			//����������Ϣ���ʽ���
			if("DependentApply".equals(applyType)||"IndependentApply".equals(applyType)){
				
				ASValuePool as = new ASValuePool();
				as.setAttribute("ObjectNo", objectNo);
				as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_approve);
				List<BusinessObject> applyRPTList =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
				if(applyRPTList==null||applyRPTList.isEmpty()){
					this.putMsg("���������Ϣ-��������Ϣ��δ��д");
				}else{
					String payMentFrequencyType = ((BusinessObject)applyRPTList.get(0)).getString("PayMentFrequencyType");
					if(payMentFrequencyType==null||payMentFrequencyType.length()==0){
						this.putMsg("���������Ϣ-��������Ϣ��������");
					}
				}
			}
		}
		
		
		/** ���ؽ������ **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}

}
