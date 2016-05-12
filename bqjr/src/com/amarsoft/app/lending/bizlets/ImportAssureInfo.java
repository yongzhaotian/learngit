package com.amarsoft.app.lending.bizlets;
/*
		Author: --王业罡 2005-08-08
		Tester:
		Describe: --引入最高担保合同;
		Input Param:
				ObjectType: --对象类型(业务阶段)。
				ObjectNo: --对象编号（申请/批复/合同流水号）。
				SerialNo:--担保合同号
		Output Param:
				return：EXIST --引入已存在
						SUCCEEDED --引入成功

		HistoryLog:
 */
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ImportAssureInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sSerialNo = (String)this.getAttribute("SerialNo");

		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSerialNo == null) sSerialNo = "";
		String sRelativeTableName="",sGuarantyID = "";
		SqlObject so=null;
		String sSql = "select RelativeTable from OBJECTTYPE_CATALOG where ObjectType=:ObjectType";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType);
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{ 
			sRelativeTableName = DataConvert.toString(rs.getString("RelativeTable"));
		}
		rs.getStatement().close();
		
		 
		//判断是否已引入
		int iCount=0;
		sSql = " select count(*) as iCount from "+sRelativeTableName+"  where SerialNo=:SerialNo and ObjectType='GuarantyContract' and ObjectNo=:ObjectNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo).setParameter("ObjectNo", sSerialNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{ 
			iCount = rs.getInt("iCount");
		}
		rs.getStatement().close(); 
		
		if (iCount==0)
		{
			if("CONTRACT_RELATIVE".equalsIgnoreCase(sRelativeTableName))
			{
				sSql = "insert into "+sRelativeTableName+" values(:ObjectNo,'GuarantyContract',:SerialNo,0.00,'010')";
				so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("SerialNo", sSerialNo);
				Sqlca.executeSQL(so);
			}else
			{
				sSql = "insert into "+sRelativeTableName+" values(:ObjectNo,'GuarantyContract',:SerialNo,0.00)";
				so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("SerialNo", sSerialNo);
				Sqlca.executeSQL(so);
			}
			//根据担保合同编号获取相应的抵质押物信息
			sSql = 	" select distinct GuarantyID from GUARANTY_RELATIVE "+
			" where ObjectType = 'BusinessContract' "+
			" and ContractNo =:ContractNo ";
			so = new SqlObject(sSql).setParameter("ContractNo", sSerialNo);
			rs = Sqlca.getASResultSet(so);
			while(rs.next())
			{
				sGuarantyID = rs.getString("GuarantyID");
				sSql = 	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
				" values(:ObjectType,:ObjectNo,:ContractNo,:GuarantyID,'Copy','1','Import')";
				so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo)
				.setParameter("ContractNo", sSerialNo).setParameter("GuarantyID", sGuarantyID);
				Sqlca.executeSQL(so);
			}
			rs.getStatement().close();
			return "SUCCEEDED";
		}
		else
		{
			return "EXIST";
		}
	}
}
