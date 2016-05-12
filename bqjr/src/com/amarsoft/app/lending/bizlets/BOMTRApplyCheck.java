package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import com.amarsoft.app.util.BOMTRUseCountVO;
import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class BOMTRApplyCheck {

	/** 合同号 （参数） **/
	private String contractNo;

	/** 服务类型 （参数）:00延期还款,01变更还款日期,02优惠提前还款,03取消随心还服务 **/
	private String alterType;

	/** 变更值 （参数） **/
	private String alterValue;

	/** 客户ID（参数） **/
	private String customerId;

	/** 客户姓名（参数） **/
	private String customerName;

	/** 申请时间取当前日期 （参数） **/
	private String applyTime;

	/** 当前还款日 （参数） **/
	private String curPayDate;

	/** 上次申请日期 （返回值） **/
	private String preApplyTime;

	/** 首次变更后的还款日 （参数） **/
	private String alterPayDate;

	/** 当前第几次使用随心还服务 **/
	private int curUseTime = 0;

	/** 根据服务类型判断这是什么服务的可使用次数(非剩余可使用次数) **/
	private int useCnt = 0;

	/** 根据服务类型判断这是什么的已使用次数 **/
	private int usedCnt = 0;

	/** 首次使用连续还款期数 **/
	private int firstSeRPSeqs = 0;

	/** 第二次及以上使用时连续还款期数 **/
	private int secSeRPSeqs = 0;

	/** 提前几天申请 **/
	private int preApplyDays = 0;

	/** 申请人 **/
	private String inputUserId;

	/** 输入时间 **/
	private String inputDate;

	/** 合同期数 **/
	private int pt;

	private int count = 0;

	/** 基础统计表信息 **/
	private BOMTRUseCountVO bomtrUseCount = new BOMTRUseCountVO();

	private SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy/MM/dd");

	private Calendar cal = Calendar.getInstance();

	private Log logger = ARE.getLog();

	public String applyCheck(Transaction transaction) {

		String result = "";
		// 初始化基础数据
		try {
			result = init(transaction);
			if (!"true".equals(result)) {
				return result;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			logger.error("【系统异常！】" + e.getMessage());
			return "false@系统异常！";
		}

		// 校验数据
		result = checkData(transaction);
		if (!"true".equals(result)) {
			return result;
		}

		// 计算变更值
		try {
			result = calcValue();
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("【系统异常！】" + e.getMessage());
			return "false@系统异常，日期计算错误！";
		}

		return result;
	}

	private String calcValue() throws Exception {

		String result = "";
		result = "true@" + preApplyTime;
		return result;
	}

	/**
	 * 初始化基础数据
	 * 
	 * @throws SQLException
	 */
	private String init(Transaction transaction) throws SQLException {

		if (contractNo == null || "".equals(contractNo)) {
			return "false@获取不到合同号！";
		}
		if (applyTime == null || "".equals(applyTime)) {
			return "false@获取不到申请时间！";
		}
		if (curPayDate == null || "".equals(curPayDate)) {
			if (!"02".equals(alterType)) {
				return "false@获取不到开始变更日期！";
			}
		}
		if (alterPayDate == null || "".equals(alterPayDate)) {
			if (!"02".equals(alterType)) {
				return "false@获取不到首次变更后还款日期！";
			}
		}
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT MAX(APPLY_TIME) AS LAST_APPLYTIME FROM BOMTR_APPLY_INFO WHERE ");
		sb.append("CONTRACTNO = :CONTRACTNO AND STATUS = '2'");
		ASResultSet rs = transaction
				.getASResultSet(new SqlObject(sb.toString()).setParameter(
						"CONTRACTNO", contractNo));
		if (rs.next()) {
			this.preApplyTime = rs.getString("LAST_APPLYTIME");
		}
		rs.getStatement().close();
		return "true";
	}

	/**
	 * 校验数据
	 * 
	 * @param transaction
	 * @return
	 */
	private String checkData(Transaction transaction) {

		String result = "";

		// 1. 校验基础类型数据是否正确
		result = checkBasicData(transaction);
		if (!"true".equals(result)) {
			return result;
		}
		// 2. 校验合同是否还有使用服务的次数
		result = checkBOMTRTimes(transaction);
		if (!"true".equals(result)) {
			return result;
		}
		// 3. 校验具体业务逻辑
		result = specificBusinessLogic(transaction);
		if (!"true".equals(result)) {
			return result;
		}

		return "true";
	}

	/**
	 * 校验基础类型数据是否正确
	 * 
	 * @return
	 */
	private String checkBasicData(Transaction transaction) {

		StringBuffer sb = null;
		ASResultSet rs = null;
		String contractStatus = "";
		String isbomtr = "";
		String currentPeriod = "";

		try {
			// 校验合同是否存在
			sb = new StringBuffer();
			sb.append("SELECT A.SERIALNO, A.CONTRACTSTATUS, A.BUGPAYPKGIND, B.CURRENTPERIOD FROM ");
			sb.append("BUSINESS_CONTRACT A INNER JOIN ACCT_LOAN B ON B.PUTOUTNO = A.SERIALNO ");
			sb.append("WHERE A.SERIALNO = :SERIALNO");
			rs = transaction.getASResultSet(new SqlObject(sb.toString())
					.setParameter("SERIALNO", contractNo));
			if (!rs.next()) {
				return "false@根据合同号【" + contractNo + "】找不到合同信息！";
			} else {
				contractStatus = rs.getString("CONTRACTSTATUS");
				isbomtr = rs.getString("BUGPAYPKGIND");
				currentPeriod = rs.getString("CURRENTPERIOD");
			}
			rs.getStatement().close();

			if (!"050".equals(contractStatus)) {
				return "false@合同【" + contractNo + "】的合同状态不符合申请随心还服务条件！";
			}
			// 判断随心还服务是否有效（有效指：购买了随心还服务且没取消随心还服务）
			if (isbomtr == null || "".equals(isbomtr) || "0".equals(isbomtr)) {
				return "false@合同【" + contractNo + "】未购买随心还服务！";
			} else if ("2".equals(isbomtr)) {
				return "false@合同【" + contractNo + "】已取消随心还服务！";
			} else if (!"1".equals(isbomtr)) {
				return "false@未知随心还服务标识！";
			}

			if (currentPeriod == null || "".equals(currentPeriod)) {
				return "false@获取当前期次失败！";
			} else if (Integer.parseInt(currentPeriod) <= 0) {
				return "false@该客户未开始还款，无法申请随心还服务！";
			}

			// 获取基础配置信息
			sb = new StringBuffer();
			sb.append("SELECT OBJECTNO, OBJECTTYPE, CUSTOMERID, CUSTOMERNAME, TOTAL_USE_CNT, DR_USE_CNT, ");
			sb.append("AP_USE_CNT, FR_USE_CNT, TOTAL_USED_CNT, DR_USED_CNT, AP_USED_CNT, FR_USED_CNT, ");
			sb.append("DR_PRE_APPLYDAYS, AP_PRE_APPLYDAYS, FR_PRE_APPLYDAYS, MAX_DELSEQS, DR_FIRST_SERPSEQS, ");
			sb.append("DR_SEC_SERPSEQS, AP_FIRST_SERPSEQS, AP_SEC_SERPSEQS, FR_FIRST_SERPSEQS FROM ");
			sb.append("BOMTR_USE_COUNT WHERE OBJECTNO = :OBJECTNO AND OBJECTTYPE = '1'");
			rs = transaction.getASResultSet(new SqlObject(sb.toString())
					.setParameter("OBJECTNO", contractNo));
			if (rs.next()) {
				bomtrUseCount.setObjectNO(rs.getString("OBJECTNO"));
				bomtrUseCount.setObjectType(rs.getString("OBJECTTYPE"));
				bomtrUseCount.setCustomerId(rs.getString("CUSTOMERID"));
				bomtrUseCount.setCustomerName(rs.getString("CUSTOMERNAME"));
				bomtrUseCount.setTotalUseCnt(rs.getInt("TOTAL_USE_CNT"));
				bomtrUseCount.setDrUseCnt(rs.getInt("DR_USE_CNT"));
				bomtrUseCount.setApUseCnt(rs.getInt("AP_USE_CNT"));
				bomtrUseCount.setFrUseCnt(rs.getInt("FR_USE_CNT"));
				bomtrUseCount.setTotalUsedCnt(rs.getInt("TOTAL_USED_CNT"));
				bomtrUseCount.setDrUsedCnt(rs.getInt("DR_USED_CNT"));
				bomtrUseCount.setApUsedCnt(rs.getInt("AP_USED_CNT"));
				bomtrUseCount.setFrUsedCnt(rs.getInt("FR_USED_CNT"));
				bomtrUseCount.setDrPreApplyDays(rs.getInt("DR_PRE_APPLYDAYS"));
				bomtrUseCount.setApPreApplyDays(rs.getInt("AP_PRE_APPLYDAYS"));
				bomtrUseCount.setFrPreApplyDays(rs.getInt("FR_PRE_APPLYDAYS"));
				bomtrUseCount.setMaxDelSeqs(rs.getInt("MAX_DELSEQS"));
				bomtrUseCount
						.setDrFirstSeRPSeqs(rs.getInt("DR_FIRST_SERPSEQS"));
				bomtrUseCount.setDrSecSeRPSeqs(rs.getInt("DR_SEC_SERPSEQS"));
				bomtrUseCount
						.setApFirstSeRPSeqs(rs.getInt("AP_FIRST_SERPSEQS"));
				bomtrUseCount.setApSecSeRPSeqs(rs.getInt("AP_SEC_SERPSEQS"));
				bomtrUseCount
						.setFrFirstSeRPSeqs(rs.getInt("FR_FIRST_SERPSEQS"));
			} else {
				// 新建随心还数据
				String result = updateBOMTRUseCount(transaction);
				if ("false".equals(result.split("@")[0])) {
					return result;
				}
			}
			rs.getStatement().close();

			if (alterType == null || "".equals(alterType)) {
				return "false@获取不到服务类型！";
			}

			if (!"00, 01, 02".contains(alterType)) {
				return "false@无效服务类型！";
			}

			if (alterValue == null || "".equals(alterValue)) {
				if ("00".equals(alterType)) {
					return "false@获取不到延期期数！";
				}
				if ("01".equals(alterType)) {
					return "false@获取不到变更还款日！";
				}
			}

			// 判断变更还款日是否有问题
			if ("01".equals(alterType)) {
				if (Integer.parseInt(alterValue) < 1
						|| Integer.parseInt(alterValue) > 28) {
					return "false@变更还款日取值有误，应为：1~28号！";
				}
			}

			// 判断延期期数是否有问题
			if ("00".equals(alterType)) {
				if (Integer.parseInt(alterValue) > bomtrUseCount
						.getMaxDelSeqs()) {
					return "false@合同【" + contractNo + "】的最多延期期数为："
							+ bomtrUseCount.getMaxDelSeqs();
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("【基础类型数据校验异常！】\n" + e.getMessage());
			return "false@基础类型数据校验异常！";
		}

		return "true";
	}

	/**
	 * 校验合同是否剩余随心还服务次数
	 * 
	 * @param transaction
	 * @return
	 */
	private String checkBOMTRTimes(Transaction transaction) {

		String typeName = ""; // 类型名称
		if ("00".equals(alterType)) { // 延期还款
			count = Integer.parseInt(alterValue);
		} else {
			count = 1;
		}
		if (bomtrUseCount.getTotalUseCnt() <= bomtrUseCount.getTotalUsedCnt()) {
			// 可使用总次数<=已使用总次数，不允许发起申请
			return "false@合同【" + contractNo + "】已经没有【随心还服务】次数！";
		}
		if (bomtrUseCount.getTotalUseCnt() < bomtrUseCount.getTotalUsedCnt()
				+ count) {
			// 可使用总次数<=已使用总次数，不允许发起申请
			return "false@合同【" + contractNo + "】剩余【随心还服务】次数不足够使用，本次需要使用的随心还次数为"
					+ count + " ！";
		}
		if ("00".equals(alterType)) { // 延期还款
			useCnt = bomtrUseCount.getDrUseCnt();
			usedCnt = bomtrUseCount.getDrUsedCnt();
			firstSeRPSeqs = bomtrUseCount.getDrFirstSeRPSeqs();
			secSeRPSeqs = bomtrUseCount.getDrSecSeRPSeqs();
			preApplyDays = bomtrUseCount.getDrPreApplyDays();
			typeName = "延期还款服务";
		} else if ("01".equals(alterType)) { // 变更还款日
			useCnt = bomtrUseCount.getApUseCnt();
			usedCnt = bomtrUseCount.getApUsedCnt();
			firstSeRPSeqs = bomtrUseCount.getApFirstSeRPSeqs();
			secSeRPSeqs = bomtrUseCount.getApSecSeRPSeqs();
			preApplyDays = bomtrUseCount.getApPreApplyDays();
			typeName = "变更还款日服务";
		} else if ("02".equals(alterType)) { // 优惠提前还款
			useCnt = bomtrUseCount.getFrUseCnt();
			usedCnt = bomtrUseCount.getFrUsedCnt();
			firstSeRPSeqs = bomtrUseCount.getFrFirstSeRPSeqs();
			preApplyDays = bomtrUseCount.getFrPreApplyDays();
			typeName = "优惠提前还款服务";
		} else {
			return "false@无效服务类型！";
		}

		if (useCnt <= usedCnt) {
			return "false@合同【" + contractNo + "】已经没有【" + typeName + "】次数！";
		} else {
			curUseTime = bomtrUseCount.getTotalUsedCnt() + count;
			if (useCnt < usedCnt + count) {
				return "false@合同【" + contractNo + "】剩余【" + typeName
						+ "】次数不足够使用，本次需要使用的随心还次数为" + count + " ！";
			}
		}
		if (curUseTime == 0) {
			return "false@合同【" + contractNo + "】获取当前是第几次服务次数失败！";
		}

		return "true";
	}

	/**
	 * 提交时将数据插入BOMTR_USE_COUNT
	 * 
	 * @return
	 * @throws SQLException
	 */
	public String updateBOMTRUseCount(Transaction transaction)
			throws SQLException {

		// 获取系统时间
		String sql = "SELECT BUSINESSDATE FROM SYSTEM_SETUP ";
		ASResultSet rs = transaction.getASResultSet(new SqlObject(sql));
		// 系统时间
		String sysTime = "";
		String period = "";

		if (rs.next()) {
			sysTime = rs.getString("BUSINESSDATE");
		}
		rs.getStatement().close();

		// 判断期次，后续将根据期次的取值来决定BOMTR_CONFIG的WHERE条件
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
		sql = "SELECT DELAYREPAY, ALTERPAYDATE, FAVREPAYMENT, DR_PRE_APPLYDAYS, AP_PRE_APPLYDAYS, "
				+ "FR_PRE_APPLYDAYS, MAX_DELSEQS, DR_FIRST_SERPSEQS, DR_SEC_SERPSEQS, AP_FIRST_SERPSEQS, "
				+ "AP_SEC_SERPSEQS, FR_FIRST_SERPSEQS, TOTAL_CNT FROM BOMTR_CONFIG WHERE PERIOD_TIME = :PERIOD_TIME";
		rs = transaction.getASResultSet(new SqlObject(sql).setParameter(
				"PERIOD_TIME", period));
		if (rs.next()) {
			bomtrUseCount.setObjectNO(contractNo);
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

		// 将所有值插入BOMTR_USE_COUNT中
		StringBuffer sb = new StringBuffer(
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

		try {
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
					.setParameter("INPUT_USERID", inputUserId)
					.setParameter("INPUT_TIME", inputDate)
					.setParameter("INPUT_SYSDATE", sysTime)
					.setParameter("UPDATE_USERID", inputUserId)
					.setParameter("UPDATE_TIME", inputDate)
					.setParameter("UPDATE_SYSDATE", sysTime));
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			return "false@系统异常，请联系IT相关人员！";
		}
		return "true";
	}

	/**
	 * 校验具体业务逻辑
	 * 
	 * @param transaction
	 * @return
	 */
	private String specificBusinessLogic(Transaction transaction) {

		// 随心还服务（延期还款、变更还款日、优惠提前还款）通用校验
		String result = usualSpecBusiLogic(transaction);
		if (!"true".equals(result)) {
			return result;
		}

		/**
		 * 延期还款、变更还款日：如果存在提前还款、退货、退保、退款、取消随心还服务申请、 申请随心还服务等费用操作申请且未生效的
		 * ，不允许提起申请([优惠]提前还款有自身的校验) 和提前还款的校验出处是一致
		 **/
		if ("00".equals(alterType) || "01".equals(alterType)) {
			try {
				result = validate(transaction);
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("【校验合同是否存在未完成的操作时发生异常！】\n" + e.getMessage());
				return "false@校验合同相关信息发生异常！";
			}
			if (!"0".equals(result)) {
				return "false@" + result;
			}
		}

		return "true";
	}

	/**
	 * 验证合同是否存在未完成的操作
	 * 
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String validate(Transaction Sqlca) throws Exception {

		StringBuffer sb = new StringBuffer();
		sb.append(" select t.serialno,t.transname from acct_transaction t where (t.relativeobjectno=:putoutno or t.relativeobjectno=(select n.serialno from acct_loan n where  n.putoutno=:putoutno) or t.relativeobjectno=(select n.serialno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno))  and t.transstatus in('0','3') and  t.transcode not in('9091','9092', '3530', '0090')");
		sb.append(" UNION ALL");
		sb.append(" select t.serialno,t.transname from acct_transaction t where t.relativeobjectno in (select f.serialno from acct_fee f,acct_loan n where f.objecttype='jbo.app.ACCT_LOAN' and f.objectno=n.serialno and   n.putoutno=:putoutno) and t.transstatus in('0','3') and  t.transcode not in('9091','9092', '3530', '0090')");
		sb.append(" UNION ALL");
		sb.append(" select b.contract_no,'退保' as transname from  batch_insurance_info  b where (b.contract_no=:putoutno or b.contract_no=(select n.putoutno from acct_loan n where  n.putoutno=:putoutno) or b.contract_no=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno)) and b.status in('4','5','6')");
		sb.append(" UNION ALL");
		sb.append(" select b.serialno,'退保' as transname from  batch_mingan_insurance  b where (b.serialno=:putoutno or b.serialno=(select n.putoutno from acct_loan n where  n.putoutno=:putoutno) or b.serialno=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno)) and b.status in('3')");
		sb.append(" UNION ALL");
		sb.append(" select pa.serialno,'提前还款' as transname from  prepayment_applay  pa where (pa.contract_serialno=:putoutno or pa.contract_serialno=(select n.putoutno from acct_loan n where  n.putoutno=:putoutno) or pa.contract_serialno=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno)) and pa.status ='0'");
		sb.append(" UNION ALL");
		sb.append(" select rc.serialno,'退货' as transname  from REFUND_CARGO rc  where  rc.approveuserid is null and (rc.serialno=:putoutno or rc.serialno=(select n.putoutno from acct_loan n where  n.serialno=:putoutno) or rc.serialno=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno)) ");
		sb.append(" UNION ALL");
		sb.append(" SELECT a.CONTRACTNO, '随心还服务包取消' AS transname FROM BUSINESS_PAYPKG_APPLY A WHERE A.PKGSTATUS = '0' AND (A.CONTRACTNO=:putoutno or A.CONTRACTNO=(select n.putoutno from acct_loan n where  n.putoutno=:putoutno) or A.CONTRACTNO=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno))");
		sb.append(" UNION ALL ");
		sb.append(" SELECT A.SERIALNO, '随心还服务申请' AS TRANSNAME FROM BOMTR_APPLY_INFO A WHERE A.STATUS ");
		sb.append(" NOT IN ('1', '2') AND (A.CONTRACTNO = :putoutno OR A.CONTRACTNO = (SELECT N.PUTOUTNO ");
		sb.append(" FROM ACCT_LOAN N WHERE N.SERIALNO = :putoutno) OR A.CONTRACTNO = (SELECT N.PUTOUTNO ");
		sb.append(" FROM ACCT_FEE F, ACCT_LOAN N WHERE F.OBJECTNO = N.SERIALNO AND F.SERIALNO = :putoutno))");
		String sql = sb.toString();
		SqlObject so = new SqlObject(sql);
		so.setParameter("putoutno", this.contractNo);
		ASResultSet rs = Sqlca.getASResultSet(so);
		if (rs.next()) {
			String transname = rs.getString("transname");
			rs.getStatement().close();
			return "该合同存在一项“" + transname + "”业务进行中，不允许同时申请！";
		} else {
			sb = new StringBuffer("");
			sb.append("SELECT COUNT(1) AS CNT FROM PREPAYMENT_APPLAY PA LEFT JOIN ACCT_LOAN ");
			sb.append("AL ON AL.SERIALNO = PA.LAON_SERIALNO LEFT JOIN ACCT_TRANSACTION T ON ");
			sb.append("PA.AT_SERIALNO = T.SERIALNO WHERE AL.CUSTOMERID = :CUSTOMERID AND ");
			sb.append("NVL(T.TRANSSTATUS, PA.STATUS) IN ('0', '3')");
			if ("01".equals(alterType)) {
				String cnt = Sqlca.getString(new SqlObject(sb.toString())
							.setParameter("CUSTOMERID", customerId));
				if (Integer.parseInt(cnt) > 0) {
					return "该客户存在一项“提前还款”业务进行中，不允许同时申请变更还款日！";
				}
			}
			
			return "0";
		}
	}

	/**
	 * 随心还服务（延期还款、变更还款日、优惠提前还款）通用校验
	 * 
	 * @param transaction
	 * @return
	 */
	private String usualSpecBusiLogic(Transaction transaction) {

		StringBuffer sb = new StringBuffer();
		ASResultSet rs = null;

		try {
			// 1. 判断回盘信息是否返回(待定)
			sb.append("");

			// 2. 判断客户下合同是否有逾期(优惠提前还款不需要校验)
			sb = new StringBuffer();
			int cnt = 0;
			if (!"02".equals(alterType)) {
				sb.append("SELECT COUNT(1) AS CNT FROM ACCT_PAYMENT_SCHEDULE A ");
				sb.append("INNER JOIN ACCT_LOAN B ON B.SERIALNO = A.OBJECTNO ");
				sb.append("OR B.SERIALNO = A.RELATIVEOBJECTNO WHERE B.CUSTOMERID = :CUSTOMERID ");
				sb.append("AND TO_NUMBER(NVL(A.PAYPRINCIPALAMT, 0)) + TO_NUMBER(NVL(A.PAYINTEAMT, 0)) <> ");
				sb.append("TO_NUMBER(NVL(A.ACTUALPAYPRINCIPALAMT, 0)) + TO_NUMBER(NVL(A.ACTUALPAYINTEAMT, 0)) ");
				sb.append("AND A.PAYDATE <= :PAYDATE");

				rs = transaction.getASResultSet(new SqlObject(sb.toString())
						.setParameter("CUSTOMERID", customerId).setParameter(
								"PAYDATE",
								sdfDate.format(sdfDate.parse(this.applyTime))));
				if (rs.next()) {
					cnt = rs.getInt("CNT");
				}
				rs.getStatement().close();
				if (cnt != 0) {
					return "false@客户【" + customerName + "(" + customerId
							+ ")】名下的合同有逾期的状态，不允许申请！";
				}
			}

			cnt = 0;
			// 3. 使用服务时，必定判断足额偿还是否达到N期及以上期款；不是的话，则不让提起申请
			sb = new StringBuffer();
			sb.append("SELECT COUNT(1) AS CNT FROM ACCT_PAYMENT_SCHEDULE A INNER JOIN ACCT_LOAN B ON ");
			sb.append("B.SERIALNO = A.OBJECTNO OR B.SERIALNO = A.RELATIVEOBJECTNO WHERE ");
			sb.append("B.PUTOUTNO = :PUTOUTNO AND A.SEQID <= :SERPSEQS AND A.FINISHDATE IS NULL");
			rs = transaction.getASResultSet(new SqlObject(sb.toString())
					.setParameter("PUTOUTNO", contractNo).setParameter(
							"SERPSEQS", firstSeRPSeqs));
			if (rs.next()) {
				cnt = rs.getInt("CNT");
			}
			rs.getStatement().close();
			if (cnt > 0) {
				return "false@当前合同【" + contractNo + "】 未足额偿还【"
						+ firstSeRPSeqs + "期】, 不允许发起申请！";
			}
			
			/**
			 * 4. 如果本次随心还服务的申请是≥ 2次申请，判断上次延期还款或变更还款日期后
			 * 是否足额偿还N期及以上期款；不是的话，则不让提起申请
			 */
			if (curUseTime > count) {
				
				// 1. 获取上次变更后的还款日期
				sb = new StringBuffer();
				String preAlterPayDate = "";
				sb.append("SELECT MAX(ALTER_PAYDATE) AS ALTER_PAYDATE FROM BOMTR_USE_LOG WHERE CONTRACTNO = ");
				sb.append(":CONTRACTNO AND STATUS = '1'");
				rs = transaction.getASResultSet(new SqlObject(sb.toString())
						.setParameter("CONTRACTNO", contractNo));
				if (rs.next()) {
					preAlterPayDate = rs.getString("ALTER_PAYDATE");
				}
				rs.getStatement().close();
				if (preAlterPayDate == null || "".equals(preAlterPayDate)) {
					return "false@合同【" + contractNo + "】获取上次变更后的首次还款日期失败！";
				}
				cal.setTime(sdfDate.parse(preAlterPayDate));
				cal.add(Calendar.MONTH, secSeRPSeqs);
				cnt = 0;
				sb = new StringBuffer();
				sb.append("SELECT COUNT(1) AS CNT FROM ACCT_PAYMENT_SCHEDULE A INNER JOIN ACCT_LOAN B ");
				sb.append("ON B.SERIALNO = A.OBJECTNO OR B.SERIALNO = A.RELATIVEOBJECTNO WHERE ");
				sb.append("B.PUTOUTNO = :PUTOUTNO AND A.PAYDATE >= :PAYDATE ");
				sb.append("AND TO_NUMBER(NVL(A.PAYPRINCIPALAMT, 0)) + TO_NUMBER(NVL(A.PAYINTEAMT, 0)) <> ");
				sb.append("TO_NUMBER(NVL(A.ACTUALPAYPRINCIPALAMT, 0)) + TO_NUMBER(NVL(A.ACTUALPAYINTEAMT, 0)) ");
				sb.append("AND A.PAYDATE <= :NPAYDATE");
				rs = transaction
						.getASResultSet(new SqlObject(sb.toString())
								.setParameter("PUTOUTNO", contractNo)
								.setParameter("PAYDATE", preAlterPayDate)
								.setParameter("NPAYDATE",
										sdfDate.format(cal.getTime())));
				if (rs.next()) {
					cnt = rs.getInt("CNT");
				}
				rs.getStatement().close();
				if (cnt > 0) {
					return "false@合同【" + contractNo + "】为第" + curUseTime
							+ "次申请服务，未足额偿还【" + secSeRPSeqs + "期】, 不允许发起申请！";
				}
			}

			// 5. 判断是否在当期到期还款日提前N天提出申请；不是的话，则不让提起申请。
			long days = (sdfDate.parse(this.curPayDate).getTime() - sdfDate
					.parse(this.applyTime).getTime()) / (24 * 60 * 60 * 1000);
			long left = days - preApplyDays;
			if (left < 0) {
				return "false@该合同【" + contractNo + "】必须在最近一期到期还款日提前"
						+ preApplyDays + "天提出申请！";
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("【随心还服务（延期还款、变更还款日、优惠提前还款）通用校验发生异常！】\n"
					+ e.getMessage());
			return "false@校验随心还服务相关信息发生异常！";
		}
		return "true";
	}

	/**
	 * 获取可变更的变更后还款日期
	 * 
	 * @param transaction
	 * @return
	 */
	public String queryAlterPayDate(Transaction transaction) {

		if (alterType == null || "".equals(alterType)) {
			return "false@获取不到服务类型！";
		}
		if (alterValue == null || "".equals(alterValue)) {

			if ("00".equals(alterType)) {
				return "false@获取不到延期期数！";
			} else {
				return "false@获取不到变更还款日！";
			}
		}
		if (curPayDate == null || "".equals(curPayDate)) {
			return "false@获取不到开始变更日期！";
		}
		try {
			if ("01".equals(alterType)) { // 变更还款日

				List<String> strList = new ArrayList<String>();
				cal.setTime(sdfDate.parse(this.applyTime));
				cal.add(Calendar.DAY_OF_MONTH, 5);
				Date beginDate = cal.getTime(); // 自申请日后5天日期
				cal.add(Calendar.DAY_OF_MONTH, 30); // 5 + 30 = 35
				Date endDate = cal.getTime(); // 自申请日后35天日期
				cal.setTime(sdfDate.parse(this.curPayDate));
				cal.set(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH),
						Integer.parseInt(this.alterValue));
				Date alterDate = cal.getTime();
				String firDate = "";
				String secDate = "";
				if (alterDate.getTime() >= beginDate.getTime()
						&& alterDate.getTime() <= endDate.getTime()) { // 在区间内就是符合条件的日期
					firDate = sdfDate.format(alterDate);
					strList.add(firDate);
				}
				cal.add(Calendar.MONTH, 1);
				alterDate = cal.getTime();
				if (alterDate.getTime() >= beginDate.getTime()
						&& alterDate.getTime() <= endDate.getTime()) { // 在区间内就是符合条件的日期
					secDate = sdfDate.format(alterDate);
					strList.add(secDate);
				}
				String res = "";
				for (String str : strList) {
					res = res + str + "," + str + ",";
				}
				if (res != null && !"".equals(res)) {
					res = res.substring(0, res.length() - 1);
				} else {
					return "false@变更还款日期的范围必须在自申请日之后5天至申请日之后35天之间！";
				}
				return "true@" + res;
			} else if ("00".equals(alterType)) {
				cal.setTime(sdfDate.parse(curPayDate));
				cal.add(Calendar.MONTH, Integer.parseInt(this.alterValue));
				String str = sdfDate.format(cal.getTime().getTime());
				return "true@" + str + "," + str;
			} else {
				return "false@无效服务类型！";
			}
		} catch (ParseException e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			return "false@系统异常，请联系IT部门的相关人员！";
		}
	}

	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}

	public String getAlterType() {
		return alterType;
	}

	public void setAlterType(String alterType) {
		this.alterType = alterType;
	}

	public String getAlterValue() {
		return alterValue;
	}

	public void setAlterValue(String alterValue) {
		this.alterValue = alterValue;
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

	public String getApplyTime() {
		return applyTime;
	}

	public void setApplyTime(String applyTime) {
		this.applyTime = applyTime;
	}

	public String getCurPayDate() {
		return curPayDate;
	}

	public void setCurPayDate(String curPayDate) {
		this.curPayDate = curPayDate;
	}

	public int getCurUseTime() {
		return curUseTime;
	}

	public void setCurUseTime(int curUseTime) {
		this.curUseTime = curUseTime;
	}

	public String getInputUserId() {
		return inputUserId;
	}

	public void setInputUserId(String inputUserId) {
		this.inputUserId = inputUserId;
	}

	public String getInputDate() {
		return inputDate;
	}

	public void setInputDate(String inputDate) {
		this.inputDate = inputDate;
	}

	public int getPt() {
		return pt;
	}

	public void setPt(String pt) {
		this.pt = Integer.parseInt(pt == null || "".equals(pt) ? "0" : pt);
	}

	public String getAlterPayDate() {
		return alterPayDate;
	}

	public void setAlterPayDate(String alterPayDate) {
		this.alterPayDate = alterPayDate;
	}
}
