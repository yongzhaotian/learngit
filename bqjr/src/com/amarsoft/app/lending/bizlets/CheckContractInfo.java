package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.app.accounting.config.SystemConfig;
import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 合同信息检查类
 * @author huangshuo
 */
public class CheckContractInfo {
	
	/** 合同号 **/
	private String contractNO;
	
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	
	private Date now = null;
	
	private Log logger = ARE.getLog();

	/**
	 * 检查合同的相关状态
	 * @param transaction
	 * @return
	 */
	public String checkContractStatus(Transaction transaction) {
		
		// 验证合同是否存在未完成的操作
		ASResultSet rs = null;
		String customerId = "";
		String customerName = "";
		String sql = "";
		String res = "";
		try {
			now = sdf.parse(SystemConfig.getBusinessDate());
			
			// 1. 合同结清的不允许申请取消服务包功能
			res = checkLoanStatus(transaction, contractNO);
			if ("FALSE".equals(res.split("@")[0])) {
				return res;
			}
			
			sql = "SELECT BC.CUSTOMERID, BC.CUSTOMERNAME FROM BUSINESS_CONTRACT BC "
					+ "WHERE BC.SERIALNO = :SERIALNO";
			rs = transaction.getASResultSet(new SqlObject(sql).setParameter("SERIALNO", contractNO));
			if (rs.next()) {
				customerId = rs.getString("CUSTOMERID");
				customerName = rs.getString("CUSTOMERNAME");
			}
			rs.getStatement().close();
			if (customerId == null || "".equals(customerId)) {
				return "FALSE@ERROR";
			}
			
			// 2. 客户名下所有合同是否有逾期 
			res = checkContractIsOverdue(transaction, customerId);
			if ("FALSE".equals(res.split("@")[0])) {
				return res;
			}
			
			// 3. 至少在到期还款日提前5天提出申请
			res = checkContractMature(transaction, contractNO);
			if ("FALSE".equals(res.split("@")[0])) {
				return res;
			}
			
			// 4. 存在提前还款、退货、退保、退款申请的，一律不该提出申请取消服务包功能
			res = checkContractApplyStatus(transaction, contractNO, customerId, customerName);
			if ("FALSE".equals(res.split("@")[0])) {
				return res;
			}
			
			// 5. 申请取消前未使用任何随心还服务，即一旦随心还服务使用，则在整个贷款期间无法取消
			res = checkIsUsedHistory(transaction, contractNO);
			if ("FALSE".equals(res.split("@")[0])) {
				return res;
			}
			
			// 6. 提过申请取消服务包的，不让再次提申请
			res = checkSXHCancelStatus(transaction, contractNO);
			if ("FALSE".equals(res.split("@")[0])) {
				return res;
			}
		} catch(Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			return "FALSE@系统异常，请联系相关的IT负责人！";
		}
		return "TRUE@";
	}
	
	/**
	 * 检查是否办理过：取消随心还服务包的业务
	 * @param transaction
	 * @param contractNO
	 * @return
	 */
	private String checkSXHCancelStatus(Transaction transaction, String contractNO) throws Exception {
		
		String sql = "SELECT COUNT(1) AS CNT FROM BUSINESS_PAYPKG_APPLY WHERE CONTRACTNO = :CONTRACTNO";
		ASResultSet rs = null;
		int cnt = 0;
		rs = transaction.getASResultSet(new SqlObject(sql).setParameter("CONTRACTNO", contractNO));
		if (rs.next()) {
			cnt = rs.getInt("CNT");
		}
		if (cnt > 0) {
			return "FALSE@合同号为：" + contractNO + " 已办理过取消随心还服务包申请，无法重复申请！";
		}
		
		return "TRUE@";
	}
	
	/**
	 * 检查“在到期还款日提前5天提出申请”是不是满足
	 * @return
	 */
	private String checkContractMature(Transaction transaction, String contractNO) throws Exception {
		
		String sql = "";
		ASResultSet rs = null;
		sql = "SELECT ATTRIBUTE3 FROM CODE_LIBRARY WHERE CODENO = "
			+ ":CODENO AND ITEMNO = :ITEMNO";
		ASResultSet configRS = transaction.getASResultSet(new SqlObject(sql)
					.setParameter("CODENO", "SXHRelativeConfig")
					.setParameter("ITEMNO", "01"));
		long applyDays = 5;
		String nextDueDate = "";
		if (configRS.next()) {
			applyDays = Long.parseLong(configRS.getString("ATTRIBUTE3") == null 
					|| "".equals(configRS.getString("ATTRIBUTE3")) 
					? "5" : configRS.getString("ATTRIBUTE3"));
		}
		configRS.getStatement().close();
		sql = "SELECT A.NEXTDUEDATE FROM ACCT_LOAN A WHERE A.PUTOUTNO = :PUTOUTNO";
		rs = transaction.getResultSet(new SqlObject(sql).setParameter("PUTOUTNO", contractNO));
		if (rs.next()) {
			nextDueDate = rs.getString("NEXTDUEDATE");
		}
		rs.getStatement().close();
		if (nextDueDate == null || "".equals(nextDueDate)) {
			return "FALSE@合同号：" + contractNO + " 找不到下个还款日！";
		}
		long day = (sdf.parse(nextDueDate).getTime() - now.getTime()) / (24 * 60 * 60 * 1000);
		if (day < applyDays) {
			return "FALSE@合同号为：" + contractNO + " 距离下个还款日不超过 " + applyDays + " 天，不允许申请取消！";
		}
		
		return "TRUE@";
	}
	
