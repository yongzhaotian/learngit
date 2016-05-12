package com.amarsoft.app.lending.bizlets;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.Arith;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.awe.util.json.JSONObject;

public class PaymentApply {
	private String serialNo;//������ˮ��
	private String contractNo;//��ͬ��
	private String userId;//�����û�
	private String orgid;//�����û�
	private String prepayFactorageFlag;//�Ƿ���ȡ��ǰ����������
	private String planExecuteDate;//�ƻ�ִ������
	private String executableDate;//��ִ������
	private String isbomtr;	// �Ƿ�ʹ���Ż���ǰ����
	/**
	 * ����
	 * @param Sqlca
	 * @return
	 */
	public String  prePaymentApply(Transaction Sqlca) {
		try {
			Map<String, Object> map  = qureyPerpaymentAmt(Sqlca);
			boolean isOutofDate = (Boolean) map.get("isOutofDate");
			if(isOutofDate){
				return "failure@��ǰ�����ִ�����ڴ�����һ�������ڣ�����������";
			}
			if("1".equals(map.get("loanstatus"))){
				return "failure@��ͬΪ����״̬������������";
			}
			if(validateBalence(map) == false){
				return "failure@��ǰ�������ʣ�౾����ȣ�����������";
			}
			String date = DateX.format(new Date(), "yyyy/MM/dd hh:mm:ss");
			String sql = " insert into prepayment_applay(serialno, contract_serialno, laon_serialno,customer_id, executable_date,nextduedate, "
					+ " plan_executable_date, status, payamt, prepayprincipal_amt, prepayinte_amt, finance_amt, "
					+ " customer_amt, insurance_amt, stamp_duty_amt, prepay_factorage_amt, prepay_factorage_flag,in_Hesitate_Date, "
					+ " applay_orgid, applicant_by, applicant_date,currency,prepaytype, accounting_orgid,"
					+ " inputuserid, input_date, modify_by, modify_date, bugpayamt, is_bomtr) values("
					+ " :serialno, :contractSerialno,:laonSerialno, :customerId, :executableDate,:nextduedate,"
					+ " :planExecutableDate, :status, :payamt, :prepayprincipalAmt, :prepayinteAmt, :financeAmt,"
					+ " :customerAmt, :insuranceAmt, :stampDutyAmt, :prepayFactorageAmt, :prepayFactorageFlag,:inHesitateDate,"
					+ " :applayOrgid, :applicantBy, :applicantDate,:currency,:prepaytype,:accountingOrgid,"
					+ " :inputuserid, :inputDate, :modifyBy, :modifyDate, :bugpayamt, :is_bomtr)";
			SqlObject so = new SqlObject(sql);
			so.setParameter("serialno", DBKeyUtils.getSerialNo());
			so.setParameter("contractSerialno", getContractNo());  
			so.setParameter("laonSerialno", (String)map.get("laonSerialno"));
			so.setParameter("customerId", (String)map.get("customerId"));
			so.setParameter("executableDate", getExecutableDate());
			so.setParameter("nextduedate", (String)map.get("nextduedate"));
			so.setParameter("planExecutableDate", getPlanExecuteDate());
			so.setParameter("status", "0");
			so.setParameter("payamt", (Double)map.get("payamt"));
			so.setParameter("prepayprincipalAmt", (Double)map.get("prepayprincipalAmt"));
			so.setParameter("prepayinteAmt", (Double)map.get("prepayinteAmt"));
			so.setParameter("financeAmt", (Double)map.get("financeAmt"));
			so.setParameter("customerAmt", (Double)map.get("customerAmt"));
			so.setParameter("insuranceAmt", (Double)map.get("insuranceAmt"));
			so.setParameter("stampDutyAmt", (Double)map.get("stampDutyAmt"));
			so.setParameter("prepayFactorageAmt", (Double)map.get("prepayFactorageAmt"));
			so.setParameter("prepayFactorageFlag", getPrepayFactorageFlag());
			so.setParameter("inHesitateDate", (Boolean)map.get("inHesitateDate"));
			so.setParameter("currency", (String)map.get("currency"));
			so.setParameter("prepaytype", "10");
			so.setParameter("accountingOrgid", (String)map.get("accountingOrgid"));
			so.setParameter("applayOrgid", getOrgid());
			so.setParameter("applicantBy",  getUserId());
			so.setParameter("applicantDate", date);
			so.setParameter("inputuserid", getUserId());
			so.setParameter("inputDate", date);
			so.setParameter("modifyBy",  getUserId());
			so.setParameter("modifyDate", date);
			so.setParameter("bugpayamt", map.get("bugpayamt").toString());
			so.setParameter("is_bomtr", (String)map.get("is_bomtr"));
			Sqlca.executeSQL(so);
			return "success@������ǰ����ɹ�";
		} catch (Exception e) {
			e.printStackTrace();
			try {
				Sqlca.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			ARE.getLog().error("������ǰ����ʧ��"+e.getMessage());
		}
		return "failure@������ǰ����ʧ�ܣ�ϵͳ�쳣";
	}
	
	/**
	 * ����ͨ��
	 * @param Sqlca
	 * @return
	 */
	public String PrepayMentApprover(Transaction Sqlca){
		try {
			PrepaymentVo vo = null;
			String sql = "  select pa.serialno,pa.contract_serialno,pa.laon_serialno,pa.accounting_orgid,pa.customer_id,pa.executable_date,"
					+" pa.plan_executable_date,pa.status,pa.payamt,pa.prepaytype,pa.currency,pa.prepayprincipal_amt,pa.in_Hesitate_Date,"
					+" pa.prepayinte_amt,pa.finance_amt,pa.customer_amt,pa.insurance_amt,pa.stamp_duty_amt,pa.prepay_factorage_amt, pa.bugpayamt, "
					+" pa.is_bomtr from prepayment_applay pa  where pa.serialno ='"+getSerialNo()+"' and pa.status ='0' for update";
			ASResultSet result = Sqlca.getASResultSet(sql);
			if(result.next()){
				vo = new PrepaymentVo();
				vo.setContractSerialno(result.getString("contract_serialno"));
				vo.setCurrency(result.getString("currency"));
				vo.setCustomerAmt(result.getDouble("customer_amt"));
				vo.setAccountingOrgid(result.getString("accounting_orgid"));
				vo.setCustomerId(result.getString("customer_id"));
				vo.setExecutableDate(result.getString("executable_date"));
				vo.setFinanceAmt(result.getDouble("finance_amt"));
				vo.setInsuranceAmt(result.getDouble("insurance_amt"));
				vo.setLaonSerialno(result.getString("laon_serialno"));
				vo.setPayamt(result.getDouble("payamt"));
				vo.setPlanExecutableDate(result.getString("plan_executable_date"));
				vo.setPrepayFactorageAmt(result.getDouble("prepay_factorage_amt"));
				vo.setPrepayinteAmt(result.getDouble("prepayinte_amt"));
				vo.setPrepayprincipalAmt(result.getDouble("prepayprincipal_amt"));
				vo.setPrepaytype(result.getString("prepaytype"));
				vo.setStampDutyAmt(result.getDouble("stamp_duty_amt"));
				vo.setInHesitateDate(result.getString("in_Hesitate_Date"));
				vo.setBugpayamt(result.getDouble("bugpayamt"));
				vo.setIsbomtr(result.getString("is_bomtr"));
			}
			result.getStatement().close();
			if(vo!=null){
				createTransPayment(Sqlca, vo);
				createTransaction(Sqlca, vo);
				//��ȡ��ǰ����������
				if(vo.getPrepayFactorageAmt()>0){
					String feeSerialNo = createFee(Sqlca, vo);
					createPaymentSchedule(Sqlca, vo, feeSerialNo);
				}
				vo.setStatus("3");
				updatePrepayMent(Sqlca, vo);
				if("1".equals(vo.getInHesitateDate())){//��ԥ������ǰ�������BC��
					String updateSql = "update  Business_Contract bc set bc.iswaver='��' where bc.serialno='"+vo.getContractSerialno()+"'";
					Sqlca.executeSQL(new SqlObject(updateSql));
				}
				return "success@�����ɹ�";
			}else{
				return "failure@����ʧ�ܣ�ѡ������벻�Ǵ�����״̬";
			}
			
		} catch (Exception e) {
			try {
				Sqlca.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			ARE.getLog().error("������ǰ����ʧ�ܣ�ϵͳ�쳣"+e.getMessage());
		}
		return "failure@����ʧ�ܣ�ϵͳ�쳣";
	}
	public String cancelPrepayMent(Transaction Sqlca){
		try {
			PrepaymentVo vo = null;
			String sql = "select pa.serialno,pa.laon_serialno,pa.contract_serialno, pa.atp_serialno,pa.at_serialno,pa.status,pa.executable_date,pa.in_Hesitate_Date  from prepayment_applay pa where pa.serialno='"+getSerialNo()+"' and pa.status in('0','3') for update ";
			ASResultSet as = Sqlca.getASResultSet(sql);
			if(as.next()){
				String status = as.getString("status");
				String executableDate  = as.getString("executable_date");
				String atSerialno  = as.getString("at_serialno");
				String laonSerialno = as.getString("laon_serialno");
				String contractSerialno = as.getString("contract_serialno");
				String inHesitateDate = as.getString("in_Hesitate_Date");
				String sysDate = SystemConfig.getBusinessDate();
				int day = DateFunctions.getDays(sysDate,executableDate);
				if("3".equals(status)){
					if(day <=0){
						return "failure@����ʧ�ܣ���ǰ��������С��ϵͳ���ڣ�������ȡ��";
					}else{
						String sSql = "delete from acct_fee af where af.feetype='A9' and af.objectno=:LoanSerialNo and exists (select 1 from acct_payment_schedule aps where aps.paytype='A9' and af.serialno=aps.objectno and aps.objecttype='jbo.app.ACCT_FEE' and aps.finishdate is null)";
						Sqlca.executeSQL(new SqlObject(sSql).setParameter("LoanSerialNo", laonSerialno));
						
						sSql = "delete from acct_payment_schedule where paytype='A9' and finishdate is null and relativeobjectno=:LoanSerialno and relativeobjecttype='jbo.app.ACCT_LOAN'";
						Sqlca.executeSQL(new SqlObject(sSql).setParameter("LoanSerialNo", laonSerialno));
						
						sSql = "update acct_transaction set transstatus='4',approvedate=:approvedate,approveuserid=:approveuserid,"
								+ " approveorgid=:approveorgid where serialno=:Serialno";
						String date = DateX.format(new Date(), "yyyy/MM/dd hh:mm:ss");
						SqlObject obj = new SqlObject(sSql);
						obj.setParameter("approvedate",date);//����ʱ��
						obj.setParameter("approveuserid",getUserId());//������
						obj.setParameter("approveorgid",getOrgid());//����ʱ��
						obj.setParameter("Serialno", atSerialno);
						Sqlca.executeSQL(obj);
					}
				}
				if("1".equals(inHesitateDate)){//��ԥ������ǰ�������BC��
					String updateSql = "update  Business_Contract bc set bc.iswaver='' where bc.serialno='"+contractSerialno+"'";
					Sqlca.executeSQL(new SqlObject(updateSql));
				}
				vo = new PrepaymentVo();
				vo.setAtpSerialno(as.getString("atp_serialno"));
				vo.setAtSerialno(as.getString("at_serialno"));
				vo.setStatus("4");
				updatePrepayMent(Sqlca,vo);
			}
			as.getStatement().close();
			if(vo == null){
				return "failure@����ʧ�ܣ�ѡ������벻�Ǵ�����״̬,����ͨ��״̬";
			}
			return "success@�����ɹ�";
		} catch (Exception e) {
			e.printStackTrace();
			try {
				Sqlca.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			ARE.getLog().error("ȡ����ǰ����ʧ�ܣ�ϵͳ�쳣"+e.getMessage());
		}
		return "failure@����ʧ�ܣ�ϵͳ�쳣";
	}
	/**
	 * ����
	 * @param Sqlca
	 * @param vo
	 * @throws Exception
	 */
	private void updatePrepayMent(Transaction Sqlca,PrepaymentVo vo) throws Exception{
		String sql ="update prepayment_applay pa set pa.at_serialno=:atSerialno,pa.atp_serialno=:atpSerialno,pa.status=:status,"
				+ " pa.approver_orgid=:approverOrgid,pa.approver_by=:approverBy,pa.approver_date=:approverDate"
				+ " where pa.serialno='"+getSerialNo()+"' ";
		SqlObject so = new SqlObject(sql);
		String date = DateX.format(new Date(), "yyyy/MM/dd hh:mm:ss");
		so.setParameter("atSerialno", vo.getAtSerialno());
		so.setParameter("atpSerialno", vo.getAtpSerialno());
		so.setParameter("status", vo.getStatus());
		so.setParameter("approverOrgid", getOrgid());
		so.setParameter("approverBy", getUserId());
		so.setParameter("approverDate", date);
		Sqlca.executeSQL(so);
	}
	/**
	 * ����ҳ��ʱ��ʼ��
	 * @param Sqlca
	 * @return
	 */
	public String initPrepayMentApplay(Transaction Sqlca){
		try {
			Map<String, Object> map = qureyPerpaymentAmt(Sqlca);
			return  JSONObject.toJSONString(map);
		} catch (Exception e) {
			e.printStackTrace();
			ARE.getLog().error("���ز�Ʒ��ǰ��������쳣"+e.getMessage());
		}
		return "failure";
	}
	
	/**
	 * ��ѯ��ǰ���������Ϣ
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	private  Map<String,Object> qureyPerpaymentAmt(Transaction Sqlca) throws Exception{
		String sql = "select bc.putoutdate,bc.customername as customerName,bc.certid as certid,bc.customerid as customerId "
				+ "  from business_contract bc where bc.serialno='"+getContractNo()+"' and  bc.contractstatus='050' ";
		SqlObject so = new SqlObject(sql);
		Map<String, Object> map = new HashMap<String, Object>();
		String putoutdate ="";
		String certid ="";
		String customerName ="";
		boolean inHesitateDate = false;
		boolean isOutofDate = false;
		ASResultSet as = Sqlca.getASResultSet(so);
		if(as.next()){
			putoutdate = as.getString("putoutdate");
			certid = as.getString("certid");
			customerName = as.getString("customerName");
			map.put("customerId", as.getString("customerId"));
		}else{
			ARE.getLog().error("���ݺ�ͬ��"+getContractNo()+"��״̬050û�в�ѯ����ͬ��Ϣ");
			throw new Exception("���ݺ�ͬ��"+getContractNo()+"��״̬050û�в�ѯ����ͬ��Ϣ");
		}
		as.getStatement().close();
		if(putoutdate==null || putoutdate.length()==0) throw new Exception("�ú�ͬ��putoutdate�����ڣ�����");
	   sql="select nextduedate,serialno,maturitydate,currency,accountingOrgid,loanstatus,nvl(normalbalance,0) as normalbalance,nvl(overduebalance,0) as overduebalance from acct_loan where putoutno='"+getContractNo()+"'";
	   ASResultSet loanAs = Sqlca.getASResultSet(sql);
	   String loanSerialNo ="";
	   String nextduedate ="";
	   String maturitydate ="";
	   String currency ="";
	   if(loanAs.next()){
		   loanSerialNo = loanAs.getString("serialno");
		   nextduedate = loanAs.getString("nextduedate"); 
		   maturitydate = loanAs.getString("maturitydate");//������ 
		   currency = loanAs.getString("currency"); 
		   map.put("accountingOrgid", loanAs.getString("accountingOrgid"));
		   map.put("loanstatus", loanAs.getString("loanstatus"));
		   map.put("nextduedate", loanAs.getString("nextduedate"));
		   map.put("normalbalance", loanAs.getDouble("normalbalance"));
		   map.put("overduebalance", loanAs.getDouble("overduebalance"));
	   }
	   loanAs.getStatement().close();
	   map.put("currency", currency);
	   map.put("laonSerialno", loanSerialNo);
	   Date pDate =  DateFunctions.getDate(getPlanExecuteDate());
	   Calendar cal = Calendar.getInstance();
	   cal.setTime(pDate);
	   int month = cal.get(Calendar.MONTH)+1;
	   Map<String,Object> params = queryPrepayFactorageAmt(Sqlca); 
	   if(month==2){//2�·������߼�
		   //��ǰ������ԥ��
		   int advanceHesitateDate = (Integer) params.get("advanceHesitateDate");
		   int days = DateFunctions.getDays(putoutdate,getPlanExecuteDate());
		   if(days<advanceHesitateDate && (DateFunctions.getDays(getPlanExecuteDate(),nextduedate)==15 ||DateFunctions.getDays(getPlanExecuteDate(),nextduedate)==14)){///��ԥ��������ԥ�ڳ�ͻ��������Ϊ��һ�����գ�������ԥ���ڣ����շ���
			   setExecutableDate(nextduedate);
			   inHesitateDate = true;
		   }else if(days<advanceHesitateDate){//��ԥ��
			    //��ԥ�ڵ���ǰ���������(��Ϣ��+14��)
				 String  payDate=DateFunctions.getRelativeDate(putoutdate,DateFunctions.TERM_UNIT_DAY, advanceHesitateDate-1);
				 setExecutableDate(payDate);
				 inHesitateDate = true;
		   }else if(DateFunctions.getDays(getPlanExecuteDate(),nextduedate)>=15){//ԥ���⣬����һ������15����
			   setExecutableDate(nextduedate);
		   }else{//ԥ���⣬����һ������15����ȡ���¸�������
			   String str=DateFunctions.getRelativeDate(nextduedate,DateFunctions.TERM_UNIT_MONTH, 1);
			   isOutofDate = true;
				setExecutableDate(str);
				if(DateFunctions.getDays(getExecutableDate(), maturitydate)<0){//�ж����¸������գ��Ƿ񳬹��ˣ���ͬ������
					setExecutableDate(maturitydate);
				} 
		   }
	   }else{//2�·������߼�����
		   //��ǰ������ԥ��
		   int advanceHesitateDate = (Integer) params.get("advanceHesitateDate");
		   int days = DateFunctions.getDays(putoutdate,getPlanExecuteDate());
		   if(days<advanceHesitateDate){//��ԥ����
			 //��ԥ�ڵ���ǰ���������(��Ϣ��+14��)
			 String  payDate=DateFunctions.getRelativeDate(putoutdate,DateFunctions.TERM_UNIT_DAY, advanceHesitateDate-1);
			 setExecutableDate(payDate);
			 inHesitateDate = true;
		   }else{//��ԥ����
			   if(DateFunctions.getDays(getPlanExecuteDate(),nextduedate)>=15){//��ԥ��������ԥ�ڳ�ͻ��������Ϊ��һ�����գ�������ԥ���ڣ����շ���
				   setExecutableDate(nextduedate);
				}else{//��ִ����Ϊ���¸������ա�
					String str=DateFunctions.getRelativeDate(nextduedate,DateFunctions.TERM_UNIT_MONTH, 1);
					setExecutableDate(str);
					isOutofDate = true;
					if(DateFunctions.getDays(getExecutableDate(), maturitydate)<0){//�ж����¸������գ��Ƿ񳬹��ˣ���ͬ������
						setExecutableDate(maturitydate);
					}
				}
		   }
	   }
	   if(inHesitateDate){
		   sql = "select  sum( case when aps.paytype='1' then (aps.payprincipalamt- nvl(aps.actualpayprincipalamt,0)) else 0 end ) as prepayprincipalAmt,"
			        +" 0 as prepayinteAmt,"
			        +" 0 as financeAmt, "
			        +" 0 as customerAmt,"
			        +" 0 as insuranceAmt,"
			        +" 0 as stampDutyAmt, "
			        +" 0 as bugpayamt "
			        +" from acct_payment_schedule aps" 
			        +" where((aps.objectno='"+loanSerialNo+"' and aps.objecttype='jbo.app.ACCT_LOAN') "
			        + " or  (aps.relativeobjectno='"+loanSerialNo+"' and aps.relativeobjecttype='jbo.app.ACCT_LOAN')) "
			        +" and aps.paydate>='"+getExecutableDate()+"' and aps.finishdate is null ";
	   }else{
		   sql = "select  sum( case when aps.paytype='1' then (aps.payprincipalamt- nvl(aps.actualpayprincipalamt,0)) else 0 end ) as prepayprincipalAmt,"
				   +" max(case when (aps.paydate='"+getExecutableDate()+"' and aps.paytype='1')  then (nvl(aps.payinteamt,0)-nvl(aps.actualpayinteamt,0)) else 0 end) as prepayinteAmt,"
				   +" max(case when (aps.paydate='"+getExecutableDate()+"' and aps.paytype='A7') then aps.payprincipalamt else 0 end) as financeAmt, "
				   +" max(case when (aps.paydate='"+getExecutableDate()+"' and aps.paytype='A2') then aps.payprincipalamt else 0 end) as customerAmt,"
				   +" max(case when (aps.paydate='"+getExecutableDate()+"' and aps.paytype='A12') then aps.payprincipalamt else 0 end) as insuranceAmt,"
				   +" max(case when (aps.paydate='"+getExecutableDate()+"' and aps.paytype='A11') then aps.payprincipalamt else 0 end) as stampDutyAmt, "
				   +" max(case when (aps.paydate='"+getExecutableDate()+"' and aps.paytype='A18') then aps.payprincipalamt else 0 end) as bugpayamt "
				   +" from acct_payment_schedule aps" 
				   +" where((aps.objectno='"+loanSerialNo+"' and aps.objecttype='jbo.app.ACCT_LOAN') "
				   + " or  (aps.relativeobjectno='"+loanSerialNo+"' and aps.relativeobjecttype='jbo.app.ACCT_LOAN')) "
				   +" and aps.paydate>='"+getExecutableDate()+"' and aps.finishdate is null ";
	   }
	   ASResultSet result = Sqlca.getASResultSet(sql);
	   double  payamt = 0;
	   double  prepayprincipalAmt = 0.00;
	   double  prepayinteAmt = 0.00;
	   double  insuranceAmt = 0.00;
	   double  prepayFactorageAmt = 0.00;
	   double  financeAmt = 0.00;
	   double  customerAmt = 0.00;
	   double  stampDutyAmt = 0.00;
	   double  bugpayamt = 0.00;
	   if(result.next()){
		   prepayprincipalAmt = result.getDouble("prepayprincipalAmt");
		   prepayinteAmt = result.getDouble("prepayinteAmt");
		   if("1".equals(getPrepayFactorageFlag())){//��ȡ��ǰ����������
			   prepayFactorageAmt = (Double) params.get("prepayFactorageAmt");
		   }
		   financeAmt = result.getDouble("financeAmt");
		   customerAmt = result.getDouble("customerAmt");
		   stampDutyAmt = result.getDouble("stampDutyAmt");
		   insuranceAmt = result.getDouble("insuranceAmt");
		   bugpayamt = result.getDouble("bugpayamt");
	   }
	   map.put("inHesitateDate", inHesitateDate);
	   map.put("isOutofDate", isOutofDate);
	   if(inHesitateDate){//��ԥ��,ֻ�ձ���
			map.put("putoutdate", putoutdate);
			map.put("constractNo", getContractNo());
			map.put("certid", certid);
			map.put("customerName", customerName);
			map.put("executableDate", getExecutableDate());
			map.put("payamt", prepayprincipalAmt);
			map.put("prepayprincipalAmt", prepayprincipalAmt);
			map.put("prepayinteAmt", 0.00);
			map.put("insuranceAmt", 0.00);
			map.put("prepayFactorageAmt", 0.00);
			map.put("financeAmt", 0.00);
			map.put("customerAmt", 0.00);
			map.put("stampDutyAmt", 0.00);
			map.put("bugpayamt", 0.00);
			map.put("is_bomtr", getIsbomtr());
	   }else{//����ԥ��
		    if ("1".equals(getIsbomtr())) {		// ʹ���Ż���ǰ����
		    	prepayFactorageAmt = 0.00;
		    }
			payamt = prepayprincipalAmt+prepayinteAmt+prepayFactorageAmt+financeAmt+customerAmt+stampDutyAmt+insuranceAmt+bugpayamt;
			BigDecimal bigDecimal = new BigDecimal(payamt);
			bigDecimal = bigDecimal.setScale(2,BigDecimal.ROUND_HALF_UP);
			payamt = bigDecimal.doubleValue();
			map.put("putoutdate", putoutdate);
			map.put("constractNo", getContractNo());
			map.put("certid", certid);
			map.put("customerName", customerName);
			map.put("executableDate", getExecutableDate());
			map.put("payamt", payamt);
			map.put("prepayprincipalAmt", prepayprincipalAmt);
			map.put("prepayinteAmt", prepayinteAmt);
			map.put("insuranceAmt", insuranceAmt);
			map.put("prepayFactorageAmt", prepayFactorageAmt);
			map.put("financeAmt", financeAmt);
			map.put("customerAmt", customerAmt);
			map.put("stampDutyAmt", stampDutyAmt);
			map.put("bugpayamt", bugpayamt);
			map.put("is_bomtr", getIsbomtr());
	   }
	   return map;
	}
	/**
	 * ������ǰ�����
	 * @param Sqlca
	 * @throws Exception
	 */
	private void createTransaction(Transaction Sqlca,PrepaymentVo vo) throws Exception{
		String sql ="INSERT INTO ACCT_TRANSACTION  (SERIALNO,TRANSCODE,DOCUMENTTYPE,DOCUMENTSERIALNO,"
				+ " TRANSNAME,OCCURDATE,OCCURTIME,TRANSSTATUS,INPUTORGID,INPUTUSERID,INPUTTIME,TRANSDATE,"
				+ " RELATIVEOBJECTNO,CHANNEL, RELATIVEOBJECTTYPE,APPROVEDATE,APPROVEUSERID,APPROVEORGID) VALUES"
				+ "(:serialno,:transcode,:documenttype,:documentserialno,:transname,:occurdate,:occurtime,"
				+ ":transstatus,:inputorgid,:inputuserid,:inputtime,:transdate,:relativeobjectno,:channel,"
				+ ":relativeobjecttype,:approvedate,:approveuserid,:approveorgid)";
		SqlObject obj = new SqlObject(sql);
		String date = DateX.format(new Date(), "yyyy/MM/dd hh:mm:ss");
		String[] dates = date.split(" ");
		String atSerialno = DBKeyUtils.getSerialNo("TQ");
		vo.setAtSerialno(atSerialno);
		obj.setParameter("serialno", atSerialno);
		obj.setParameter("transcode", "0055");//���״���
		obj.setParameter("documenttype", BUSINESSOBJECT_CONSTATNTS.back_bill);//��������
		obj.setParameter("documentserialno", vo.getAtpSerialno());//������ˮ��
		obj.setParameter("transname", "��ǰ����");//��������
		obj.setParameter("occurdate", dates[0]);//���ײ�������
		obj.setParameter("occurtime", dates[1]);//����ʱ��
		obj.setParameter("transstatus", "3");//����״̬
		obj.setParameter("inputorgid", getOrgid());//¼�����
		obj.setParameter("inputuserid", getUserId());//¼����
		obj.setParameter("inputtime", date);//¼��ʱ��
		obj.setParameter("transdate", vo.getExecutableDate());//��������
		obj.setParameter("relativeobjectno", vo.getLaonSerialno());//����������
		obj.setParameter("channel", "01");//��������
		obj.setParameter("relativeobjecttype", BUSINESSOBJECT_CONSTATNTS.loan);//������������
		obj.setParameter("approvedate",date);//����ʱ��
		obj.setParameter("approveuserid",getUserId());//������
		obj.setParameter("approveorgid",getOrgid());//����ʱ��
		Sqlca.executeSQL(obj);
	}
	
	/**
	 * ������ǰ��������Ϣ
	 * @param Sqlca
	 * @throws Exception
	 */
	private void createTransPayment(Transaction Sqlca,PrepaymentVo vo) throws Exception{
		String sql =" INSERT INTO ACCT_TRANS_PAYMENT  (SERIALNO,OBJECTNO,OBJECTTYPE,CURRENCY,PAYAMT,PAYPRINCIPALAMT,"
					+" PAYINTEAMT,PrepayInterestDaysFlag,PrepayInterestBaseFlag,PrePayAmountFlag,CashOnlineFlag,PayAccountFlag,"
					+" PREPAYPRINCIPALAMT,PREPAYINTEAMT,PREPAYTYPE,CUSTOMERSERVEFEE,accountingorgid,"
					+" PAYINSURANCEFEE,STAMPTAX,PREPAYMENTFEE,ACCOUNTMANAGEFEE, BUGPAYAMT, IS_BOMTR)"
					+" VALUES"
					+" (:serialno,:objectno,:objecttype,:currency,:payamt,:payprincipalamt,"
					+" :payinteamt,:prepayInterestDaysFlag,:prepayInterestBaseFlag,:prePayAmountFlag,:cashOnlineFlag,:payAccountFlag,"
					+" :prepayprincipalamt,:prepayinteamt,:prepaytype,:customerservefee,:accountingorgid,"
					+" :payinsurancefee,:stamptax,:prepaymentfee,:accountmanagefee, :bugpayamt, :IS_BOMTR)";
		SqlObject obj = new SqlObject(sql);
		String s = DBKeyUtils.getSerialNo("TQ");
		vo.setAtpSerialno(s);
		obj.setParameter("serialno", s);//���ݺ�
		obj.setParameter("objectno", vo.getLaonSerialno());//����������
		obj.setParameter("objecttype", BUSINESSOBJECT_CONSTATNTS.loan);//������������
		obj.setParameter("currency", vo.getCurrency());//����
		obj.setParameter("payamt", vo.getPayamt());//Ӧ���ܽ��
		obj.setParameter("payprincipalamt", vo.getPrepayprincipalAmt());//Ӧ��������
		obj.setParameter("payinteamt", vo.getPrepayinteAmt());//Ӧ��������Ϣ
		obj.setParameter("prepayInterestDaysFlag","02");
		obj.setParameter("prepayInterestBaseFlag","02");
		obj.setParameter("prePayAmountFlag","2");
		obj.setParameter("cashOnlineFlag","1");
		obj.setParameter("payAccountFlag","2");
		obj.setParameter("prepayprincipalamt", vo.getPrepayprincipalAmt());//��ǰ�������
		obj.setParameter("prepayinteamt",  vo.getPrepayinteAmt());//��ǰ������Ϣ
		obj.setParameter("prepaytype",  vo.getPrepaytype());//��ǰ���ʽ
		obj.setParameter("accountingorgid", vo.getAccountingOrgid());//������������
		obj.setParameter("customerservefee", vo.getCustomerAmt());//�ͻ������
		obj.setParameter("payinsurancefee",vo.getInsuranceAmt());//Ӧ�����շ�
		obj.setParameter("stamptax",  vo.getStampDutyAmt());//Ӧ��ӡ��˰
		obj.setParameter("prepaymentfee", vo.getPrepayFactorageAmt());//��ǰ����������
		obj.setParameter("accountmanagefee", vo.getFinanceAmt());//��������
		obj.setParameter("bugpayamt", vo.getBugpayamt());
		obj.setParameter("IS_BOMTR", vo.getIsbomtr());
		Sqlca.executeSQL(obj);
	}
	
	/**
	 *  ������ǰ����������
	 * @param Sqlca
	 * @param vo
	 * @param feetermid
	 * @return ��������
	 * @throws Exception
	 */
	private String createFee(Transaction Sqlca,PrepaymentVo vo) throws Exception{
		String qsql=" select bc.businesstype,ptl.termid,bc.businesssum from business_contract bc,product_term_library ptl "+
				"	where  bc.businesstype||'-V1.0'=ptl.objectno "+
				"	and ptl.subtermtype='A9' "+
				"	and ptl.status='1' "+
				"	and bc.serialno='"+vo.getContractSerialno()+"'";
		ASResultSet rs=Sqlca.getASResultSet(new SqlObject(qsql));
		String feetermid = "";
		if(rs.next()){
			feetermid=rs.getString("termid");
		}
		rs.getStatement().close();
		String sql = "insert into acct_fee (serialno,objecttype,objectno,feetype,feetermid,currency,amount, feeflag, feepaydateflag,"
					 +" status,inputuser,inputorg,inputtime,updateuser,updatetime,totalamount)"
					 + " values (:serialno,:objecttype,:objectno,:feetype,:feetermid,:currency,:amount,:feeflag,:feepaydateflag,"
					 + " :status,:inputuser,:inputorg,:inputtime,:updateuser,:updatetime,:totalamount)";
		SqlObject obj = new SqlObject(sql);
		String s = DBKeyUtils.getSerialNo("TQ");
		String date = DateX.format(new Date(), "yyyy/MM/dd hh:mm:ss");
		obj.setParameter("serialno", s);
		obj.setParameter("objecttype", BUSINESSOBJECT_CONSTATNTS.loan);
		obj.setParameter("objectno", vo.getLaonSerialno());
		obj.setParameter("feetype", "A9");
		obj.setParameter("feetermid", feetermid);
		obj.setParameter("currency", vo.getCurrency());
		obj.setParameter("amount", vo.getPrepayFactorageAmt());
		obj.setParameter("feeflag", "R");
		obj.setParameter("feepaydateflag", "01");
		obj.setParameter("status", "1");
		obj.setParameter("inputuser", getUserId());
		obj.setParameter("inputorg", getOrgid());
		obj.setParameter("inputtime", date);
		obj.setParameter("updateuser", getUserId());
		obj.setParameter("updatetime", date);
		obj.setParameter("totalamount", vo.getPrepayFactorageAmt());
		Sqlca.executeSQL(obj);
		return s;
	}
	
	/**
	 * ������ǰ����������
	 * @param Sqlca
	 * @param vo
	 * @param feeSerialNo
	 * @throws Exception
	 */
	private void createPaymentSchedule(Transaction Sqlca,PrepaymentVo vo,String feeSerialNo) throws Exception{
		String qsql = "select s.seqid from acct_payment_schedule s where s.objectno='"+vo.getLaonSerialno()+"' and s.paydate='"+vo.getExecutableDate()+"'";
		double seqid = Sqlca.getDouble(qsql);
		String sql = "insert into acct_payment_schedule"
				+ "   (serialno,objectno,seqid,paydate,paytype,payprincipalamt,objecttype,autopayflag,relativeobjectno,relativeobjecttype)"
				+ "values(:serialno,:objectno,:seqid,:paydate,:paytype,:payprincipalamt,:objecttype,:autopayflag,:relativeobjectno,:relativeobjecttype)";
		SqlObject obj = new SqlObject(sql);
		String s = DBKeyUtils.getSerialNo("TQ");
		obj.setParameter("serialno", s);
		obj.setParameter("objectno", feeSerialNo);
		obj.setParameter("seqid", seqid);
		obj.setParameter("paydate", vo.getExecutableDate());
		obj.setParameter("paytype", "A9");
		obj.setParameter("payprincipalamt", vo.getPrepayFactorageAmt());
		obj.setParameter("objecttype", BUSINESSOBJECT_CONSTATNTS.fee);
		obj.setParameter("autopayflag", "1");
		obj.setParameter("relativeobjectno",vo.getLaonSerialno());
		obj.setParameter("relativeobjecttype",BUSINESSOBJECT_CONSTATNTS.loan);
		Sqlca.executeSQL(obj);
	}
	/**
	 * ���ݺ�ͬ�Ų�ѯ��ǰ����������
	 * @param Sqlca
	 * @return
	 * @throws Exception 
	 */
	public Map<String,Object> queryPrepayFactorageAmt(Transaction Sqlca) throws Exception{
		String sql=" select bc.businesstype,ptl.termid,bc.businesssum,bc.inputdate,bc.BUGPAYPKGIND from business_contract bc,product_term_library ptl "+
				"	where  bc.businesstype||'-V1.0'=ptl.objectno "+
				"	and ptl.subtermtype='A9' "+
				"	and ptl.status='1' "+
				"	and bc.serialno='"+getContractNo()+"'";
		ASResultSet rs=Sqlca.getASResultSet(new SqlObject(sql));
		sql = "SELECT ATTRIBUTE1, ATTRIBUTE2 FROM CODE_LIBRARY WHERE CODENO = :CODENO AND ITEMNO = :ITEMNO";
		ASResultSet configRS = Sqlca.getASResultSet(new SqlObject(sql)
								.setParameter("CODENO", "SXHRelativeConfig")
								.setParameter("ITEMNO", "01"));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		String configDateStr = "2015/10/31";
		String configAmt = "100";
		// String bugPaypkgind = "";
		if (configRS.next()) {
			configDateStr = configRS.getString("ATTRIBUTE1");
			configAmt = configRS.getString("ATTRIBUTE2");
		}
		configRS.getStatement().close();
		
		double prepayFactorageAmt = 0;
		int advanceHesitateDate = 0;
		if(rs.next()){
			String businessType=rs.getString("businesstype");
			String termId=rs.getString("termid");
			String inputDateStr = rs.getString("inputdate");
			double businessSum=rs.getDouble("businesssum");
			// bugPaypkgind = rs.getString("BUGPAYPKGIND");
			Date configDate = sdf.parse(configDateStr);
			Date inputDate = sdf.parse(inputDateStr);
			
			//�ӻ�����ȡ�ò���
			//��Ӧ���ݿ��ѯ��ʽ select * from PRODUCT_TERM_PARA TP where tp.termid='TQ001' and tp.objectno='CSJ012-V1.0';
			String advance = ProductConfig.getProductTermParameterAttribute(businessType, "V1.0", termId, "AdvancehesitateDate","DefaultValue");
			if(advance != null && advance.length()>0)
				advanceHesitateDate = Integer.parseInt(advance);
			//���㷽ʽ
			String CalType = ProductConfig.getProductTermParameterAttribute(businessType, "V1.0", termId, "FeeCalType","DefaultValue");
			if("01".equals(CalType)){//�̶����
				if (configDate.getTime() > inputDate.getTime()) {
					prepayFactorageAmt = Double.parseDouble(configAmt);
				} else {
					prepayFactorageAmt = Double.parseDouble(ProductConfig.getProductTermParameterAttribute(businessType, "V1.0", termId, "FeeAmount","DefaultValue"));
				}
			}else if("02".equals(CalType)){//������*����
				String FeeRate = ProductConfig.getProductTermParameterAttribute(businessType, "V1.0", termId, "FeeRate","DefaultValue");
				prepayFactorageAmt = businessSum * Double.parseDouble(FeeRate)*0.01;
			}
			String minAmtStr = ProductConfig.getProductTermParameterAttribute(businessType, "V1.0", termId, "FeeAmount","MinValue");
			String maxAmtStr = ProductConfig.getProductTermParameterAttribute(businessType, "V1.0", termId, "FeeAmount","MaxValue");
			if(minAmtStr != null && minAmtStr.length()>0){
				double minAmt = Double.parseDouble(minAmtStr);
				if(prepayFactorageAmt < minAmt){
					prepayFactorageAmt = minAmt;
				}
			}
			if(maxAmtStr != null && maxAmtStr.length()>0){
				double maxAmt = Double.parseDouble(maxAmtStr);
				if(prepayFactorageAmt > maxAmt){
					prepayFactorageAmt = maxAmt;
				}
			}
		}
		rs.getStatement().close();
		Map<String, Object> map  = new HashMap<String, Object>();
		map.put("prepayFactorageAmt", prepayFactorageAmt);
		map.put("advanceHesitateDate", advanceHesitateDate);
		return map;
	}
	
	private boolean validateBalence(Map<String, Object> map){
		double prepayprincipalAmt = (Double) map.get("prepayprincipalAmt");
		double normalbalance = (Double)map.get("normalbalance");
		double overduebalance = (Double)map.get("overduebalance");
		if(Arith.round(prepayprincipalAmt, 2) < Arith.round(normalbalance+overduebalance, 2)){
			return false;
		}
		return true;
	}

	public String getContractNo() {
		return contractNo;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getOrgid() {
		return orgid;
	}

	public void setOrgid(String orgid) {
		this.orgid = orgid;
	}

	public String getPlanExecuteDate() {
		return planExecuteDate;
	}

	public void setPlanExecuteDate(String planExecuteDate) {
		this.planExecuteDate = planExecuteDate;
	}

	public String getExecutableDate() {
		return executableDate;
	}

	public String getPrepayFactorageFlag() {
		return prepayFactorageFlag;
	}

	public void setPrepayFactorageFlag(String prepayFactorageFlag) {
		this.prepayFactorageFlag = prepayFactorageFlag;
	}

	public void setExecutableDate(String executableDate) {
		this.executableDate = executableDate;
	}
	
	public String getIsbomtr() {
		return isbomtr;
	}

	public void setIsbomtr(String isbomtr) {
		this.isbomtr = isbomtr;
	}

	public class PrepaymentVo{
		private String contractSerialno;//��ͬ��
		private String laonSerialno ;//��ݺ�
		private String atpSerialno ;//ACCT_TRANS_PAYMENT serialno
		private String atSerialno ;//acct_transaction serialno
		private String accountingOrgid ;//��������������
		private String customerId ;//�ͻ����
		private String executableDate;//��ǰ�����ִ������
		private String planExecutableDate;//�ƻ���ǰ��������
		private String status;//����״̬
		private double payamt;//Ӧ���ܽ��
		private String prepaytype;//��ǰ���ʽ��Code:PrepaymentType
		private String currency;//���֣�Code:Currency
		private double prepayprincipalAmt;//��ǰ�������
		private double prepayinteAmt ;//��ǰ������Ϣ���
		private double financeAmt ;//��������
		private double customerAmt ;//�ͻ������
		private double insuranceAmt;//���շ�
		private double stampDutyAmt;//ӡ��˰
		private double prepayFactorageAmt;//ӡ��˰
		private String prepayFactorageFlag;//��ǰ����������
		private String inHesitateDate ;//�Ƿ���ԥ����ǰ���0��1��
		private double bugpayamt;// ���Ļ������
		private String isbomtr;	// �Ƿ�ʹ���Ż���ǰ����
		public String getContractSerialno() {
			return contractSerialno;
		}
		public void setContractSerialno(String contractSerialno) {
			this.contractSerialno = contractSerialno;
		}
		public String getLaonSerialno() {
			return laonSerialno;
		}
		public void setLaonSerialno(String laonSerialno) {
			this.laonSerialno = laonSerialno;
		}
		public String getCustomerId() {
			return customerId;
		}
		public void setCustomerId(String customerId) {
			this.customerId = customerId;
		}
		public String getExecutableDate() {
			return executableDate;
		}
		public void setExecutableDate(String executableDate) {
			this.executableDate = executableDate;
		}
		public String getPlanExecutableDate() {
			return planExecutableDate;
		}
		public void setPlanExecutableDate(String planExecutableDate) {
			this.planExecutableDate = planExecutableDate;
		}
		public String getStatus() {
			return status;
		}
		public void setStatus(String status) {
			this.status = status;
		}
		public double getPayamt() {
			return payamt;
		}
		public void setPayamt(double payamt) {
			this.payamt = payamt;
		}
		public String getAccountingOrgid() {
			return accountingOrgid;
		}
		public void setAccountingOrgid(String accountingOrgid) {
			this.accountingOrgid = accountingOrgid;
		}
		public String getAtSerialno() {
			return atSerialno;
		}
		public void setAtSerialno(String atSerialno) {
			this.atSerialno = atSerialno;
		}
		public String getPrepaytype() {
			return prepaytype;
		}
		public void setPrepaytype(String prepaytype) {
			this.prepaytype = prepaytype;
		}
		public String getCurrency() {
			return currency;
		}
		public void setCurrency(String currency) {
			this.currency = currency;
		}
		public double getPrepayprincipalAmt() {
			return prepayprincipalAmt;
		}
		public void setPrepayprincipalAmt(double prepayprincipalAmt) {
			this.prepayprincipalAmt = prepayprincipalAmt;
		}
		public double getPrepayinteAmt() {
			return prepayinteAmt;
		}
		public void setPrepayinteAmt(double prepayinteAmt) {
			this.prepayinteAmt = prepayinteAmt;
		}
		public double getFinanceAmt() {
			return financeAmt;
		}
		public void setFinanceAmt(double financeAmt) {
			this.financeAmt = financeAmt;
		}
		public double getCustomerAmt() {
			return customerAmt;
		}
		public void setCustomerAmt(double customerAmt) {
			this.customerAmt = customerAmt;
		}
		public double getInsuranceAmt() {
			return insuranceAmt;
		}
		public void setInsuranceAmt(double insuranceAmt) {
			this.insuranceAmt = insuranceAmt;
		}
		public double getStampDutyAmt() {
			return stampDutyAmt;
		}
		public void setStampDutyAmt(double stampDutyAmt) {
			this.stampDutyAmt = stampDutyAmt;
		}
		public double getPrepayFactorageAmt() {
			return prepayFactorageAmt;
		}
		public void setPrepayFactorageAmt(double prepayFactorageAmt) {
			this.prepayFactorageAmt = prepayFactorageAmt;
		}
		public String getPrepayFactorageFlag() {
			return prepayFactorageFlag;
		}
		public void setPrepayFactorageFlag(String prepayFactorageFlag) {
			this.prepayFactorageFlag = prepayFactorageFlag;
		}
		public String getAtpSerialno() {
			return atpSerialno;
		}
		public void setAtpSerialno(String atpSerialno) {
			this.atpSerialno = atpSerialno;
		}
		public String getInHesitateDate() {
			return inHesitateDate;
		}
		public void setInHesitateDate(String inHesitateDate) {
			this.inHesitateDate = inHesitateDate;
		}
		public double getBugpayamt() {
			return bugpayamt;
		}
		public void setBugpayamt(double bugpayamt) {
			this.bugpayamt = bugpayamt;
		}
		public String getIsbomtr() {
			return isbomtr;
		}
		public void setIsbomtr(String isbomtr) {
			this.isbomtr = isbomtr;
		}
		
	}
}
