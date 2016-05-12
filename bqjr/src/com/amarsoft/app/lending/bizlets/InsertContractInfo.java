package com.amarsoft.app.lending.bizlets;

/**
 * 流程初始化类
 * @history fhuang 2007.01.08 增加中小企业流程选择
 * 			syang 2009/10/26 更正注释
 */

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class InsertContractInfo extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//对象类型
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		
		System.out.println(sObjectNo+","+sObjectType);
		//定义变量:用户名称、机构名称、流程名称、阶段名称、阶段类型、开始时间、任务流水号、SQL
		String sSql = "";
		//定义变量：查询结果集
		ASResultSet rs=null;
		SqlObject so;
		String sColumnName="";       //一个字段名称
		String sColumnNames="";      //字段拼接名称
	    String findColumnValues="";  //查找的列名
	    String sNewObjectNo = "";  //新生成流水号
	    String sArtificialNo="";   //撤销后的合同编号
		String[] sColumnList;
		StringBuffer  sb=new StringBuffer();
		
		//查询出合同信息中所有字段的组合
		sSql =  "select colName from DATAOBJECT_LIBRARY where DONo = 'ContractInfo1211'";
	    rs = Sqlca.getASResultSet(sSql);
		while(rs.next()){
			sColumnName=rs.getString("colName");
		    if(sColumnName.equals("InputOrgName") || sColumnName.equals("OperateOrgName") || sColumnName.equals("OperateUserName")
		    	|| sColumnName.equals("OpenBankName") || sColumnName.equals("OpenBranchName") || sColumnName.equals("SerialNo") ||sColumnName.equals("ExhibitionHallName")){
		    	continue;
		    }
		    sb.append(sColumnName);
		    sb.append(",");
		}
		sColumnNames=sb.toString().substring(0, sb.lastIndexOf(","));
		findColumnValues=sColumnNames.substring(sColumnNames.indexOf(",")+1, sColumnNames.length());
		System.out.println(findColumnValues);
		rs.close();
		
		//查询出合同编号，并生成撤销后新的合同编号
		sSql =  "select artificialno from business_contract where serialNo =:serialNo";
		so = new SqlObject(sSql).setParameter("serialNo", sObjectNo);
		System.out.println(sSql);
	    rs = Sqlca.getASResultSet(so);
	    if(rs.next()){
	    	sArtificialNo=rs.getString("artificialno")+"0";
	    }
		rs.close();
		
		//在合同表中插入 新的数据
		sNewObjectNo = DBKeyHelp.getSerialNo("BUSINESS_CONTRACT","SerialNo",Sqlca);
		System.out.println(sArtificialNo+"------------");
		System.out.println(sNewObjectNo+"------------++++++++++++++");
		sSql =  "insert into  business_contract (serialNo,"+ sColumnNames+ ") select '"+sNewObjectNo+"','"+sArtificialNo+"',"+ findColumnValues +" from business_contract where serialNo='"+sObjectNo+"'";
		System.out.println(sSql);
		SqlObject so1 = new SqlObject(sSql);
	    //执行插入语句
		Sqlca.executeSQL(so1);
	   
	    
	    
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
		bzInitFlow.setAttribute("ObjectNo",sNewObjectNo); 
		bzInitFlow.setAttribute("ApplyType",sApplyType); 
		bzInitFlow.setAttribute("UserID",sUserID); 
		bzInitFlow.setAttribute("OrgID",sOrgID); 
		bzInitFlow.setAttribute("FlowNo",sFlowNo); 
		bzInitFlow.setAttribute("PhaseNo",sPhaseNo); 
		bzInitFlow.run(Sqlca);
		System.out.println(sNewObjectNo+"------------");
	    return sNewObjectNo;
	 }

  
}
