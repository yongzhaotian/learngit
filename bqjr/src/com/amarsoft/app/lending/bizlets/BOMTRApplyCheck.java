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

	/** ��ͬ�� �������� **/
	private String contractNo;

	/** �������� ��������:00���ڻ���,01�����������,02�Ż���ǰ����,03ȡ�����Ļ����� **/
	private String alterType;

	/** ���ֵ �������� **/
	private String alterValue;

	/** �ͻ�ID�������� **/
	private String customerId;

	/** �ͻ������������� **/
	private String customerName;

	/** ����ʱ��ȡ��ǰ���� �������� **/
	private String applyTime;

	/** ��ǰ������ �������� **/
	private String curPayDate;

	/** �ϴ��������� ������ֵ�� **/
	private String preApplyTime;

	/** �״α����Ļ����� �������� **/
	private String alterPayDate;

	/** ��ǰ�ڼ���ʹ�����Ļ����� **/
	private int curUseTime = 0;

	/** ���ݷ��������ж�����ʲô����Ŀ�ʹ�ô���(��ʣ���ʹ�ô���) **/
	private int useCnt = 0;

	/** ���ݷ��������ж�����ʲô����ʹ�ô��� **/
	private int usedCnt = 0;

	/** �״�ʹ�������������� **/
	private int firstSeRPSeqs = 0;

	/** �ڶ��μ�����ʹ��ʱ������������ **/
	private int secSeRPSeqs = 0;

	/** ��ǰ�������� **/
	private int preApplyDays = 0;

	/** ������ **/
	private String inputUserId;

	/** ����ʱ�� **/
	private String inputDate;

	/** ��ͬ���� **/
	private int pt;

	private int count = 0;

	/** ����ͳ�Ʊ���Ϣ **/
	private BOMTRUseCountVO bomtrUseCount = new BOMTRUseCountVO();

	private SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy/MM/dd");

	private Calendar cal = Calendar.getInstance();

	private Log logger = ARE.getLog();

	public String applyCheck(Transaction transaction) {

		String result = "";
		// ��ʼ����������
		try {
			result = init(transaction);
			if (!"true".equals(result)) {
				return result;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			logger.error("��ϵͳ�쳣����" + e.getMessage());
			return "false@ϵͳ�쳣��";
		}

		// У������
		result = checkData(transaction);
		if (!"true".equals(result)) {
			return result;
		}

		// ������ֵ
		try {
			result = calcValue();
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("��ϵͳ�쳣����" + e.getMessage());
			return "false@ϵͳ�쳣�����ڼ������";
		}

		return result;
	}

	private String calcValue() throws Exception {

		String result = "";
		result = "true@" + preApplyTime;
		return result;
	}

	/**
	 * ��ʼ����������
	 * 
	 * @throws SQLException
	 */
	private String init(Transaction transaction) throws SQLException {

		if (contractNo == null || "".equals(contractNo)) {
			return "false@��ȡ������ͬ�ţ�";
		}
		if (applyTime == null || "".equals(applyTime)) {
			return "false@��ȡ��������ʱ�䣡";
		}
		if (curPayDate == null || "".equals(curPayDate)) {
			if (!"02".equals(alterType)) {
				return "false@��ȡ������ʼ������ڣ�";
			}
		}
		if (alterPayDate == null || "".equals(alterPayDate)) {
			if (!"02".equals(alterType)) {
				return "false@��ȡ�����״α���󻹿����ڣ�";
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
	 * У������
	 * 
	 * @param transaction
	 * @return
	 */
	private String checkData(Transaction transaction) {

		String result = "";

		// 1. У��������������Ƿ���ȷ
		result = checkBasicData(transaction);
		if (!"true".equals(result)) {
			return result;
		}
		// 2. У���ͬ�Ƿ���ʹ�÷���Ĵ���
		result = checkBOMTRTimes(transaction);
		if (!"true".equals(result)) {
			return result;
		}
		// 3. У�����ҵ���߼�
		result = specificBusinessLogic(transaction);
		if (!"true".equals(result)) {
			return result;
		}

		return "true";
	}

	/**
	 * У��������������Ƿ���ȷ
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
			// У���ͬ�Ƿ����
			sb = new StringBuffer();
			sb.append("SELECT A.SERIALNO, A.CONTRACTSTATUS, A.BUGPAYPKGIND, B.CURRENTPERIOD FROM ");
			sb.append("BUSINESS_CONTRACT A INNER JOIN ACCT_LOAN B ON B.PUTOUTNO = A.SERIALNO ");
			sb.append("WHERE A.SERIALNO = :SERIALNO");
			rs = transaction.getASResultSet(new SqlObject(sb.toString())
					.setParameter("SERIALNO", contractNo));
			if (!rs.next()) {
				return "false@���ݺ�ͬ�š�" + contractNo + "���Ҳ�����ͬ��Ϣ��";
			} else {
				contractStatus = rs.getString("CONTRACTSTATUS");
				isbomtr = rs.getString("BUGPAYPKGIND");
				currentPeriod = rs.getString("CURRENTPERIOD");
			}
			rs.getStatement().close();

			if (!"050".equals(contractStatus)) {
				return "false@��ͬ��" + contractNo + "���ĺ�ͬ״̬�������������Ļ�����������";
			}
			// �ж����Ļ������Ƿ���Ч����Чָ�����������Ļ�������ûȡ�����Ļ�����
			if (isbomtr == null || "".equals(isbomtr) || "0".equals(isbomtr)) {
				return "false@��ͬ��" + contractNo + "��δ�������Ļ�����";
			} else if ("2".equals(isbomtr)) {
				return "false@��ͬ��" + contractNo + "����ȡ�����Ļ�����";
			} else if (!"1".equals(isbomtr)) {
				return "false@δ֪���Ļ������ʶ��";
			}

			if (currentPeriod == null || "".equals(currentPeriod)) {
				return "false@��ȡ��ǰ�ڴ�ʧ�ܣ�";
			} else if (Integer.parseInt(currentPeriod) <= 0) {
				return "false@�ÿͻ�δ��ʼ����޷��������Ļ�����";
			}

			// ��ȡ����������Ϣ
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
				// �½����Ļ�����
				String result = updateBOMTRUseCount(transaction);
				if ("false".equals(result.split("@")[0])) {
					return result;
				}
			}
			rs.getStatement().close();

			if (alterType == null || "".equals(alterType)) {
				return "false@��ȡ�����������ͣ�";
			}

			if (!"00, 01, 02".contains(alterType)) {
				return "false@��Ч�������ͣ�";
			}

			if (alterValue == null || "".equals(alterValue)) {
				if ("00".equals(alterType)) {
					return "false@��ȡ��������������";
				}
				if ("01".equals(alterType)) {
					return "false@��ȡ������������գ�";
				}
			}

			// �жϱ���������Ƿ�������
			if ("01".equals(alterType)) {
				if (Integer.parseInt(alterValue) < 1
						|| Integer.parseInt(alterValue) > 28) {
					return "false@���������ȡֵ����ӦΪ��1~28�ţ�";
				}
			}

			// �ж����������Ƿ�������
			if ("00".equals(alterType)) {
				if (Integer.parseInt(alterValue) > bomtrUseCount
						.getMaxDelSeqs()) {
					return "false@��ͬ��" + contractNo + "���������������Ϊ��"
							+ bomtrUseCount.getMaxDelSeqs();
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("��������������У���쳣����\n" + e.getMessage());
			return "false@������������У���쳣��";
		}

		return "true";
	}

	/**
	 * У���ͬ�Ƿ�ʣ�����Ļ��������
	 * 
	 * @param transaction
	 * @return
	 */
	private String checkBOMTRTimes(Transaction transaction) {

		String typeName = ""; // ��������
		if ("00".equals(alterType)) { // ���ڻ���
			count = Integer.parseInt(alterValue);
		} else {
			count = 1;
		}
		if (bomtrUseCount.getTotalUseCnt() <= bomtrUseCount.getTotalUsedCnt()) {
			// ��ʹ���ܴ���<=��ʹ���ܴ�����������������
			return "false@��ͬ��" + contractNo + "���Ѿ�û�С����Ļ����񡿴�����";
		}
		if (bomtrUseCount.getTotalUseCnt() < bomtrUseCount.getTotalUsedCnt()
				+ count) {
			// ��ʹ���ܴ���<=��ʹ���ܴ�����������������
			return "false@��ͬ��" + contractNo + "��ʣ�ࡾ���Ļ����񡿴������㹻ʹ�ã�������Ҫʹ�õ����Ļ�����Ϊ"
					+ count + " ��";
		}
		if ("00".equals(alterType)) { // ���ڻ���
			useCnt = bomtrUseCount.getDrUseCnt();
			usedCnt = bomtrUseCount.getDrUsedCnt();
			firstSeRPSeqs = bomtrUseCount.getDrFirstSeRPSeqs();
			secSeRPSeqs = bomtrUseCount.getDrSecSeRPSeqs();
			preApplyDays = bomtrUseCount.getDrPreApplyDays();
			typeName = "���ڻ������";
		} else if ("01".equals(alterType)) { // ���������
			useCnt = bomtrUseCount.getApUseCnt();
			usedCnt = bomtrUseCount.getApUsedCnt();
			firstSeRPSeqs = bomtrUseCount.getApFirstSeRPSeqs();
			secSeRPSeqs = bomtrUseCount.getApSecSeRPSeqs();
			preApplyDays = bomtrUseCount.getApPreApplyDays();
			typeName = "��������շ���";
		} else if ("02".equals(alterType)) { // �Ż���ǰ����
			useCnt = bomtrUseCount.getFrUseCnt();
			usedCnt = bomtrUseCount.getFrUsedCnt();
			firstSeRPSeqs = bomtrUseCount.getFrFirstSeRPSeqs();
			preApplyDays = bomtrUseCount.getFrPreApplyDays();
			typeName = "�Ż���ǰ�������";
		} else {
			return "false@��Ч�������ͣ�";
		}

		if (useCnt <= usedCnt) {
			return "false@��ͬ��" + contractNo + "���Ѿ�û�С�" + typeName + "��������";
		} else {
			curUseTime = bomtrUseCount.getTotalUsedCnt() + count;
			if (useCnt < usedCnt + count) {
				return "false@��ͬ��" + contractNo + "��ʣ�ࡾ" + typeName
						+ "���������㹻ʹ�ã�������Ҫʹ�õ����Ļ�����Ϊ" + count + " ��";
			}
		}
		if (curUseTime == 0) {
			return "false@��ͬ��" + contractNo + "����ȡ��ǰ�ǵڼ��η������ʧ�ܣ�";
		}

		return "true";
	}

	/**
	 * �ύʱ�����ݲ���BOMTR_USE_COUNT
	 * 
	 * @return
	 * @throws SQLException
	 */
	public String updateBOMTRUseCount(Transaction transaction)
			throws SQLException {

		// ��ȡϵͳʱ��
		String sql = "SELECT BUSINESSDATE FROM SYSTEM_SETUP ";
		ASResultSet rs = transaction.getASResultSet(new SqlObject(sql));
		// ϵͳʱ��
		String sysTime = "";
		String period = "";

		if (rs.next()) {
			sysTime = rs.getString("BUSINESSDATE");
		}
		rs.getStatement().close();

		// �ж��ڴΣ������������ڴε�ȡֵ������BOMTR_CONFIG��WHERE����
		if (pt <= 12) {
			period = "12";
		} else if (pt <= 24 && pt > 12) {
			period = "1224";
		} else if (pt <= 36 && pt > 24) {
			period = "2436";
		} else {
			period = "2436";
		}

		// �����ڴ���BOMTR_CONFIG��ȡֵ
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

		// ������ֵ����BOMTR_USE_COUNT��
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
			return "false@ϵͳ�쳣������ϵIT�����Ա��";
		}
		return "true";
	}

	/**
	 * У�����ҵ���߼�
	 * 
	 * @param transaction
	 * @return
	 */
	private String specificBusinessLogic(Transaction transaction) {

		// ���Ļ��������ڻ����������ա��Ż���ǰ���ͨ��У��
		String result = usualSpecBusiLogic(transaction);
		if (!"true".equals(result)) {
			return result;
		}

		/**
		 * ���ڻ����������գ����������ǰ����˻����˱����˿ȡ�����Ļ��������롢 �������Ļ�����ȷ��ò���������δ��Ч��
		 * ����������������([�Ż�]��ǰ�����������У��) ����ǰ�����У�������һ��
		 **/
		if ("00".equals(alterType) || "01".equals(alterType)) {
			try {
				result = validate(transaction);
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("��У���ͬ�Ƿ����δ��ɵĲ���ʱ�����쳣����\n" + e.getMessage());
				return "false@У���ͬ�����Ϣ�����쳣��";
			}
			if (!"0".equals(result)) {
				return "false@" + result;
			}
		}

		return "true";
	}

	/**
	 * ��֤��ͬ�Ƿ����δ��ɵĲ���
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
		sb.append(" select b.contract_no,'�˱�' as transname from  batch_insurance_info  b where (b.contract_no=:putoutno or b.contract_no=(select n.putoutno from acct_loan n where  n.putoutno=:putoutno) or b.contract_no=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno)) and b.status in('4','5','6')");
		sb.append(" UNION ALL");
		sb.append(" select b.serialno,'�˱�' as transname from  batch_mingan_insurance  b where (b.serialno=:putoutno or b.serialno=(select n.putoutno from acct_loan n where  n.putoutno=:putoutno) or b.serialno=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno)) and b.status in('3')");
		sb.append(" UNION ALL");
		sb.append(" select pa.serialno,'��ǰ����' as transname from  prepayment_applay  pa where (pa.contract_serialno=:putoutno or pa.contract_serialno=(select n.putoutno from acct_loan n where  n.putoutno=:putoutno) or pa.contract_serialno=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno)) and pa.status ='0'");
		sb.append(" UNION ALL");
		sb.append(" select rc.serialno,'�˻�' as transname  from REFUND_CARGO rc  where  rc.approveuserid is null and (rc.serialno=:putoutno or rc.serialno=(select n.putoutno from acct_loan n where  n.serialno=:putoutno) or rc.serialno=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno)) ");
		sb.append(" UNION ALL");
		sb.append(" SELECT a.CONTRACTNO, '���Ļ������ȡ��' AS transname FROM BUSINESS_PAYPKG_APPLY A WHERE A.PKGSTATUS = '0' AND (A.CONTRACTNO=:putoutno or A.CONTRACTNO=(select n.putoutno from acct_loan n where  n.putoutno=:putoutno) or A.CONTRACTNO=(select n.putoutno from acct_fee f,acct_loan n where f.objectno=n.serialno and  f.serialno=:putoutno))");
		sb.append(" UNION ALL ");
		sb.append(" SELECT A.SERIALNO, '���Ļ���������' AS TRANSNAME FROM BOMTR_APPLY_INFO A WHERE A.STATUS ");
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
			return "�ú�ͬ����һ�" + transname + "��ҵ������У�������ͬʱ���룡";
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
					return "�ÿͻ�����һ���ǰ���ҵ������У�������ͬʱ�����������գ�";
				}
			}
			
			return "0";
		}
	}

	/**
	 * ���Ļ��������ڻ����������ա��Ż���ǰ���ͨ��У��
	 * 
	 * @param transaction
	 * @return
	 */
	private String usualSpecBusiLogic(Transaction transaction) {

		StringBuffer sb = new StringBuffer();
		ASResultSet rs = null;

		try {
			// 1. �жϻ�����Ϣ�Ƿ񷵻�(����)
			sb.append("");

			// 2. �жϿͻ��º�ͬ�Ƿ�������(�Ż���ǰ�����ҪУ��)
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
					return "false@�ͻ���" + customerName + "(" + customerId
							+ ")�����µĺ�ͬ�����ڵ�״̬�����������룡";
				}
			}

			cnt = 0;
			// 3. ʹ�÷���ʱ���ض��ж������Ƿ�ﵽN�ڼ������ڿ���ǵĻ���������������
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
				return "false@��ǰ��ͬ��" + contractNo + "�� δ������"
						+ firstSeRPSeqs + "�ڡ�, �����������룡";
			}
			
			/**
			 * 4. ����������Ļ�����������ǡ� 2�����룬�ж��ϴ����ڻ�������������ں�
			 * �Ƿ�����N�ڼ������ڿ���ǵĻ���������������
			 */
			if (curUseTime > count) {
				
				// 1. ��ȡ�ϴα����Ļ�������
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
					return "false@��ͬ��" + contractNo + "����ȡ�ϴα������״λ�������ʧ�ܣ�";
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
					return "false@��ͬ��" + contractNo + "��Ϊ��" + curUseTime
							+ "���������δ������" + secSeRPSeqs + "�ڡ�, �����������룡";
				}
			}

			// 5. �ж��Ƿ��ڵ��ڵ��ڻ�������ǰN��������룻���ǵĻ��������������롣
			long days = (sdfDate.parse(this.curPayDate).getTime() - sdfDate
					.parse(this.applyTime).getTime()) / (24 * 60 * 60 * 1000);
			long left = days - preApplyDays;
			if (left < 0) {
				return "false@�ú�ͬ��" + contractNo + "�����������һ�ڵ��ڻ�������ǰ"
						+ preApplyDays + "��������룡";
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("�����Ļ��������ڻ����������ա��Ż���ǰ���ͨ��У�鷢���쳣����\n"
					+ e.getMessage());
			return "false@У�����Ļ����������Ϣ�����쳣��";
		}
		return "true";
	}

	/**
	 * ��ȡ�ɱ���ı���󻹿�����
	 * 
	 * @param transaction
	 * @return
	 */
	public String queryAlterPayDate(Transaction transaction) {

		if (alterType == null || "".equals(alterType)) {
			return "false@��ȡ�����������ͣ�";
		}
		if (alterValue == null || "".equals(alterValue)) {

			if ("00".equals(alterType)) {
				return "false@��ȡ��������������";
			} else {
				return "false@��ȡ������������գ�";
			}
		}
		if (curPayDate == null || "".equals(curPayDate)) {
			return "false@��ȡ������ʼ������ڣ�";
		}
		try {
			if ("01".equals(alterType)) { // ���������

				List<String> strList = new ArrayList<String>();
				cal.setTime(sdfDate.parse(this.applyTime));
				cal.add(Calendar.DAY_OF_MONTH, 5);
				Date beginDate = cal.getTime(); // �������պ�5������
				cal.add(Calendar.DAY_OF_MONTH, 30); // 5 + 30 = 35
				Date endDate = cal.getTime(); // �������պ�35������
				cal.setTime(sdfDate.parse(this.curPayDate));
				cal.set(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH),
						Integer.parseInt(this.alterValue));
				Date alterDate = cal.getTime();
				String firDate = "";
				String secDate = "";
				if (alterDate.getTime() >= beginDate.getTime()
						&& alterDate.getTime() <= endDate.getTime()) { // �������ھ��Ƿ�������������
					firDate = sdfDate.format(alterDate);
					strList.add(firDate);
				}
				cal.add(Calendar.MONTH, 1);
				alterDate = cal.getTime();
				if (alterDate.getTime() >= beginDate.getTime()
						&& alterDate.getTime() <= endDate.getTime()) { // �������ھ��Ƿ�������������
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
					return "false@����������ڵķ�Χ��������������֮��5����������֮��35��֮�䣡";
				}
				return "true@" + res;
			} else if ("00".equals(alterType)) {
				cal.setTime(sdfDate.parse(curPayDate));
				cal.add(Calendar.MONTH, Integer.parseInt(this.alterValue));
				String str = sdfDate.format(cal.getTime().getTime());
				return "true@" + str + "," + str;
			} else {
				return "false@��Ч�������ͣ�";
			}
		} catch (ParseException e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			return "false@ϵͳ�쳣������ϵIT���ŵ������Ա��";
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
