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
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteGuarantyContract extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sSerialNo = (String)this.getAttribute("SerialNo");
		
		SqlObject so ;//声明对象
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSerialNo == null) sSerialNo = "";
				
		//根据对象类型获得关联表名
		String sRelativeTableName = "";
		String sSql = " select RelativeTable from OBJECTTYPE_CATALOG "+
        " where ObjectType =:ObjectType ";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType);
        ASResultSet rs = Sqlca.getASResultSet(so);
        
		if(rs.next())
			sRelativeTableName = DataConvert.toString(rs.getString("RelativeTable"));
		rs.getStatement().close();
		
		//该担保合同是否已被其他业务使用过
		int iCount = 0;
		sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT "+
		" where SerialNo =:SerialNo "+
		" and ContractType = '020' "+
		" and (ContractStatus = '020' "+
		" or ContractStatus = '030')";
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
        rs = Sqlca.getASResultSet(so);
        
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		if(iCount <= 0)//非最高额担保合同
		{
			//删除与担保合同有关且未入库的抵质押物
			sSql =  " delete from GUARANTY_INFO "+
			" where GuarantyID in "+
			" (select GuarantyID from GUARANTY_RELATIVE "+
			" where ObjectType =:ObjectType "+
			" and ObjectNo=:ObjectNo "+
			" and ContractNo =:ContractNo "+
			" and Channel = 'New') "+
			" and GuarantyStatus = '01' ";
			so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", sSerialNo);
	        Sqlca.executeSQL(so);
						
			//删除担保合同
	        sSql =  " delete from GUARANTY_CONTRACT "+
			" where SerialNo =:SerialNo ";
	        so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
	        Sqlca.executeSQL(so);
		}
		
		//删除担保合同与抵质押物的关联关系
		sSql =  " delete from GUARANTY_RELATIVE "+
		" where ObjectType =:ObjectType "+
		" and ObjectNo =:ObjectNo "+
		" and ContractNo =:ContractNo ";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", sSerialNo);
        Sqlca.executeSQL(so);
		
		//解除该业务与担保合同变更的关联关系
        sSql = "delete from Transform_relative where SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType ='GuarantyContract'";
        so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo).setParameter("ObjectNo", sSerialNo);
		Sqlca.executeSQL(so);
		
		//删除业务与担保合同的关联关系
		sSql =  " delete from "+sRelativeTableName+" "+
		" where SerialNo =:SerialNo "+
		" and ObjectType = 'GuarantyContract' "+
		" and ObjectNo=:ObjectNo ";
		 so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo).setParameter("ObjectNo", sSerialNo);
        Sqlca.executeSQL(so);
	
		return "SUCCEEDED";
	}
}
