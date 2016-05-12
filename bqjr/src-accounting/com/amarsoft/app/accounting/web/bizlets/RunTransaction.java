package com.amarsoft.app.accounting.web.bizlets;
/**
 * 2011-04-16
 * xjzhao 
 * ���ݵ�����Ϣ���ý��ף��˷�����ͬʱ����һ���µĽ��׼�¼
 */

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class RunTransaction extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		try
		{
			String objectType = (String)this.getAttribute("ObjectType");//��������
			String objectNo = (String)this.getAttribute("ObjectNo");//���ݱ��
			String userID = (String)this.getAttribute("UserID");//�����û�
			String transactionCode = (String)this.getAttribute("TransactionCode");//���״���
			String transactionDate = (String)this.getAttribute("TransactionDate");//��������
			String relativeObjectType = (String)this.getAttribute("RelativeObjectType");//������������
			String relativeObjectNo = (String)this.getAttribute("RelativeObjectNo");//�����������
			
			BusinessObject documentObject = bom.loadObjectWithKey(objectType, objectNo);
			
			BusinessObject relativeObject =null;
			if(relativeObjectType!=null &&!"".equals(relativeObjectType) && relativeObjectNo!=null &&!"".equals(relativeObjectNo) )
				relativeObject = bom.loadObjectWithKey(relativeObjectType, relativeObjectNo);
			if(relativeObject==null) relativeObject = documentObject;
			BusinessObject transaction = TransactionFunctions.createTransaction(transactionCode, documentObject, relativeObject, userID, transactionDate, bom);

			transaction = TransactionFunctions.loadTransaction(transaction, bom);
			TransactionFunctions.runTransaction(transaction, bom);
			bom.updateDB();//�ȸ������ݿ⣬�������ʧ����ع�

			int i=TransactionFunctions.runOnlineTransaction(transaction, bom);
			if(i==1){
				bom.commit();
				return "true";
			}
			else{
				bom.rollback();
				List<String> a = TransactionFunctions.getErrorMessage(transaction, "");
				String messageError = a.toString();
				return "false@����ԭ��"+messageError;
			}
			
			
		}catch(Exception e)
		{
			bom.rollback();
			e.printStackTrace();
			ARE.getLog().debug("ϵͳ����", e);
			return "false@"+e.getMessage();
		}
	}
}
