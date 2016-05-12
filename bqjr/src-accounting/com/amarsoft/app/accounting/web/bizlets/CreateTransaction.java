package com.amarsoft.app.accounting.web.bizlets;
/**
 * ygwang
 * 创建一个交易
 */

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.config.loader.TransactionConfig;
import com.amarsoft.app.accounting.trans.TransactionFunctions;
import com.amarsoft.app.lending.bizlets.InitializeFlow;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class CreateTransaction extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String relativeObjectType = (String)this.getAttribute("RelativeObjectType");//单据类型
		String relativeObjectNo = (String)this.getAttribute("RelativeObjectNo");//单据编号
		String userID = (String)this.getAttribute("UserID");//操作用户
		String objectType = (String) this.getAttribute("ObjectType");
		String transactionCode = (String)this.getAttribute("TransactionCode");//交易代码
		String transactionDate = (String)this.getAttribute("TransactionDate");//交易日期
		String flowFlag = (String)this.getAttribute("FlowFlag");//是否创建流程
		String channel = (String)this.getAttribute("Channel");//交易创建渠道 参见代码TransChannel
		if(channel == null) channel = "01";//如果没有传入值默认信贷系统
		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		
		if(flowFlag==null||flowFlag.length()==0) flowFlag="1";
		
		try
		{
			BusinessObject relativeObject=null;
			if(relativeObjectType.length()>0&&relativeObjectNo.length()>0){
				relativeObject = bom.loadObjectWithKey(relativeObjectType, relativeObjectNo);
				if(relativeObject==null) throw new Exception("未找到对象{"+relativeObjectType+"-"+relativeObjectNo+"}");
			}
			BusinessObject transaction = TransactionFunctions.createTransaction(transactionCode, null, relativeObject, userID, transactionDate, bom);
			transaction.setAttributeValue("Channel", channel);
			bom.updateDB();
			String transactionSerialNo=transaction.getObjectNo();
			
			//创建流程
			ASUser curUser = ASUser.getUser(userID,Sqlca);
			//初始化流程信息
			ASValuePool transactionDef = TransactionConfig.getTransactionDef(transactionCode);
			String flowNo = transactionDef.getString("FlowNo");
			if(flowNo==null||flowNo.length()==0||flowFlag.equals("2")){
				return "true@"+transactionSerialNo;
			}
			else{
				Bizlet bzInitFlow = new InitializeFlow();
				bzInitFlow.setAttribute("ObjectType","TransactionApply"); 
				bzInitFlow.setAttribute("ObjectNo",transactionSerialNo); 
				bzInitFlow.setAttribute("ApplyType",objectType);
				bzInitFlow.setAttribute("FlowNo",flowNo);
				bzInitFlow.setAttribute("PhaseNo",Sqlca.getString(new SqlObject("select initPhase from FLOW_CATALOG where FlowNo = :FlowNo").setParameter("FlowNo", flowNo)));
				bzInitFlow.setAttribute("UserID",curUser.getUserID());
				bzInitFlow.setAttribute("OrgID",curUser.getOrgID());
				bzInitFlow.run(Sqlca);			
				return "true@"+transactionSerialNo;
			}
		}catch(Exception e)
		{
			bom.rollback();
			e.printStackTrace();
			return e.getMessage();
		}
	}
}
