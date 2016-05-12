package com.amarsoft.app.lending.bizlets;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class PayMentRevisionSchedule extends Bizlet{
	private String json;
	private String contractSerialNo;
	private String userId;
	private String revisionSerialno;
	private String revisionSerialnos;
	private String objectNo;
	private int pt;					//期数
	private String customerId;		// 客户编码
	private String customerName;	// 客户姓名
	private String nextduedate;		// 下一个还款日期
	
	/** 基础统计表信息 **/
	private BOMTRUseCountVO bomtrUseCount = new BOMTRUseCountVO();
	
	/**
	 * 提交类型 （1,暂存，2.提交申请 ）
	 * 对应数据库 （1,待审批，2.审批中，3.审批通过，4.审批拒绝）
	 */
	private String submitType;
	public void test(Transaction Sqlca){
		System.out.println("json："+json);
	}

	public void onSubmitApp(Transaction Sqlca) throws Exception {
		if(this.revisionSerialno !=null && revisionSerialno.trim().length()>0){
			updateApp(Sqlca);
			return;
		}
		ASResultSet rs=null;
		String customerID = null;
		String customerName = null;
		String inputdate =null;
		StringBuffer sql = new StringBuffer();
		sql.append("select BUSINESS_CONTRACT.SerialNo as SerialNo, ");
        sql.append(" BUSINESS_CONTRACT.ApplySerialNo as ApplySerialNo, ");
        sql.append(" BUSINESS_CONTRACT.CustomerID as CustomerID,  ");         
        sql.append(" BUSINESS_CONTRACT.CustomerType as CustomerType, ");  
        sql.append(" BUSINESS_CONTRACT.salesExecutive as salesExecutive, ");
        sql.append(" getItemName('CustomerType',CustomerType) as CustomerTypeName,");         
        sql.append(" BUSINESS_CONTRACT.CustomerName as CustomerName, ");          
        sql.append(" getItemName('BusinessType',ProductID) as ProductName, ");        
        sql.append(" getItemName('SubProductType',SubProductType) as SubProductType, ");         
        sql.append(" BUSINESS_CONTRACT.BusinessType as BusinessType, ");          
        sql.append(" BUSINESS_CONTRACT.ProductID as ProductID,");                  
        sql.append(" getItemName('ContractStatus',ContractStatus) as ContractStatus,");                 
        sql.append(" BUSINESS_CONTRACT.BusinessSum as BusinessSum");          
        sql.append(" from  BUSINESS_CONTRACT");         
        sql.append(" where SerialNo ='"+getContractSerialNo()+"'");   
        rs=Sqlca.getASResultSet(new SqlObject(sql.toString()));
        if(rs.next()){
        	customerID = rs.getString("CustomerID");
        	customerName = rs.getString("CustomerName");
        	String applicant = rs.getString("salesExecutive");
        	inputdate = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");
        	StringBuffer sql1 = new StringBuffer();
        	sql1.append("INSERT INTO ACCT_PAYMENT_REVERSION");
        	sql1.append(" (SERIALNO,CONTRACT_SERIALNO,CUSTOMER_ID, CUSTOMER_NAME, STATUS,APPLICANT,APPLICANT_DATE,INPUTE_BY,INPUTE_DATE, UPDATED_BY,UPDATED_DATE)");
        	sql1.append("VALUES(:serialno,:contractSerialno,:customerId,:customerName,:status,:applicant,:applicantDate,:inputeBy,:inputeDate,:updatedBy,:updatedDate)");
        	SqlObject so = new SqlObject(sql1.toString());
        	String sr =  DBKeyHelp.getSerialNo("ACCT_PAYMENT_REVERSION","SERIALNO");
        	this.revisionSerialno=sr;
        	so.setParameter("serialno",sr);
        	so.setParameter("contractSerialno",getContractSerialNo().trim());
        	so.setParameter("customerId", customerID.trim());
        	so.setParameter("customerName", customerName.trim());
        	so.setParameter("status", submitType);
        	so.setParameter("applicant",applicant);
        	so.setParameter("applicantDate", inputdate);
        	so.setParameter("inputeBy",getUserId().trim());
        	so.setParameter("inputeDate", inputdate);
        	so.setParameter("updatedBy", getUserId().trim());
        	so.setParameter("updatedDate", inputdate);
        	Sqlca.executeSQL(so);
        	String jsons[] = json.split("\\|");
        	for(int i=0;i<jsons.length;i++){
        		String detail[] = jsons[i].split(":");
        		String paymentScheduleSerialno = detail[0];
        		String payprincipalAmt = detail[1];
        		String payprincipalRevisionAmt = detail[2];
        		String payType = null;
        		String paySQL= "select aps.paytype as payType,aps.payprincipalamt as payprincipalamt from acct_payment_schedule aps where aps.serialno='"+paymentScheduleSerialno.trim()+"'";
        		ASResultSet pay= Sqlca.getResultSet(new SqlObject(paySQL));
        		if(pay.next()){
        			payType = pay.getString("payType");
        			payprincipalAmt = pay.getString("payprincipalamt");
        		}
        		StringBuffer sql2 = new StringBuffer();
        		sql2.append("insert into Acct_Payment_Reversion_Detail");
        		sql2.append("(Serialno,Revision_Serialno,Payment_Schedule_Serialno,Payprincipal_Amt,payType,");
        		sql2.append("Payprincipal_Revision_Amt,Inpute_By,Inpute_Date,Updated_By,Updated_Date)");
        		sql2.append("VALUES(:serialNo,:revisionSerialno,:paymentScheduleSerialno,:payprincipalAmt,:payType,");
        		sql2.append(":payprincipalRevisionAmt,:inputeBy,:inputeDate,:updatedBy,:updatedDate)");
        		SqlObject so1 = new SqlObject(sql2.toString());
        		so1.setParameter("serialNo", DBKeyHelp.getSerialNo("Acct_Payment_Reversion_Detail","Serialno"));
        		so1.setParameter("revisionSerialno", sr);
        		so1.setParameter("paymentScheduleSerialno", paymentScheduleSerialno.trim());
          		so1.setParameter("payprincipalAmt", payprincipalAmt.trim());
          		so1.setParameter("payType", payType.trim());
          		so1.setParameter("payprincipalRevisionAmt", payprincipalRevisionAmt.trim());
          		so1.setParameter("inputeBy", userId);
          		so1.setParameter("inputeDate", inputdate);
          		so1.setParameter("updatedBy", userId);
          		so1.setParameter("updatedDate", inputdate);
          		Sqlca.executeSQL(so1);
        	}
        	if("2".equals(this.submitType)){//提交申请时创建交易
    			createAcctTransaction(Sqlca);
    		}
        	Sqlca.commit();
        }
        rs.getStatement().close();   
	}
	
	private void updateApp(Transaction Sqlca) throws Exception{
		String inputdate = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");
		String sql = "update ACCT_PAYMENT_REVERSION r set r.status=:status,r.UPDATED_BY=:updatedBy,r.UPDATED_DATE=:updatedDate where r.SERIALNO =:serialno"; 
		SqlObject so = new SqlObject(sql);
		so.setParameter("status", submitType);
		so.setParameter("updatedBy", getUserId());
		so.setParameter("updatedDate", inputdate);
		so.setParameter("serialno", revisionSerialno.trim());
		Sqlca.executeSQL(so);
		if("2".equals(this.submitType)){//提交申请时创建交易
			createAcctTransaction(Sqlca);
		}
		String jsons[] = json.split("\\|");
    	for(int i=0;i<jsons.length;i++){
    		String detail[] = jsons[i].split(":");
    		String paymentScheduleSerialno = detail[0];
    		String payprincipalAmt = detail[1];
    		String payprincipalRevisionAmt = detail[2];
    		String payType = null;
    		String paySQL= "select aps.paytype as payType,aps.payprincipalamt as payprincipalamt from acct_payment_schedule aps where aps.serialno='"+paymentScheduleSerialno.trim()+"'";
    		ASResultSet pay= Sqlca.getResultSet(new SqlObject(paySQL));
    		if(pay.next()){
    			payType = pay.getString("payType");
    			payprincipalAmt = pay.getString("payprincipalamt");
    		}
    		StringBuffer sql1 = new StringBuffer();
    		sql1.append("update Acct_Payment_Reversion_Detail d set d.Payprincipal_Amt=:payprincipalAmt,d.Payprincipal_Revision_Amt=:payprincipalRevisionAmt,");
    		sql1.append("d.payType=:payType,d.Updated_By=:updatedBy,d.Updated_Date=:updatedDate where d.Revision_Serialno=:revisionSerialno and d.Payment_Schedule_Serialno=:paymentScheduleSerialno");
    		SqlObject so1 = new SqlObject(sql1.toString());
    		so1.setParameter("revisionSerialno", getRevisionSerialno());
    		so1.setParameter("paymentScheduleSerialno", paymentScheduleSerialno.trim());
      		so1.setParameter("payprincipalAmt", payprincipalAmt.trim());
      		so1.setParameter("payType", payType.trim());
      		so1.setParameter("payprincipalRevisionAmt", payprincipalRevisionAmt.trim());
      		so1.setParameter("updatedBy", userId);
      		so1.setParameter("updatedDate", inputdate);
      		Sqlca.executeSQL(so1);
      		pay.getStatement().close();
    	}
    	Sqlca.commit();
		
	}
	
	/**
	 * 创建交易记录
	 * @param Sqlca
	 * @throws Exception
	 */
	private void createAcctTransaction(Transaction Sqlca) throws Exception{
		String inputdate = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");
		StringBuffer createAcctTransaction = new StringBuffer();
		createAcctTransaction.append("insert into acct_transaction ");
		createAcctTransaction.append("(serialno,");
		createAcctTransaction.append(" transcode,");
		createAcctTransaction.append(" documenttype,");
		createAcctTransaction.append(" documentserialno,");
		createAcctTransaction.append(" transname,");
		createAcctTransaction.append(" occurdate,");
		createAcctTransaction.append(" occurtime,");
		createAcctTransaction.append(" transstatus,");
		createAcctTransaction.append(" inputorgid,");
		createAcctTransaction.append(" inputuserid,");
		createAcctTransaction.append(" inputtime,");
		createAcctTransaction.append(" description,");
		createAcctTransaction.append(" transdate,");
		createAcctTransaction.append(" relativeobjectno,");
		createAcctTransaction.append(" channel,");
		createAcctTransaction.append(" relativeobjecttype)");
		createAcctTransaction.append(" values (");
		createAcctTransaction.append(":serialno,:transcode,:documenttype,:documentserialno,");
		createAcctTransaction.append(":transname,:occurdate,:occurtime,:transstatus,");
		createAcctTransaction.append(":inputorgid,:inputuserid,:inputtime,:description,");
		createAcctTransaction.append(":transdate,:relativeobjectno,:channel,:relativeobjecttype)");
		SqlObject create = new SqlObject(createAcctTransaction.toString());
		create.setParameter("serialno",  DBKeyHelp.getSerialNo("acct_transaction","serialno"));
		create.setParameter("transcode", "0121");
		create.setParameter("documenttype", "jbo.app.ACCT_PAYMENT_REVERSION");
		create.setParameter("documentserialno", revisionSerialno.trim());
		create.setParameter("transname", "还款计划修正");
		create.setParameter("occurdate",  DateX.format(new java.util.Date(),"yyyy/MM/dd"));
		create.setParameter("occurtime",  DateX.format(new java.util.Date(),"HH:mm:ss"));
		create.setParameter("transstatus","0");
		create.setParameter("inputorgid","1");
		create.setParameter("inputuserid",getUserId());
		create.setParameter("inputtime",inputdate);
		create.setParameter("description","还款计划修正");
		create.setParameter("transdate",DateX.format(new java.util.Date(),"yyyy/MM/dd"));
		create.setParameter("relativeobjectno",objectNo.trim());
		create.setParameter("channel","01");
		create.setParameter("relativeobjecttype","jbo.app.ACCT_PAYMENT_SCHEDULE");
		Sqlca.executeSQL(create);
	}
	
	/**
	 * 更新交易状态
	 * @param Sqlca 
	 * @param documentserialno
	 * @throws Exception
	 */
	private void updateAcctTransaction(Transaction Sqlca,String documentserialno)  throws Exception{
		String sql = "update acct_transaction t set t.transstatus=:status  where t.documenttype='jbo.app.ACCT_PAYMENT_REVERSION' and t.documentserialno=:documentserialno";
		SqlObject so = new SqlObject(sql);
		so.setParameter("status", "1");
		so.setParameter("documentserialno", documentserialno);
		Sqlca.executeSQL(so);
	}
	
	private void updateAcctFee(Transaction Sqlca,String serialno) throws Exception{
		StringBuffer sb = new StringBuffer();
		sb.append("select sum(d.payprincipal_amt-d.payprincipal_revision_amt)  as waiveAmt, ");
		sb.append(" sum(d.payprincipal_amt)  as totalamount,");
		sb.append(" max(s.objectno)  as objectno");
		sb.append(" from acct_payment_reversion_detail d ,acct_payment_schedule s where");
		sb.append(" s.serialno = d.payment_schedule_serialno");
		sb.append(" and d.revision_serialno=:serialno and d.paytype in ('A2','A7')  group by  d.revision_serialno,s.objectno");
		SqlObject queryso = new SqlObject(sb.toString());
		queryso.setParameter("serialno", serialno);
		 ASResultSet result= Sqlca.getResultSet(queryso);
		 while(result.next()){
			 BigDecimal waiveamount = result.getBigDecimal("waiveAmt");
			 if(waiveamount.compareTo(new BigDecimal(0))<=0){
				continue; 
			 }
			 BigDecimal totalamount = result.getBigDecimal("totalamount").subtract(waiveamount);
			 String keyserialno = result.getString("objectno");
			 String sql = "UPDATE ACCT_FEE SET WAIVEAMOUNT=:WAIVEAMOUNT, TOTALAMOUNT=:TOTALAMOUNT WHERE SERIALNO=:SERIALNO";
			 SqlObject so = new SqlObject(sql);
			 so.setParameter("WAIVEAMOUNT", waiveamount.toString());
			 so.setParameter("TOTALAMOUNT", totalamount.toString());
			 so.setParameter("SERIALNO", keyserialno);
			 Sqlca.executeSQL(so);
		 }
	}
	
	private void createAcctFeeLog(Transaction Sqlca,String serialno) throws Exception{
		// String inputdate = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");
		StringBuffer query = new StringBuffer();
	   query.append("select d.payprincipal_amt,d.payprincipal_revision_amt,d.paytype,(d.payprincipal_amt-d.payprincipal_revision_amt) as waiveAmt ,s.seqid,s.objectno,f.currency, ");
	   query.append("f.accountingorgid,f.objectno as fobjectno");
	   query.append(" from acct_payment_reversion_detail d,acct_payment_schedule s,acct_fee f ");
	   query.append(" where d.payment_schedule_serialno = s.serialno and f.serialno=s.objectno");
	   query.append(" and (d.payprincipal_amt-d.payprincipal_revision_amt)>0 ");
	   query.append(" and d.paytype in ('A2','A7')  and d.revision_serialno=:serialno");
	   SqlObject queryso = new SqlObject(query.toString());
	   queryso.setParameter("serialno", serialno);
	   ASResultSet feeResult= Sqlca.getResultSet(queryso);
	   while(feeResult.next()){
		    BigDecimal waiveamount = feeResult.getBigDecimal("waiveAmt");
//		    BigDecimal revisionAmt = feeResult.getBigDecimal("payprincipal_revision_amt");
		    BigDecimal amt = feeResult.getBigDecimal("payprincipal_amt");
		    BigDecimal waivepercent = waiveamount.divide(amt,2,BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal(100));
		    String seqid = feeResult.getString("seqid");
		    String feetype = feeResult.getString("paytype");
		    String currency = feeResult.getString("currency");
		    String feeserialno = feeResult.getString("objectno");  
		    String accountingorgid = feeResult.getString("accountingorgid");  
		    String fobjectno = feeResult.getString("fobjectno");  
		    StringBuffer sb = new StringBuffer();
			sb.append("insert into acct_fee_log ");
			sb.append("(serialno,");
			sb.append(" objecttype,");
			sb.append(" objectno,");
			sb.append(" direction,");
			sb.append(" feeamount,");
			sb.append(" accountingorgid,");
			sb.append(" currency,");
			sb.append(" status,");
			sb.append(" remark,");
			sb.append(" feeserialno,");
	        sb.append(" feetype,");
	        sb.append(" waiveamount,");
	        sb.append(" waivepercent,");
	        sb.append(" waivetype,");
	        sb.append(" transdate,");
	        sb.append(" seqid)");
	        sb.append("values(:serialno,");
	        sb.append(":objecttype,");
			sb.append(":objectno,");
			sb.append(":direction,");
			sb.append(":feeamount,");
			sb.append(":accountingorgid,");
			sb.append(":currency,");
			sb.append(":status,");
			sb.append(":remark,");
			sb.append(":feeserialno,");
	        sb.append(":feetype,");
	        sb.append(":waiveamount,");
	        sb.append(":waivepercent,");
	        sb.append(":waivetype,");
	        sb.append(":transdate,");
	        sb.append(":seqid)");
	    	SqlObject so = new SqlObject(sb.toString());
	    	so.setParameter("serialno",  DBKeyHelp.getSerialNo("acct_fee_log","serialno"));
	    	so.setParameter("objecttype", "jbo.app.ACCT_LOAN");
	    	so.setParameter("objectno", fobjectno);
	    	so.setParameter("direction", "R");
	    	so.setParameter("feeamount", amt.toString());
	    	so.setParameter("accountingorgid", accountingorgid);
	    	so.setParameter("currency", currency);
	    	so.setParameter("status", "1");
	    	so.setParameter("remark", "还款计划修正");
	    	so.setParameter("feeserialno", feeserialno);
	    	so.setParameter("feetype", feetype);
	    	so.setParameter("waiveamount", waiveamount.toString());
	    	so.setParameter("waivepercent", waivepercent.toString());
	    	so.setParameter("waivetype", "0");
	    	so.setParameter("transdate", DateX.format(new java.util.Date(),"yyyy/MM/dd"));
	    	so.setParameter("seqid", seqid);
	    	Sqlca.executeSQL(so);
	   }
		
	}
	/**
	 * 删除申请
	 * @param Sqlca
	 * @throws Exception
	 */
	public void deleteApp(Transaction Sqlca) throws Exception{
		String sql =  "delete ACCT_PAYMENT_REVERSION r where r.SERIALNO =:serialno";
		SqlObject so = new SqlObject(sql);
		so.setParameter("serialno", this.getRevisionSerialno());
		Sqlca.executeSQL(so);
		String detailSQL = "delete Acct_Payment_Reversion_Detail d where d.Payment_Schedule_Serialno=:paymentScheduleSerialno";
		SqlObject so1 = new SqlObject(detailSQL);
		so1.setParameter("paymentScheduleSerialno", this.getRevisionSerialno());
		Sqlca.executeSQL(so1);
		Sqlca.commit();
	}
	/**
	 * 提交审批
	 * @param Sqlca
	 * @throws Exception
	 */
	public void approver(Transaction Sqlca) throws Exception{
		String[] serialnos = this.revisionSerialnos.split("\\|");
		for(int i=0;i<serialnos.length;i++){
			updateAcctTransaction(Sqlca,serialnos[i].trim());//更新交易状态
			String inputdate = DateX.format(new java.util.Date(),"yyyy/MM/dd HH:mm:ss");
			String sql = "update ACCT_PAYMENT_REVERSION r set r.status=:status,r.approver=:approver,r.APPROVER_DATE=:approverDate,r.UPDATED_BY=:updatedBy,r.UPDATED_DATE=:updatedDate where r.SERIALNO =:serialno"; 
			SqlObject so = new SqlObject(sql);
			so.setParameter("status", this.submitType);
			so.setParameter("approver", getUserId());
			so.setParameter("approverDate", inputdate);
			so.setParameter("updatedBy", getUserId());
			so.setParameter("updatedDate", inputdate);
			so.setParameter("serialno", serialnos[i].trim());
			Sqlca.executeSQL(so);
			if("3".equals(this.submitType.trim())){ //审批后立即把更新后的还款计划应用到合同的还款计划中
				String detailSql = "select d.payprincipal_revision_amt as amt,d.payment_schedule_serialno as paySerialno from  Acct_Payment_Reversion_Detail d where d.payprincipal_amt<>d.payprincipal_revision_amt and d.revision_serialno =:serialno";
				SqlObject detailSo = new SqlObject(detailSql);
				detailSo.setParameter("serialno", serialnos[i].trim());
				ASResultSet rs=Sqlca.getASResultSet(detailSo);
				while(rs.next()){
					String payId = rs.getString("paySerialno");
					String amt = rs.getString("amt");
					String updateSql = "update acct_payment_schedule aps set aps.payprincipalamt=:amt where aps.serialno=:payId";
					SqlObject updateSo = new SqlObject(updateSql);
					updateSo.setParameter("amt", amt);
					updateSo.setParameter("payId", payId);
					Sqlca.executeSQL(updateSo);
				}
				String paySQL= "select apr.contract_serialno from acct_payment_reversion apr where apr.serialno=:serialno";
	    		ASResultSet pay= Sqlca.getResultSet(new SqlObject(paySQL).setParameter("serialno", serialnos[i].trim()));
	    		if(pay.next()){
	    			contractSerialNo = pay.getString("contract_serialno");
	    			pay.getStatement().close();
	    		}
			    StringBuffer sb = new StringBuffer();//更新余额
			    sb.append("update  acct_payment_schedule aps set aps.principalbalance=nvl(( ");
				sb.append("(select bc.businesssum from  business_contract bc where bc.serialno='"+contractSerialNo+"') - (select sum(aps1.payprincipalamt) ");
				sb.append(" from acct_payment_schedule aps1 ");
				sb.append(" where (aps1.objectno = aps.objectno and ");
				sb.append(" aps1.seqid < aps.seqid + 1) ");
				sb.append(" or (aps1.relativeobjectno = aps.relativeobjectno and ");
				sb.append(" aps1.seqid < aps.seqid + 1))),0) ");
				sb.append(" where (aps.objectno =(select serialno from acct_loan where putoutno = '"+contractSerialNo+"') and aps.objecttype = 'jbo.app.ACCT_LOAN' and aps.paytype = '1') ");
				sb.append(" or (aps.relativeobjectno =(select serialno from acct_loan where putoutno = '"+contractSerialNo+"') and aps.relativeobjecttype = 'jbo.app.ACCT_LOAN' and aps.paytype = '1') ");
			    String updateBalance = sb.toString();
			    SqlObject updateBalanceSo = new SqlObject(updateBalance);
			    Sqlca.executeSQL(updateBalanceSo);
				rs.getStatement().close();
				createAcctFeeLog(Sqlca,serialnos[i].trim());//创建费用日志
				updateAcctFee(Sqlca, serialnos[i].trim());//更新费用表
			}
			Sqlca.commit();
		}
	}
	
	/**
	 * 验证合同是否存在未完成的操作
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String validate(Transaction Sqlca) throws Exception{
		StringBuffer sb = new StringBuffer();
		sb.append(" select t.serialno,t.transname from acct_transaction t where (t.relativeobjectno=:putoutno or t.relativeobjectno=(select n.serialno from acct_loan n where  n.putoutno=:putoutno) or t.relativeobjectno=(select n.serialno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno))  and t.transstatus in('0','3') and  t.transcode not in('9091','9092')");
		sb.append(" UNION ALL");
		sb.append(" select t.serialno,t.transname from acct_transaction t where t.relativeobjectno in (select f.serialno from acct_fee f,acct_loan n where f.objecttype='jbo.app.ACCT_LOAN' and f.objectno=n.serialno and   n.putoutno=:putoutno) and t.transstatus in('0','3') and  t.transcode not in('9091','9092')");
		sb.append(" UNION ALL");
		sb.append(" select b.contract_no,'退保' as transname from  batch_insurance_info  b where (b.contract_no=:putoutno or b.contract_no=(select n.putoutno from acct_loan n where  n.putoutno=:putoutno) or b.contract_no=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno)) and b.status in('4','5','6')");
		sb.append(" UNION ALL");
		sb.append(" select b.serialno,'退保' as transname from  batch_mingan_insurance  b where (b.serialno=:putoutno or b.serialno=(select n.putoutno from acct_loan n where  n.putoutno=:putoutno) or b.serialno=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno)) and b.status in('3')");
		sb.append(" UNION ALL");
		sb.append(" select pa.serialno,'提前还款' as transname from  prepayment_applay  pa where (pa.contract_serialno=:putoutno or pa.contract_serialno=(select n.putoutno from acct_loan n where  n.putoutno=:putoutno) or pa.contract_serialno=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno)) and pa.status ='0'");
		sb.append(" UNION ALL");
		sb.append(" select rc.serialno,'退货' as transname  from REFUND_CARGO rc  where  rc.approveuserid is null and (rc.serialno=:putoutno or rc.serialno=(select n.putoutno from acct_loan n where  n.serialno=:putoutno) or rc.serialno=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno)) ");
		sb.append(" UNION ALL");
		sb.append(" SELECT a.CONTRACTNO, '随心还服务包取消' AS transname FROM BUSINESS_PAYPKG_APPLY A WHERE A.PKGSTATUS = '0' AND (A.CONTRACTNO=:putoutno or A.CONTRACTNO=(select n.putoutno from acct_loan n where  n.putoutno=:putoutno) or A.CONTRACTNO=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno))" );
		sb.append(" UNION ALL ");
		sb.append(" SELECT A.SERIALNO, '随心还服务申请' AS TRANSNAME FROM BOMTR_APPLY_INFO A WHERE A.STATUS ");
		sb.append(" NOT IN ('1', '2') AND (A.CONTRACTNO = :putoutno OR A.CONTRACTNO = (SELECT N.PUTOUTNO ");
		sb.append(" FROM ACCT_LOAN N WHERE N.SERIALNO = :putoutno) OR A.CONTRACTNO = (SELECT N.PUTOUTNO ");
		sb.append(" FROM ACCT_FEE F, ACCT_LOAN N WHERE F.OBJECTNO = N.SERIALNO AND F.SERIALNO = :putoutno))");
		String sql = sb.toString();
		SqlObject so = new SqlObject(sql);
		so.setParameter("putoutno", this.contractSerialNo);
		ASResultSet rs=Sqlca.getASResultSet(so);
		if(rs.next()){
			String transname = rs.getString("transname");
			rs.getStatement().close();
			return "该合同存在一项“"+transname+"”业务进行中，不允许同时申请！";
		}else{
			return "0";
		}
	}
	
	/**
	 * 校验合同号对应的随心还数据
	 * @param serialNO
	 * @param transaction
	 * @return
	 * @throws SQLException 
	 */
	public String checkBOMTRInfo(Transaction transaction) throws Exception {
		
		StringBuffer sb = new StringBuffer();
		String periods = "0";
		sb.append("SELECT CUSTOMERID, CUSTOMERNAME, PERIODS FROM BUSINESS_CONTRACT WHERE SERIALNO = :SERIALNO");
		ASResultSet rs = transaction.getASResultSet(new SqlObject(sb.toString())
								.setParameter("SERIALNO", this.contractSerialNo));
		if (rs.next()) {
			this.customerId = rs.getString("CUSTOMERID");
			this.customerName = rs.getString("CUSTOMERNAME");
			periods = rs.getString("PERIODS");
		}
		if (this.customerId == null || "".equals(this.customerId) 
				|| this.customerName == null || "".equals(this.customerName)) {
			return "找不到客户信息！";
		}
		

		//获取系统时间
		String sql = "SELECT BUSINESSDATE FROM SYSTEM_SETUP ";
		rs = transaction.getASResultSet(new SqlObject(sql));
		// 系统时间
		String sysTime = "";
		
		if (rs.next()){
			sysTime = rs.getString("BUSINESSDATE");
		}
		rs.getStatement().close();
		
		BOMTRApplyCheck check = new BOMTRApplyCheck();
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		check.setContractNo(this.contractSerialNo);
		check.setAlterType("02");
		check.setAlterValue("");
		check.setCustomerId(this.customerId);
		check.setCustomerName(this.customerName);
		check.setCurPayDate(nextduedate);
		check.setPt(periods);
		check.setInputUserId(getUserId().trim());
		check.setInputDate(sdf.format(date));
		check.setApplyTime(sysTime);
		String res = check.applyCheck(transaction);
		if (res != null && res.contains("false")) {
			return res.split("@")[1];
		}
		
		return "0";
	}
	
	/**
	 * 提交时将数据插入BOMTR_USE_COUNT
	 * @return
	 * @throws SQLException 
	 */
	public String updateBOMTRUseCount(Transaction transaction) throws SQLException{
		
		String inputdate = DateX.format(new Date(),"yyyy/MM/dd HH:mm:ss");
		
		//获取系统时间
		String sql = "SELECT BUSINESSDATE FROM SYSTEM_SETUP ";
		ASResultSet rs = transaction.getASResultSet(new SqlObject(sql));
		// 系统时间
		String sysTime = "";
		String period = "";
		
		if (rs.next()){
			sysTime = rs.getString("BUSINESSDATE");
		}
		rs.getStatement().close();
		
		//判断期次，后续将根据期次的取值来决定BOMTR_CONFIG的WHERE条件
		if (pt <= 12) {
			period = "12";
		} else if (pt <= 24 && pt > 12) {
			period = "1224";
		} else if (pt <= 36 && pt > 24) {
			period = "2436";
		} else {
			period = "2436";
		}
		rs.getStatement().close();
		
		//根据期次在BOMTR_CONFIG中取值
		sql = "SELECT DELAYREPAY, ALTERPAYDATE, FAVREPAYMENT, DR_PRE_APPLYDAYS, AP_PRE_APPLYDAYS, "
			+ "FR_PRE_APPLYDAYS, MAX_DELSEQS, DR_FIRST_SERPSEQS, DR_SEC_SERPSEQS, AP_FIRST_SERPSEQS, "
			+ "AP_SEC_SERPSEQS, FR_FIRST_SERPSEQS, TOTAL_CNT FROM BOMTR_CONFIG WHERE PERIOD_TIME = :PERIOD_TIME";
		rs = transaction.getASResultSet(new SqlObject(sql).setParameter("PERIOD_TIME", period));
		if(rs.next()){
			bomtrUseCount.setObjectNO(contractSerialNo);
			bomtrUseCount.setObjectType("1");
			bomtrUseCount.setCustomerId(customerId);
			bomtrUseCount.setCustomerName(customerName);
			bomtrUseCount.setTotalUseCnt(rs.getInt("TOTAL_CNT"));
			bomtrUseCount.setDrUseCnt(rs.getInt("DELAYREPAY"));
			bomtrUseCount.setApUseCnt(rs.getInt("ALTERPAYDATE"));
			bomtrUseCount.setFrUseCnt(rs.getInt("FAVREPAYMENT"));
			bomtrUseCount.setTotalUsedCnt(0);
			bomtrUseCount.setDrUsedCnt(0);
			bomtrUseCount.setApUsedCnt(0);
			bomtrUseCount.setFrUsedCnt(0);
			bomtrUseCount.setDrPreApplyDays(rs.getInt("DR_PRE_APPLYDAYS"));
			bomtrUseCount.setApPreApplyDays(rs.getInt("AP_PRE_APPLYDAYS"));
			bomtrUseCount.setFrPreApplyDays(rs.getInt("FR_PRE_APPLYDAYS"));
			bomtrUseCount.setMaxDelSeqs(rs.getInt("MAX_DELSEQS"));
			bomtrUseCount.setDrFirstSeRPSeqs(rs.getInt("DR_FIRST_SERPSEQS"));
			bomtrUseCount.setDrSecSeRPSeqs(rs.getInt("DR_SEC_SERPSEQS"));
			bomtrUseCount.setApFirstSeRPSeqs(rs.getInt("AP_FIRST_SERPSEQS"));
			bomtrUseCount.setApSecSeRPSeqs(rs.getInt("AP_SEC_SERPSEQS"));
			bomtrUseCount.setFrFirstSeRPSeqs(rs.getInt("FR_FIRST_SERPSEQS"));
		}
		rs.getStatement().close();
		
		//将所有值插入BOMTR_USE_COUNT中
		StringBuffer sb = new StringBuffer("INSERT INTO BOMTR_USE_COUNT (OBJECTNO, OBJECTTYPE, CUSTOMERID, ");
		sb.append("CUSTOMERNAME, TOTAL_USE_CNT, DR_USE_CNT, AP_USE_CNT, FR_USE_CNT, TOTAL_USED_CNT, DR_USED_CNT, ");
		sb.append("AP_USED_CNT, FR_USED_CNT, DR_PRE_APPLYDAYS, AP_PRE_APPLYDAYS, FR_PRE_APPLYDAYS, MAX_DELSEQS, ");
		sb.append("DR_FIRST_SERPSEQS, AP_FIRST_SERPSEQS, FR_FIRST_SERPSEQS, DR_SEC_SERPSEQS, AP_SEC_SERPSEQS, ");
		sb.append("INPUT_USERID, INPUT_TIME, INPUT_SYSDATE, UPDATE_USERID, UPDATE_TIME, UPDATE_SYSDATE) VALUES ");
		sb.append("(:OBJECTNO, :OBJECTTYPE, :CUSTOMERID, :CUSTOMERNAME, :TOTAL_USE_CNT, :DR_USE_CNT, :AP_USE_CNT, ");
		sb.append(":FR_USE_CNT, :TOTAL_USED_CNT, :DR_USED_CNT, :AP_USED_CNT, :FR_USED_CNT, :DR_PRE_APPLYDAYS, ");
		sb.append(":AP_PRE_APPLYDAYS, :FR_PRE_APPLYDAYS, :MAX_DELSEQS, :DR_FIRST_SERPSEQS, :AP_FIRST_SERPSEQS, ");
		sb.append(":FR_FIRST_SERPSEQS, :DR_SEC_SERPSEQS, :AP_SEC_SERPSEQS, :INPUT_USERID, :INPUT_TIME, :INPUT_SYSDATE, ");
		sb.append(":UPDATE_USERID, :UPDATE_TIME, :UPDATE_SYSDATE) ");
		
		try{
			transaction.executeSQL(new SqlObject(sb.toString())
				.setParameter("OBJECTNO", bomtrUseCount.getObjectNO())
				.setParameter("OBJECTTYPE", "1")
				.setParameter("CUSTOMERID", bomtrUseCount.getCustomerId())
				.setParameter("CUSTOMERNAME", bomtrUseCount.getCustomerName())
				.setParameter("TOTAL_USE_CNT", bomtrUseCount.getTotalUseCnt())
				.setParameter("DR_USE_CNT", bomtrUseCount.getDrUseCnt())
				.setParameter("AP_USE_CNT", bomtrUseCount.getApUseCnt())
				.setParameter("FR_USE_CNT", bomtrUseCount.getFrUseCnt())
				.setParameter("TOTAL_USED_CNT", "0")
				.setParameter("DR_USED_CNT", "0")
				.setParameter("AP_USED_CNT", "0")
				.setParameter("FR_USED_CNT", "0")
				.setParameter("DR_PRE_APPLYDAYS", bomtrUseCount.getDrPreApplyDays())
				.setParameter("AP_PRE_APPLYDAYS", bomtrUseCount.getApPreApplyDays())
				.setParameter("FR_PRE_APPLYDAYS", bomtrUseCount.getFrPreApplyDays())
				.setParameter("MAX_DELSEQS", bomtrUseCount.getMaxDelSeqs())
				.setParameter("DR_FIRST_SERPSEQS", bomtrUseCount.getDrFirstSeRPSeqs())
				.setParameter("DR_SEC_SERPSEQS", bomtrUseCount.getDrSecSeRPSeqs())
				.setParameter("AP_FIRST_SERPSEQS", bomtrUseCount.getApFirstSeRPSeqs())
				.setParameter("AP_SEC_SERPSEQS", bomtrUseCount.getApSecSeRPSeqs())
				.setParameter("FR_FIRST_SERPSEQS", bomtrUseCount.getFrFirstSeRPSeqs())
				.setParameter("INPUT_USERID", getUserId().trim())
				.setParameter("INPUT_TIME", inputdate)
				.setParameter("INPUT_SYSDATE", sysTime)
				.setParameter("UPDATE_USERID", getUserId().trim())
				.setParameter("UPDATE_TIME", inputdate)
				.setParameter("UPDATE_SYSDATE", sysTime));
		} catch (Exception e) {
			e.printStackTrace();
			ARE.getLog().error(e.getMessage());
			return "false@系统异常，请联系IT相关人员！";
		}
		return "true";
	}
	
	/**
	 * 验证是否有更改数据
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String validateModify(Transaction Sqlca)throws Exception{
		String detailSql = "select count(1) from  Acct_Payment_Reversion_Detail d where (d.payprincipal_amt-d.payprincipal_revision_amt)>0 and d.revision_serialno =:serialno";
		SqlObject detailSo = new SqlObject(detailSql);
		detailSo.setParameter("serialno", revisionSerialno.trim());
		int count=Sqlca.executeSQL(detailSo);
		if(count>0){
			return "1";
		}else{
			return "0";
		}
	}
	
	@Override
	public Object run(Transaction arg0) throws Exception {
		System.out.println("json：");
		return null;
	}

	public String getJson() {
		return json;
	}

	public void setJson(String json) {
		this.json = json;
	}

	public String getContractSerialNo() {
		return contractSerialNo;
	}

	public void setContractSerialNo(String contractSerialNo) {
		this.contractSerialNo = contractSerialNo;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getRevisionSerialno() {
		return revisionSerialno;
	}

	public void setRevisionSerialno(String revisionSerialno) {
		this.revisionSerialno = revisionSerialno;
	}

	public String getSubmitType() {
		return submitType;
	}

	public void setSubmitType(String submitType) {
		this.submitType = submitType;
	}

	public String getRevisionSerialnos() {
		return revisionSerialnos;
	}

	public void setRevisionSerialnos(String revisionSerialnos) {
		this.revisionSerialnos = revisionSerialnos;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}
	
	public String getNextduedate() {
		return nextduedate;
	}

	public void setNextduedate(String nextduedate) {
		this.nextduedate = nextduedate;
	}

	/**
	 * 随心还使用次数统计表
	 * @author kailh
	 */
	class BOMTRUseCountVO {
		
		/** OBJECTNO -- 合同号/客户编码 **/
		private String objectNO;
		
		/** OBJECTTYPE -- 1-合同号,2-客户编码 **/
		private String objectType;
		
		/** CUSTOMERID -- 客户ID **/
		private String customerId;
		
		/** CUSTOMERNAME -- 客户姓名 **/
		private String customerName;
		
		/** TOTAL_USE_CNT -- 总共可使用次数 **/
		private int totalUseCnt;
		
		/** DR_USE_CNT -- 延期还款可使用次数 **/
		private int drUseCnt;
		
		/** AP_USE_CNT -- 变更还款日可使用次数 **/
		private int apUseCnt;
		
		/** FR_USE_CNT -- 优惠提前还款可使用次数 **/
		private int frUseCnt;
		
		/** TOTAL_USED_CNT -- 总共已使用次数 **/
		private int totalUsedCnt;
		
		/** DR_USED_CNT -- 延期还款已使用次数 **/
		private int drUsedCnt;
		
		/** AP_USED_CNT -- 变更还款日已使用次数 **/
		private int apUsedCnt;
		
		/** FR_USED_CNT -- 优惠提前还款已使用次数 **/
		private int frUsedCnt;
		
		/** DR_PRE_APPLYDAYS -- 延期还款提前几天申请 **/
		private int drPreApplyDays;
		
		/** AP_PRE_APPLYDAYS -- 变更还款日提前几天申请 **/
		private int apPreApplyDays;
		
		/** FR_PRE_APPLYDAYS -- 优惠提前还款提前几天申请 **/
		private int frPreApplyDays;
		
		/** MAX_DELSEQS -- 最多延期期数 **/
		private int maxDelSeqs;
		
		/** DR_FIRST_SERPSEQS -- 延期还款首次使用连续还款期数 **/
		private int drFirstSeRPSeqs;
		
		/** DR_SEC_SERPSEQS -- 延期还款第二次使用时连续还款期数 **/
		private int drSecSeRPSeqs;
		
		/** AP_FIRST_SERPSEQS -- 变更还款日首次使用连续还款期数 **/
		private int apFirstSeRPSeqs;
		
		/** AP_SEC_SERPSEQS -- 变更还款日第二次使用时连续还款期数 **/
		private int apSecSeRPSeqs;
		
		/** FR_FIRST_SERPSEQS -- 优惠提前还款首次使用连续还款期数 **/
		private int frFirstSeRPSeqs;
		
		public BOMTRUseCountVO() {
			
		}

		public String getObjectNO() {
			return objectNO;
		}

		public void setObjectNO(String objectNO) {
			this.objectNO = objectNO;
		}

		public String getObjectType() {
			return objectType;
		}

		public void setObjectType(String objectType) {
			this.objectType = objectType;
		}

		public String getCustomerId() {
			return customerId;
		}

		public void setCustomerId(String customerId) {
			this.customerId = customerId;
		}

		public String getCustomerName() {
			return customerName;
		}

		public void setCustomerName(String customerName) {
			this.customerName = customerName;
		}

		public int getTotalUseCnt() {
			return totalUseCnt;
		}

		public void setTotalUseCnt(int totalUseCnt) {
			this.totalUseCnt = totalUseCnt;
		}

		public int getDrUseCnt() {
			return drUseCnt;
		}

		public void setDrUseCnt(int drUseCnt) {
			this.drUseCnt = drUseCnt;
		}

		public int getApUseCnt() {
			return apUseCnt;
		}

		public void setApUseCnt(int apUseCnt) {
			this.apUseCnt = apUseCnt;
		}

		public int getFrUseCnt() {
			return frUseCnt;
		}

		public void setFrUseCnt(int frUseCnt) {
			this.frUseCnt = frUseCnt;
		}

		public int getTotalUsedCnt() {
			return totalUsedCnt;
		}

		public void setTotalUsedCnt(int totalUsedCnt) {
			this.totalUsedCnt = totalUsedCnt;
		}

		public int getDrUsedCnt() {
			return drUsedCnt;
		}

		public void setDrUsedCnt(int drUsedCnt) {
			this.drUsedCnt = drUsedCnt;
		}

		public int getApUsedCnt() {
			return apUsedCnt;
		}

		public void setApUsedCnt(int apUsedCnt) {
			this.apUsedCnt = apUsedCnt;
		}

		public int getFrUsedCnt() {
			return frUsedCnt;
		}

		public void setFrUsedCnt(int frUsedCnt) {
			this.frUsedCnt = frUsedCnt;
		}

		public int getDrPreApplyDays() {
			return drPreApplyDays;
		}

		public void setDrPreApplyDays(int drPreApplyDays) {
			this.drPreApplyDays = drPreApplyDays;
		}

		public int getApPreApplyDays() {
			return apPreApplyDays;
		}

		public void setApPreApplyDays(int apPreApplyDays) {
			this.apPreApplyDays = apPreApplyDays;
		}

		public int getFrPreApplyDays() {
			return frPreApplyDays;
		}

		public void setFrPreApplyDays(int frPreApplyDays) {
			this.frPreApplyDays = frPreApplyDays;
		}

		public int getMaxDelSeqs() {
			return maxDelSeqs;
		}

		public void setMaxDelSeqs(int maxDelSeqs) {
			this.maxDelSeqs = maxDelSeqs;
		}

		public int getDrFirstSeRPSeqs() {
			return drFirstSeRPSeqs;
		}

		public void setDrFirstSeRPSeqs(int drFirstSeRPSeqs) {
			this.drFirstSeRPSeqs = drFirstSeRPSeqs;
		}

		public int getDrSecSeRPSeqs() {
			return drSecSeRPSeqs;
		}

		public void setDrSecSeRPSeqs(int drSecSeRPSeqs) {
			this.drSecSeRPSeqs = drSecSeRPSeqs;
		}

		public int getApFirstSeRPSeqs() {
			return apFirstSeRPSeqs;
		}

		public void setApFirstSeRPSeqs(int apFirstSeRPSeqs) {
			this.apFirstSeRPSeqs = apFirstSeRPSeqs;
		}

		public int getApSecSeRPSeqs() {
			return apSecSeRPSeqs;
		}

		public void setApSecSeRPSeqs(int apSecSeRPSeqs) {
			this.apSecSeRPSeqs = apSecSeRPSeqs;
		}

		public int getFrFirstSeRPSeqs() {
			return frFirstSeRPSeqs;
		}

		public void setFrFirstSeRPSeqs(int frFirstSeRPSeqs) {
			this.frFirstSeRPSeqs = frFirstSeRPSeqs;
		}
	}
}
