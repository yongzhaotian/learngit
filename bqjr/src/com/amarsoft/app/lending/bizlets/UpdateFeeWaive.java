package com.amarsoft.app.lending.bizlets;

import java.sql.PreparedStatement;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class UpdateFeeWaive extends Bizlet {

	
	public Object run(Transaction Sqlca) throws Exception {
		//获取费用流水号,期次,减免金额,录入日期,录入人,录入机构,交易流水号
		String sFeeSerialNo=(String)this.getAttribute("FeeSerialNo");
		String sSeqID=(String)this.getAttribute("SeqID");
		String sInputTime=SystemConfig.getBusinessDate();
		String sInputUserID=(String)this.getAttribute("InputUserID");	
		String sInputOrgID=(String)this.getAttribute("InputOrgID");
		String sWaiveAmount=(String)this.getAttribute("WaiveAmount");
		String sObjectNo=(String)this.getAttribute("ObjectNo");

		
		if(sFeeSerialNo==null || sFeeSerialNo.equals("")) throw new Exception("费用流水号不存在，请检查");
		if(sSeqID==null  || sSeqID.equals("")) throw new Exception("acct_payment_schedule里没找到对应的记录");
		if(sWaiveAmount==null  || sWaiveAmount.equals("")) sWaiveAmount="0.00";
		if(sInputTime==null) sInputTime="";
		if(sInputUserID==null) sInputUserID="";
		if(sInputOrgID==null) sInputOrgID="";
		if(sObjectNo==null) sObjectNo="";
		
		String sSql="select count(1) from acct_fee_waive where remark=:remark";
		ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("remark", sObjectNo));
		int i=0;
		if(rs.next()){
			i=rs.getInt(1);
			if(i>0){
				String updateSql="update acct_fee_waive set waivefromstage=:waivefromstage,waiveamount=:waiveamount where remark=:remark ";
				Sqlca.executeSQL(new SqlObject(updateSql).setParameter("waivefromstage", sSeqID).setParameter("waiveamount", sWaiveAmount).setParameter("remark", sObjectNo));
				rs.close();
				return "true";
			}
		}
		rs.close();
		
		sSql="select serialno from acct_fee_waive where objectno=:objectno and waivefromstage=:waivefromstage and status='1'";
		rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("objectno", sFeeSerialNo).setParameter("waivefromstage", sSeqID));
		if(rs.next()){
			return "1";
		}
		rs.getStatement().close();
		
		String InsertSql="insert into acct_fee_waive(serialno,objecttype,objectno,status,waivefromstage,inputuser,inputorg,inputtime,waiveamount,remark) "
				+" values(?,'jbo.app.ACCT_FEE',?,'1',?,?,?,?,?,?)";
		
		String sSerialno=DBKeyHelp.getSerialNo("ACCT_FEE_WAIVE","SERIALNO","");
		PreparedStatement  ps=null;
		try {	

			ps=Sqlca.getConnection().prepareStatement(InsertSql);
			ps.setString(1,sSerialno);
			ps.setString(2, sFeeSerialNo);
			ps.setString(3,sSeqID);
			ps.setString(4, sInputUserID);
			ps.setString(5, sInputOrgID);
			ps.setString(6, sInputTime);
			ps.setString(7, sWaiveAmount);
			ps.setString(8, sObjectNo);
			ps.executeUpdate();
			
			ps.close();
		} catch (Exception e) {
			if(ps!=null) ps.close();
			e.printStackTrace();
			return "false";
		}
		
		return "true";
	}

}
