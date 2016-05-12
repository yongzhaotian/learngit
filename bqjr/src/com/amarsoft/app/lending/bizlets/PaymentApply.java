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
	private String serialNo;//申请流水号
	private String contractNo;//合同号
	private String userId;//操作用户
	private String orgid;//操作用户
	private String prepayFactorageFlag;//是否收取提前还款手续费
	private String planExecuteDate;//计划执行日期
	private String executableDate;//可执行日期
	private String isbomtr;	// 是否使用优惠提前还款
	/**
	 * 申请
	 * @param Sqlca
	 * @return
	 */
	public String  prePaymentApply(Transaction Sqlca) {
		try {
			Map<String, Object> map  = qureyPerpaymentAmt(Sqlca);
			boolean isOutofDate = (Boolean) map.get("isOutofDate");
			if(isOutofDate){
				return "failure@提前还款可执行日期大于下一还款日期，不允许申请";
			}
			if("1".equals(map.get("loanstatus"))){
				return "failure@合同为逾期状态，不允许申请";
			}
			if(validateBalence(map) == false){
				return "failure@提前还款本金与剩余本金不相等，不允许申请";
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
			return "success@申请提前还款成功";
		} catch (Exception e) {
			e.printStackTrace();
			try {
				Sqlca.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			ARE.getLog().error("申请提前还款失败"+e.getMessage());
		}
		return "failure@申请提前还款失败，系统异常";
	}
	
	/**
	 * 审批通过
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
				//收取提前还款手续费
				if(vo.getPrepayFactorageAmt()>0){
					String feeSerialNo = createFee(Sqlca, vo);
					createPaymentSchedule(Sqlca, vo, feeSerialNo);
				}
				vo.setStatus("3");
				updatePrepayMent(Sqlca, vo);
				if("1".equals(vo.getInHesitateDate())){//犹豫期内提前还款，更新BC表
					String updateSql = "update  Business_Contract bc set bc.iswaver='是' where bc.serialno='"+vo.getContractSerialno()+"'";
					Sqlca.executeSQL(new SqlObject(updateSql));
				}
				return "success@操作成功";
			}else{
				return "failure@操作失败，选择的申请不是待审批状态";
			}
			
		} catch (Exception e) {
			try {
				Sqlca.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			ARE.getLog().error("审批提前还款失败，系统异常"+e.getMessage());
		}
		return "failure@操作失败，系统异常";
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
						return "failure@操作失败，提前还款日期小于系统日期，不允许取消";
					}else{
						String sSql = "delete from acct_fee af where af.feetype='A9' and af.objectno=:LoanSerialNo and exists (select 1 from acct_payment_schedule aps where aps.paytype='A9' and af.serialno=aps.objectno and aps.objecttype='jbo.app.ACCT_FEE' and aps.finishdate is null)";
						Sqlca.executeSQL(new SqlObject(sSql).setParameter("LoanSerialNo", laonSerialno));
						
						sSql = "delete from acct_payment_schedule where paytype='A9' and finishdate is null and relativeobjectno=:LoanSerialno and relativeobjecttype='jbo.app.ACCT_LOAN'";
						Sqlca.executeSQL(new SqlObject(sSql).setParameter("LoanSerialNo", laonSerialno));
						
						sSql = "update acct_transaction set transstatus='4',approvedate=:approvedate,approveuserid=:approveuserid,"
								+ " approveorgid=:approveorgid where serialno=:Serialno";
						String date = DateX.format(new Date(), "yyyy/MM/dd hh:mm:ss");
						SqlObject obj = new SqlObject(sSql);
						obj.setParameter("approvedate",date);//审批时间
						obj.setParameter("approveuserid",getUserId());//审批人
						obj.setParameter("approveorgid",getOrgid());//审批时间
						obj.setParameter("Serialno", atSerialno);
						Sqlca.executeSQL(obj);
					}
				}
				if("1".equals(inHesitateDate)){//犹豫期内提前还款，更新BC表
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
				return "failure@操作失败，选择的申请不是待审批状态,审批通过状态";
			}
			return "success@操作成功";
		} catch (Exception e) {
			e.printStackTrace();
			try {
				Sqlca.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			ARE.getLog().error("取消提前还款失败，系统异常"+e.getMessage());
		}
		return "failure@操作失败，系统异常";
	}
	/**
	 * 更新
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
	 * 加载页面时初始化
	 * @param Sqlca
	 * @return
	 */
	public String initPrepayMentApplay(Transaction Sqlca){
		try {
			Map<String, Object> map = qureyPerpaymentAmt(Sqlca);
			return  JSONObject.toJSONString(map);
		} catch (Exception e) {
			e.printStackTrace();
			ARE.getLog().error("加载产品提前还款参数异常"+e.getMessage());
		}
		return "failure";
	}
	
	/**
	 * 查询提前还款金额等信息
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
			ARE.getLog().error("根据合同号"+getContractNo()+"和状态050没有查询到合同信息");
			throw new Exception("根据合同号"+getContractNo()+"和状态050没有查询到合同信息");
		}
		as.getStatement().close();
		if(putoutdate==null || putoutdate.length()==0) throw new Exception("该合同的putoutdate不存在，请检查");
	   sql="select nextduedate,serialno,maturitydate,currency,accountingOrgid,loanstatus,nvl(normalbalance,0) as normalbalance,nvl(overduebalance,0) as overduebalance from acct_loan where putoutno='"+getContractNo()+"'";
	   ASResultSet loanAs = Sqlca.getASResultSet(sql);
	   String loanSerialNo ="";
	   String nextduedate ="";
	   String maturitydate ="";
	   String currency ="";
	   if(loanAs.next()){
		   loanSerialNo = loanAs.getString("serialno");
		   nextduedate = loanAs.getString("nextduedate"); 
		   maturitydate = loanAs.getString("maturitydate");//到期日 
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
	   if(month==2){//2月份特殊逻辑
		   //提前还款犹豫期
		   int advanceHesitateDate = (Integer) params.get("advanceHesitateDate");
		   int days = DateFunctions.getDays(putoutdate,getPlanExecuteDate());
		   if(days<advanceHesitateDate && (DateFunctions.getDays(getPlanExecuteDate(),nextduedate)==15 ||DateFunctions.getDays(getPlanExecuteDate(),nextduedate)==14)){///犹豫期外与犹豫期冲突，还款日为下一还款日，并算犹豫期内，不收费用
			   setExecutableDate(nextduedate);
			   inHesitateDate = true;
		   }else if(days<advanceHesitateDate){//犹豫期
			    //犹豫期的提前还款可行日(计息日+14天)
				 String  payDate=DateFunctions.getRelativeDate(putoutdate,DateFunctions.TERM_UNIT_DAY, advanceHesitateDate-1);
				 setExecutableDate(payDate);
				 inHesitateDate = true;
		   }else if(DateFunctions.getDays(getPlanExecuteDate(),nextduedate)>=15){//豫期外，离下一还款日15天内
			   setExecutableDate(nextduedate);
		   }else{//豫期外，离下一还款日15天外取下下个还款日
			   String str=DateFunctions.getRelativeDate(nextduedate,DateFunctions.TERM_UNIT_MONTH, 1);
			   isOutofDate = true;
				setExecutableDate(str);
				if(DateFunctions.getDays(getExecutableDate(), maturitydate)<0){//判断下下个还款日，是否超过了，合同到期日
					setExecutableDate(maturitydate);
				} 
		   }
	   }else{//2月份以外逻辑处理
		   //提前还款犹豫期
		   int advanceHesitateDate = (Integer) params.get("advanceHesitateDate");
		   int days = DateFunctions.getDays(putoutdate,getPlanExecuteDate());
		   if(days<advanceHesitateDate){//犹豫期内
			 //犹豫期的提前还款可行日(计息日+14天)
			 String  payDate=DateFunctions.getRelativeDate(putoutdate,DateFunctions.TERM_UNIT_DAY, advanceHesitateDate-1);
			 setExecutableDate(payDate);
			 inHesitateDate = true;
		   }else{//犹豫期外
			   if(DateFunctions.getDays(getPlanExecuteDate(),nextduedate)>=15){//犹豫期外与犹豫期冲突，还款日为下一还款日，并算犹豫期内，不收费用
				   setExecutableDate(nextduedate);
				}else{//可执行日为下下个还款日。
					String str=DateFunctions.getRelativeDate(nextduedate,DateFunctions.TERM_UNIT_MONTH, 1);
					setExecutableDate(str);
					isOutofDate = true;
					if(DateFunctions.getDays(getExecutableDate(), maturitydate)<0){//判断下下个还款日，是否超过了，合同到期日
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
		   if("1".equals(getPrepayFactorageFlag())){//收取提前还款手续费
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
	   if(inHesitateDate){//犹豫期,只收本金
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
	   }else{//非犹豫期
		    if ("1".equals(getIsbomtr())) {		// 使用优惠提前还款
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
	 * 创建提前还款交易
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
		obj.setParameter("transcode", "0055");//交易代码
		obj.setParameter("documenttype", BUSINESSOBJECT_CONSTATNTS.back_bill);//单据类型
		obj.setParameter("documentserialno", vo.getAtpSerialno());//单据流水号
		obj.setParameter("transname", "提前还款");//交易名称
		obj.setParameter("occurdate", dates[0]);//交易操作日期
		obj.setParameter("occurtime", dates[1]);//交易时间
		obj.setParameter("transstatus", "3");//交易状态
		obj.setParameter("inputorgid", getOrgid());//录入机构
		obj.setParameter("inputuserid", getUserId());//录入人
		obj.setParameter("inputtime", date);//录入时间
		obj.setParameter("transdate", vo.getExecutableDate());//交易日期
		obj.setParameter("relativeobjectno", vo.getLaonSerialno());//关联对象编号
		obj.setParameter("channel", "01");//交易渠道
		obj.setParameter("relativeobjecttype", BUSINESSOBJECT_CONSTATNTS.loan);//关联对象类型
		obj.setParameter("approvedate",date);//审批时间
		obj.setParameter("approveuserid",getUserId());//审批人
		obj.setParameter("approveorgid",getOrgid());//审批时间
		Sqlca.executeSQL(obj);
	}
	
	/**
	 * 创建提前还款金额信息
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
		obj.setParameter("serialno", s);//单据号
		obj.setParameter("objectno", vo.getLaonSerialno());//关联对象编号
		obj.setParameter("objecttype", BUSINESSOBJECT_CONSTATNTS.loan);//关联对象类型
		obj.setParameter("currency", vo.getCurrency());//币种
		obj.setParameter("payamt", vo.getPayamt());//应还总金额
		obj.setParameter("payprincipalamt", vo.getPrepayprincipalAmt());//应还本金金额
		obj.setParameter("payinteamt", vo.getPrepayinteAmt());//应还正常利息
		obj.setParameter("prepayInterestDaysFlag","02");
		obj.setParameter("prepayInterestBaseFlag","02");
		obj.setParameter("prePayAmountFlag","2");
		obj.setParameter("cashOnlineFlag","1");
		obj.setParameter("payAccountFlag","2");
		obj.setParameter("prepayprincipalamt", vo.getPrepayprincipalAmt());//提前还款本金金额
		obj.setParameter("prepayinteamt",  vo.getPrepayinteAmt());//提前还款利息
		obj.setParameter("prepaytype",  vo.getPrepaytype());//提前还款方式
		obj.setParameter("accountingorgid", vo.getAccountingOrgid());//贷款所属机构
		obj.setParameter("customerservefee", vo.getCustomerAmt());//客户服务费
		obj.setParameter("payinsurancefee",vo.getInsuranceAmt());//应还保险费
		obj.setParameter("stamptax",  vo.getStampDutyAmt());//应还印花税
		obj.setParameter("prepaymentfee", vo.getPrepayFactorageAmt());//提前还款手续费
		obj.setParameter("accountmanagefee", vo.getFinanceAmt());//财务管理费
		obj.setParameter("bugpayamt", vo.getBugpayamt());
		obj.setParameter("IS_BOMTR", vo.getIsbomtr());
		Sqlca.executeSQL(obj);
	}
	
	/**
	 *  创建提前还款手续费
	 * @param Sqlca
	 * @param vo
	 * @param feetermid
	 * @return 费用主键
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
	 * 创建提前还款手续费
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
	 * 根据合同号查询提前还款手续费
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
			
			//从缓存中取得参数
			//对应数据库查询方式 select * from PRODUCT_TERM_PARA TP where tp.termid='TQ001' and tp.objectno='CSJ012-V1.0';
			String advance = ProductConfig.getProductTermParameterAttribute(businessType, "V1.0", termId, "AdvancehesitateDate","DefaultValue");
			if(advance != null && advance.length()>0)
				advanceHesitateDate = Integer.parseInt(advance);
			//计算方式
			String CalType = ProductConfig.getProductTermParameterAttribute(businessType, "V1.0", termId, "FeeCalType","DefaultValue");
			if("01".equals(CalType)){//固定金额
				if (configDate.getTime() > inputDate.getTime()) {
					prepayFactorageAmt = Double.parseDouble(configAmt);
				} else {
					prepayFactorageAmt = Double.parseDouble(ProductConfig.getProductTermParameterAttribute(businessType, "V1.0", termId, "FeeAmount","DefaultValue"));
				}
			}else if("02".equals(CalType)){//贷款金额*费率
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
		private String contractSerialno;//合同号
		private String laonSerialno ;//借据号
		private String atpSerialno ;//ACCT_TRANS_PAYMENT serialno
		private String atSerialno ;//acct_transaction serialno
		private String accountingOrgid ;//贷款人所属机构
		private String customerId ;//客户编号
		private String executableDate;//提前还款可执行日期
		private String planExecutableDate;//计划提前还款日期
		private String status;//申请状态
		private double payamt;//应还总金额
		private String prepaytype;//提前还款方式（Code:PrepaymentType
		private String currency;//币种（Code:Currency
		private double prepayprincipalAmt;//提前还款本金金额
		private double prepayinteAmt ;//提前还款利息金额
		private double financeAmt ;//财务管理费
		private double customerAmt ;//客户管理费
		private double insuranceAmt;//保险费
		private double stampDutyAmt;//印花税
		private double prepayFactorageAmt;//印花税
		private String prepayFactorageFlag;//提前还款手续费
		private String inHesitateDate ;//是否犹豫期提前还款，0否，1是
		private double bugpayamt;// 随心还服务费
		private String isbomtr;	// 是否使用优惠提前还款
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
