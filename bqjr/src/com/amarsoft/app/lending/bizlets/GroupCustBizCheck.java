package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


/**
 * 集团客户在途业务检查，在集团客户转移管理户权时，需要对集团客户相应业务作检查<br/>
 * 系统中，目前只运行集团客户作额度申请，无其它申请，因此只要检查额度申请就行了<br/>
 * 1.检查是否存在在途申请<br/>
 * 2.检查是否存在未审批通过的最终审批意见<br/>
 * 3.如果已登记了合同，检查合同是否“登记完成”<br/>
 * @author syang 2009/11/04
 *
 */
public class GroupCustBizCheck extends Bizlet {

	/**
	 * 集团客户ID
	 */
	private String sCustomerID = "";
	private Transaction Sqlca = null;
	SqlObject so=null;//声明对象
	/**
	 * @return 
	 * 0 未结清的业务笔数为0(通过)<br/>
	 * 1 有在途额度申请<br/>
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
		//如果有业务申请未归档，则认为是未结清
		String sSql = " select count(SerialNo) from BUSINESS_APPLY where CustomerID =:CustomerID and PigeonholeDate is null ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
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
		//如果有批复未归档，则认为是未结清
		String sSql = " select count(*) from BUSINESS_APPROVE where CustomerID =:CustomerID and PigeonholeDate is null ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
		String sCount = Sqlca.getString(so);
		if(sCount == null) sCount = "0";
		iResult = Integer.parseInt(sCount);
		return iResult;
	}
	
	/**
	 * 集团客户未“登记完成”的合同统计
	 * @return　“登记完成”的合同数量
	 * @throws Exception 
	 */
	private int businessContractCount() throws Exception{
		int iResult = 0;
		String sSql = " select count(*) from BUSINESS_CONTRACT where CustomerID =:CustomerID and FinishDate is null ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
		String sCount = Sqlca.getString(so);
		if(sCount == null) sCount = "0";
		iResult = Integer.parseInt(sCount);
		return iResult;
	}
	
}
