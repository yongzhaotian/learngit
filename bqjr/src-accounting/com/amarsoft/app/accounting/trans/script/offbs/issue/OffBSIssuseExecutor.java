package com.amarsoft.app.accounting.trans.script.offbs.issue;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.amarscript.Any;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.app.accounting.util.FeeFunctions;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

/**
 * �����
 */
public class OffBSIssuseExecutor implements ITransactionExecutor{
	
	
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		
		BusinessObject businessPutout=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		if(!"0".equals(businessPutout.getString("PutoutStatus")) && businessPutout.getString("PutoutStatus")!=null) 
			throw new LoanException("����״̬����δ���ˣ�����ʹ�ô������ܣ�");
		//������������
		businessPutout.setAttributeValue("PutoutDate", SystemConfig.getBusinessDate());
		String maturitydate = businessPutout.getString("Maturity");
		if(maturitydate==null||maturitydate.length()==0){
			//���������պ�����
			int termMonth = businessPutout.getInt("TermMonth");
			int termDay = businessPutout.getInt("TermDay");
			if(termMonth>=0 && termDay >= 0 && termMonth+termDay > 0){
				maturitydate=DateFunctions.getRelativeDate(SystemConfig.getBusinessDate(), DateFunctions.TERM_UNIT_MONTH, termMonth);
				maturitydate=DateFunctions.getRelativeDate(maturitydate, DateFunctions.TERM_UNIT_DAY, termDay);
				businessPutout.setAttributeValue("Maturity",maturitydate);//����ĵ�����
			}
			else throw new LoanException("δ¼����ȷ���ޣ����飡");
		}
		//����BUSINESS_PUTOUT��������BUSINESS_DUEBILL����
		createDueBill(transaction,boManager);

