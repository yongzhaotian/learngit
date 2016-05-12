package com.amarsoft.app.lending.bizlets;
/**
 * 自动风险探测账户是否在账户管理已经登记，如果未登记，则在表ACCOUNT_INFO插入一条数据
 * 
 * @author smiao 2011.06.08
 */

import com.amarsoft.amarscript.ASMethod;
import com.amarsoft.amarscript.Any;
import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.bizobject.AccountInfo;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

public class InsertAccount extends AlarmBiz{
	
	public Object  run(Transaction Sqlca) throws Exception{
		
		//自动获得传入的参数值
		String sSerialNo = (String)this.getAttribute("ObjectNo");
		String sUserID = (String)this.getAttribute("UserID");
		
		//定义变量
		ASResultSet rs ;
		String sSql = "";
		String sContractSerialNo = "";//合同号
		String sCustomerID = "";//客户ID
		String sCustomerName = "";//客户名称
		String sRequitalAccount = "";//资金回笼账户
		String sFundBackAccount = "";//还款准备金账户
		String sAccount = "";//账户
		String flagRegister ="";//账户登记标志位
		SqlObject so; //声明对象
		
		//实例化用户对象
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		
		//根据参数获取合同号
		sSql = "select ContractSerialNo from BUSINESS_PUTOUT where SerialNo =:SerialNo";
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
		rs = Sqlca.getResultSet(so);
		if(rs.next()){
			sContractSerialNo = rs.getString("ContractSerialNo");
		}
		rs.getStatement().close();
		//根据合同号获取客户ID,客户名称,资金回笼账户,还款准备金账户
		sSql = "select CustomerID,CustomerName, RequitalAccount,FundBackAccount from BUSINESS_CONTRACT where SerialNo =:SerialNo";
		so = new SqlObject(sSql).setParameter("SerialNo", sContractSerialNo);
		rs = Sqlca.getResultSet(so);
		if(rs.next()){
			sCustomerID = rs.getString("CustomerID");
			sCustomerName = rs.getString("CustomerName");
			sRequitalAccount = rs.getString("RequitalAccount");
			sFundBackAccount = rs.getString("FundBackAccount");
		}
		rs.getStatement().close();
		//判断资金回笼账户和还款准备金账户是否为空
		if(sRequitalAccount == null && sFundBackAccount == null){
			putMsg("还款准备金账户或资金回笼账户信息为空,请填写账户信息");
			setPass(false);
			return "failure";
		}else{			
			ASMethod asm = new ASMethod("BusinessManage","CheckRegister",Sqlca);//调用方法获取是否在账户管理已近登记
			Any anyValue  = asm.execute(sFundBackAccount+","+sRequitalAccount+","+sCustomerID);
			flagRegister = anyValue.toStringValue();
			
				if(flagRegister.equals("true")){
					putMsg("账户信息已经登记");
					setPass(true);
				}else if(flagRegister.equals("false"))
				{
					putMsg("还款准备金账户或资金回笼账户在账户管理还未登记，系统将会自动添加到账户管理");			
					sAccount = sRequitalAccount == null ?sFundBackAccount:sRequitalAccount;		
					//在ACCOUNT_INFO插入一条记录
					sSql = "insert into ACCOUNT_INFO (Account,CustomerID,CustomerName,AccountSource,InputUserID,InputOrgID,InputDate,UpdateUserID,UpdateDate) values" +
							" (:Account,:CustomerID,:CustomerName,:AccountSource,:InputUserID,:InputOrgID,:InputDate,:UpdateUserID,:UpdateDate)";
					so = new SqlObject(sSql);
					so.setParameter("Account", sAccount).setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("AccountSource", AccountInfo.ACCOUNTSOURCE_FROMCONTRACT)
					.setParameter("InputUserID", CurUser.getUserID()).setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputDate", StringFunction.getToday()).setParameter("UpdateUserID", CurUser.getUserID())
					.setParameter("UpdateDate", StringFunction.getToday());
					//执行更新语句
					Sqlca.executeSQL(so);
					setPass(true);
				}
			return "success";
		}
	}
}
