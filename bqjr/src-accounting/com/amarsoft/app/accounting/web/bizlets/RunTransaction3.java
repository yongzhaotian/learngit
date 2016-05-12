package com.amarsoft.app.accounting.web.bizlets;
/**
 * 2011-04-16
 * xjzhao 
 * ���ݽ������͵��ý��ף��˷�����ͬʱ����һ���µĽ��׼�¼
 */

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class RunTransaction3 extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		try
		{
			String objectType = (String)this.getAttribute("ObjectType");//��������
			String objectNo = (String)this.getAttribute("ObjectNo");//���ݱ��
			String userID = (String)this.getAttribute("UserID");//�����û�
			String transactionTermID = (String)this.getAttribute("TransactionTermID");//����������
			String transactionDate = (String)this.getAttribute("TransactionDate");//��������
			String relativeObjectType = (String)this.getAttribute("RelativeObjectType");//������������
			String relativeObjectNo = (String)this.getAttribute("RelativeObjectNo");//�����������
			String productID = (String)this.getAttribute("ProductID");//
			String productVersion = (String)this.getAttribute("ProductVersion");//
			if(transactionDate==null)
			{
				transactionDate = SystemConfig.getBusinessDate();
			}
			if(productVersion==null||productVersion.length()==0) productVersion=ProductConfig.getProductNewestVersionID(productID);
			
			String transactionCode = ProductConfig.getProductTermParameterAttribute(productID, productVersion, transactionTermID, "TransactionCode", "DefaultValue");
			if(transactionCode==null||transactionCode.length()==0) 
				throw new Exception("�ò�Ʒ��"+productID+"-"+productVersion+"��δ���ý��������"+transactionTermID+"���Ĳ�����TransactionCode����Ĭ��ֵ����ȷ�ϸ���ҵ���Ƿ��ʹ�ô˹��ܣ�");
			
			BusinessObject documentObject = bom.loadObjectWithKey(objectType, objectNo);
			BusinessObject relativeObject =null;
			if(relativeObjectType!=null &&!"".equals(relativeObjectType) && relativeObjectNo!=null &&!"".equals(relativeObjectNo) )
				relativeObject = bom.loadObjectWithKey(relativeObjectType, relativeObjectNo);
			if(relativeObject==null) relativeObject = documentObject;
			//���ع�������
			ASValuePool as =  new ASValuePool();
			as.setAttribute("DocumentType", objectType);
			as.setAttribute("DocumentSerialNo", objectNo);
			as.setAttribute("TransDate", transactionDate);
			List<BusinessObject> transactionList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.transaction, "DocumentType=:DocumentType and DocumentSerialNo=:DocumentSerialNo", as);
			BusinessObject transaction = null;
			if(transactionList == null || transactionList.isEmpty()){
				transaction = TransactionFunctions.createTransaction(transactionCode, documentObject, relativeObject, userID, transactionDate, bom);
				bom.updateDB();
				bom.commit();
			}
			else{
				transaction = transactionList.get(0);
			}
			transaction = TransactionFunctions.loadTransaction(transaction, bom);
			TransactionFunctions.runTransaction(transaction, bom);
			bom.updateDB();//�ȸ������ݿ⣬�������ʧ����ع�


			//int i=TransactionFunctions.runOnlineTransaction(transaction, bom);
			int i = 1;
			if(i==1){
				bom.updateDB();
				bom.commit();
				return "true@���׳ɹ�";
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
