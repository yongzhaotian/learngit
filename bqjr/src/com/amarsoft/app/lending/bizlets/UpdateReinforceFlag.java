/*
		Author: --jschen 2010-03-18
		Tester:
		Describe: --更改BUSINESS_CONTRACT表中信息的ReinforceFlag字段的值
		Input Param:
				ObjectNo: 合同流水号
				ReinforceFlag：补登类型
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;


import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateReinforceFlag extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//补登标志
	 	String sReinforceFlag = (String)this.getAttribute("ReinforceFlag");
		//对象编号 合同编号
	 	String sObjectNo = (String)this.getAttribute("ObjectNo");
	 	//业务品种
	 	String sBusinessType = (String)this.getAttribute("BusinessType");

		
		//将空值转化为空字符串
		if(sReinforceFlag == null) sReinforceFlag = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		SqlObject so;
		//定义变量
		String sSql="";

		if(sReinforceFlag.equals("010")) //未补登完成的信贷业务
		{
			sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '020' where SerialNo =:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
			Sqlca.executeSQL(so);
			UpdateFinished(Sqlca,sBusinessType,sObjectNo);
			
		}else if(sReinforceFlag.equals("110")) //未补登完成的授信额度
		{

			sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '120' where SerialNo =:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
			Sqlca.executeSQL(so);
			UpdateFinished(Sqlca,sBusinessType,sObjectNo);
		}else if(sReinforceFlag.equals("020")) //补登完成业务
		{
			sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '010' where SerialNo =:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
			Sqlca.executeSQL(so);
			UpdateUnFinished(Sqlca,"",sObjectNo);
		}else if(sReinforceFlag.equals("120")) //补登完成额度
		{
			sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '110' where SerialNo =:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
			Sqlca.executeSQL(so);
		}
		
		
		return "succeed";
	    
	 }
 
	 public void UpdateFinished(Transaction Sqlca,String sBusinessType,String sObjectNo)throws Exception{
		//定义变量
		String sSql2= "";
		ASResultSet rs = null;
		SqlObject so;
		String sCustomerID = "",sOperateUserID = "",sOperateOrgID = "",sInputOrgID = "",sInputUserID = "";
		 
		sSql2 = "Select CustomerID,OperateUserID,OperateOrgID,InputOrgID,InputUserID from BUSINESS_CONTRACT where SerialNo =:SerialNo";
		so = new SqlObject(sSql2).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{
			sCustomerID = rs.getString("CustomerID");
			sOperateUserID = rs.getString("OperateUserID");
			sOperateOrgID = rs.getString("OperateOrgID");
			sInputUserID = rs.getString("InputUserID");
			sInputOrgID = rs.getString("InputOrgID");
			if(sOperateUserID == null || "".equalsIgnoreCase(sOperateUserID)){
				sOperateUserID = sInputUserID;
				//更新合同表的OperateUserID
				sSql2 = "Update BUSINESS_CONTRACT  set OperateUserID =:OperateUserID where SerialNo =:SerialNo";
				so = new SqlObject(sSql2).setParameter("OperateUserID", sOperateUserID).setParameter("SerialNo", sObjectNo);
				Sqlca.executeSQL(so);
			}
			
			if(sOperateOrgID == null || "".equalsIgnoreCase(sOperateOrgID)){
				sOperateOrgID = sInputOrgID;
				//更新合同表的OperateOrgID
				sSql2 = "Update BUSINESS_CONTRACT  set OperateOrgID =:OperateOrgID where SerialNo =:SerialNo ";
				so = new SqlObject(sSql2).setParameter("OperateUserID", sOperateUserID).setParameter("SerialNo", sObjectNo);
				Sqlca.executeSQL(so);
			}
		}
		rs.getStatement().close();
		
		//更新归档日期
		sSql2 = "Update BUSINESS_CONTRACT  set PigeonholeDate =:PigeonholeDate where SerialNo =:SerialNo";
		so = new SqlObject(sSql2).setParameter("PigeonholeDate", StringFunction.getToday()).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		
		/******更新借据表上的BusinessType字段 ，该字段是否有值可以用来判断对应合同补登是否完成。同时更新借据上的其他字段***/
		sSql2 = "Update BUSINESS_DUEBILL  set BusinessType =:BusinessType, " +
				"CustomerID =:CustomerID,"+
				"OperateUserID =:OperateUserID,"+
				"OperateOrgID =:OperateOrgID,"+
				"InputOrgID =:InputOrgID,"+
				"InputUserID =:InputUserID "+
				"where RelativeSerialNo2 =:RelativeSerialNo2";
		so = new SqlObject(sSql2).setParameter("BusinessType", sBusinessType)
		.setParameter("CustomerID", sCustomerID)
		.setParameter("OperateUserID", sOperateUserID)
		.setParameter("OperateOrgID", sOperateOrgID)
		.setParameter("InputOrgID", sInputOrgID)
		.setParameter("InputUserID", sInputUserID)
		.setParameter("RelativeSerialNo2", sObjectNo);
		Sqlca.executeSQL(so);
		
	    //查询该主合同下的担保合同 的流水号，返回值可能是个数组
		sSql2 = "select ObjectNo from CONTRACT_RELATIVE where  SerialNo =:SerialNo and ObjectType ='GuarantyContract'";
		so = new SqlObject(sSql2).setParameter("SerialNo", sObjectNo);
	    String sSerialNo_sObjectNo_Array[]=Sqlca.getStringArray(so);//将结果保存为String类型 的数组
	    //补登完成时更新该担保合同的合同状态为'020'——已签合同
	    for(int i=0;i<sSerialNo_sObjectNo_Array.length;i++){
	    	if(sSerialNo_sObjectNo_Array.length==0) break;
	    	else{
	    		so = new SqlObject("update Guaranty_Contract set ContractStatus ='020' where SerialNo =:SerialNo").setParameter("SerialNo", sSerialNo_sObjectNo_Array[i]);
	    		Sqlca.executeSQL(so);
	    	}
	    }
		 
	 }
	 
	 public void UpdateUnFinished(Transaction Sqlca,String sBusinessType,String sObjectNo)throws Exception{
		//定义变量
		String sSql2= "";
		SqlObject so;

		//更新归档日期
		sSql2 = "Update BUSINESS_CONTRACT  set PigeonholeDate ='' where SerialNo =:SerialNo";
		so = new SqlObject(sSql2).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		/******更新借据表上的BusinessType字段 ，该字段是否有值可以用来判断对应合同补登是否完成。同时更新借据上的其他字段***/
		sSql2 = "Update BUSINESS_DUEBILL  set BusinessType =:BusinessType, " +
				"CustomerID = '',"+
				"OperateUserID = '',"+
				"OperateOrgID = '',"+
				"InputOrgID = '',"+
				"InputUserID = '' "+
				"where RelativeSerialNo2 =:RelativeSerialNo2";
		so = new SqlObject(sSql2).setParameter("BusinessType", sBusinessType).setParameter("RelativeSerialNo2", sObjectNo);
		Sqlca.executeSQL(so);
		
	    //查询该主合同下的担保合同 的流水号，返回值可能是个数组
		sSql2 = "select ObjectNo from CONTRACT_RELATIVE where  SerialNo =:SerialNo and ObjectType ='GuarantyContract'";
		so = new SqlObject(sSql2).setParameter("SerialNo", sObjectNo);
	    String sSerialNo_sObjectNo_Array[]=Sqlca.getStringArray(so);//将结果保存为String类型 的数组
	    //转补登未完成时更新该担保合同的合同状态为'010'——未签合同
	    for(int i=0;i<sSerialNo_sObjectNo_Array.length;i++){
	    	if(sSerialNo_sObjectNo_Array.length==0) break;
	    	else{
	    		//只将一般担保合同置为'010'——未签合同，最高额担保合同不变
	    		so = new SqlObject("update Guaranty_Contract set ContractStatus ='010' where ContractType = '010' and SerialNo =:SerialNo").setParameter("SerialNo", sSerialNo_sObjectNo_Array[i]);
	    		Sqlca.executeSQL(so);
	    	}
	    }
		 
	 }

}