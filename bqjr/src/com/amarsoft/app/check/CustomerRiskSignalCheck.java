package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 预警客户检查
 * @author syang
 * @since 2009/09/15
 */
public class CustomerRiskSignalCheck extends AlarmBiz {
	
	/** 成员变量定义 **/
	String sCount="";

	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		
		/** 变量定义 **/
		
		
		/** 程序体 **/
		//检查该客户是否存在已生效的预警信息
		String sSql = " select count(RS1.SerialNo) from RISK_SIGNAL RS1  "+
					  " where RS1.SerialNo not in (select distinct RS2.RelativeSerialNo "+
					  " from RISK_SIGNAL RS2 "+
					  " where RS2.SignalType='02' "+
					  " and RS2.SignalStatus='30') "+
					  " and RS1.ObjectType = 'Customer' "+
					  " and RS1.ObjectNo =:ObjectNo "+
					  " and SignalType = '01' "+
					  " and RS1.SignalStatus='30' ";
		  SqlObject so = new SqlObject(sSql);
		  so.setParameter("ObjectNo", sCustomerID);
          sCount = Sqlca.getString(so);
		
		if( sCount != null && Integer.parseInt(sCount,10) > 0  ){
			putMsg( "存在生效的预警信号");
		}
		
		/** 返回结果处理 **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
