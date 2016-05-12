package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.amarsoft.app.util.BOMTRUseCountVO;
import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class BOMTRApply {
	/*流水号*/
	private String serialNo;
	/*合同号*/
	private String contractNO;
	/*客户ID*/
	private String customerId;
	/*客户姓名*/
	private String customerName;
	/*客户证件ID*/
	private String certId;
	/*客户证件类型*/
	private String certType;
	/*变更类型：00-延期还款（随心还）01-变更还款日期（随心还）02-优惠提前还款*/
	private String alterType;
	/*开始变更的还款日(变化前)*/
	private String curPaydate;
	/*变更值--延期还款：期数；变更还款日：日期（几号）*/
	private String alterValue;
	/*变更后的第一个还款日(变化后)*/
	private String alterPaydate;
	/*申请状态：0-申请中；1-已通过；2-已拒绝。*/
	private String status;
	/*申请原因*/
	private String applyReason;
	/*申请时间（服务器）*/
	private String applyTime;
	/*申请系统时间（SYSTEM_SETTUP.BUSINESS_DATE）*/
	private String applySysdate;
	/*审核人ID*/
	private String approveUserid;
	/*审核时间（服务器）*/
	private String approveTime;
	/*审核系统时间（SYSTEM_SETTUP.BUSINESS_DATE）*/
	private String approveSysdate;
	/*审批意见*/
	private String approveOpinion;
	/*剩余服务次数*/
	private String leftTimes;
	/*上次申请时间（服务器）*/
	private String preApplytime;
	/*录入的用户ID*/
	private String inputUserid;
	/*录入的服务器时间*/
	private String inputTime;
	/*录入的系统时间（SYSTEM_SETTUP.BUSINESS_DATE）*/
	private String inputSysdate;
	/*更新的用户ID*/
	private String updateUserid;
	/*更新的服务器时间*/
	private String updateTime;
	/*更新的系统时间（SYSTEM_SETTUP.BUSINESS_DATE）*/
	private String updateSysdate;
	/*备注*/
	private String remark;
	/*是否有随心还*/
	private String isBomtr;
		
	private Calendar cal = Calendar.getInstance();
	
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");//定义日期格式
	
	private SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy/MM/dd");//定义日期格式
	
	private Log logger = ARE.getLog();
	
	/**
	 * 提交上申请
	 * @return
	 */
	public String submitApply(Transaction transaction) {
		
		StringBuffer sb = new StringBuffer("INSERT INTO BOMTR_APPLY_INFO (SERIALNO, CONTRACTNO, CUSTOMERID, CUSTOMERNAME, CERTID, CERTTYPE, ");
		sb.append ("ALTER_TYPE, CUR_PAYDATE, ALTER_VALUE, ALTER_PAYDATE, STATUS, ");
		sb.append ("APPLY_REASON, APPLY_TIME, APPLY_SYSDATE, APPROVE_USERID, APPROVE_TIME, APPROVE_SYSDATE, APPROVE_OPINION, ");
		sb.append ("LEFT_TIMES, PRE_APPLYTIME, INPUT_USERID, INPUT_TIME, INPUT_SYSDATE, UPDATE_USERID, UPDATE_TIME, ");
		sb.append ("UPDATE_SYSDATE, REMARK, IS_BOMTR)VALUES (:SERIALNO, :CONTRACTNO, :CUSTOMERID, :CUSTOMERNAME, :CERTID, ");
		sb.append (":CERTTYPE, :ALTER_TYPE, :CUR_PAYDATE, :ALTER_VALUE, :ALTER_PAYDATE, ");
		sb.append (":STATUS, :APPLY_REASON, :APPLY_TIME, :APPLY_SYSDATE, :APPROVE_USERID, ");
		sb.append (":APPROVE_TIME, :APPROVE_SYSDATE, :APPROVE_OPINION, :LEFT_TIMES, :PRE_APPLYTIME, :INPUT_USERID, ");
		sb.append (":INPUT_TIME, :INPUT_SYSDATE, :UPDATE_USERID, :UPDATE_TIME, :UPDATE_SYSDATE, :REMARK, :IS_BOMTR)");
		
		if ("00".equals(alterType)) {
			remark = "期次";
		} else if ("01".equals(alterType)) {
			remark = "号";
		}
		Date date = new Date();
		inputTime = sdf.format(date);
		updateTime = sdf.format(date);
		approveTime = sdf.format(date);
		
		try {
			approveUserid = "SYSTEM";
			approveOpinion = "审核通过";
			inputSysdate = transaction.getString(new SqlObject(
					"SELECT BUSINESSDATE FROM SYSTEM_SETUP"));
			updateSysdate = inputSysdate;
			applySysdate = inputSysdate;
			approveSysdate = inputSysdate;
			transaction.executeSQL(new SqlObject(sb.toString())
				.setParameter("SERIALNO",serialNo)
				.setParameter("CONTRACTNO",contractNO)
				.setParameter("CUSTOMERID",customerId)
				.setParameter("CUSTOMERNAME",customerName)
				.setParameter("CERTID",certId)
				.setParameter("CERTTYPE",certType)
				.setParameter("ALTER_TYPE",alterType)
				.setParameter("CUR_PAYDATE",curPaydate)
				.setParameter("ALTER_VALUE",alterValue)
				.setParameter("ALTER_PAYDATE",alterPaydate)
				.setParameter("STATUS",status)
				.setParameter("APPLY_REASON",applyReason)
				.setParameter("APPLY_TIME",applyTime)
				.setParameter("APPLY_SYSDATE",applySysdate)
				.setParameter("APPROVE_USERID",approveUserid)
				.setParameter("APPROVE_TIME",approveTime)
				.setParameter("APPROVE_SYSDATE",approveSysdate)
				.setParameter("APPROVE_OPINION",approveOpinion)
				.setParameter("LEFT_TIMES",leftTimes)
				.setParameter("PRE_APPLYTIME",preApplytime)
				.setParameter("INPUT_USERID",inputUserid)
				.setParameter("INPUT_TIME",inputTime)
				.setParameter("INPUT_SYSDATE",inputSysdate)
				.setParameter("UPDATE_USERID",updateUserid)
				.setParameter("UPDATE_TIME",updateTime)
				.setParameter("UPDATE_SYSDATE",updateSysdate)
				.setParameter("REMARK",remark)
				.setParameter("IS_BOMTR", "1"));
			cal.setTime(sdfDate.parse(alterPaydate));
			int alterMonth = cal.get(Calendar.MONTH);
			cal.setTime(sdfDate.parse(curPaydate));
			int curMonth = cal.get(Calendar.MONTH);
			int alterMonthValue = alterMonth - curMonth;
			if ("01".equals(alterType)){
				String nextDueDate = "";
				StringBuffer sql = new StringBuffer();
				sql.append("SELECT BC.SERIALNO, BC.BUGPAYPKGIND, B.NEXTDUEDATE, BC.PERIODS FROM BUSINESS_CONTRACT BC ");
				sql.append("INNER JOIN ACCT_LOAN B ON B.PUTOUTNO = BC.SERIALNO WHERE BC.CONTRACTSTATUS = '050' ");
				sql.append("AND EXISTS (SELECT 1 FROM BUSINESS_CONTRACT BCA WHERE BCA.CUSTOMERID = BC.CUSTOMERID ");
				sql.append("AND BCA.SERIALNO <> BC.SERIALNO AND BCA.SERIALNO = :SERIALNO)");
				ASResultSet srs = transaction.getASResultSet(new SqlObject(sql.toString())
							.setParameter("SERIALNO", contractNO));
				while(srs.next()){
					contractNO = srs.getString("SERIALNO");
					isBomtr = srs.getString("BUGPAYPKGIND");
					String periods = srs.getString("PERIODS");
					nextDueDate = srs.getString("NEXTDUEDATE");
					if (!"1".equals(isBomtr)) {
						isBomtr = "0";
					}
					
					sql = new StringBuffer();
					sql.append("SELECT DISTINCT A.PAYDATE AS PAYDATE, A.SEQID AS SEQID, B.PUTOUTNO AS PUTOUTNO FROM ACCT_PAYMENT_SCHEDULE A ");
					sql.append("INNER JOIN ACCT_LOAN B ON (B.SERIALNO = A.OBJECTNO OR B.SERIALNO = A.RELATIVEOBJECTNO) ");
					sql.append("AND (B.CURRENTPERIOD = A.SEQID OR B.CURRENTPERIOD + 1 = A.SEQID) WHERE B.PUTOUTNO = :PUTOUTNO ");
					sql.append("ORDER BY SEQID");
					ASResultSet rs = transaction.getASResultSet(new SqlObject(sql.toString())
								.setParameter("PUTOUTNO", contractNO));
					while(rs.next()){
						if(curPaydate == null || "".equals(curPaydate)){
							curPaydate = rs.getString("PAYDATE");
							continue;
						}
					}
					rs.getStatement().close();	
					if (curPaydate == null || "".equals(curPaydate)) {
						curPaydate = nextDueDate;
					}
					
					cal.setTime(sdfDate.parse(curPaydate));
					cal.set(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), Integer.parseInt(alterValue));
					cal.add(Calendar.MONTH, alterMonthValue);
					alterPaydate = sdfDate.format(cal.getTime());
					
					sb = new StringBuffer("");
					sb.append("SELECT COUNT(1) AS CNT, NVL(SUM(TOTAL_USE_CNT) - SUM(TOTAL_USED_CNT), 0) ");
					sb.append("AS LEFTTIME FROM BOMTR_USE_COUNT WHERE OBJECTNO = :OBJECTNO ");
					sb.append("AND OBJECTTYPE = '1'");
					rs = transaction.getASResultSet(new SqlObject(sb.toString())
								.setParameter("OBJECTNO", contractNO));
					String cnt = "0";
					String leftTimeStr = "0";
					if (rs.next()) {
						cnt = rs.getString("CNT");
						leftTimeStr = rs.getString("LEFTTIME");
					}
					rs.getStatement().close();
					/*String cnt = transaction.getString(new SqlObject(sb.toString())
								.setParameter("OBJECTNO", contractNO));*/
					if (Integer.parseInt(cnt) == 0 && "1".equals(isBomtr)) {		// 没有记录，生成一条新记录
						
						// 系统时间
						String period = "";

						// 判断期次，后续将根据期次的取值来决定BOMTR_CONFIG的WHERE条件
						int pt = Integer.parseInt(periods == null || "".equals(periods) ? "0" : periods);
						if (pt <= 12) {
							period = "12";
						} else if (pt <= 24 && pt > 12) {
							period = "1224";
						} else if (pt <= 36 && pt > 24) {
							period = "2436";
						} else {
							period = "2436";
						}

						// 根据期次在BOMTR_CONFIG中取值
						BOMTRUseCountVO bomtrUseCount = new BOMTRUseCountVO();
						sb = new StringBuffer("");
						sb.append("SELECT DELAYREPAY, ALTERPAYDATE, FAVREPAYMENT, DR_PRE_APPLYDAYS, AP_PRE_APPLYDAYS, ");
						sb.append("FR_PRE_APPLYDAYS, MAX_DELSEQS, DR_FIRST_SERPSEQS, DR_SEC_SERPSEQS, AP_FIRST_SERPSEQS, ");
						sb.append("AP_SEC_SERPSEQS, FR_FIRST_SERPSEQS, TOTAL_CNT FROM BOMTR_CONFIG WHERE PERIOD_TIME = :PERIOD_TIME");
						rs = transaction.getASResultSet(new SqlObject(sb.toString()).setParameter(
								"PERIOD_TIME", period));
						if (rs.next()) {
							bomtrUseCount.setObjectNO(contractNO);
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
							leftTimeStr = String.valueOf(
									bomtrUseCount.getTotalUseCnt() - bomtrUseCount.getTotalUsedCnt());
						}
						rs.getStatement().close();

						// 将所有值插入BOMTR_USE_COUNT中
						sb = new StringBuffer(
								"INSERT INTO BOMTR_USE_COUNT (OBJECTNO, OBJECTTYPE, CUSTOMERID, ");
						sb.append("CUSTOMERNAME, TOTAL_USE_CNT, DR_USE_CNT, AP_USE_CNT, FR_USE_CNT, TOTAL_USED_CNT, DR_USED_CNT, ");
						sb.append("AP_USED_CNT, FR_USED_CNT, DR_PRE_APPLYDAYS, AP_PRE_APPLYDAYS, FR_PRE_APPLYDAYS, MAX_DELSEQS, ");
						sb.append("DR_FIRST_SERPSEQS, AP_FIRST_SERPSEQS, FR_FIRST_SERPSEQS, DR_SEC_SERPSEQS, AP_SEC_SERPSEQS, ");
						sb.append("INPUT_USERID, INPUT_TIME, INPUT_SYSDATE, UPDATE_USERID, UPDATE_TIME, UPDATE_SYSDATE) VALUES ");
						sb.append("(:OBJECTNO, :OBJECTTYPE, :CUSTOMERID, :CUSTOMERNAME, :TOTAL_USE_CNT, :DR_USE_CNT, :AP_USE_CNT, ");
						sb.append(":FR_USE_CNT, :TOTAL_USED_CNT, :DR_USED_CNT, :AP_USED_CNT, :FR_USED_CNT, :DR_PRE_APPLYDAYS, ");
						sb.append(":AP_PRE_APPLYDAYS, :FR_PRE_APPLYDAYS, :MAX_DELSEQS, :DR_FIRST_SERPSEQS, :AP_FIRST_SERPSEQS, ");
						sb.append(":FR_FIRST_SERPSEQS, :DR_SEC_SERPSEQS, :AP_SEC_SERPSEQS, :INPUT_USERID, :INPUT_TIME, :INPUT_SYSDATE, ");
						sb.append(":UPDATE_USERID, :UPDATE_TIME, :UPDATE_SYSDATE) ");

						transaction.executeSQL(new SqlObject(sb.toString())
								.setParameter("OBJECTNO", bomtrUseCount.getObjectNO())
								.setParameter("OBJECTTYPE", "1")
								.setParameter("CUSTOMERID", bomtrUseCount.getCustomerId())
								.setParameter("CUSTOMERNAME",
										bomtrUseCount.getCustomerName())
								.setParameter("TOTAL_USE_CNT",
										bomtrUseCount.getTotalUseCnt())
								.setParameter("DR_USE_CNT", bomtrUseCount.getDrUseCnt())
								.setParameter("AP_USE_CNT", bomtrUseCount.getApUseCnt())
								.setParameter("FR_USE_CNT", bomtrUseCount.getFrUseCnt())
								.setParameter("TOTAL_USED_CNT", "0")
								.setParameter("DR_USED_CNT", "0")
								.setParameter("AP_USED_CNT", "0")
								.setParameter("FR_USED_CNT", "0")
								.setParameter("DR_PRE_APPLYDAYS",
										bomtrUseCount.getDrPreApplyDays())
								.setParameter("AP_PRE_APPLYDAYS",
										bomtrUseCount.getApPreApplyDays())
								.setParameter("FR_PRE_APPLYDAYS",
										bomtrUseCount.getFrPreApplyDays())
								.setParameter("MAX_DELSEQS", bomtrUseCount.getMaxDelSeqs())
								.setParameter("DR_FIRST_SERPSEQS",
										bomtrUseCount.getDrFirstSeRPSeqs())
								.setParameter("DR_SEC_SERPSEQS",
										bomtrUseCount.getDrSecSeRPSeqs())
								.setParameter("AP_FIRST_SERPSEQS",
										bomtrUseCount.getApFirstSeRPSeqs())
								.setParameter("AP_SEC_SERPSEQS",
										bomtrUseCount.getApSecSeRPSeqs())
								.setParameter("FR_FIRST_SERPSEQS",
										bomtrUseCount.getFrFirstSeRPSeqs())
								.setParameter("INPUT_USERID", inputUserid)
								.setParameter("INPUT_TIME", inputTime)
								.setParameter("INPUT_SYSDATE", applySysdate)
								.setParameter("UPDATE_USERID", updateUserid)
								.setParameter("UPDATE_TIME", updateTime)
								.setParameter("UPDATE_SYSDATE", applySysdate));
					}
					
					sb = new StringBuffer("INSERT INTO BOMTR_APPLY_INFO (SERIALNO, CONTRACTNO, CUSTOMERID, CUSTOMERNAME, CERTID, CERTTYPE, ");
					sb.append ("ALTER_TYPE, CUR_PAYDATE, ALTER_VALUE, ALTER_PAYDATE, STATUS, ");
					sb.append ("APPLY_REASON, APPLY_TIME, APPLY_SYSDATE, APPROVE_USERID, APPROVE_TIME, APPROVE_SYSDATE, APPROVE_OPINION, ");
					sb.append ("LEFT_TIMES, PRE_APPLYTIME, INPUT_USERID, INPUT_TIME, INPUT_SYSDATE, UPDATE_USERID, UPDATE_TIME, ");
					sb.append ("UPDATE_SYSDATE, REMARK, IS_BOMTR)VALUES (:SERIALNO, :CONTRACTNO, :CUSTOMERID, :CUSTOMERNAME, :CERTID, ");
					sb.append (":CERTTYPE, :ALTER_TYPE, :CUR_PAYDATE, :ALTER_VALUE, :ALTER_PAYDATE, ");
					sb.append (":STATUS, :APPLY_REASON, :APPLY_TIME, :APPLY_SYSDATE, :APPROVE_USERID, ");
					sb.append (":APPROVE_TIME, :APPROVE_SYSDATE, :APPROVE_OPINION, :LEFT_TIMES, :PRE_APPLYTIME, :INPUT_USERID, ");
					sb.append (":INPUT_TIME, :INPUT_SYSDATE, :UPDATE_USERID, :UPDATE_TIME, :UPDATE_SYSDATE, :REMARK, :IS_BOMTR)");
					transaction.executeSQL(new SqlObject(sb.toString())
						.setParameter("SERIALNO", DBKeyUtils.getSerialNo())
						.setParameter("CONTRACTNO",contractNO)
						.setParameter("CUSTOMERID",customerId)
						.setParameter("CUSTOMERNAME",customerName)
						.setParameter("CERTID",certId)
						.setParameter("CERTTYPE",certType)
						.setParameter("ALTER_TYPE",alterType)
						.setParameter("CUR_PAYDATE",curPaydate)
						.setParameter("ALTER_VALUE",alterValue)
						.setParameter("ALTER_PAYDATE",alterPaydate)
						.setParameter("STATUS",status)
						.setParameter("APPLY_REASON",applyReason)
						.setParameter("APPLY_TIME",applyTime)
						.setParameter("APPLY_SYSDATE",applySysdate)
						.setParameter("APPROVE_USERID",approveUserid)
						.setParameter("APPROVE_TIME",approveTime)
						.setParameter("APPROVE_SYSDATE",approveSysdate)
						.setParameter("APPROVE_OPINION",approveOpinion)
						.setParameter("LEFT_TIMES",leftTimeStr)
						.setParameter("PRE_APPLYTIME",preApplytime)
						.setParameter("INPUT_USERID",inputUserid)
						.setParameter("INPUT_TIME",inputTime)
						.setParameter("INPUT_SYSDATE",inputSysdate)
						.setParameter("UPDATE_USERID",updateUserid)
						.setParameter("UPDATE_TIME",updateTime)
						.setParameter("UPDATE_SYSDATE",updateSysdate)
						.setParameter("REMARK",remark)
						.setParameter("IS_BOMTR",isBomtr));
				}
				srs.getStatement().close();
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			try {
				transaction.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
				return "false@系统异常，请联系IT相关人员！";
			}
			return "false@系统异常，请联系IT相关人员！";
		}
			return "true@提交成功！";
	}
	
	

	public String cancelApproval(Transaction transaction) {// 取消申请

		Date DA=new Date();
		updateTime = sdf.format(DA);
		updateUserid = "SYSTEM";
		status = "2";/* 修改申请状态为“0”已取消 */

		try {
			updateSysdate = (transaction.getString(new SqlObject(
					"SELECT BUSINESSDATE FROM SYSTEM_SETUP")));
			
			if(alterType.equals("01")){
			StringBuffer sql = new StringBuffer();
					sql.append("UPDATE BOMTR_APPLY_INFO SET STATUS=:STATUS,UPDATE_USERID=:UPDATE_USERID,");
					sql.append("UPDATE_TIME=:UPDATE_TIME,UPDATE_SYSDATE=:UPDATE_SYSDATE WHERE ALTER_TYPE NOT IN ('00','02')");
					sql.append("AND CUSTOMERID = :CUSTOMERID AND STATUS = '0'");
			
			transaction.executeSQL(new SqlObject(sql.toString())
					.setParameter("STATUS", status)
					.setParameter("CUSTOMERID", customerId)
					.setParameter("UPDATE_TIME", updateTime)
					.setParameter("UPDATE_USERID", updateUserid)
					.setParameter("ALTER_TYPE", alterType)
					.setParameter("UPDATE_SYSDATE", updateSysdate));
			}
			if (alterType.equals("00") || alterType.equals("02")){
				StringBuffer sql = new StringBuffer();
				sql.append("UPDATE BOMTR_APPLY_INFO SET STATUS=:STATUS,UPDATE_USERID=:UPDATE_USERID,");
				sql.append("UPDATE_TIME=:UPDATE_TIME,UPDATE_SYSDATE=:UPDATE_SYSDATE WHERE SERIALNO=:SERIALNO");

		
				transaction.executeSQL(new SqlObject(sql.toString())
					.setParameter("STATUS", status)
					.setParameter("SERIALNO", serialNo)
					.setParameter("UPDATE_TIME", updateTime)
					.setParameter("UPDATE_USERID", updateUserid)
					.setParameter("UPDATE_SYSDATE", updateSysdate));
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			return "false@系统异常，请联系IT相关人员！";
		}

		return "true@取消成功！";

	}

	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public String getContractNO() {
		return contractNO;
	}
	public void setContractNO(String contractNO) {
		this.contractNO = contractNO;
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
	public String getCertId() {
		return certId;
	}
	public void setCertId(String certId) {
		this.certId = certId;
	}
	public String getCertType() {
		return certType;
	}

	public void setCertType(String certType) {
		this.certType = certType;
	}

	public String getAlterType() {
		return alterType;
	}
	public void setAlterType(String alterType) {
		this.alterType = alterType;
	}
	public String getCurPaydate() {
		return curPaydate;
	}
	public void setCurPaydate(String curPaydate) {
		this.curPaydate = curPaydate;
	}
	public String getAlterValue() {
		return alterValue;
	}
	public void setAlterValue(String alterValue) {
		this.alterValue = alterValue;
	}
	public String getAlterPaydate() {
		return alterPaydate;
	}
	public void setAlterPaydate(String alterPaydate) {
		this.alterPaydate = alterPaydate;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getApplyReason() {
		return applyReason;
	}
	public void setApplyReason(String applyReason) {
		this.applyReason = applyReason;
	}
	public String getApplyTime() {
		return applyTime;
	}
	public void setApplyTime(String applyTime) {
		this.applyTime = applyTime;
	}
	public String getApplySysdate() {
		return applySysdate;
	}
	public void setApplySysdate(String applySysdate) {
		this.applySysdate = applySysdate;
	}
	public String getApproveUserid() {
		return approveUserid;
	}
	public void setApproveUserid(String approveUserid) {
		this.approveUserid = approveUserid;
	}
	public String getApproveTime() {
		return approveTime;
	}
	public void setApproveTime(String approveTime) {
		this.approveTime = approveTime;
	}
	public String getApproveSysdate() {
		return approveSysdate;
	}
	public void setApproveSysdate(String approveSysdate) {
		this.approveSysdate = approveSysdate;
	}
	public String getApproveOpinion() {
		return approveOpinion;
	}
	public void setApproveOpinion(String approveOpinion) {
		this.approveOpinion = approveOpinion;
	}
	public String getLeftTimes() {
		return leftTimes;
	}
	public void setLeftTimes(String leftTimes) {
		this.leftTimes = leftTimes;
	}
	public String getPreApplytime() {
		return preApplytime;
	}
	public void setPreApplytime(String preApplytime) {
		this.preApplytime = preApplytime;
	}
	public String getInputUserid() {
		return inputUserid;
	}
	public void setInputUserid(String inputUserid) {
		this.inputUserid = inputUserid;
	}
	public String getInputTime() {
		return inputTime;
	}
	public void setInputTime(String inputTime) {
		this.inputTime = inputTime;
	}
	public String getInputSysdate() {
		return inputSysdate;
	}
	public void setInputSysdate(String inputSysdate) {
		this.inputSysdate = inputSysdate;
	}
	public String getUpdateUserid() {
		return updateUserid;
	}
	public void setUpdateUserid(String updateUserid) {
		this.updateUserid = updateUserid;
	}
	public String getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}
	public String getUpdateSysdate() {
		return updateSysdate;
	}
	public void setUpdateSysdate(String updateSysdate) {
		this.updateSysdate = updateSysdate;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getIsBomtr() {
		return isBomtr;
	}
	public void setIsBomtr(String isBomtr) {
		this.isBomtr = isBomtr;
	}
}
