/*
		Author: --wqchen 2010-03-23
		Tester:
		Describe: --合并合同
		Input Param:
				SerialNo: 合同流水号
				ObjectNo：被合并的合同号
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UniteContract extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sObjectNoArray = (String)this.getAttribute("ObjectNoArray");
		String sObjectNo[] = sObjectNoArray.split(",");
		
		//参数定义
		double dBalance = 0.00;//余额
		double dNormalBalance = 0.00;//正常余额
		double dOverdueBalance = 0.00;//逾期余额
		double dDullBalance = 0.00;//呆滞余额
		double dBadBalance = 0.00;//呆账余额
		double dInterestBalance1 = 0.00;//表内欠息余额
		double dInterestBalance2 = 0.00;//表外欠息余额
		double dShiftBalance = 0.00;//移交保全时余额
		double dTABalance = 0.00;//分期业务欠本金
		double dTAInterestBalance = 0.00;//分期业务欠利息
		double dFineBalance1 = 0.00;//本金罚息
		double dFineBalance2 = 0.00;//利息罚息
		ASResultSet rs = null;
		SqlObject so;
		//------------------------计算被合并合同的金额综合-------------------------------
		String sSql = "";
		//获取合并合同金额
		sSql = " select Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance,"+
	 	   " InterestBalance1,InterestBalance2,ShiftBalance,TABalance,TAInterestBalance,FineBalance1,FineBalance2 "+
	       " from BUSINESS_CONTRACT where SerialNo=:SerialNo ";
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			dFineBalance2 = dFineBalance2 + rs.getDouble("FineBalance2");
			dBalance = dBalance + rs.getDouble("Balance");
			dNormalBalance = dNormalBalance + rs.getDouble("NormalBalance");
			dOverdueBalance = dOverdueBalance + rs.getDouble("OverdueBalance");
			dDullBalance = dDullBalance + rs.getDouble("DullBalance");
			dBadBalance = dBadBalance + rs.getDouble("BadBalance");
			dInterestBalance1 = dInterestBalance1 + rs.getDouble("InterestBalance1");
			dInterestBalance2 = dInterestBalance2 + rs.getDouble("InterestBalance2");
			dShiftBalance = dShiftBalance + rs.getDouble("ShiftBalance");
			dTABalance = dTABalance + rs.getDouble("TABalance");
			dTAInterestBalance = dTAInterestBalance + rs.getDouble("TAInterestBalance");
			dFineBalance1 = dFineBalance1 + rs.getDouble("FineBalance1");
		}
		rs.getStatement().close();		
		
		//获取被合并合同金额
		for(int i = 0;i<sObjectNo.length;i++){
			sSql = " select Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance,"+
	    	   " InterestBalance1,InterestBalance2,ShiftBalance,TABalance,TAInterestBalance,FineBalance1,FineBalance2 "+
            " from BUSINESS_CONTRACT where SerialNo=:SerialNo ";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo[i]);
			rs = Sqlca.getASResultSet(so);
			if(rs.next()){
				dFineBalance2 = dFineBalance2 + rs.getDouble("FineBalance2");
				dBalance = dBalance + rs.getDouble("Balance");
				dNormalBalance = dNormalBalance + rs.getDouble("NormalBalance");
				dOverdueBalance = dOverdueBalance + rs.getDouble("OverdueBalance");
				dDullBalance = dDullBalance + rs.getDouble("DullBalance");
				dBadBalance = dBadBalance + rs.getDouble("BadBalance");
				dInterestBalance1 = dInterestBalance1 + rs.getDouble("InterestBalance1");
				dInterestBalance2 = dInterestBalance2 + rs.getDouble("InterestBalance2");
				dShiftBalance = dShiftBalance + rs.getDouble("ShiftBalance");
				dTABalance = dTABalance + rs.getDouble("TABalance");
				dTAInterestBalance = dTAInterestBalance + rs.getDouble("TAInterestBalance");
				dFineBalance1 = dFineBalance1 + rs.getDouble("FineBalance1");
			}
			rs.getStatement().close();
			
			//更新借据表，将原合同号更新为目标合同号
			sSql = " update BUSINESS_DUEBILL  set RelativeSerialNo2 =:NewRelativeSerialNo2  where RelativeSerialNo2 =:RelativeSerialNo2 ";
			so = new SqlObject(sSql).setParameter("NewRelativeSerialNo2", sSerialNo).setParameter("RelativeSerialNo2", sObjectNo[i]);
			Sqlca.executeSQL(so);
		}
		
		//------------------------将对应的字段值之和更新到主合同对应字段---------------------------
		java.text.DecimalFormat df = new java.text.DecimalFormat("#0.00");
		sSql = " update BUSINESS_CONTRACT " +
		   " set FineBalance2=:FineBalance2,Balance=:Balance," +
		   " NormalBalance=:NormalBalance,OverdueBalance=:OverdueBalance," +
		   " DullBalance=:DullBalance,BadBalance=:BadBalance," +
		   " InterestBalance1=:InterestBalance1,InterestBalance2=:InterestBalance2," +
		   " ShiftBalance=:ShiftBalance,TABalance=:TABalance," +
		   " TAInterestBalance=:TAInterestBalance,FineBalance1=:FineBalance1 " +
		   " where SerialNo=:SerialNo ";
		so = new SqlObject(sSql);
		so.setParameter("FineBalance2", df.format(dFineBalance2)).setParameter("Balance", df.format(dBalance)).setParameter("NormalBalance", df.format(dNormalBalance))
		.setParameter("OverdueBalance", df.format(dOverdueBalance)).setParameter("DullBalance", df.format(dDullBalance)).setParameter("BadBalance", df.format(dBadBalance))
		.setParameter("InterestBalance1", df.format(dInterestBalance1)).setParameter("InterestBalance2", df.format(dInterestBalance2)).setParameter("ShiftBalance", df.format(dShiftBalance))
		.setParameter("TABalance", df.format(dTABalance)).setParameter("TAInterestBalance", df.format(dTAInterestBalance)).setParameter("FineBalance1", df.format(dFineBalance1))
		.setParameter("SerialNo", sSerialNo);
		Sqlca.executeSQL(so);
		//删除被合并合同的记录
		for(int i = 0;i<sObjectNo.length;i++){
			//删除被合并合同的记录
			sSql = " delete from BUSINESS_CONTRACT where SerialNo =:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo[i]);
			Sqlca.executeSQL(so);
		}
		return "true";
	}		
}