	/***
	 * 确定合同借据状态
	 * @return
	 */
	public String checkLoanStatus(Transaction transaction, String contractNO) throws Exception {
		
		String sql = "";
		String loanStatus = "";
		ASResultSet rs = null;
		sql = "SELECT A.LOANSTATUS FROM ACCT_LOAN A WHERE A.PUTOUTNO = :PUTOUTNO";
		rs = transaction.getASResultSet(new SqlObject(sql).setParameter("PUTOUTNO", contractNO));
		if (rs.next()) {
			loanStatus = rs.getString("LOANSTATUS");
		}
		rs.getStatement().close();
		if ("2".equals(loanStatus) || "3".equals(loanStatus) || "4".equals(loanStatus)) {
			return "FALSE@合同号为：" + contractNO + " 已经结清，无法申请取消随心还服务包！";
		}
		
		return "TRUE@";
	}
	
	/**
	 * 客户名下所有合同是否有逾期 
	 * @return
	 */
	public String checkContractIsOverdue(Transaction transaction, String customerId) throws Exception {
		
		ASResultSet rs = null;
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT COUNT(1) AS CNT FROM ACCT_PAYMENT_SCHEDULE A ");
		sb.append("INNER JOIN ACCT_LOAN B ON B.SERIALNO = A.OBJECTNO ");
		sb.append("OR B.SERIALNO = A.RELATIVEOBJECTNO WHERE B.CUSTOMERID = :CUSTOMERID ");
		sb.append("AND TO_NUMBER(NVL(A.PAYPRINCIPALAMT, 0)) + TO_NUMBER(NVL(A.PAYINTEAMT, 0)) <> ");
		sb.append("TO_NUMBER(NVL(A.ACTUALPAYPRINCIPALAMT, 0)) + TO_NUMBER(NVL(A.ACTUALPAYINTEAMT, 0)) ");
		sb.append("AND A.PAYDATE <= :PAYDATE");
		rs = transaction.getASResultSet(new SqlObject(sb.toString())
					.setParameter("CUSTOMERID", customerId)
					.setParameter("PAYDATE", SystemConfig.getBusinessDate()));
		if (rs.next()) {
			int cnt = rs.getInt("CNT");
			if (cnt > 0) {
				return "FALSE@客户编号为：" + customerId + "有合同逾期未还清，无法申请取消随心还服务包！";
			}
		}
		rs.getStatement().close();
		
		return "TRUE@";
	}
	
