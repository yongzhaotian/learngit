package com.amarsoft.app.accounting.trans.script.loan.accountorgchange;

//���������ǰ����
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.common.executor.BookKeepExecutor;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;

public class AccountOrgChangeExecutor extends BookKeepExecutor{
	
	
	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		ArrayList<BusinessObject> detailList = new ArrayList<BusinessObject>();
		//���׶�Ӧ�Ľ�ݶ���
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		//���׶�Ӧ�ĵ��ݶ���
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		//ȡ�»���
		String newAccountingOrgID = loanChange.getString("AccountingOrgID");
		//��ԭ��ݶ�������˻������õ����ݵ�ԭ���˻�����
		loan.setAttributeValue("AccountingOrgID", loanChange.getString("AccountingOrgID"));

		//�˴������¼
		List<BusinessObject> subledgers = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger);
		if(subledgers != null){
			for(int i =0; i < subledgers.size(); i ++){
				String subLedgerSerialNo = subledgers.get(i).getString("SerialNo");
				String objectType = subledgers.get(i).getString("ObjectType");
				String objectNo = subledgers.get(i).getString("ObjectNo");
				String oldAccountingOrgID = subledgers.get(i).getString("AccountingOrgID");
				String bookType = subledgers.get(i).getString("BookType");
				String accountCodeNo = subledgers.get(i).getString("AccountCodeNo");
				String currency = subledgers.get(i).getString("Currency");
				double occuramt = subledgers.get(i).getDouble("DebitBalance")-subledgers.get(i).getDouble("CreditBalance");
				
				double exchangeRate=0d,baseCurrencyAmount=0d;
				String baseCurrency="";
				if(!bookType.equals(AccountCodeConfig.accountcode_type_s)){
					ASValuePool accountCodeDefinition=(ASValuePool) AccountCodeConfig.getAccountCodeDefinition(bookType, accountCodeNo);
					//���ұ���
					baseCurrency =  accountCodeDefinition.getString("BaseCurrency");
					if(baseCurrency==null||baseCurrency.length()==0){
						throw new Exception("��Ŀ{"+accountCodeNo+"}δ���屾�ұ��֣�");
					}
					//ȡ���׷���ʱ��ʵʱ����\ȡ���һ�ν��׻��� ��Ŀ��������ѡ��
					//exchangeRate = RateConfig.getExchangeRate(currency, baseCurrency);
					exchangeRate = subledgers.get(i).getDouble("ExchangeRate");
					//�۱��ҽ��
					baseCurrencyAmount =occuramt*exchangeRate;
				}
				
				//�����ϻ��������˷�¼
				BusinessObject subDetail = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.subledger_detail,boManager);
				subDetail.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));//���ý��ױ��
				subDetail.setAttributeValue("SubLedgerSerialNo", subLedgerSerialNo);//���÷ֻ�����ˮ��
				subDetail.setAttributeValue("ExchangeRate",exchangeRate);
				subDetail.setAttributeValue("BookType",bookType);
				subDetail.setAttributeValue("BaseCurrency",baseCurrency);
				subDetail.setAttributeValue("ObjectType",objectType);
				subDetail.setAttributeValue("ObjectNo",objectNo);
				subDetail.setAttributeValue("AccountCodeNo",accountCodeNo);
				subDetail.setAttributeValue("Reference",transaction.getString("TransCode"));
				subDetail.setAttributeValue("SortNo",String.valueOf(i+1));
				subDetail.setAttributeValue("Currency",currency);
				subDetail.setAttributeValue("AccountingOrgID",oldAccountingOrgID);
				subDetail.setAttributeValue("DebitAmt",-subledgers.get(i).getDouble("DebitBalance"));
				subDetail.setAttributeValue("CreditAmt",-subledgers.get(i).getDouble("CreditBalance"));
				subDetail.setAttributeValue("ODebitBalance",subledgers.get(i).getDouble("DebitBalance"));//��¼�仯ǰ�����
				subDetail.setAttributeValue("DebitBalance",0.0d);//��¼�仯ǰ�����
				subDetail.setAttributeValue("OCreditBalance",subledgers.get(i).getDouble("CreditBalance"));//��¼�仯ǰ�����
				subDetail.setAttributeValue("CreditBalance",0.0d);//��¼�仯������
				subDetail.setAttributeValue("BaseCurrencyAmount",Arith.round(-baseCurrencyAmount,2));
				subDetail.setAttributeValue("Description", "��������");
				subDetail.setAttributeValue("LDStatus","1");
				subDetail.setAttributeValue("OccurDate",transaction.getString("TransDate"));
				subDetail.setAttributeValue("OccurTime",DateFunctions.getDateTime(new java.util.Date(),"HH:mm:ss"));
				detailList.add(subDetail);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,subDetail);
				
				//�����»��������˷�¼
				BusinessObject newSubDetail = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.subledger_detail,boManager);
				newSubDetail.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));//���ý��ױ��
				newSubDetail.setAttributeValue("SubLedgerSerialNo", subLedgerSerialNo);//���÷ֻ�����ˮ��
				newSubDetail.setAttributeValue("ExchangeRate",exchangeRate);
				newSubDetail.setAttributeValue("BookType",bookType);
				newSubDetail.setAttributeValue("BaseCurrency",baseCurrency);
				newSubDetail.setAttributeValue("ObjectType",objectType);
				newSubDetail.setAttributeValue("ObjectNo",objectNo);
				newSubDetail.setAttributeValue("AccountCodeNo",accountCodeNo);
				newSubDetail.setAttributeValue("Reference",transaction.getString("TransCode"));
				newSubDetail.setAttributeValue("SortNo",String.valueOf(i+1));
				newSubDetail.setAttributeValue("Currency",currency);
				newSubDetail.setAttributeValue("AccountingOrgID",newAccountingOrgID);
				newSubDetail.setAttributeValue("DebitAmt",subledgers.get(i).getDouble("DebitBalance"));
				newSubDetail.setAttributeValue("CreditAmt",subledgers.get(i).getDouble("CreditBalance"));
				newSubDetail.setAttributeValue("ODebitBalance",0.0d);//��¼�仯ǰ�����
				newSubDetail.setAttributeValue("DebitBalance",subledgers.get(i).getDouble("DebitBalance"));//��¼�仯ǰ�����
				newSubDetail.setAttributeValue("OCreditBalance",0.0d);//��¼�仯ǰ�����
				newSubDetail.setAttributeValue("CreditBalance",subledgers.get(i).getDouble("CreditBalance"));//��¼�仯������
				newSubDetail.setAttributeValue("BaseCurrencyAmount",Arith.round(baseCurrencyAmount,2));
				newSubDetail.setAttributeValue("Description", "��������");
				newSubDetail.setAttributeValue("LDStatus","1");
				newSubDetail.setAttributeValue("OccurDate",transaction.getString("TransDate"));
				newSubDetail.setAttributeValue("OccurTime",DateFunctions.getDateTime(new java.util.Date(),"HH:mm:ss"));
				detailList.add(newSubDetail);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,newSubDetail);
				
				//���·ֻ�����Ϣ�����
				subledgers.get(i).setAttributeValue("AccountingOrgID", newAccountingOrgID);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,subledgers.get(i));
			}
		}
		//���������Ϣ
		checkbalance(detailList);
		
		//���Ĺ������û�����Ϣ
		List<BusinessObject> feeList = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.fee);
		if(feeList != null){
			for(BusinessObject fee:feeList){
				fee.setAttributeValue("AccountingOrgID", newAccountingOrgID);
				boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,fee);	
			}
		}
		
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);	
		return 1;
	}

}