package com.amarsoft.app.check;

import com.amarsoft.amarscript.ASMethod;
import com.amarsoft.amarscript.Any;
import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * <p>
 * 自动风险探测中申请检查支付总金额与放贷金额是否相等
 * </p>
 * @author smiao,2011.06.08
 *
 */
public class PaymentSumCheck extends AlarmBiz{
	
	public Object run(Transaction Sqlca) throws Exception{
		
		//自动获得传入的参数值
		String sSerialNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sBusinessSum = (String)this.getAttribute("BusinessSum");//放贷金额
		String sBusinessCurrency = (String)this.getAttribute("BusinessCurrency");//放贷币种	

		String sSql = "";
		double dExchangeValue = 0.0 ;
		double dBusinessSum = 0.0;
		
		//获取放贷金额对应币种的汇率		
		sSql = "select ExchangeValue from ERATE_INFO where Currency = :Currency ";
		ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("Currency", sBusinessCurrency));
		
		if(rs.next()){
			dExchangeValue = rs.getDouble("ExchangeValue");
		}
		rs.getStatement().close();	
		
		dBusinessSum = Double.parseDouble(sBusinessSum);
		dBusinessSum = dBusinessSum*dExchangeValue;//转化为人民币的放贷金额

		ASMethod asm = new ASMethod("BusinessManage","GetPaymentAmount",Sqlca);//调用方法获取支付总金额
			
		Any anyValue  = asm.execute(sSerialNo+","+sObjectType);
		
		String newPhaseNo = anyValue.toStringValue();
		
		double paymentsum =  Double.parseDouble(newPhaseNo);//支付总金额		
		
		if(paymentsum == dBusinessSum){
			putMsg("支付总金额与放贷金额相等");
			setPass(true);
		}else{
			putMsg("支付总额应与放贷金额相等");
			setPass(false);
		}
		return "success";
	}
}
