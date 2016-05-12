package com.amarsoft.app.lending.bizlets;

/*
Author: --zywei 2006-01-12
Tester:
Describe: --担保合同管理中建立抵质押物与担保合同、业务合同之间的关联关系
		  --目前用于页面：ValidAssureImpawnInfo1、ValidAssureImpawnInfo2、
		  ValidAssurePawnInfo1、ValidAssurePawnInfo2
Input Param:
		ContractNo: 担保合同编号
		GuarantyID: 抵质押物编号
Output Param:

HistoryLog:
*/

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AddGuarantyRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sContractNo = (String)this.getAttribute("ContractNo");
		String sGuarantyID = (String)this.getAttribute("GuarantyID");
		String sChannel = (String)this.getAttribute("Channel");
		String sType = (String)this.getAttribute("Type");
		
		//将空值转化为空字符串
		if(sContractNo == null) sContractNo = "";
		if(sGuarantyID == null) sGuarantyID = "";
		if(sChannel == null) sChannel = "";
		if(sType == null) sType = "";
				
		SqlObject so = null; //声明对象
		//定义变量		
		ASResultSet rs = null;//查询结果集
		String sSql = "";//Sql语句
		String sSerialNo = "";//合同编号			
		int iCount = 0;//记录数	
		
		//根据担保合同编号获取相关业务合同编号
		sSql = 	" select SerialNo from CONTRACT_RELATIVE "+
		" where ObjectType = 'GuarantyContract' "+
		" and ObjectNo =:ObjectNo ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sContractNo);
		
		//目前ALS6.5版本只做如果是新增的最高额担保合同，则ObjectNo给一个默认值“NewGC”,没有跟任何的业务合同关联。add by jgao1
		boolean IsExist = false;//表示是否存在业务合同号，默认为不存在
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			IsExist = true;//表示存在业务合同号
		}
		rs.getStatement().close();
		if(IsExist)	{	
			rs = Sqlca.getASResultSet(so);
			while (rs.next())
			{
				sSerialNo = rs.getString("SerialNo");
				//验证该关联关系是否已存在
				sSql = 	" select count(ObjectNo) from GUARANTY_RELATIVE "+
				" where ObjectType = 'BusinessContract' "+
				" and ObjectNo =:ObjectNo "+
				" and ContractNo =:ContractNo "+
				" and GuarantyID =:GuarantyID ";
				so = new SqlObject(sSql);
				so.setParameter("ObjectNo", sSerialNo).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
				ASResultSet rs1 = Sqlca.getASResultSet(so);
				if (rs1.next())
					iCount = rs1.getInt(1);
				rs1.getStatement().close();
			
				//如果不存在关联关系，则建立抵质押物与担保合同、业务合同之间的管理关系
				if(iCount < 1)
				{
					//对象类型（合同：BusinessContract）、对象编号（合同编号）、担保合同编号、抵质押物编号、关联关系来源渠道（新增：New；拷贝：Copy）、有效标志（1：有效；2：无效）、数据来源类型（Add：新增；Import：引入）
					sSql = 	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type,RelationStatus)"+
					" values('BusinessContract',:ObjectNo,:ContractNo,:GuarantyID,:Channel,'1',:Type,'010') ";
					so = new SqlObject(sSql);
					so.setParameter("ObjectNo", sSerialNo).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID)
					.setParameter("Channel", sChannel).setParameter("Type", sType);
					Sqlca.executeSQL(so);
					
				}
			}		
			rs.getStatement().close();
		}else{
			//验证该关联关系是否已存在
			sSql = 	" select count(ContractNo) from GUARANTY_RELATIVE "+
			" where ObjectType = 'BusinessContract' "+
			" and ContractNo =:ContractNo "+
			" and GuarantyID =:GuarantyID ";
			so =  new SqlObject(sSql).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
			ASResultSet rs1 = Sqlca.getASResultSet(so);
			if (rs1.next())
				iCount = rs1.getInt(1);
			rs1.getStatement().close();
		
			//如果不存在关联关系，则建立抵质押物与担保合同、业务合同之间的管理关系
			if(iCount < 1)
			{
				//对象类型（合同：BusinessContract）、对象编号（合同编号）、担保合同编号、抵质押物编号、关联关系来源渠道（新增：New；拷贝：Copy）、有效标志（1：有效；2：无效）、数据来源类型（Add：新增；Import：引入）
				sSql = 	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type,RelationStatus)"+
				" values('BusinessContract','NewGC',:ContractNo,:GuarantyID,:Channel,'1',:Type,'010') ";
				so = new SqlObject(sSql).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID).setParameter("Channel", sChannel).setParameter("Type", sType);
				Sqlca.executeSQL(so);
			}
			else{    //added by yzheng 2013-06-20
				String relationStatus = "";
				sSql = 	" select RelationStatus from GUARANTY_RELATIVE where ContractNo=:ContractNo and GuarantyID=:GuarantyID ";
				so = new SqlObject(sSql).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
				rs1 = Sqlca.getASResultSet(so);
				if (rs1.next())
					relationStatus = rs1.getString("RelationStatus");
				rs1.getStatement().close();
				
				if(relationStatus.equals("010")){  //重复引入
					return "2";  
				}
				else{  //之前引入后又被删除
					sSql = 	" update GUARANTY_RELATIVE set RelationStatus = '010' where ContractNo=:ContractNo and GuarantyID=:GuarantyID ";
					so = new SqlObject(sSql).setParameter("ContractNo", sContractNo).setParameter("GuarantyID", sGuarantyID);
					Sqlca.executeSQL(so);
				}
			}
		}				
		return "1";
	}		
}
