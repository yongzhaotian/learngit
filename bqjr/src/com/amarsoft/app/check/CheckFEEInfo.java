package com.amarsoft.app.check;


import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;

public class CheckFEEInfo extends AlarmBiz {

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		
	   //��ȡ����
		String objectNo=(String)this.getAttribute("ObjectNo");
		String objectType=(String)this.getAttribute("ObjectType");
		if(objectNo==null||objectNo.length()==0) throw new Exception("����������󣬲���Ϊ�գ�������ObjectNo:{"+objectNo+"}");
		if(objectType==null||objectType.length()==0) throw new Exception("����������󣬲���Ϊ�գ�������ObjectType:{"+objectType+"}");
		
		
		AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
		//��������׶η�����ϢУ��
		if("CreditApply".equals(objectType)){
			//������Ϣ
			ASValuePool as = new ASValuePool();
			as.setAttribute("ObjectNo", objectNo);
			as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_apply);
			List<BusinessObject> applyFEEInfo =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, "ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
			if(applyFEEInfo==null||applyFEEInfo.isEmpty()){
				this.putMsg("����������Ϣ-��������Ϣ��δ��д");
			}
			/*else{
				for(int j=0;j<applyFEEInfo.size();j++){
					BusinessObject feeInfo = (BusinessObject) applyFEEInfo.get(j);
					String currency = feeInfo.getString("Currency");
					String amount = feeInfo.getString("Amount");
					if(amount==null||amount.length()==0||currency==null||currency.length()==0){
						this.putMsg("���������Ϣ-��������Ϣ��������");
					}
				}
			}
			//��������׶η�����ϢУ��
			if(!"1010".equals(phaseType)&&!"1020".equals(phaseType)&&!"1030".equals(phaseType)){
				List flowOpinion = (List) this.getAttribute(BUSINESSOBJECT_CONSTATNTS.flow_opinion);
				if(flowOpinion.size()==0||flowOpinion.isEmpty()){
					this.putMsg("δǩ�����-û�������������Ϣ�˲�");
				}else{
					for(int i=0;i<flowOpinion.size();i++){
						BusinessObject opinionInfo = (BusinessObject) flowOpinion.get(i);
						List feeInfoList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, "and ObjectNo='"+opinionInfo.getString("OpinionNo")+"' and ObjectType='"+BUSINESSOBJECT_CONSTATNTS.flow_opinion+"'", null);
						if(feeInfoList.size()==0||feeInfoList.isEmpty()){
							this.putMsg("ǩ�����-���������������-��������Ϣ��δ��д");
						}else{
							for(int j=0;j<feeInfoList.size();j++){
								BusinessObject feeInfo = (BusinessObject) feeInfoList.get(j);
								String currency = feeInfo.getString("Currency");
								String amount = feeInfo.getString("Amount");
								if(amount==null||amount.length()==0||currency==null||currency.length()==0){
									this.putMsg("ǩ�����-���������������-��������Ϣ��������");
								}
							}
						}
					}
				}
			}*/
		}
		
		//�ſ�����׶η�����ϢУ��
		if("BusinessPutout".equals(objectType)){
			//������Ϣ
			ASValuePool as = new ASValuePool();
			as.setAttribute("ObjectNo", objectNo);
			as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
			List<BusinessObject> putoutFEEInfo =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, "ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
			if(putoutFEEInfo==null||putoutFEEInfo.isEmpty()){
				this.putMsg("�ſ�������Ϣ-��������Ϣ��δ��д");
			}else{
				for(int j=0;j<putoutFEEInfo.size();j++){
					BusinessObject feeInfo = (BusinessObject) putoutFEEInfo.get(j);
					String currency = feeInfo.getString("Currency");
					String amount = feeInfo.getString("Amount");
					if(amount==null||amount.length()==0||currency==null||currency.length()==0){
						this.putMsg("�ſ�������Ϣ-��������Ϣ��������");
					}
				}
			}
			
			//�ſ�����׶η�����ϢУ��
			/*
			if(!"0010".equals(phaseType)){
				List flowOpinion = (List) this.getAttribute(BUSINESSOBJECT_CONSTATNTS.flow_opinion);
				if(flowOpinion.size()==0||flowOpinion.isEmpty()){
					this.putMsg("δǩ�����-û�������������Ϣ�˲�");
				}else{
					for(int i=0;i<flowOpinion.size();i++){
						BusinessObject opinionInfo = (BusinessObject) flowOpinion.get(i);
						List feeInfoList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, "and ObjectNo='"+opinionInfo.getString("OpinionNo")+"' and ObjectType='"+BUSINESSOBJECT_CONSTATNTS.flow_opinion+"'", null);
						if(feeInfoList.size()==0||!feeInfoList.isEmpty()){
							this.putMsg("ǩ�����-���������������-��������Ϣ��δ��д");
						}else{
							for(int j=0;j<feeInfoList.size();j++){
								BusinessObject feeInfo = (BusinessObject) feeInfoList.get(j);
								String currency = feeInfo.getString("Currency");
								String amount = feeInfo.getString("Amount");
								if(amount==null||amount.length()==0||currency==null||currency.length()==0){
									this.putMsg("ǩ�����-���������������-��������Ϣ��������");
								}
							}
						}
					}
				}
			}
			*/
		}
		
		//�����׶η�����ϢУ��
		if("ApproveApply".equals(objectType)){
			//������Ϣ
			ASValuePool as = new ASValuePool();
			as.setAttribute("ObjectNo", objectNo);
			as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_approve);
			List<BusinessObject> applyFEEInfo =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee, "ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
			if(applyFEEInfo==null||applyFEEInfo.isEmpty()){
				this.putMsg("������Ϣ-��������Ϣ��δ��д");
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
