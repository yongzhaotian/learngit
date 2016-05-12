package com.amarsoft.app.lending.bizlets;

/*
Author: --ccxie 2010/03/22
Tester:
Describe: --删除担保合同关联关系
Input Param:
		ContractNo: 担保合同编号
		GuarantyID: 抵质押物编号
Output Param:

HistoryLog:
*/

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteGuarantyRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sContractNo = (String)this.getAttribute("ContractNo");
		String sGuarantyID = (String)this.getAttribute("GuarantyID");
		
		SqlObject so ;//声明对象
		
		//将空值转化为空字符串
		if(sContractNo == null) sContractNo = "";
		if(sGuarantyID == null) sGuarantyID = "";
		so = new SqlObject("select GuarantyStatus from GUARANTY_INFO where GuarantyID =:GuarantyID").setParameter("GuarantyID", sGuarantyID);
		String sGuarantyStatus = Sqlca.getString(so);
		if(sGuarantyStatus == null) sGuarantyStatus = "";
		//sGuarantyStatus=01担保品未入库
		if(sGuarantyStatus.equals("01")){
			so = new SqlObject("delete from GUARANTY_RELATIVE where ContractNo=:ContractNo and GuarantyID=:GuarantyID").setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
			Sqlca.executeSQL(so);
		}else{//关联关系置为无效
			so = new SqlObject("update GUARANTY_RELATIVE set RelationStatus = '020' where ContractNo=:ContractNo and GuarantyID=:GuarantyID ").setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
			Sqlca.executeSQL(so);
		  }
		return "sccuss";
	}		
}
