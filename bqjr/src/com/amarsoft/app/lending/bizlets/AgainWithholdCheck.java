package com.amarsoft.app.lending.bizlets;

import java.math.BigDecimal;
import java.text.DecimalFormat;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class AgainWithholdCheck{

	private String sContractSerialNo; //��ͬ��ˮ
	
	public String getSContractSerialNo() {
		return sContractSerialNo;
	}

	public void setSContractSerialNo(String sContractSerialNo) {
		this.sContractSerialNo = sContractSerialNo;
	}

	public String runTransaction(Transaction Sqlca) throws Exception {
		ASResultSet rs = null;
		BigDecimal payAmt =new BigDecimal("0");//Ӧ���ܽ��
		int i = 0;
		String businessDate = SystemConfig.getBusinessDate();
		String sLoanSerialNo = "";//��ݺ�
		BigDecimal outsourcingCollection=new BigDecimal("0");//ί����շ�
		
		//�����������ڡ����ۡ�ע���ͬ
		String sSql = "select count(1) from acct_loan al,business_contract bc where al.putoutno='"+sContractSerialNo+"' and al.loanstatus in ('0','1') and bc.RepaymentWay='1' and al.putoutno=bc.serialno and bc.contractstatus='050'";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		
		rs.getStatement().close();
		if(i != 1) return "false@�����������ڡ����ۡ�ע���ͬ�����������ٴδ���";
		i = 0;
		
		//��ͬ������Ч��δ�������˻�����
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
			if(i > 0) return "false@��ͬ������Ч��δ�������˻����룬���������ٴδ���";
			i = 0;
		}
		
		//�ͻ��Ѵ��ڵ���Ĵ����ļ���
		sSql = "select count(1) from withhold_ebu_info where WITHHOLDDATE='"+businessDate+"' and CUSTOMERID=(select customerid from acct_loan where putoutno='"+sContractSerialNo+"')";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		
		rs.getStatement().close();
		if(i > 0) return "false@�ͻ��Ѵ��ڵ���Ĵ����ļ��У����������ٴδ���";
		i = 0;
		
		sSql = "select count(1) from withhold_kft_info where WITHHOLDDATE='"+businessDate+"' and CUSTOMERID=(select customerid from acct_loan where putoutno='"+sContractSerialNo+"')";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		
		rs.getStatement().close();
		if(i > 0) return "false@�ͻ��Ѵ��ڵ���Ĵ����ļ��У����������ٴδ���";
		i = 0;
		
		//��ͬ�������˿�������˿������е�
		sSql="select count(1) from refund_deposits where customerid=(select customerid from acct_loan where putoutno='"+sContractSerialNo+"') and approvedate is null";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		
		rs.getStatement().close();
		if(i != 0) return "false@�ú�ͬ���������е��˿�����,���������ٴδ���";
		
		//��ͬ��������ǰ������ڻ�������е�
	    sSql = "select count(1) from acct_loan al,acct_trans_payment atp,acct_transaction at "+
	    	 "	where al.serialno=at.relativeobjectno and at.relativeobjecttype='jbo.app.ACCT_LOAN' and at.documentserialno=atp.serialno and at.documenttype='jbo.app.ACCT_TRANS_PAYMENT' "+
	    	 "	and at.transcode='0055' and atp.PrePayType is not null and at.transstatus='0' and al.putoutno='"+sContractSerialNo+"'";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		
		rs.getStatement().close();
		if(i != 0) return "false@�ú�ͬ���������е���ǰ��������,���������ٴδ���";
		
		//��������������ٴδ��ۡ��ĺ�ͬ�����ڻ�������е�
	    sSql = "select count(1) from ls_batch_las_core blc,acct_loan al where inputdate='"+businessDate+"' and BATCHTRANSTYPE in ('1','2','0') " +
	    		" and blc.objectno=al.serialno and blc.objecttype='jbo.app.ACCT_LOAN' and al.putoutno='"+sContractSerialNo+"' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		
		rs.getStatement().close();
		if(i != 0) return "false@�ú�ͬ�����ѷ�����ٴδ�������,�������ظ�����";
		
		//��ǰ����
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
		//��ѯδ���̵ļ�¼
		sSql ="select count(1)    from import_norec_info t where t.customerid = (select bc.customerid from business_contract bc where bc.serialno ='"+sContractSerialNo+"')";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			i = rs.getInt(1);
		}
		rs.getStatement().close();
		if(i != 0) return "false@�ú�ͬ����δ����,���������ٴδ���!";
		
		//һ�㻹��
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
		
		
		//ί����շ�
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
		else return "false@�ú�ͬ������Ƿ����������ٴδ���";
	}
}
