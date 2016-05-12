package com.amarsoft.app.accounting.trans.script.loan.manualbook;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.amarscript.Expression;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.AccountCodeConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.RateConfig;
import com.amarsoft.app.accounting.config.loader.TransactionConfig;
import com.amarsoft.app.accounting.exception.LoanException;
import com.amarsoft.app.accounting.trans.ITransactionScript;
import com.amarsoft.app.accounting.trans.script.common.executor.BookKeepExecutor;
import com.amarsoft.app.accounting.util.ExtendedFunctions;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;

/**
 * ��Ŀ�����������������֣���Ŀ�˵��������п�Ŀ�ı��
 * ��������������
 * @author xjzhao
 */
public class AccountCodeChangeExecutor extends BookKeepExecutor{
	
	private ArrayList<BusinessObject> detailList = new ArrayList<BusinessObject>();

	/**
	 * �������ݴ���
	 */
	public int execute(String scriptID,ITransactionScript transactionScript) throws LoanException, Exception {
		BusinessObject transaction = transactionScript.getTransaction();
		AbstractBusinessObjectManager boManager = transactionScript.getBOManager();
		
		BusinessObject loanChange = transaction.getRelativeObject(transaction.getString("DocumentType"), transaction.getString("DocumentSerialNo"));
		BusinessObject loan = transaction.getRelativeObject(transaction.getString("RelativeObjectType"), transaction.getString("RelativeObjectNo"));
		BusinessObject oldLoan = loan.cloneObject();
		
		ASValuePool as = new ASValuePool();
		as.setAttribute("BookType", AccountCodeConfig.accountcode_type_b);
		List<BusinessObject> subsidiaryLedger = loan.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subsidiary_ledger, as);
		
		//��������
		int i = 1;
		
