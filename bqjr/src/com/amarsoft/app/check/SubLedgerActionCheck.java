package com.amarsoft.app.check;


import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.Transaction;


/**
 * �������������ף�¼��������Ϣ�Ƿ�ƽ��
 * @author xjzhao
 */

public class SubLedgerActionCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		String sTransSerialNo = (String)this.getAttribute("ObjectNo");
		if(sTransSerialNo == null) sTransSerialNo = "";
		
		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		try
		{
			BusinessObject transaction = TransactionFunctions.loadTransaction(sTransSerialNo, bom);
			TransactionFunctions.runTransaction(transaction, bom);
			setPass(true);
		}catch(Exception ex)
		{
			ex.printStackTrace();
			this.putMsg(ex.getMessage());
			setPass(false);
		}
		
		return null;
	}

}
