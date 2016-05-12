package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * 客户在途业务查询，<br/>
 * 项目实际过程中可以根据自己的情况作实际修改<br/>
 * 目前只对申请作检查，如果客户关联的全部申请均已签批复，则认为该客户无在途业务了<br/>
 * @author syang 2009/11/06
 *
 */
public class CustomerUnFinishedBiz extends Bizlet {

	/**
	 * 客户ID
	 */
	private String sCustomerID = "";
	private Transaction Sqlca = null;
	
	/**
	 * @return 
	 * 0 未结清的业务笔数为0(通过)<br/>
	 * 1 有在途申请<br/>
	 * 2 在未审批通过的最终审批意见<br/>
	 * 3 有未登记完成的合同<br/>
	 */
	public Object run(Transaction Sqlca) throws Exception{
		/*
		 * 获取参数
		 */
		this.sCustomerID = (String)this.getAttribute("CustomerID");
		this.Sqlca = Sqlca;
		
		/*
		 * 变量定义
		 */
		String sReturn = "0";
		
		if(businessApplyCount() > 0){
			sReturn = "1";
			return sReturn;
		}
		if(businessApproveCount() > 0){
			sReturn = "2";
			return sReturn;
		}
		if(businessContractCount() > 0){
			sReturn = "3";
			return sReturn;
		}
		if(evaluateCount() > 0){
			sReturn = "4";
			return sReturn;
		}
		return sReturn;
	}
	
	/**
	 * 客户在途申请统计
	 * @return
	 * 返回在途申请笔数
	 * @throws Exception 
	 */
	private int businessApplyCount() throws Exception{
		int iResult = 0;
		//统计业务未签批复的数量
		String sSql = " select count(SerialNo) from BUSINESS_APPLY where CustomerID =:CustomerID and Flag5 <> '020'";
		SqlObject so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
		String sCount = Sqlca.getString(so);
		if(sCount == null) sCount = "0";
		iResult = Integer.parseInt(sCount);
		return iResult;
	}
	
	/**
	 * 客户未审批完成的批复统计
	 * @return　未审批完成的批复
	 * @throws Exception 
	 */
	private int businessApproveCount() throws Exception{
		int iResult = 0;
		return iResult;
	}
	
	/**
	 * 未终结的合同检查
	 * @return　未终止的合同数量select count(*) FROM evaluate_record e,flow_object f where e.serialno=f.objectno and e.objectno='2009120100000198' and phaseno <>'1000' and flowno='EvaluateFlow'
	 * @throws Exception 
	 */
	private int businessContractCount() throws Exception{
		int iResult = 0;
		return iResult;
	}
	
	/**
	 * 检查客户在途的信用等级评估申请数量
	 * @return
	 * @throws Exception
	 */
	private int evaluateCount() throws Exception{
		int iResult = 0;
		
		
		SqlObject so = new SqlObject("select count(*) from EVALUATE_RECORD E,FLOW_OBJECT F where E.SerialNo = F.ObjectNo and E.ObjectNo =:ObjectNo  and F.FlowNo = 'EvaluateFlow' and F.PhaseNo <> '1000' ");
		so.setParameter("ObjectNo", sCustomerID);
		String sCount = Sqlca.getString(so);
		if(sCount == null) sCount = "0";
		iResult = Integer.parseInt(sCount);
		return iResult;
	}
}
