package com.amarsoft.app.accounting.web.bizlets;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * <p>
 * 获取Transaction对应的对象类型以及权限
 * </p>
 * @author smiao 2011.06.08
 *
 */

public class GetTransactionRela extends Bizlet {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		//自动获得传入的参数值
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sType = (String)this.getAttribute("Type");
		
		AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
		BusinessObject bo =bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.transaction, sSerialNo);
		String sRelativeObjectType = bo.getString("RelativeObjectType");
		String sRelativeObjectNo = bo.getString("RelativeObjectNo");
		if(sRelativeObjectType.equals(BUSINESSOBJECT_CONSTATNTS.fee))
		{
			if(BUSINESSOBJECT_CONSTATNTS.fee.equals(sType))
				return sRelativeObjectNo;
			else if(BUSINESSOBJECT_CONSTATNTS.loan.equals(sType))
			{
				BusinessObject bofee = bom.loadObjectWithKey(sRelativeObjectType, sRelativeObjectNo);
				if(bofee.getString("ObjectType").equals(BUSINESSOBJECT_CONSTATNTS.loan))
					return bofee.getString("ObjectNo");
				else
					return "";
			}
			else if(BUSINESSOBJECT_CONSTATNTS.business_contract.equals(sType))
			{
				BusinessObject bofee = bom.loadObjectWithKey(sRelativeObjectType, sRelativeObjectNo);
				if(bofee.getString("ObjectType").equals(BUSINESSOBJECT_CONSTATNTS.business_contract))
					return bofee.getString("ObjectNo");
				else if(bofee.getString("ObjectType").equals(BUSINESSOBJECT_CONSTATNTS.loan))
				{
					BusinessObject boLoan = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.loan, bofee.getString("ObjectNo"));
					return boLoan.getString("ContractSerialNo");
				}
				else
					return "";
			}
			else if(BUSINESSOBJECT_CONSTATNTS.transaction.equals(sType))
			{
				return bo.getString("StrikeSerialNo");
			}
			else
				return "";
		}
		else if(sRelativeObjectType.equals(BUSINESSOBJECT_CONSTATNTS.loan))
		{
			if(BUSINESSOBJECT_CONSTATNTS.loan.equals(sType))
				return sRelativeObjectNo;
			else if(BUSINESSOBJECT_CONSTATNTS.business_contract.equals(sType))
			{
				BusinessObject boLoan = bom.loadObjectWithKey(sRelativeObjectType, sRelativeObjectNo);
				return boLoan.getString("ContractSerialNo");
			}
			else if(BUSINESSOBJECT_CONSTATNTS.transaction.equals(sType))
			{
				return bo.getString("StrikeSerialNo");
			}
			else return "";
		}
		else if(sRelativeObjectType.equals(BUSINESSOBJECT_CONSTATNTS.business_contract))
		{
			if(BUSINESSOBJECT_CONSTATNTS.business_contract.equals(sType))
			{
				return sRelativeObjectNo;
			}
			else if(BUSINESSOBJECT_CONSTATNTS.transaction.equals(sType))
			{
				return bo.getString("StrikeSerialNo");
			}
			else
				return "";
		}
		return "";
	}

}
