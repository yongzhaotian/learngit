package com.amarsoft.app.accounting.web.bizlets;
/**
 * 2011-04-16
 * ygwang
 * ���ý������
 */

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.util.FeeFunctions;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CalFeeAmount extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		try{
			String feeSerialNo = (String)this.getAttribute("FeeSerialNo");
			AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
			BusinessObject fee = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.fee, feeSerialNo);
			if(fee==null){
				throw new Exception("δ�ҵ����ü�¼{"+feeSerialNo+"}");
			}
			BusinessObject businessObject = bom.loadObjectWithKey(fee.getString("ObjectType"), fee.getString("ObjectNo"));
			fee.setRelativeObject(businessObject);
			return DataConvert.toMoney(FeeFunctions.calFeeAmount(fee,businessObject, bom));
		}
		catch(Exception e){
			ARE.getLog().error("ϵͳ����", e);
			throw e;
		}
	}
}