		//1���������п�Ŀ�ı��
		//1.1�������������Ϣ���
		String changeFields = TransactionConfig.getTransactionDef(transaction.getString("TransCode"), "ChangeFields");
		if(changeFields != null && !"".equals(changeFields))
		{
			String[] changeFieldArray = changeFields.split(",");
			for(String changeField:changeFieldArray)
			{
				String field = changeField.split("=")[0];
				String fieldScript = changeField.split("=")[1];
				String fieldValue = Expression.getExpressionValue(ExtendedFunctions.replaceAllIgnoreCase(fieldScript, transaction), boManager.getSqlca()).stringValue();
				if(fieldValue != null && !"".equals(fieldValue))
					loan.setAttributeValue(field, fieldValue);
			}
			
			ASValuePool oldAccountLibrary = AccountCodeConfig.getAccountingCatalog(oldLoan, boManager.getSqlca());
			ASValuePool accountLibrary = AccountCodeConfig.getAccountingCatalog(loan, boManager.getSqlca());
			
			//1.2��Ŀ��Ϣ���
			if(subsidiaryLedger != null && !subsidiaryLedger.isEmpty())
			{
				if(oldAccountLibrary != null && accountLibrary!=null)
				{
					
					for(BusinessObject sl:subsidiaryLedger)
					{
						String oldAccountCodeNo = sl.getString("AccountCodeNo");
						String accountCodeNo = "";
						for(Object key:oldAccountLibrary.getKeys())
						{
							Object o = oldAccountLibrary.getAttribute(String.valueOf(key));
							if(o instanceof BusinessObject)
							{
								BusinessObject oldab = (BusinessObject)oldAccountLibrary.getAttribute(String.valueOf(key));
								if(oldab!=null && oldAccountCodeNo.equals(oldab.getString("SubjectNo")))
								{
									BusinessObject ab = (BusinessObject)accountLibrary.getAttribute(String.valueOf(key));
									if(ab != null)
									{
										accountCodeNo = ab.getString("SubjectNo");
										break;
									}
								}
							}
						}
						
						if(oldAccountCodeNo.equals(accountCodeNo)) continue;
						if(accountCodeNo == null || "".equals(accountCodeNo)) throw new Exception("δ�ҵ�������Ϣ����Ӧ�����п�Ŀ��Ϣ������ϵϵͳ����Ա�������ã�");
						
						String subLedgerSerialNo = sl.getString("SerialNo");
						String objectType = sl.getString("ObjectType");
						String objectNo = sl.getString("ObjectNo");
						String accountingOrgID = sl.getString("AccountingOrgID");
						String bookType = sl.getString("BookType");
						String currency = sl.getString("Currency");
						double occuramt = sl.getDouble("DebitBalance")-sl.getDouble("CreditBalance");
						
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
							exchangeRate = sl.getDouble("ExchangeRate");
							//�۱��ҽ��
							baseCurrencyAmount =occuramt*exchangeRate;
						}
						
						//�����Ͽ�Ŀ�����˷�¼
						BusinessObject subDetail = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.subledger_detail,boManager);
						subDetail.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));//���ý��ױ��
						subDetail.setAttributeValue("SubLedgerSerialNo", subLedgerSerialNo);//���÷ֻ�����ˮ��
						subDetail.setAttributeValue("ExchangeRate",exchangeRate);
						subDetail.setAttributeValue("BookType",bookType);
						subDetail.setAttributeValue("BaseCurrency",baseCurrency);
						subDetail.setAttributeValue("ObjectType",objectType);
						subDetail.setAttributeValue("ObjectNo",objectNo);
						subDetail.setAttributeValue("AccountCodeNo",oldAccountCodeNo);
						subDetail.setAttributeValue("Reference",transaction.getString("TransCode"));
						subDetail.setAttributeValue("SortNo",String.valueOf(i++));
						subDetail.setAttributeValue("Currency",currency);
						subDetail.setAttributeValue("AccountingOrgID",accountingOrgID);
						subDetail.setAttributeValue("DebitAmt",-sl.getDouble("DebitBalance"));
						subDetail.setAttributeValue("CreditAmt",-sl.getDouble("CreditBalance"));
						subDetail.setAttributeValue("ODebitBalance",sl.getDouble("DebitBalance"));//��¼�仯ǰ�����
						subDetail.setAttributeValue("DebitBalance",0.0d);//��¼�仯ǰ�����
						subDetail.setAttributeValue("OCreditBalance",sl.getDouble("CreditBalance"));//��¼�仯ǰ�����
						subDetail.setAttributeValue("CreditBalance",0.0d);//��¼�仯������
						subDetail.setAttributeValue("BaseCurrencyAmount",Arith.round(-baseCurrencyAmount,2));
						subDetail.setAttributeValue("Description", "��Ŀ����");
						subDetail.setAttributeValue("LDStatus","1");
						subDetail.setAttributeValue("OccurDate",transaction.getString("TransDate"));
						subDetail.setAttributeValue("OccurTime",DateFunctions.getDateTime(new java.util.Date(),"HH:mm:ss"));
						this.detailList .add(subDetail);
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,subDetail);
						
						//�����¿�Ŀ�����˷�¼
						BusinessObject newsld = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.subledger_detail,boManager);
						newsld.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));//���ý��ױ��
						newsld.setAttributeValue("SubLedgerSerialNo", subLedgerSerialNo);//���÷ֻ�����ˮ��
						newsld.setAttributeValue("ExchangeRate",exchangeRate);
						newsld.setAttributeValue("BookType",bookType);
						newsld.setAttributeValue("BaseCurrency",baseCurrency);
						newsld.setAttributeValue("ObjectType",objectType);
						newsld.setAttributeValue("ObjectNo",objectNo);
						newsld.setAttributeValue("AccountCodeNo",accountCodeNo);
						newsld.setAttributeValue("Reference",transaction.getString("TransCode"));
						newsld.setAttributeValue("SortNo",String.valueOf(i++));
						newsld.setAttributeValue("Currency",currency);
						newsld.setAttributeValue("AccountingOrgID",accountingOrgID);
						newsld.setAttributeValue("DebitAmt",sl.getDouble("DebitBalance"));
						newsld.setAttributeValue("CreditAmt",sl.getDouble("CreditBalance"));
						newsld.setAttributeValue("ODebitBalance",0.0d);//��¼�仯ǰ�����
						newsld.setAttributeValue("DebitBalance",sl.getDouble("DebitBalance"));//��¼�仯ǰ�����
						newsld.setAttributeValue("OCreditBalance",0.0d);//��¼�仯ǰ�����
						newsld.setAttributeValue("CreditBalance",sl.getDouble("CreditBalance"));//��¼�仯������
						newsld.setAttributeValue("BaseCurrencyAmount",Arith.round(baseCurrencyAmount,2));
						newsld.setAttributeValue("Description", "��Ŀ����");
						newsld.setAttributeValue("LDStatus","1");
						newsld.setAttributeValue("OccurDate",transaction.getString("TransDate"));
						newsld.setAttributeValue("OccurTime",DateFunctions.getDateTime(new java.util.Date(),"HH:mm:ss"));
						this.detailList.add(newsld);
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,newsld);
						
						//���·ֻ�����Ϣ���Ŀ��Ϣ
						sl.setAttributeValue("AccountCodeNo", accountCodeNo);
						boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,sl);
					}
				}
				else
					throw new Exception("δ�ҵ�������Ϣ����Ӧ�����񷽰���Ϣ������ϵϵͳ����Ա�������ã�");
			}
		}
		//2�������ֹ�¼���¼
		List<BusinessObject> subLedgerDetails = loanChange.getRelativeObjects(BUSINESSOBJECT_CONSTATNTS.subledger_detail);
		for(BusinessObject subLedgerDetail:subLedgerDetails)
		{
			BusinessObject newsld = new BusinessObject(BUSINESSOBJECT_CONSTATNTS.subledger_detail,boManager);
			newsld.setValue(subLedgerDetail);
			newsld.setAttributeValue("TransSerialNo", transaction.getString("SerialNo"));//���ý��ױ��
			newsld.setAttributeValue("ObjectType",loan.getObjectType());
			newsld.setAttributeValue("ObjectNo",loan.getObjectNo());
			newsld.setAttributeValue("Currency",loan.getString("Currency"));
			newsld.setAttributeValue("AccountingOrgID",loan.getString("AccountingOrgID"));
			newsld.setAttributeValue("SortNo",String.valueOf(i++));
			newsld.setAttributeValue("LDStatus","0");
			newsld.setAttributeValue("OccurDate",transaction.getString("TransDate"));
			newsld.setAttributeValue("OccurTime",DateFunctions.getDateTime(new java.util.Date(),"HH:mm:ss"));
			double occuramt = newsld.getDouble("DebitAmt")-newsld.getDouble("CreditAmt");
			double exchangeRate=0d,baseCurrencyAmount=0d;
			String baseCurrency="";
			if(!newsld.getString("BookType").equals(AccountCodeConfig.accountcode_type_s)){
				ASValuePool accountCodeDefinition=(ASValuePool) AccountCodeConfig.getAccountCodeDefinition(newsld.getString("BookType"), newsld.getString("AccountCodeNo"));
				//���ұ���
				baseCurrency =  accountCodeDefinition.getString("BaseCurrency");
				if(baseCurrency==null||baseCurrency.length()==0){
					throw new Exception("��Ŀ{"+newsld.getString("AccountCodeNo")+"}δ���屾�ұ��֣�");
				}
				//ȡ���׷���ʱ��ʵʱ����
				exchangeRate = RateConfig.getExchangeRate(loan.getString("Currency"), baseCurrency);
				//�۱��ҽ��
				baseCurrencyAmount =occuramt*exchangeRate;
			}
			
			newsld.setAttributeValue("ExchangeRate",exchangeRate);
			newsld.setAttributeValue("BaseCurrency",baseCurrency);
			newsld.setAttributeValue("BaseCurrencyAmount",Arith.round(baseCurrencyAmount,2));
			this.detailList.add(newsld);
			boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_new,newsld);
			
			//������չ����
			if(subsidiaryLedger != null && !subsidiaryLedger.isEmpty() && 
				(AccountCodeConfig.accountcode_type_n.equals(newsld.getString("BookType"))
					|| AccountCodeConfig.accountcode_type_o.equals(newsld.getString("BookType"))))
			{
				this.detailList.add(this.createExLedgerdetail(newsld, AccountCodeConfig.accountcode_type_b));
			}
		}
		boManager.setBusinessObject(AbstractBusinessObjectManager.operateflag_update,loan);
		//���������Ϣ
		checkbalance(detailList);
		//���·ֻ���
		updateLedgerAccount(detailList);
		
		return 1;
	}
}