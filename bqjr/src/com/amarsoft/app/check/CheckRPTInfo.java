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
		
	   //获取参数
		String taskNo=(String)this.getAttribute("TaskNo");
		if(taskNo==null||taskNo.length()==0) throw new Exception("传入参数错误，不能为空！参数：TaskNo:{"+taskNo+"}");
		String objectType=(String)this.getAttribute("ObjectType");
		if(objectType==null||objectType.length()==0) throw new Exception("传入参数错误，不能为空！参数：ObjectType:{"+objectType+"}");
		String objectNo=(String)this.getAttribute("ObjectNo");
		if(objectNo==null||objectNo.length()==0) throw new Exception("传入参数错误，不能为空！参数：objectNo:{"+objectNo+"}");
		
		AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
		//获取任务信息
		BusinessObject flowTask = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.flow_task, taskNo);
		
		String phaseType = flowTask.getString("PhaseType");
		
		//贷款申请阶段还款信息校验
		if("CreditApply".equals(objectType)){
			BusinessObject businessApply = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_apply, objectNo);
			String applyType = businessApply.getString("ApplyType");
			//贷款申请信息还款方式组件
			if("DependentApply".equals(applyType)||"IndependentApply".equals(applyType)){
				
				ASValuePool as = new ASValuePool();
				as.setAttribute("ObjectNo", objectNo);
				as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_apply);
				List<BusinessObject> applyRPTList =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
				if(applyRPTList==null||applyRPTList.isEmpty()){
					this.putMsg("贷款基本信息-【还款信息】未填写");
				}else{
					String payMentFrequencyType = ((BusinessObject)applyRPTList.get(0)).getString("PayMentFrequencyType");
					if(payMentFrequencyType==null||payMentFrequencyType.length()==0){
						this.putMsg("贷款基本信息-【还款信息】不完整");
					}
				}
				if(!"1010".equals(phaseType)&&!"1020".equals(phaseType)&&!"1030".equals(phaseType)){
					//贷款申请，签署意见还款组件信息校验
					if("IndependentApply".equals(applyType)||"DependentApply".equals(applyType)){
						as = new ASValuePool();
						as.setAttribute("ObjectNo", objectNo);
						as.setAttribute("ObjectType", objectType);
						as.setAttribute("SerialNo", taskNo);
						List<BusinessObject> flowOpinion = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.flow_opinion, "ObjectNo=:ObjectNo and ObjectType=:ObjectType and SerialNo=:SerialNo", as);
						if(flowOpinion.size()==0||flowOpinion.isEmpty()){
							this.putMsg("未签署意见-没有相关联还款信息核查");
						}else{
							for(int i=0;i<flowOpinion.size();i++){
								BusinessObject opinionInfo = (BusinessObject) flowOpinion.get(i);
								as = new ASValuePool();
								as.setAttribute("ObjectNo", opinionInfo.getString("OpinionNo"));
								as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.flow_opinion);
								List<BusinessObject> opinionRPTList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType ", as);
								//还款组件信息校验
								if(opinionRPTList==null||opinionRPTList.isEmpty()){
									this.putMsg("签署意见-【本次意见审批】-【还款信息】未填写");
								}else{
									for(int j=0;j<opinionRPTList.size();j++){
										String payMentFrequencyType = ((BusinessObject)opinionRPTList.get(i)).getString("PayMentFrequencyType");
										if(payMentFrequencyType==null||payMentFrequencyType.length()==0){
											this.putMsg("签署意见-【本次意见审批】-【还款信息】不完整");
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
		//放款申请阶段还款信息校验
		if("BusinessPutout".equals(objectType)){
			
			BusinessObject businessPutout = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_putout, objectNo);
			
			BusinessObject businessContract = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_contract,businessPutout.getString("ContractSerialNo"));
			String applyType = businessContract.getString("ApplyType");
			//放款申请信息，还款组件信息校验
			if("IndependentApply".equals(applyType)||"DependentApply".equals(applyType)){
				//还款组件信息
				ASValuePool as = new ASValuePool();
				as.setAttribute("ObjectNo", objectNo);
				as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
				List<BusinessObject> putoutRPTInfo =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
				if(putoutRPTInfo==null||putoutRPTInfo.isEmpty()){
					this.putMsg("放款申请信息-【还款信息】未填写");
				}else{
					String payMentFrequencyType = ((BusinessObject)putoutRPTInfo.get(0)).getString("PayMentFrequencyType");
					if(payMentFrequencyType==null||payMentFrequencyType.length()==0){
						this.putMsg("放款申请信息-【还款信息】不完整");
					}
				}
			}
			
			if(!"0010".equals(phaseType)){
				//放款申请，签署意见还款组件信息校验
				if("IndependentApply".equals(applyType)||"DependentApply".equals(applyType)){
					ASValuePool as = new ASValuePool();
					as.setAttribute("ObjectNo", objectNo);
					as.setAttribute("ObjectType", objectType);
					as.setAttribute("SerialNo", taskNo);
					List<BusinessObject> flowOpinion = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.flow_opinion, "ObjectNo=:ObjectNo and ObjectType=:ObjectType and SerialNo=:SerialNo", as);
					if(flowOpinion.size()==0||!flowOpinion.isEmpty()){
						this.putMsg("未签署意见-没有相关联还款组件信息核查");
					}else{
						for(int i=0;i<flowOpinion.size();i++){
							BusinessObject opinionInfo = (BusinessObject) flowOpinion.get(i);
							as = new ASValuePool();
							as.setAttribute("ObjectNo", opinionInfo.getString("OpinionNo"));
							as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.flow_opinion);
							List<BusinessObject> opinionRPTList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType ", as);
							//还款组件信息校验
							if(opinionRPTList==null||opinionRPTList.isEmpty()){
								this.putMsg("签署意见-【本次审批意见】-【还款组件信息】未填写");
							}else{
								String payMentFrequencyType = ((BusinessObject)opinionRPTList.get(0)).getString("PayMentFrequencyType");
								if(payMentFrequencyType==null||payMentFrequencyType.length()==0){
									this.putMsg("签署意见-【本次审批意见】-【还款组件信息】不完整");
								}
							}
						}
					}
				}
			}
		}
		
		//批复阶段还款信息校验
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
//				if(!"1010".equals(phaseType)&&!"1020".equals(phaseType)&&!"1030".equals(phaseType)){
//					//贷款申请，签署意见还款组件信息校验
//					if("IndependentApply".equals(applyType)||"DependentApply".equals(applyType)){
//						as = new ASValuePool();
//						as.setAttribute("ObjectNo", objectNo);
//						as.setAttribute("ObjectType", objectType);
//						as.setAttribute("SerialNo", taskNo);
//						List<BusinessObject> flowOpinion = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.flow_opinion, "ObjectNo=:ObjectNo and ObjectType=:ObjectType and SerialNo=:SerialNo", as);
//						if(flowOpinion.size()==0||flowOpinion.isEmpty()){
//							this.putMsg("未签署意见-没有相关联还款信息核查");
//						}else{
//							for(int i=0;i<flowOpinion.size();i++){
//								BusinessObject opinionInfo = (BusinessObject) flowOpinion.get(i);
//								as = new ASValuePool();
//								as.setAttribute("ObjectNo", opinionInfo.getString("OpinionNo"));
//								as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.flow_opinion);
//								List<BusinessObject> opinionRPTList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment, "ObjectNo=:ObjectNo and ObjectType=:ObjectType ", as);
//								//还款组件信息校验
//								if(opinionRPTList==null||opinionRPTList.isEmpty()){
//									this.putMsg("签署意见-【本次意见审批】-【还款信息】未填写");
//								}else{
//									for(int j=0;j<opinionRPTList.size();j++){
//										String payMentFrequencyType = ((BusinessObject)opinionRPTList.get(i)).getString("PayMentFrequencyType");
//										if(payMentFrequencyType==null||payMentFrequencyType.length()==0){
//											this.putMsg("签署意见-【本次意见审批】-【还款信息】不完整");
//										}
//									}
//								}
//							}
//						}
//					}
//				}
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
