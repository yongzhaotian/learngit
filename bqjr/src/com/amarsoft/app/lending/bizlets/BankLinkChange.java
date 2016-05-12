package com.amarsoft.app.lending.bizlets;

import java.sql.PreparedStatement;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class BankLinkChange extends Bizlet {

	
	public Object run(Transaction Sqlca) throws Exception {
		//客户号,旧更新日期，旧更新用户，旧更新机构，当前更新机构，当前更新用户，贷方金额，进账流水号
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sUpdateDate = (String)this.getAttribute("UpdateDate");
		String sUpdateUserID = (String)this.getAttribute("UpdateUserID");
		String sUpdateOrgID = (String)this.getAttribute("UpdateOrgID");
		String sCurOrg = (String)this.getAttribute("CurOrg");
		String sCurUser = (String)this.getAttribute("CurUser");
		String sTrsAmtC = (String)this.getAttribute("TrsAmtC");
		String sSerialno = (String)this.getAttribute("Serialno");
		
		if(sCurOrg == null || sCurOrg.length() == 0) sTrsAmtC = "";
		if(sCurUser == null || sCurUser.length() == 0) sCurUser = "";
		if(sTrsAmtC == null || sTrsAmtC.length() == 0) sTrsAmtC = "0.0";
		
		String sBusinessDate=SystemConfig.getBusinessDate();
		
		//插入分离日终
		String sInsertSql="insert into bank_link_log (SERIALNO,CUSTOMERID,OLDUPDATEDATE,OLDMATCHINGFLAG,OLDUPDATEUSERID,OLDUPDATEORGID,UPDATEDATE,MATCHINGFLAG,UPDATEUSERID,UPDATEORGID) "+
                       " values(?,?,?,'3',?,?,?,'1',?,?) ";
		PreparedStatement  ps=null;
		try {	
			
			ps=Sqlca.getConnection().prepareStatement(sInsertSql);
			ps.setString(1,sSerialno);
			ps.setString(2,sCustomerID);
			ps.setString(3,sUpdateDate);
			ps.setString(4,sUpdateUserID);
			ps.setString(5,sUpdateOrgID);
			ps.setString(6,sBusinessDate);
			ps.setString(7,sCurUser);
			ps.setString(8,sCurOrg);
			ps.executeUpdate();
			
			ps.close();
		} catch (Exception e) {
			if(ps!=null) ps.close();
			e.printStackTrace();
			return "false";
		}
		
		if(!sBusinessDate.equals(sUpdateDate)){
			//插入变更日志
			String sSql="select nvl(debitbalance,0) as LastCreditBalance from acct_subsidiary_ledger where accountcodeno='Customer21' and objectno=:CustomerID and objecttype='jbo.app.CUSTOMER_INFO'";
			
			ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID", sCustomerID));
			double sLastCreditBalance=0.00;
			if(rs.next()){
				sLastCreditBalance=rs.getDouble("LastCreditBalance");
			}
			rs.close();
			
			sSql = "insert into batch_advance_log (SERIALNO, INPUTDATE, CUSTOMERID, LASTCREDITBALANCE, CREDITBALANCE, OBJECTTYPE) "+
						" values (?,?,?,?,?,?)";
			String serialNo = DBKeyHelp.getSerialNo("BATCH_ADVANCE_LOG", "SERIALNO", "");
			PreparedStatement  p = null;
			try {	
				
				p=Sqlca.getConnection().prepareStatement(sSql);
				p.setString(1,serialNo);
				p.setString(2,sBusinessDate);
				p.setString(3,sCustomerID);
				p.setDouble(4,sLastCreditBalance);
				p.setDouble(5,sLastCreditBalance-Double.parseDouble(sTrsAmtC));
				p.setString(6,"4");
				
				p.executeUpdate();
				
				p.close();
			} catch (Exception e) {
				if(p!=null) p.close();
				e.printStackTrace();
				return "false";
			}
			
			//更新客户预存款
			String updateSql="update acct_subsidiary_ledger set debitbalance=debitbalance-:debitbalance where accountcodeno='Customer21' and objectno=:Customerid and objecttype='jbo.app.CUSTOMER_INFO' ";
			Sqlca.executeSQL(new SqlObject(updateSql).setParameter("debitbalance", sTrsAmtC).setParameter("Customerid", sCustomerID));
		}
		
		//更新进账信息
		String updateSql1="update bank_link_info set CUSTOMERID='',MATCHINGFLAG='1',UPDATEORGID=:UPDATEORGID,UPDATEUSERID=:UPDATEUSERID,UPDATEDATE=:UPDATEDATE where SERIALNO=:SERIALNO ";
		Sqlca.executeSQL(new SqlObject(updateSql1).setParameter("UPDATEORGID", sCurOrg).setParameter("UPDATEUSERID", sCurUser).setParameter("UPDATEDATE", sBusinessDate).setParameter("SERIALNO", sSerialno));
				
		return "success";
	}	
}
