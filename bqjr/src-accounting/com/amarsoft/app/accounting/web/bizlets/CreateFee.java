package com.amarsoft.app.accounting.web.bizlets;
/**
 * ygwang
 * ����һ������
 */

import com.amarsoft.app.accounting.util.FeeFunctions;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;

public class CreateFee extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String objectType = (String)this.getAttribute("ObjectType");//��������
		String objectNo = (String)this.getAttribute("ObjectNo");//���ݱ��
		String userID = (String)this.getAttribute("UserID");//�����û�
		String feeTermID = (String)this.getAttribute("FeeTermID");//���״���
		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		
		BusinessObject relativeObject=null;
		if(objectNo.length()>0&&objectType.length()>0){
			relativeObject = bom.loadObjectWithKey(objectType, objectNo);
			if(relativeObject==null) throw new Exception("δ�ҵ�����{"+objectType+"-"+objectNo+"}");
		}
		else{
			 throw new Exception("δ����������ͺͶ�����!");
		}
		BusinessObject fee = FeeFunctions.createFee(feeTermID, relativeObject,bom);
		bom.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, fee);
		bom.updateDB();
		return fee.getString("SerialNo");
	}
}
