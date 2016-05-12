package com.amarsoft.app.accounting.web.bizlets;
/**
 * 2011-04-16
 * xjzhao 
 * 根据交易流水号调用交易
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
			
			String transactionSerialNo = (String)this.getAttribute("TransactionSerialNo");//交易流水号
			String userID  = (String)this.getAttribute("UserID");//用户编号
			String flag = (String)this.getAttribute("Flag");//是否强制执行 Y N
			if(transactionSerialNo == null) transactionSerialNo = "";
			if(userID == null) userID = "";
			if(flag == null) flag = "";
			
			//锁定该笔交易，防止重复点击
			SqlObject sqlo = new SqlObject(" update ACCT_TRANSACTION set TransStatus='1' where TransStatus = '0' and SerialNo = :SerialNo");
			sqlo.setParameter("SerialNo", transactionSerialNo);
			int iupdate = Sqlca.executeSQL(sqlo);
			if(iupdate == 0) messageError = "false@系统正在处理，请勿重复点击！";
			
			//开始交易处理
			BusinessObject transaction = TransactionFunctions.loadTransaction(transactionSerialNo, bom);
			transaction.setAttributeValue("TransDate",SystemConfig.getBusinessDate());//设置交易实际执行日期
			if(!"0".equals(transaction.getString("TransStatus"))){
				messageError = "false@错误原因：交易状态不正常，确认是否已记账！";
			}
			//如果生效日期小于当前系统营业时间，阻止交易执行
			if(!"".equals(transaction.getString("TransDate")) && transaction.getString("TransDate").compareTo(SystemConfig.getBusinessDate())>0 && "N".equals(flag))
			{
				ARE.getLog().info("交易【"+transaction.getObjectNo()+"】已经预约到【"+transaction.getString("TransDate")+"】");
				transaction.setAttributeValue("TransStatus", "3");
				bom.setBusinessObject(AbstractBusinessObjectManager.operateflag_update, transaction);
				bom.updateDB();
				bom.commit();
				messageError = "true@交易成功";
			}
			else
			{
				TransactionFunctions.runTransaction(transaction, bom);
				bom.updateDB();//先更新数据库，如果交易失败则回滚

				int i=TransactionFunctions.runOnlineTransaction(transaction, bom);
				if(i==1){
					bom.updateDB();
					bom.commit();
					messageError = "true@交易成功";
				}
				else{
					bom.rollback();
					List<String> a = TransactionFunctions.getErrorMessage(transaction, "");
					messageError = a.toString();
					return "false@错误原因："+messageError;
				}
			}
			return messageError;
		}catch(Exception e)
		{
			bom.rollback();
			ARE.getLog().error("系统出错", e);
			e.printStackTrace();
			messageError =  "false@错误原因："+e.getMessage();
			//throw e;
			return messageError;
		}
	}
}
