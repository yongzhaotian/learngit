package com.amarsoft.app.lending.bizlets;

import java.math.BigDecimal;
import java.text.DecimalFormat;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class AgainWithholdCheck{

	private String sContractSerialNo; //合同流水
	
	public String getSContractSerialNo() {
		return sContractSerialNo;
	}

	public void setSContractSerialNo(String sContractSerialNo) {
		this.sContractSerialNo = sContractSerialNo;
	}

	public String runTransaction(Transaction Sqlca) throws Exception {
		ASResultSet rs = null;
		BigDecimal payAmt =new BigDecimal("0");//应还总金额
		int i = 0;
		String businessDate = SystemConfig.getBusinessDate();
		String sLoanSerialNo = "";//借据号
		BigDecimal outsourcingCollection=new BigDecimal("0");//委外催收费
		
		//非正常、逾期、代扣、注册合同
		String sSql = "select count(1) from acct_loan al,business_contract bc where al.putoutno='"+sContractSerialNo+"' and al.loanstatus in ('0','1') and bc.RepaymentWay='1' and al.putoutno=bc.serialno and bc.contractstatus='050'";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		
		rs.getStatement().close();
		if(i != 1) return "false@非正常、逾期、代扣、注册合同，不允许发起再次代扣";
		i = 0;
		
		//合同存在有效的未审批的退货申请
		sSql = "select count(1) from business_contract where serialno='"+sContractSerialNo+"' and to_char(to_date('"+businessDate+"','YYYY/MM/DD')+15,'YYYY/MM/DD')<=to_char(to_date(CONTRACTEFFECTIVEDATE,'YYYY/MM/DD')+15,'YYYY/MM/DD') ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		int j = 0;
		if(rs.next()){
			j = rs.getInt(1);
		}
		rs.getStatement().close();
		
		if(j > 0){
			sSql = "select count(1) from REFUND_CARGO where approvedate is null and serialno='"+sContractSerialNo+"'";
			rs = Sqlca.getASResultSet(new SqlObject(sSql));
			if(rs.next()){
				i = rs.getInt(1);
			}
			
			rs.getStatement().close();
			if(i > 0) return "false@合同存在有效的未审批的退货申请，不允许发起再次代扣";
			i = 0;
		}
		
		//客户已存在当天的代扣文件中
		sSql = "select count(1) from withhold_ebu_info where WITHHOLDDATE='"+businessDate+"' and CUSTOMERID=(select customerid from acct_loan where putoutno='"+sContractSerialNo+"')";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		
		rs.getStatement().close();
		if(i > 0) return "false@客户已存在当天的代扣文件中，不允许发起再次代扣";
		i = 0;
		
		sSql = "select count(1) from withhold_kft_info where WITHHOLDDATE='"+businessDate+"' and CUSTOMERID=(select customerid from acct_loan where putoutno='"+sContractSerialNo+"')";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		
		rs.getStatement().close();
		if(i > 0) return "false@客户已存在当天的代扣文件中，不允许发起再次代扣";
		i = 0;
		
		//合同已申请退款处理，且在退款流程中的
		sSql="select count(1) from refund_deposits where customerid=(select customerid from acct_loan where putoutno='"+sContractSerialNo+"') and approvedate is null";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		
		rs.getStatement().close();
		if(i != 0) return "false@该合同存在审批中的退款申请,不允许发起再次代扣";
		
		//合同已申请提前还款，且在还在审核中的
	    sSql = "select count(1) from acct_loan al,acct_trans_payment atp,acct_transaction at "+
	    	 "	where al.serialno=at.relativeobjectno and at.relativeobjecttype='jbo.app.ACCT_LOAN' and at.documentserialno=atp.serialno and at.documenttype='jbo.app.ACCT_TRANS_PAYMENT' "+
	    	 "	and at.transcode='0055' and atp.PrePayType is not null and at.transstatus='0' and al.putoutno='"+sContractSerialNo+"'";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		
		rs.getStatement().close();
		if(i != 0) return "false@该合同存在审批中的提前还款申请,不允许发起再次代扣";
		
		//当天已申请过“再次代扣”的合同，且在还在审核中的
	    sSql = "select count(1) from ls_batch_las_core blc,acct_loan al where inputdate='"+businessDate+"' and BATCHTRANSTYPE in ('1','2','0') " +
	    		" and blc.objectno=al.serialno and blc.objecttype='jbo.app.ACCT_LOAN' and al.putoutno='"+sContractSerialNo+"' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		
		rs.getStatement().close();
		if(i != 0) return "false@该合同今天已发起过再次代扣申请,不允许重复申请";
		
		//提前还款
		sSql = "select al.serialno as objectno,atp.payamt as payamount from acct_transaction at,acct_trans_payment atp,acct_loan al "+
			   " where at.transcode='0055' and at.transstatus='3' and at.transdate<='"+businessDate+"' "+
			   " and at.documentserialno=atp.serialno and at.documenttype='jbo.app.ACCT_TRANS_PAYMENT' " +
			   " and al.serialno=at.relativeobjectno and al.putoutno='"+sContractSerialNo+"' ";

		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		while(rs.next()){
			sLoanSerialNo = rs.getString("objectno");
			payAmt=payAmt.add(rs.getBigDecimal("payamount"));
		}
		rs.getStatement().close();
		//if(payAmt > 0) return "true@"+String.valueOf(payAmt)+"@"+sLoanSerialNo;
		//查询未回盘的记录
		sSql ="select count(1)    from import_norec_info t where t.customerid = (select bc.customerid from business_contract bc where bc.serialno ='"+sContractSerialNo+"')";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		rs.getStatement().close();
		if(i != 0) return "false@该合同存在未回盘,不允许发起再次代扣!";
		
		//一般还款
		sSql = "select al.serialno as objectno,sum(nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0)+nvl(aps.payinteamt,0)- "+
			       " nvl(aps.actualpayinteamt,0)) as payamount "+
					" from acct_payment_schedule aps,acct_loan al "+
					" where  ((al.serialno=aps.objectno and aps.objecttype='jbo.app.ACCT_LOAN') or   "+
					" (al.serialno=aps.relativeobjectno and aps.relativeobjecttype='jbo.app.ACCT_LOAN'))  "+
					" and (aps.finishdate is null or aps.finishdate=' ')  "+
					" and aps.paydate<='"+businessDate+"' "+
					" and al.putoutno='"+sContractSerialNo+"' "+
					" group by al.serialno";

		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			sLoanSerialNo = rs.getString("objectno");
			payAmt=payAmt.add(rs.getBigDecimal("payamount"));
		}
		rs.getStatement().close();
		
		
		//委外催收费
		sSql="select nvl(sum(nvl(cus.payoutsourcesum,0)-nvl(cus.actualcreateoutsource,0)),0) as OutsourcingCollection from consume_outsourcing_info cus "+ 
			  "where cus.contractno='"+sContractSerialNo+"' and to_char(to_date('"+businessDate+"','yyyy-MM-dd'),'yyyy-MM-dd') between to_char(to_date(cus.transferdate,'yyyy-MM-dd'),'yyyy-MM-dd') and to_char(to_date(cus.enddate,'yyyy-MM-dd'),'yyyy-MM-dd')";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			System.out.println(rs.getBigDecimal("OutsourcingCollection"));
			outsourcingCollection=rs.getBigDecimal("OutsourcingCollection");
			payAmt=payAmt.add(rs.getBigDecimal("OutsourcingCollection"));
		}
		rs.getStatement().close();
		
		if(payAmt !=null && payAmt.compareTo(BigDecimal.ZERO)>0) return "true@"+String.valueOf(payAmt)+"@"+sLoanSerialNo+"@"+String.valueOf(outsourcingCollection);
		else return "false@该合同不存在欠款，不允许发起再次代扣";
	}
}
