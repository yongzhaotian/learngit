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
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sCustomerID="";
		String sSerialNo="";
		
		String sSql = "",sNewObjectNo = "",sArtificialNo="";//������ĺ�ͬ
		ASResultSet rs = null; 
		SqlObject so ;//��������
		
		//��ѯCL_INFO�и�LinIDΪ�յ���ҵ�����LineID����Ϊ���Ƶ���ʼ�㣬Ȼ���������LineID�����Ƴ��� ---jgao
		sSql = "select LineID from CL_INFO where ApplySerialNo=:ApplySerialNo  and (ParentLineID IS NULL or ParentLineID = '' or ParentLineID = ' ')";
		so = new SqlObject(sSql).setParameter("ApplySerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		
		
		String sLineID="";
		while(rs.next())
		{
			sLineID = rs.getString("LineID");
		}
		rs.getStatement().close();
		
		
		//��ѯ����ͬ��ţ������ɳ������µĺ�ͬ���
		if(sObjectType.equals("ContractRevokApply")){
			sSql =  "select artificialno from business_contract where serialNo =:serialNo";
			so = new SqlObject(sSql).setParameter("serialNo", sObjectNo);
			rs = Sqlca.getASResultSet(so);
			if(rs.next()){
				sArtificialNo=rs.getString("artificialno")+"0";
			}
			rs.close();
		}
		
		//��ȡ�����µĺ�ͬ�Ź���
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
		
		//����������Ϣ
		sNewObjectNo = DBKeyHelp.getSerialNo("BUSINESS_CONTRACT","SerialNo",Sqlca);
		sSql = "insert into BUSINESS_CONTRACT (SerialNo,artificialno,ApplySerialNo,stores,OperateDate,Periods,ContractStatus,OperateOrgID,OperateUserID,InputUserID,ProductID,UpdateDate,InputOrgID,CertID,CustomerName,CreditAttribute,CustomerID,CustomerType,InputDate,BusinessType,CertType,ProductName,TempSaveFlag,productversion)" +
				" select '"+sSerialNo+"','"+sArtificialNo+"','"+sNewObjectNo+"',stores,OperateDate,Periods,ContractStatus,OperateOrgID,OperateUserID,InputUserID,ProductID,UpdateDate,InputOrgID,CertID,CustomerName,CreditAttribute,CustomerID,CustomerType,InputDate,BusinessType,CertType,ProductName,TempSaveFlag,productversion" +
				" from BUSINESS_CONTRACT where SerialNo='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);
		
		//��CL_INFO���в���������ݣ�ʵ�ָ���,�Ӹ�LineID�����һ����LineID ---by jgao
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

	    
		//��ó�ʼ�������Ϣ
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
		
		//��ʼ��������Ϣ
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
