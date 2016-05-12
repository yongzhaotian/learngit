/*
		Author: --wqchen 2010-03-23
		Tester:
		Describe: --�ϲ���ͬ
		Input Param:
				SerialNo: ��ͬ��ˮ��
				ObjectNo�����ϲ��ĺ�ͬ��
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
		//�Զ���ô���Ĳ���ֵ
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sObjectNoArray = (String)this.getAttribute("ObjectNoArray");
		String sObjectNo[] = sObjectNoArray.split(",");
		
		//��������
		double dBalance = 0.00;//���
		double dNormalBalance = 0.00;//�������
		double dOverdueBalance = 0.00;//�������
		double dDullBalance = 0.00;//�������
		double dBadBalance = 0.00;//�������
		double dInterestBalance1 = 0.00;//����ǷϢ���
		double dInterestBalance2 = 0.00;//����ǷϢ���
		double dShiftBalance = 0.00;//�ƽ���ȫʱ���
		double dTABalance = 0.00;//����ҵ��Ƿ����
		double dTAInterestBalance = 0.00;//����ҵ��Ƿ��Ϣ
		double dFineBalance1 = 0.00;//����Ϣ
		double dFineBalance2 = 0.00;//��Ϣ��Ϣ
		ASResultSet rs = null;
		SqlObject so;
		//------------------------���㱻�ϲ���ͬ�Ľ���ۺ�-------------------------------
		String sSql = "";
		//��ȡ�ϲ���ͬ���
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
		
		//��ȡ���ϲ���ͬ���
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
			
			//���½�ݱ���ԭ��ͬ�Ÿ���ΪĿ���ͬ��
			sSql = " update BUSINESS_DUEBILL  set RelativeSerialNo2 =:NewRelativeSerialNo2  where RelativeSerialNo2 =:RelativeSerialNo2 ";
			so = new SqlObject(sSql).setParameter("NewRelativeSerialNo2", sSerialNo).setParameter("RelativeSerialNo2", sObjectNo[i]);
			Sqlca.executeSQL(so);
		}
		
		//------------------------����Ӧ���ֶ�ֵ֮�͸��µ�����ͬ��Ӧ�ֶ�---------------------------
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
		//ɾ�����ϲ���ͬ�ļ�¼
		for(int i = 0;i<sObjectNo.length;i++){
			//ɾ�����ϲ���ͬ�ļ�¼
			sSql = " delete from BUSINESS_CONTRACT where SerialNo =:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo[i]);
			Sqlca.executeSQL(so);
		}
		return "true";
	}		
}
