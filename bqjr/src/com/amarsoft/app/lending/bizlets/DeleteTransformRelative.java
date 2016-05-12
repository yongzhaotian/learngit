package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteTransformRelative extends Bizlet{


	public Object run(Transaction Sqlca) throws Exception {
		
		String sSerialNo = (String)this.getAttribute("SerialNo");//变更申请号
		String sObjectNo = (String)this.getAttribute("ObjectNo");//合同号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sContractNo = (String)this.getAttribute("ContractNo");//担保合同号
		
		if(sContractNo == null) sContractNo = "";
		if(sSerialNo == null) sSerialNo = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		
		//定义参数
		String sql = "";
		SqlObject so ;//声明对象
		//担保品可能会有多个所以用数组来控制
		so = new SqlObject("select GuarantyID from GUARANTY_RELATIVE  where ObjectType = 'BusinessContract' and ContractNo =:ContractNo").setParameter("ContractNo", sContractNo);
		String[] sGuarantyID = Sqlca.getStringArray(so);
		//删除担保合同和担保品的关联关系
		for(int i=0;i<sGuarantyID.length;i++){
			if(sGuarantyID.length==0){
				break;
			}else{
				sql = " delete from Guaranty_Relative where ContractNo =:ContractNo  and ObjectType = 'BusinessContract' and ObjectNo=:ObjectNo" +
				"  and GuarantyID in ('"+sGuarantyID[i]+"' )";
				so = new SqlObject(sql).setParameter("ContractNo", sContractNo).setParameter("ObjectNo", sObjectNo);
				Sqlca.executeSQL(so);
			}
		}
		
		//删除担保合同和Transform_Relative表的关系
		sql = "delete from TRANSFORM_RELATIVE where SerialNo =:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType ";
		so = new SqlObject(sql).setParameter("SerialNo", sSerialNo).setParameter("ObjectNo", sContractNo).setParameter("ObjectType",sObjectType);
		Sqlca.executeSQL(so);
		return "success";
	}

}
