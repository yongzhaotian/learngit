package com.amarsoft.app.check;


import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;

public class CheckRPTInfo extends AlarmBiz {

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		
	   //��ȡ����
		String taskNo=(String)this.getAttribute("TaskNo");
		if(taskNo==null||taskNo.length()==0) throw new Exception("����������󣬲���Ϊ�գ�������TaskNo:{"+taskNo+"}");
		String objectType=(String)this.getAttribute("ObjectType");
		if(objectType==null||objectType.length()==0) throw new Exception("����������󣬲���Ϊ�գ�������ObjectType:{"+objectType+"}");
		String objectNo=(String)this.getAttribute("ObjectNo");
		if(objectNo==null||objectNo.length()==0) throw new Exception("����������󣬲���Ϊ�գ�������objectNo:{"+objectNo+"}");
		
		AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
		//��ȡ������Ϣ
		BusinessObject flowTask = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.flow_task, taskNo);
		
		String phaseType = flowTask.getString("PhaseType");
		
		//��������׶λ�����ϢУ��
		if("CreditApply".equals(objectType)){
			BusinessObject businessApply = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_apply, objectNo);
			String applyType = businessApply.getString("ApplyType");
			//����������Ϣ���ʽ���
			if("DependentApply".equals(applyType)||"IndependentApply".equals(applyType)){
				
				ASValuePool as = new ASValuePool();
				as.setAttribute("ObjectNo", objectNo);
				as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_apply);
				List<BusinessObject> applyRPTList =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
				if(applyRPTList==null||applyRPTList.isEmpty()){
					this.putMsg("���������Ϣ-��������Ϣ��δ��д");
				}else{
					String payMentFrequencyType = ((BusinessObject)applyRPTList.get(0)).getString("PayMentFrequencyType");
					if(payMentFrequencyType==null||payMentFrequencyType.length()==0){
						this.putMsg("���������Ϣ-��������Ϣ��������");
					}
				}
				if(!"1010".equals(phaseType)&&!"1020".equals(phaseType)&&!"1030".equals(phaseType)){
					//�������룬ǩ��������������ϢУ��
					if("IndependentApply".equals(applyType)||"DependentApply".equals(applyType)){
						as = new ASValuePool();
						as.setAttribute("ObjectNo", objectNo);
						as.setAttribute("ObjectType", objectType);
						as.setAttribute("SerialNo", taskNo);
						List<BusinessObject> flowOpinion = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.flow_opinion, "ObjectNo=:ObjectNo and ObjectType=:ObjectType and SerialNo=:SerialNo", as);
						if(flowOpinion.size()==0||flowOpinion.isEmpty()){
							this.putMsg("δǩ�����-û�������������Ϣ�˲�");
						}else{
							for(int i=0;i<flowOpinion.size();i++){
								BusinessObject opinionInfo = (BusinessObject) flowOpinion.get(i);
								as = new ASValuePool();
								as.setAttribute("ObjectNo", opinionInfo.getString("OpinionNo"));
								as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.flow_opinion);
								List<BusinessObject> opinionRPTList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType ", as);
								//���������ϢУ��
								if(opinionRPTList==null||opinionRPTList.isEmpty()){
									this.putMsg("ǩ�����-���������������-��������Ϣ��δ��д");
								}else{
									for(int j=0;j<opinionRPTList.size();j++){
										String payMentFrequencyType = ((BusinessObject)opinionRPTList.get(i)).getString("PayMentFrequencyType");
										if(payMentFrequencyType==null||payMentFrequencyType.length()==0){
											this.putMsg("ǩ�����-���������������-��������Ϣ��������");
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
		//�ſ�����׶λ�����ϢУ��
		if("BusinessPutout".equals(objectType)){
			
			BusinessObject businessPutout = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_putout, objectNo);
			
			BusinessObject businessContract = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_contract,businessPutout.getString("ContractSerialNo"));
			String applyType = businessContract.getString("ApplyType");
			//�ſ�������Ϣ�����������ϢУ��
			if("IndependentApply".equals(applyType)||"DependentApply".equals(applyType)){
				//���������Ϣ
				ASValuePool as = new ASValuePool();
				as.setAttribute("ObjectNo", objectNo);
				as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
				List<BusinessObject> putoutRPTInfo =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
				if(putoutRPTInfo==null||putoutRPTInfo.isEmpty()){
					this.putMsg("�ſ�������Ϣ-��������Ϣ��δ��д");
				}else{
					String payMentFrequencyType = ((BusinessObject)putoutRPTInfo.get(0)).getString("PayMentFrequencyType");
					if(payMentFrequencyType==null||payMentFrequencyType.length()==0){
						this.putMsg("�ſ�������Ϣ-��������Ϣ��������");
					}
				}
			}
			
			if(!"0010".equals(phaseType)){
				//�ſ����룬ǩ��������������ϢУ��
				if("IndependentApply".equals(applyType)||"DependentApply".equals(applyType)){
					ASValuePool as = new ASValuePool();
					as.setAttribute("ObjectNo", objectNo);
					as.setAttribute("ObjectType", objectType);
					as.setAttribute("SerialNo", taskNo);
					List<BusinessObject> flowOpinion = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.flow_opinion, "ObjectNo=:ObjectNo and ObjectType=:ObjectType and SerialNo=:SerialNo", as);
					if(flowOpinion.size()==0||!flowOpinion.isEmpty()){
						this.putMsg("δǩ�����-û����������������Ϣ�˲�");
					}else{
						for(int i=0;i<flowOpinion.size();i++){
							BusinessObject opinionInfo = (BusinessObject) flowOpinion.get(i);
							as = new ASValuePool();
							as.setAttribute("ObjectNo", opinionInfo.getString("OpinionNo"));
							as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.flow_opinion);
							List<BusinessObject> opinionRPTList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType ", as);
							//���������ϢУ��
							if(opinionRPTList==null||opinionRPTList.isEmpty()){
								this.putMsg("ǩ�����-���������������-�����������Ϣ��δ��д");
							}else{
								String payMentFrequencyType = ((BusinessObject)opinionRPTList.get(0)).getString("PayMentFrequencyType");
								if(payMentFrequencyType==null||payMentFrequencyType.length()==0){
									this.putMsg("ǩ�����-���������������-�����������Ϣ��������");
								}
							}
						}
					}
				}
			}
		}
		
		//�����׶λ�����ϢУ��
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
//				if(!"1010".equals(phaseType)&&!"1020".equals(phaseType)&&!"1030".equals(phaseType)){
//					//�������룬ǩ��������������ϢУ��
//					if("IndependentApply".equals(applyType)||"DependentApply".equals(applyType)){
//						as = new ASValuePool();
//						as.setAttribute("ObjectNo", objectNo);
//						as.setAttribute("ObjectType", objectType);
//						as.setAttribute("SerialNo", taskNo);
//						List<BusinessObject> flowOpinion = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.flow_opinion, "ObjectNo=:ObjectNo and ObjectType=:ObjectType and SerialNo=:SerialNo", as);
//						if(flowOpinion.size()==0||flowOpinion.isEmpty()){
//							this.putMsg("δǩ�����-û�������������Ϣ�˲�");
//						}else{
//							for(int i=0;i<flowOpinion.size();i++){
//								BusinessObject opinionInfo = (BusinessObject) flowOpinion.get(i);
//								as = new ASValuePool();
//								as.setAttribute("ObjectNo", opinionInfo.getString("OpinionNo"));
//								as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.flow_opinion);
//								List<BusinessObject> opinionRPTList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType ", as);
//								//���������ϢУ��
//								if(opinionRPTList==null||opinionRPTList.isEmpty()){
//									this.putMsg("ǩ�����-���������������-��������Ϣ��δ��д");
//								}else{
//									for(int j=0;j<opinionRPTList.size();j++){
//										String payMentFrequencyType = ((BusinessObject)opinionRPTList.get(i)).getString("PayMentFrequencyType");
//										if(payMentFrequencyType==null||payMentFrequencyType.length()==0){
//											this.putMsg("ǩ�����-���������������-��������Ϣ��������");
//										}
//									}
//								}
//							}
//						}
//					}
//				}
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