		//��bc��ʵ�ʷſ������
		BusinessObject bc=businessPutout.getRelativeObject(BUSINESSOBJECT_CONSTATNTS.business_contract,businessPutout.getString("ContractSerialNo"));
		bc.setAttributeValue("ActualputoutSum", bc.getDouble("ActualputoutSum")+businessPutout.getDouble("BusinessSum"));
		bc.setAttributeValue("Balance", bc.getDouble("Balance")+businessPutout.getDouble("BusinessSum"));
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,bc);
		
		//���³��˼�¼�ſ�״̬		
		businessPutout.setAttributeValue("PutoutStatus", "1");
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, businessPutout);
		
		return 1;
	}
	
	/**
	 * ���ݳ�����Ϣ���ɴ�����Ϣ
	 * @throws Exception
	 */
	private BusinessObject createDueBill(BusinessObject transaction,AbstractBusinessObjectManager boManager) throws Exception{
		BusinessObject bd = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.business_duebill,boManager);
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, bd);
		transaction.setAttributeValue("RelativeObjectType", bd.getObjectType());
		transaction.setAttributeValue("RelativeObjectNo", bd.getObjectNo());
		transaction.setRelativeObject(bd);
		Item[] colMapping = CodeCache.getItems("BD_ColumnsMapping");
		for (int i=0;i<colMapping.length;i++) {
			Item item=colMapping[i];
			String bdAttributeID=item.getItemNo();
			String objectType=item.getItemAttribute();
			String attributeID=item.getRelativeCode();
			if(objectType!=null&&objectType.length()>0){
				BusinessObject sourceObject=transaction.getRelativeObjects(objectType).get(0);
				bd.setAttributeValue(bdAttributeID, sourceObject.getObject(attributeID));
			}
			else{
				Any a = ExtendedFunctions.getScriptValue(attributeID,transaction,boManager.getSqlca());
				bd.setAttributeValue(bdAttributeID, a);
			}
		}
		//��������صķ��ã����ſ�ǰ�ķ��ù����������
		copyFeeToBusinessDueBill(transaction,bd,boManager);
		return bd;
	}
	
	private void copyFeeToBusinessDueBill(BusinessObject transaction,BusinessObject bd,AbstractBusinessObjectManager boManager) throws Exception{
		BusinessObject businessPutout=transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		List<BusinessObject> feeList = businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		List<BusinessObject> feeLogList = businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_log);
		List<BusinessObject> feeScheduleList = businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_schedule);
		List<BusinessObject> feeAmortizeScheduleList = businessPutout.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.feeAmortize_schedule);
		if(feeList!=null){
			for(BusinessObject fee:feeList){
				BusinessObject newFee = new BusinessObject(fee.getObjectType(),boManager);
				newFee.setValue(fee);
				
				bd.setRelativeObject(newFee);
				newFee.setAttributeValue("ObjectType", bd.getObjectType());
				newFee.setAttributeValue("ObjectNo", bd.getObjectNo());
				newFee.removeRelativeObject(businessPutout.getObjectType(), businessPutout.getObjectNo());
				newFee.setAttributeValue("Status", "1");
				fee.setAttributeValue("Status", "3");
				newFee.setAttributeValue("AccountingOrgID", bd.getString("OPERATEORGID"));
				
				//�������̯���ƻ�
				if(feeAmortizeScheduleList!=null){
					for(BusinessObject feeAmortize:feeAmortizeScheduleList){
						if(feeAmortize.getString("FeeSerialNo").equals(fee.getObjectNo()))
						{
							BusinessObject newFeeAmortize = new BusinessObject(feeAmortize.getObjectType(),boManager);
							newFeeAmortize.setValue(feeAmortize);
							newFeeAmortize.setAttributeValue("ObjectType", bd.getObjectType());
							newFeeAmortize.setAttributeValue("ObjectNo", bd.getObjectNo());
							newFeeAmortize.setAttributeValue("FeeSerialNo", newFee.getObjectNo());
							feeAmortize.setAttributeValue("Status", "2");
							boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newFeeAmortize);
							bd.setRelativeObject(newFeeAmortize);
						}
					}
				}
				
				if(feeScheduleList!=null){
					for(BusinessObject feeSche:feeScheduleList){
						if(feeSche.getString("FeeSerialNo").equals(fee.getObjectNo()))
						{
							BusinessObject newFeeSche = new BusinessObject(feeSche.getObjectType(),boManager);
							newFeeSche.setValue(feeSche);
							newFeeSche.setAttributeValue("ObjectType", bd.getObjectType());
							newFeeSche.setAttributeValue("ObjectNo", bd.getObjectNo());
							newFeeSche.setAttributeValue("FeeSerialNo", newFee.getObjectNo());
							boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newFeeSche);
							bd.setRelativeObject(newFeeSche);
							newFee.setRelativeObject(feeSche);
							
							if(feeLogList!=null){
								for(BusinessObject feeLog:feeLogList){
									if(feeLog.getString("FeeScheduleSerialNo").equals(feeSche.getObjectNo()))
									{
										BusinessObject newFeeLog = new BusinessObject(feeLog.getObjectType(),boManager);
										newFeeLog.setValue(feeLog);
										newFeeLog.setAttributeValue("ObjectType", bd.getObjectType());
										newFeeLog.setAttributeValue("ObjectNo", bd.getObjectNo());
										newFeeLog.setAttributeValue("FeeSerialNo", newFee.getObjectNo());
										newFeeLog.setAttributeValue("FeeScheduleSerialNo", newFeeSche.getObjectNo());
										feeLog.setAttributeValue("Status", "2");
										boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newFeeLog);
										bd.setRelativeObject(newFeeLog);
									}
								}
							}
						}
					}
				}
				
				//������ü�����Ϣ
				List<BusinessObject> boList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_waive);
				if(boList != null)
				{
					for(BusinessObject feewaive:boList)
					{
						BusinessObject fw = new BusinessObject(feewaive.getObjectType(),boManager);
						fw.setValue(feewaive);
						fw.setAttributeValue("ObjectNo", newFee.getObjectNo());
						fw.setAttributeValue("ObjectType", newFee.getObjectType());
						
						if(fw.getString("WaiveFromDate") == null || fw.getString("WaiveFromDate").length() == 0)
							fw.setAttributeValue("WaiveFromDate", newFee.getString("SegFromDate"));
						if(fw.getString("WaiveToDate") == null || fw.getString("WaiveToDate").length() == 0)
							fw.setAttributeValue("WaiveToDate", newFee.getString("SegToDate"));
						if(fw.getInt("WaiveFromStage") == 0) fw.setAttributeValue("WaiveFromStage", newFee.getString("SegFromStage"));
						if(fw.getInt("WaiveToStage") == 0) fw.setAttributeValue("WaiveToStage", newFee.getString("SegToStage"));
						newFee.setRelativeObject(fw);
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, fw);
					}
				}
				//��������˻���Ϣ
				boList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
				if(boList != null)//�鿴���ñ���¼��ķ��ô���˻���Ϣ
				{
					for(BusinessObject bo:boList)
					{
						BusinessObject la = new BusinessObject(bo.getObjectType(),boManager);
						la.setValue(bo);
						la.setAttributeValue("ObjectNo",newFee.getObjectNo());
						la.setAttributeValue("ObjectType", newFee.getObjectType());
						la.setAttributeValue("Status", "1");
						newFee.setRelativeObject(la);
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, la);
					}
				}
				//���շ�ʱ�Ҳ��������˻����Զ��ҷ��ù������˻���Ϣ�Ƿ����һЩ������
				else//������ñ���δ¼��ķ��ô���˻���Ϣ�������ʹ�ô���¼��Ĵ���˻���Ϣ
				{
					boList = bd.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
					if(boList == null) return;
					for(BusinessObject bo:boList)
					{
						BusinessObject la = new BusinessObject(bo.getObjectType(),boManager);
						la.setValue(bo);
						la.setAttributeValue("ObjectNo",newFee.getObjectNo());
						la.setAttributeValue("ObjectType", newFee.getObjectType());
						la.setAttributeValue("Status", "1");
						newFee.setRelativeObject(la);
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, la);
					}
				}
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, newFee);
				ArrayList<BusinessObject> feeScheduleList_T = FeeFunctions.createFeeScheduleList(newFee,bd, boManager);
				newFee.setRelativeObjects(feeScheduleList_T);
				bd.setRelativeObjects(feeScheduleList_T);
				boManager.setBusinessObjects(AbstractBusinessObjectManager.operateflag_new, feeScheduleList_T);
			}
		}
	}
}
