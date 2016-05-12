package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteCreditCognTask extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//自动获得传入的参数值		
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sDeleteType = (String)this.getAttribute("DeleteType");
		
		//将空值转化成空字符串		
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sDeleteType == null) sDeleteType = "";
		
		//删除任务
		if(sDeleteType.equals("DeleteTask")){
			//删除行用等级认定申请信息2009-04-03
			if(sObjectType.equals("Customer")){
				//删除风险度评估明细信息
				deleteCreditCognTableData("Evaluate_Data",sObjectType,sObjectNo,Sqlca);
				//删除风险度评估信息
				deleteCreditCognTableData("Evaluate_Record",sObjectType,sObjectNo,Sqlca);
				//删除流程对象信息				
				deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
				//删除流程任务信息
				deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);
				//删除流程意见信息
				deleteTableData("Flow_Opinion",sObjectType,sObjectNo,Sqlca);
			}
		}
		return "1";
	}
	
	private void deleteCreditCognTableData(String sTableName,String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = " delete from "+sTableName+" where ObjectType =:ObjectType and serialno =:SerialNo  ";
		SqlObject so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
	}
	
	//删除有ObjectType,ObjectNo作为外键的表
	private void deleteTableData(String sTableName,String sObjectType,String sObjectNo,Transaction Sqlca) throws Exception {
		String sSql = " delete from "+sTableName+" where ObjectType =:ObjectType and ObjectNo =:ObjectNo ";
		SqlObject so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so);
	}
}
