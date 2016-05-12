/*
		Author: --ccxie 2010/03/18
		Tester:
		Describe: 担保变更流程审批通过时进行的一些相关操作
		Input Param:
				ObjectNo: 担保变更合同流水号
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ApproveTransform extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//合同流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		ASResultSet rs = null,rs1 = null;
		SqlObject so = null; //声明对象
		
		so = new SqlObject("select RelativeSerialNo from GUARANTY_TRANSFORM where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
		String sContractSerialNo = Sqlca.getString(so);
		//将TRANSFORM_RELATIVE表中的关联关系更新到CONTRACT_RELATIVE表
		String sSql = "";
		//担保合同变更为拟新增状态的相关操作
		//1.	执行INSERT操作：将TR表中新增的担保合同关联关系插入到CR表中，并将CR.RelationStatus置为'010'
		//2.	执行UPDATE操作：将GC.ContractStatus更新为已签署合同-'020'
		
		sSql = " select ObjectNo,RelativeSum from TRANSFORM_RELATIVE where SerialNo =:SerialNo and RelationStatus = '020' ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		while(rs.next()){
			sSql = " INSERT INTO CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo,RelativeSum,RelationStatus) values (:SerialNo,'GuarantyContract',"+
			":ObjectNo,:RelativeSum,'010')";
			so = new SqlObject(sSql).setParameter("SerialNo", sContractSerialNo).setParameter("ObjectNo", rs.getString(1)).setParameter("RelativeSum", rs.getString(2));
			Sqlca.executeSQL(so);
			
			//根据批复阶段担保信息的流水号查找到相应的担保物信息
			sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
			" where ObjectType =:ObjectType "+
			" and ObjectNo =:ObjectNo "+
			" and ContractNo =:ContractNo ";
			so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sContractSerialNo).setParameter("ContractNo", rs.getString(1));
			rs1 = Sqlca.getASResultSet(so);
			while(rs1.next())
			{
				sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
				" values('BusinessContract',:ObjectNo,:ContractNo, "+
				" :GuarantyID,'Copy',:Status,:Type) ";
				so = new SqlObject(sSql).setParameter("ObjectNo", sContractSerialNo).setParameter("ContractNo", rs.getString(1))
				.setParameter("GuarantyID", rs1.getString("GuarantyID")).setParameter("Status", rs1.getString("Status")).setParameter("Type", rs1.getString("Type"));
				Sqlca.executeSQL(so);
				
			}
			rs1.getStatement().close();
		}
		rs.getStatement().close();
		
		sSql =  " update GUARANTY_CONTRACT set ContractStatus = '020' where SerialNo in (select ObjectNo from TRANSFORM_RELATIVE where SerialNo =:SerialNo and ObjectType = 'GuarantyContract' and RelationStatus = '020' )";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		
		//担保合同变更为拟解除状态的相关操作
		//1.	执行UPDATE操作：将CR.RelationStatus置为'020'
		//2.	执行UPDATE操作：如果解除一般担保合同，将GC.ContractStatus置为已失效-'030'
		sSql =  " update CONTRACT_RELATIVE set RelationStatus = '020' where SerialNo =:SerialNo " +
		" and ObjectType = 'GuarantyContract' and ObjectNo in (select ObjectNo from TRANSFORM_RELATIVE " +
		" where SerialNo =:SerialNo1 and ObjectType = 'GuarantyContract' and RelationStatus = '030' )";
		so = new SqlObject(sSql).setParameter("SerialNo", sContractSerialNo).setParameter("SerialNo1", sObjectNo);
		Sqlca.executeSQL(so);
		
		sSql =  " update GUARANTY_CONTRACT set ContractStatus = '030' where ContractType = '010' and SerialNo in " +
		" (select ObjectNo from TRANSFORM_RELATIVE where SerialNo =:SerialNo and ObjectType = 'GuarantyContract' and RelationStatus = '030' )";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		
		//更新BUSINESS_CONTRACT表中的TransformTimes字段值
		//设置BUSINESS_CONTRACT表的标志位TransformFlag=0,表示该笔主合同的担保合同变更流程已完成
		sSql = " update BUSINESS_CONTRACT set TransformFlag = '0',TransformTimes = nvl(TransformTimes,0)+1 where SerialNo =:SerialNo";
		so = new SqlObject(sSql).setParameter("SerialNo", sContractSerialNo);
		Sqlca.executeSQL(so);

		return "success";
	 }

}
