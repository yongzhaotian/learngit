package com.amarsoft.app.lending.bizlets;
/*
		Author: --zywei 2005-12-10
		Tester:
		Describe: --删除担保合同;
		Input Param:
				ObjectType: --对象类型(业务阶段)。
				ObjectNo: --对象编号（申请/批复/合同流水号）。
				SerialNo:--担保合同号
		Output Param:
				return：返回值（SUCCEEDED --删除成功）

		HistoryLog:
 */
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteGuarantyInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sContractNo = (String)this.getAttribute("ContractNo");
		String sGuarantyID = (String)this.getAttribute("GuarantyID");

		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sContractNo == null) sContractNo = "";
		if(sGuarantyID == null) sGuarantyID = "";
						
		
		//删除抵质押物
		String sSql = "";
		SqlObject so ;//声明对象
		sSql = 	" delete from GUARANTY_INFO "+
		" where GuarantyID =:GuarantyID "+
		" and GuarantyStatus = '01' ";
		so = new SqlObject(sSql).setParameter("GuarantyID", sGuarantyID);
        Sqlca.executeSQL(so);
		
		//删除抵质押物与担保合同的关联关系
        sSql = 	" delete from GUARANTY_RELATIVE "+
		" where ObjectType =:ObjectType "+
		" and ObjectNo =:ObjectNo "+
		" and ContractNo =:ContractNo "+
		" and GuarantyID =:GuarantyID ";
        so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
        Sqlca.executeSQL(so);
        
		return "SUCCEEDED";
	}
}
