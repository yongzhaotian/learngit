package com.amarsoft.app.accounting.web.bizlets;
/**
 * 2011-04-16
 * xjzhao 
 * ���ݽ�����ˮ�ŵ��ý���
 */

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;



public class RunTransaction2 extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String messageError = "";
		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		try{
			
			String transactionSerialNo = (String)this.getAttribute("TransactionSerialNo");//������ˮ��
			String userID  = (String)this.getAttribute("UserID");//�û����
			String flag = (String)this.getAttribute("Flag");//�Ƿ�ǿ��ִ�� Y N
			if(transactionSerialNo == null) transactionSerialNo = "";
			if(userID == null) userID = "";
			if(flag == null) flag = "";
			
			//�����ñʽ��ף���ֹ�ظ����
			SqlObject sqlo = new SqlObject(" update ACCT_TRANSACTION set TransStatus='1' where TransStatus = '0' and SerialNo = :SerialNo");
			sqlo.setParameter("SerialNo", transactionSerialNo);
			int iupdate = Sqlca.executeSQL(sqlo);
			if(iupdate == 0) messageError = "false@ϵͳ���ڴ��������ظ������";
			
			//��ʼ���״���
			BusinessObject transaction = TransactionFunctions.loadTransaction(transactionSerialNo, bom);
			transaction.setAttributeValue("TransDate",SystemConfig.getBusinessDate());//���ý���ʵ��ִ������
			if(!"0".equals(transaction.getString("TransStatus"))){
				messageError = "false@����ԭ�򣺽���״̬��������ȷ���Ƿ��Ѽ��ˣ�";
			}
			//�����Ч����С�ڵ�ǰϵͳӪҵʱ�䣬��ֹ����ִ��
			if(!"".equals(transaction.getString("TransDate")) && transaction.getString("TransDate").compareTo(SystemConfig.getBusinessDate())>0 && "N".equals(flag))
			{
				ARE.getLog().info("���ס�"+transaction.getObjectNo()+"���Ѿ�ԤԼ����"+transaction.getString("TransDate")+"��");
				transaction.setAttributeValue("TransStatus", "3");
				bom.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, transaction);
				bom.updateDB();
				bom.commit();
				messageError = "true@���׳ɹ�";
			}
			else
			{
				TransactionFunctions.runTransaction(transaction, bom);
				bom.updateDB();//�ȸ������ݿ⣬�������ʧ����ع�

				int i=TransactionFunctions.runOnlineTransaction(transaction, bom);
				if(i==1){
					bom.updateDB();
					bom.commit();
					messageError = "true@���׳ɹ�";
				}
				else{
					bom.rollback();
					List<String> a = TransactionFunctions.getErrorMessage(transaction, "");
					messageError = a.toString();
					return "false@����ԭ��"+messageError;
				}
			}
			return messageError;
		}catch(Exception e)
		{
			bom.rollback();
			ARE.getLog().error("ϵͳ����", e);
			e.printStackTrace();
			messageError =  "false@����ԭ��"+e.getMessage();
			//throw e;
			return messageError;
		}
	}
}
