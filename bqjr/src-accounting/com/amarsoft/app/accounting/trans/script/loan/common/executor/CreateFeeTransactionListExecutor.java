package com.amarsoft.app.accounting.trans.script.loan.common.executor;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.app.accounting.trans.script.ITransactionExecutor;
import com.amarsoft.are.util.ASValuePool;

public class CreateFeeTransactionListExecutor implements ITransactionExecutor{
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		//����ҵ�����
				BusinessObject feeObject = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
				String transactionCode=transaction.getString("TransCode");
				//��ȡҵ�����Ĺ���������Ϣ
				List<BusinessObject> feeList = feeObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
				if(feeList==null||feeList.isEmpty()){
					//���ط��÷���
					String whereClauseSql =" ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status " ;
					ASValuePool as = new ASValuePool();
					as.setAttribute("ObjectType", feeObject.getObjectType());
					as.setAttribute("ObjectNo", feeObject.getObjectNo());
					as.setAttribute("Status", "1");
					ASValuePool rela = new ASValuePool();
					rela.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
					rela.setAttribute("ObjectNo", "${SerialNo}");
					feeList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.fee,whereClauseSql,as,BUSINESSOBJECT_CONSTATNTS.fee_waive," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",rela);
					feeList = boManager.loadBusinessObjects(feeList, BUSINESSOBJECT_CONSTATNTS.loan_accounts," ObjectNo=:ObjectNo and ObjectType=:ObjectType ",rela);
					feeObject.setRelativeObjects(feeList);
				}
				
				if(feeList!=null&&!feeList.isEmpty()){
					for(BusinessObject fee:feeList){
						//fee=FeeFunctions.importTermParameter(fee, feeObject, boManager);
						//У����ڴ˴��������Ƿ���createFeeTransaction�����ڣ�ԭ������Щ��Ŀ��Ҫ�ֹ��������ý���
						if(!checkFeeValid(transaction, fee, feeObject))continue;
						if(getFeeLog(transaction, fee.getString("SerialNo"))!=null) continue;//����Ѿ��ֹ������˶�Ӧ�ķ��ý��ף������ظ�������
						
						String feeTransactionCode=fee.getString("TransCode");//�������״���
						if(feeTransactionCode==null||feeTransactionCode.length()==0) continue;
						if(feeTransactionCode.indexOf(transactionCode)<0) continue;
						String feePayDateFlag=fee.getString("FeePayDateFlag");
						if(feePayDateFlag==null) continue;
						
						String feeFlag = fee.getString("FeeFlag");
						String transCode=null;
						if(feeFlag==null||feeFlag.length()==0) continue;
						else if(feeFlag.equals("R")){
							transCode=ACCOUNT_CONSTANTS.TRANSCODE_RECIEVE_FEE;
							if(fee.getDouble("ActualRecieveAmount")>= fee.getDouble("TotalAmount") && fee.getDouble("TotalAmount") > 0.0d)
								continue;
						}
						else if(feeFlag.equals("P")){
							transCode=ACCOUNT_CONSTANTS.TRANSCODE_PAY_FEE;
							if(fee.getDouble("ActualPayAmount")>= fee.getDouble("TotalAmount") && fee.getDouble("TotalAmount") > 0.0d)
								continue;
						}
						else continue; 
						List<BusinessObject> accountList = fee.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
						if(accountList == null || accountList.isEmpty())
							accountList = feeObject.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
						if(accountList == null || accountList.isEmpty())
						{
							ASValuePool as = new ASValuePool();
							as.setAttribute("ObjectType", feeObject.getObjectType());
							as.setAttribute("ObjectNo", feeObject.getObjectNo());
							as.setAttribute("Status", "1");
							accountList = boManager.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts, " ObjectType = :ObjectType and ObjectNo = :ObjectNo and Status=:Status " , as);
						}
						fee.setRelativeObjects(accountList);
						BusinessObject feeTransaction = createFeeTransaction(transaction, fee, transCode, boManager);
						if(feeTransaction==null) continue;
						feeTransaction.setRelativeObject(feeObject);
						transaction.setRelativeObject(feeTransaction);
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, feeTransaction);
					}
				}
		
		return 1;
	}
	
	private BusinessObject getFeeLog(BusinessObject transaction, String feeSerialNo) throws Exception{
		List<BusinessObject> feeLogList = transaction.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee_log);
		if(feeLogList!=null){
			for(BusinessObject feeLog:feeLogList){
				if(feeSerialNo.equals(feeLog.getString("FeeSerialNo")))
					return feeLog;
			}
		}
		return null;
	}
	
	private boolean checkFeeValid(BusinessObject transaction, BusinessObject fee, BusinessObject loan) throws NumberFormatException, Exception{
		if(!loan.getObjectType().equals(BUSINESSOBJECT_CONSTATNTS.loan))
			return true;
		int segBeginStage = fee.getInt("SegBeginStage");
		int segStages = fee.getInt("SEGStages");
		int segEndStage = fee.getInt("SEGEndStage");
		if(segBeginStage==0&&segStages==0) return true;
		if(segEndStage==0) segEndStage=segBeginStage+segStages;
		 
		String putoutDate = loan.getString("PutoutDate");
		
		String fromDate = fee.getString("SegFromDate");
		String toDate = fee.getString("SegToDate");
		if(fromDate==null||fromDate.length()==0)
			fromDate = DateFunctions.getRelativeDate(putoutDate, DateFunctions.TERM_UNIT_MONTH, segBeginStage-1);
		if(toDate==null||toDate.length()==0)
			toDate = DateFunctions.getRelativeDate(putoutDate, DateFunctions.TERM_UNIT_MONTH, segEndStage-segBeginStage+1);
		if(toDate.compareTo(transaction.getString("TransDate"))<=0
				&&toDate.compareTo(transaction.getString("TransDate"))>0){
			return true;
		}
		else{
			return false;
		}
	}
	
	private BusinessObject createFeeTransaction(BusinessObject transaction, BusinessObject fee,String transCode, AbstractBusinessObjectManager boManager) throws NumberFormatException, Exception{
		BusinessObject feeObject=transaction.getRelativeObject(
				transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		
		BusinessObject feeLog = this.getFeeLog(transaction, fee.getString("SerialNo"));
		if(feeLog==null){
			fee.setRelativeObject(feeObject);
			
			BusinessObject feeTransaction = TransactionFunctions.createTransaction(transCode, null, fee, transaction.getString("InputUserID"),transaction.getString("TransDate"), boManager);
			feeLog = feeTransaction.getRelativeObject(feeTransaction.getString("DocumentType"),
					feeTransaction.getString("DocumentSerialNo"));
			feeLog.setAttributeValue("TransactionSerialNo", transaction.getString("SerialNo"));
			feeTransaction.setAttributeValue("ParentTransSerialNo", transaction.getString("SerialNo"));
			transaction.setRelativeObject(feeLog);
			feeTransaction.setRelativeObject(feeObject);
			fee.removeRelativeObject(feeObject);
			return feeTransaction;
		}
		else return null;
	}
}
