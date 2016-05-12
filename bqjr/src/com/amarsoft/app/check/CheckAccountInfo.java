package com.amarsoft.app.check;


import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;

public class CheckAccountInfo extends AlarmBiz {

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		
	   //获取参数
		String objectNo=(String)this.getAttribute("ObjectNo");
		String objectType=(String)this.getAttribute("ObjectType");
		if(objectNo==null||objectNo.length()==0) throw new Exception("传入参数错误，不能为空！参数：ObjectNo:{"+objectNo+"}");
		if(objectType==null||objectType.length()==0) throw new Exception("传入参数错误，不能为空！参数：ObjectType:{"+objectType+"}");
		boolean sOutComeCount = false;
		boolean sReapyPayCount = false;
		AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectNo", objectNo);
		as.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
		List<BusinessObject> sPutOutAccountInfo =  bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.loan_accounts, "ObjectNo=:ObjectNo and ObjectType=:ObjectType", as);
		if(sPutOutAccountInfo==null||sPutOutAccountInfo.isEmpty()){
			this.putMsg("账户信息- 放款帐号未填写");
			this.putMsg("账户信息- 还款帐号未填写");
    	}else
    	{
    		for(int j=0;j<sPutOutAccountInfo.size();j++){
				BusinessObject loan_accounts = (BusinessObject) sPutOutAccountInfo.get(j);
				String sAccountIndicator = loan_accounts.getString("AccountIndicator");
				if("00".equals(sAccountIndicator))sOutComeCount = true;
				if("01".equals(sAccountIndicator))sReapyPayCount = true;
			}
    	}
		
		if(!sOutComeCount)this.putMsg("账户信息- 放款帐号未填写");
		if(!sReapyPayCount)this.putMsg("账户信息- 还款帐号未填写");
		
		/** 返回结果处理 **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}

}
