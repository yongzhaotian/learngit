package com.amarsoft.app.accounting.web;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 反冲授信承诺
 * @author xuzhiming 2012/12/27
 * 
 */
public class StrikeCommitmentScript extends Bizlet {
	/**
	 * 授信承诺记账
	 * @throws Exception
	 */
	public Object run(Transaction Sqlca) throws Exception {
		String bcSerialNo = (String)this.getAttribute("BCSerialNo");
		if(bcSerialNo == null || "".equals(bcSerialNo))
		{
			throw new Exception("合同编号为空！");
		}
		String userID = (String)this.getAttribute("UserID");
		if(userID == null)
		{
			userID = "system";
		}
		AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
		
		String sql = "select '1' as StrikeFlag, bc.* from Business_Contract bc where SerialNo in " +
				"(" +
					"select asl.ObjectNo from Acct_Subsidiary_Ledger asl " +
					"where 1=1 " +
					"and asl.ObjectType = :ObjectType " +
					"and asl.ObjectNo = :ObjectNo " +
					"and asl.AccountCodeNo = :AccountCodeNo " +
					"and asl.DebitBalance > asl.CreditBalance " +
				")";
		ASValuePool as = new ASValuePool();
		as.setAttribute("ObjectType", "BusinessContract");
		as.setAttribute("ObjectNo", bcSerialNo);
		as.setAttribute("AccountCodeNo", "6000101");
		List<BusinessObject> bcList = bom.loadBusinessObjects(BUSINESSOBJECT_CONSTATNTS.business_contract,sql,as);
		if(bcList != null && !bcList.isEmpty()){
			BusinessObject businesscontract = bcList.get(0);
			BusinessObject transaction = TransactionFunctions.createTransaction("0010", null, businesscontract, userID, SystemConfig.getBusinessDate(), bom);

			transaction = TransactionFunctions.loadTransaction(transaction, bom);
			TransactionFunctions.runTransaction(transaction, bom);
			bom.updateDB();//先更新数据库，如果交易失败则回滚
		}
		return "true";
	}
	
	public Object execute(String bcSerialNo,String userID,Transaction Sqlca) throws Exception{
		StrikeCommitmentScript scs = new StrikeCommitmentScript();
		scs.setAttribute("BCSerialNo", bcSerialNo);
		scs.setAttribute("UserID", userID);
		return scs.run(Sqlca);
	}
}