	/**
	 * 检查合同各类型申请的申请状态
	 * @param transaction
	 * @param contractNO
	 * @param customerId
	 * @param customerName
	 * @return
	 */
	public String checkContractApplyStatus(Transaction transaction, String contractNO, 
			String customerId, String customerName) throws Exception {
		
		String transName = "";
		ASResultSet rs = null;
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT PA.SERIALNO, '提前还款' AS TRANSNAME FROM PREPAYMENT_APPLAY PA WHERE ");
		sb.append("(PA.CONTRACT_SERIALNO = :CONTRACT_NO_A OR PA.CONTRACT_SERIALNO = (SELECT N.PUTOUTNO ");
		sb.append("FROM ACCT_LOAN N WHERE N.PUTOUTNO = :CONTRACT_NO_A) OR PA.CONTRACT_SERIALNO = ");
		sb.append("(SELECT N.PUTOUTNO FROM ACCT_FEE F, ACCT_LOAN N WHERE F.OBJECTNO = N.SERIALNO ");
		sb.append("AND F.SERIALNO = :CONTRACT_NO_A)) AND PA.STATUS = '0' ");
		sb.append("UNION ALL ");
		sb.append("SELECT T.SERIALNO, T.TRANSNAME FROM ACCT_TRANSACTION T WHERE (T.RELATIVEOBJECTNO ");
		sb.append("= :CONTRACT_NO_A OR T.RELATIVEOBJECTNO = (SELECT N.SERIALNO FROM ACCT_LOAN N WHERE ");
		sb.append("N.PUTOUTNO = :CONTRACT_NO_A) OR T.RELATIVEOBJECTNO = (SELECT N.SERIALNO FROM ACCT_FEE F, ");
		sb.append("ACCT_LOAN N WHERE F.OBJECTNO = N.SERIALNO AND F.SERIALNO = :CONTRACT_NO_A)) AND ");
		sb.append("T.TRANSSTATUS IN('0', '3') AND T.TRANSCODE NOT IN('9091', '9092') ");
		sb.append("UNION ALL ");
		sb.append("SELECT T.SERIALNO, T.TRANSNAME FROM ACCT_TRANSACTION T WHERE T.RELATIVEOBJECTNO ");
		sb.append("IN (SELECT F.SERIALNO FROM ACCT_FEE F, ACCT_LOAN N WHERE F.OBJECTTYPE = ");
		sb.append("'JBO.APP.ACCT_LOAN' AND F.OBJECTNO = N.SERIALNO AND N.PUTOUTNO = :CONTRACT_NO_A) ");
		sb.append("AND T.TRANSSTATUS IN('0', '3') AND T.TRANSCODE NOT IN('9091', '9092') ");
		sb.append("UNION ALL ");
		sb.append("SELECT B.SERIALNO, '退保' AS TRANSNAME FROM BATCH_MINGAN_INSURANCE B WHERE ");
		sb.append("(B.SERIALNO = :CONTRACT_NO_A OR B.SERIALNO = (SELECT N.PUTOUTNO FROM ACCT_LOAN N ");
		sb.append("WHERE N.PUTOUTNO = :CONTRACT_NO_A) OR B.SERIALNO = (SELECT N.PUTOUTNO FROM ");
		sb.append("ACCT_FEE F, ACCT_LOAN N WHERE F.OBJECTNO = N.SERIALNO AND ");
		sb.append("F.SERIALNO = :CONTRACT_NO_A)) AND B.STATUS IN('3') ");
		sb.append("UNION ALL ");
		sb.append("SELECT RC.SERIALNO, '退货' AS TRANSNAME FROM REFUND_CARGO RC WHERE ");
		sb.append("RC.APPROVEUSERID IS NULL AND (RC.SERIALNO = :CONTRACT_NO_A OR RC.SERIALNO = ");
		sb.append("(SELECT N.PUTOUTNO FROM ACCT_LOAN N WHERE  N.SERIALNO = :CONTRACT_NO_A) OR ");
		sb.append("RC.SERIALNO = (SELECT N.PUTOUTNO FROM ACCT_FEE F,ACCT_LOAN N WHERE ");
		sb.append("F.OBJECTNO = N.SERIALNO AND F.SERIALNO = :CONTRACT_NO_A)) ");
		sb.append("UNION ALL ");
		sb.append("SELECT A.SERIALNO, '随心还服务' AS TRANSNAME FROM BOMTR_APPLY_INFO A WHERE A.STATUS ");
		sb.append("NOT IN ('2', '3') AND (A.CONTRACTNO = :CONTRACT_NO_A OR A.CONTRACTNO = (SELECT N.PUTOUTNO ");
		sb.append("FROM ACCT_LOAN N WHERE N.SERIALNO = :CONTRACT_NO_A) OR A.CONTRACTNO = (SELECT N.PUTOUTNO ");
		sb.append("FROM ACCT_FEE F, ACCT_LOAN N WHERE F.OBJECTNO = N.SERIALNO AND F.SERIALNO = :CONTRACT_NO_A))");
		rs = transaction.getASResultSet(new SqlObject(sb.toString())
								.setParameter("CONTRACT_NO_A", contractNO));
		if (rs.next()) {
			transName = rs.getString("TRANSNAME");
		}
		rs.getStatement().close();
		if (!"".equals(transName)) {
			if ("虚拟配账".equals(transName)) {
				return "FALSE@客户：" + customerName + "(客户编号为" + customerId 
						+ ")有一笔" + transName + "业务正在进行中，不允许同时申请！";
			} else {
				return "FALSE@合同号：" + contractNO + "有一笔" + transName + "业务正在进行中，不允许同时申请！";
			}
		}
		
		return "TRUE@";
	}
	
	private String checkIsUsedHistory(Transaction transaction, String contractNO) throws SQLException {
		
		StringBuffer sb = new StringBuffer();
		int cnt = 0;
		sb.append("SELECT COUNT(1) AS CNT FROM BOMTR_USE_LOG WHERE CONTRACTNO = :CONTRACTNO");
		String res = transaction.getString(new SqlObject(sb.toString()).setParameter("CONTRACTNO", contractNO));
		if (res == null || "".equals(res)) {
			cnt = 0;
		} else {
			cnt = Integer.parseInt(res);
		}
		if (cnt > 0) {
			return "FALSE@该笔合同已经使用过随心还服务，无法取消服务！";
		}
		
		return "TRUE@";
	}

	public String getContractNO() {
		return contractNO;
	}

	public void setContractNO(String contractNO) {
		this.contractNO = contractNO;
	}
}
