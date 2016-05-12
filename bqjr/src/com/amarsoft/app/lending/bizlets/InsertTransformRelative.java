package com.amarsoft.app.lending.bizlets;

/*
Author: --ccxie 2010/04/06
Tester:
Describe: --拷贝最高额担保合同下的担保品
Input Param:
Output Param:
		
HistoryLog:
*/

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InsertTransformRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");//担保合同编号
		String sSerialNo = (String)this.getAttribute("SerialNo");//担保合同变更申请流水号
		String sRelationStatus = (String)this.getAttribute("RelationStatus");
		SqlObject so;
		//主合同编号
		so = new SqlObject("select RelativeSerialNo from GUARANTY_TRANSFORM where SerialNo =:SerialNo").setParameter("SerialNo", sSerialNo);
		String sContractNo =  Sqlca.getString(so);
		//将空值转化为空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSerialNo == null) sSerialNo = "";
		if(sRelationStatus == null) sRelationStatus = "";	
		if(sContractNo == null) sContractNo = "";	

		//定义变量		
		String sSql = "";//Sql语句
		ASResultSet rs = null;
		String sGuarantyID = "";
		//插入担保合同与主合同的关联关系
		sSql = "select count(*) from TRANSFORM_RELATIVE where SerialNo =:SerialNo and ObjectNo =:ObjectNo and ObjectType = 'GuarantyContract'";
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("ObjectNo", sObjectNo);
		String sCount = Sqlca.getString(so);
		if(sCount.equals("0")){
			sSql = "insert into TRANSFORM_RELATIVE(SerialNo,ObjectNo,ObjectType,RelationStatus) values(:SerialNo,:ObjectNo,:ObjectType,:RelationStatus)";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo", sSerialNo).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType).setParameter("RelationStatus", sRelationStatus);
			Sqlca.executeSQL(so);	
			//复制担保合同与被引入的最高额担保合同下属的担保品的关联关系
			sSql = 	" select distinct GuarantyID from GUARANTY_RELATIVE "+
			" where ObjectType = 'BusinessContract' "+
			" and ContractNo =:ContractNo ";
			so = new SqlObject(sSql).setParameter("ContractNo", sObjectNo);
			rs = Sqlca.getASResultSet(so);
			while(rs.next())
			{
				
				sGuarantyID = rs.getString("GuarantyID");
				sSql = 	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
				" values('BusinessContract',:ObjectNo,:ContractNo,:GuarantyID,'Copy','1','Import')";
				so = new SqlObject(sSql).setParameter("ObjectNo", sContractNo).setParameter("ContractNo", sObjectNo).setParameter("GuarantyID", sGuarantyID);
				Sqlca.executeSQL(so);
			}
			rs.getStatement().close();			
			return "SUCCEEDED";
		}else
			return "EXIST";
	}		
}
