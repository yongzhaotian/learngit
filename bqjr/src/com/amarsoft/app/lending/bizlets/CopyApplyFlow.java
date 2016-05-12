package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.billions.GenerateSerialNo;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CopyApplyFlow extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
		//对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sCustomerID="";
		String sSerialNo="";
		
		String sSql = "",sNewObjectNo = "",sArtificialNo="";//撤销后的合同
		ASResultSet rs = null; 
		SqlObject so ;//声明对象
		
		//查询CL_INFO中父LinID为空的项，找到它的LineID，作为复制的起始点，然后把它的子LineID都复制出来 ---jgao
		sSql = "select LineID from CL_INFO where ApplySerialNo=:ApplySerialNo  and (ParentLineID IS NULL or ParentLineID = '' or ParentLineID = ' ')";
		so = new SqlObject(sSql).setParameter("ApplySerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		
		
		String sLineID="";
		while(rs.next())
		{
			sLineID = rs.getString("LineID");
		}
		rs.getStatement().close();
		
		
		//查询出合同编号，并生成撤销后新的合同编号
		if(sObjectType.equals("ContractRevokApply")){
			sSql =  "select artificialno from business_contract where serialNo =:serialNo";
			so = new SqlObject(sSql).setParameter("serialNo", sObjectNo);
			rs = Sqlca.getASResultSet(so);
			if(rs.next()){
				sArtificialNo=rs.getString("artificialno")+"0";
			}
			rs.close();
		}
		
		//获取生成新的合同号规则
		sSql = "select customerID from BUSINESS_CONTRACT where serialNo=:serialNo";
		so = new SqlObject(sSql).setParameter("serialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			sCustomerID = rs.getString("customerID");
		}
		rs.close();
		GenerateSerialNo gs =new GenerateSerialNo();
		gs.setSerialNo(sCustomerID);
		sSerialNo=gs.getContractId(Sqlca);	
		
		//复制申请信息
		sNewObjectNo = DBKeyHelp.getSerialNo("BUSINESS_CONTRACT","SerialNo",Sqlca);
		sSql = "insert into BUSINESS_CONTRACT (SerialNo,artificialno,ApplySerialNo,stores,OperateDate,Periods,ContractStatus,OperateOrgID,OperateUserID,InputUserID,ProductID,UpdateDate,InputOrgID,CertID,CustomerName,CreditAttribute,CustomerID,CustomerType,InputDate,BusinessType,CertType,ProductName,TempSaveFlag,productversion)" +
				" select '"+sSerialNo+"','"+sArtificialNo+"','"+sNewObjectNo+"',stores,OperateDate,Periods,ContractStatus,OperateOrgID,OperateUserID,InputUserID,ProductID,UpdateDate,InputOrgID,CertID,CustomerName,CreditAttribute,CustomerID,CustomerType,InputDate,BusinessType,CertType,ProductName,TempSaveFlag,productversion" +
				" from BUSINESS_CONTRACT where SerialNo='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);
		
		//在CL_INFO表中插入多条数据，实现复制,从父LineID到最后一个子LineID ---by jgao
		if(sObjectType.equals("CreditApply"))
		{			
		    String sNewLineID1 = DBKeyHelp.getSerialNo("CL_INFO","LineID",Sqlca);
		    sSql = "insert into CL_INFO (LineID,ApplySerialNo,ParentLineID,CustomerID,CustomerName,BusinessType,Rotative,BailRatio,LineSum1,LineSum2,InputOrg,InputUser,InputTime,UpdateTime,CLTypeID,CLTypeName,ApproveSerialNo,BCSerialNo)" +
		           " select '"+sNewLineID1+"','"+sNewObjectNo+"',ParentLineID,CustomerID,CustomerName,BusinessType,Rotative,BailRatio,LineSum1,LineSum2,InputOrg,InputUser,InputTime,UpdateTime,CLTypeID,CLTypeName,ApproveSerialNo,BCSerialNo" + 
		           " from CL_INFO where LineID='"+sLineID+"'";
		    Sqlca.executeSQL(sSql);
		    sSql = "select LineID from CL_INFO where ParentLineID=:ParentLineID ";
	        so = new SqlObject(sSql).setParameter("ParentLineID", sLineID);
		    rs=Sqlca.getASResultSet(so);
		    
		    while(rs.next())
		    {		    	
			    String sNewLineID = DBKeyHelp.getSerialNo("CL_INFO","LineID",Sqlca);
			    sSql = "insert into CL_INFO (LineID,ApplySerialNo,ParentLineID,CustomerID,CustomerName,BusinessType,Rotative,  BailRatio,LineSum1,LineSum2,InputOrg,InputUser,InputTime,UpdateTime,CLTypeID,CLTypeName,ApproveSerialNo,BCSerialNo)" +
			  		   " select '"+sNewLineID+"','"+sNewObjectNo+"','"+sNewLineID1+"',CustomerID,CustomerName,BusinessType,Rotative,BailRatio,LineSum1,LineSum2, InputOrg,InputUser,InputTime,  UpdateTime,CLTypeID,CLTypeName,ApproveSerialNo,BCSerialNo" + 
			  		   " from CL_INFO where LineID='"+rs.getString("LineID")+"'";
		        Sqlca.executeSQL(sSql);
		    }
		    rs.getStatement().close();
		}

	    
		//获得初始化相关信息
		String sApplyType = "",sFlowNo = "",sUserID = "",sOrgID = "",sPhaseNo = "";
		sSql = "select ObjectType,ObjectNo,ApplyType,UserID,OrgID,FlowNo,PhaseNo from FLOW_OBJECT where ObjectNo=:ObjectNo and ObjectType=:ObjectType ";
		so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType);
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{
			sApplyType = rs.getString("ApplyType");
			sUserID = rs.getString("UserID");
			sOrgID = rs.getString("OrgID");
			sFlowNo = rs.getString("FlowNo");
			sPhaseNo = rs.getString("PhaseNo");
		}
		rs.getStatement().close();
		
		//初始化流程信息
		Bizlet bzInitFlow = new InitializeFlow();
		bzInitFlow.setAttribute("ObjectType",sObjectType); 
		bzInitFlow.setAttribute("ObjectNo",sSerialNo); 
		bzInitFlow.setAttribute("ApplyType",sApplyType); 
		bzInitFlow.setAttribute("UserID",sUserID); 
		bzInitFlow.setAttribute("OrgID",sOrgID); 
		bzInitFlow.setAttribute("FlowNo",sFlowNo); 
		bzInitFlow.setAttribute("PhaseNo",sPhaseNo); 
		bzInitFlow.run(Sqlca);
		
	    return sNewObjectNo;
	    
	 }

}
