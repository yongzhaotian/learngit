package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class QueryBOMTRInfo {
	/** ����ʱ�䣨�������� **/
	private String applyTime;
	/** ��ͬ�� **/
	private String contractNo;
	/** ��ʼ����Ļ����� **/
	private String curPayDate;
	/** ��һ�λ����� **/
	private String curNextPayDate;
	/** ���Ļ����ô���  **/
	private int TotalUseCnt;
	/** ���Ļ����ô���  **/
	private int TotalUsedCnt;
	/** ���Ļ�ʣ�����  **/
	private int leftTime = 0;
	/** ��ͬ���ڴ�  **/
	private int perIods = 0;
		
	private SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy/MM/dd");
			
	private Log logger = ARE.getLog();
	
	/**
	 * ͳ�Ʊ���գ����ô�����
	 * 
	 * **/
	public String queryBOMTRRelativeInfo(Transaction transaction) throws SQLException{
		
		String sql = "SELECT BUSINESSDATE FROM SYSTEM_SETUP";
		this.applyTime = transaction.getString(new SqlObject(sql));
		StringBuffer sb = new StringBuffer();
		ASResultSet rs = null;
		ASResultSet srs = null;
		String currentPeriod = "";
		sb = new StringBuffer();
		sb.append("SELECT A.PERIODS AS PERIODS,B.CURRENTPERIOD AS CURRENTPERIOD FROM ");
		sb.append("BUSINESS_CONTRACT A INNER JOIN ACCT_LOAN B ON B.PUTOUTNO = A.SERIALNO ");
		sb.append("WHERE A.SERIALNO = :SERIALNO");
		srs = transaction.getASResultSet(new SqlObject(sb.toString())
				.setParameter("SERIALNO", contractNo));
		if (srs.next()) {
			perIods = srs.getInt("PERIODS");
			currentPeriod = srs.getString("CURRENTPERIOD");
		}
		srs.getStatement().close();
		sb = new StringBuffer();
		
		if ("".equals(perIods)){
			return "false@��ͬ��" + contractNo + "����ȡ�����ڴ�ʧ�ܣ�";
		}
		if (currentPeriod == null || "".equals(currentPeriod)) {
			return "false@��ȡ��ǰ�ڴ�ʧ�ܣ�";
		} else if (Integer.parseInt(currentPeriod) <= 0) {
			return "false@�ÿͻ�δ��ʼ����޷��������Ļ�����";
		}
		String pt = "";
		if (perIods <= 12) {
			pt = "12";
		} else if (perIods <= 24 && perIods > 12) {
			pt = "1224";
		} else if (perIods <= 36 && perIods > 24) {
			pt = "2436";
		} else {
			pt = "2436";
		}
		sb = new StringBuffer();
		String payDate = "";
		String nextDueDate = "";
		String seqId = "";
		sb.append("SELECT DISTINCT A.PAYDATE AS PAYDATE, B.NEXTDUEDATE AS NEXTDUEDATE, ");
		sb.append("A.SEQID AS SEQID FROM ACCT_PAYMENT_SCHEDULE A INNER JOIN ACCT_LOAN B ON ");
		sb.append("B.CURRENTPERIOD = A.SEQID AND (B.SERIALNO = A.OBJECTNO OR B.SERIALNO = ");
		sb.append("A.RELATIVEOBJECTNO) WHERE B.PUTOUTNO = :PUTOUTNO");
		rs = transaction.getASResultSet(new SqlObject(sb.toString())
				.setParameter("PUTOUTNO", contractNo));
		if (rs.next()) {
			payDate = rs.getString("PAYDATE");
			nextDueDate = rs.getString("NEXTDUEDATE");
			seqId = rs.getString("SEQID");
		} else {
			return "false@��ͬ��" + contractNo + "����ȡ����ƻ�ʧ�ܣ�";
		}
		rs.getStatement().close();
		try {
			if (sdfDate.parse(this.applyTime).getTime() > sdfDate.parse(payDate).getTime()) {
				this.curPayDate = nextDueDate;
				// ��ȡ�¸���Ч�Ļ�����
				seqId = String.valueOf(Integer.parseInt(seqId) + 2);		// ���ڵ�ǰ�ڴ��Ѿ���ȥ�ˣ�����ֻ��ȡ��һ�ڵĻ�������Ϊ�ڶ��α���Ļ�����
				sb = new StringBuffer();
				sb.append("SELECT DISTINCT A.PAYDATE AS PAYDATE FROM ACCT_PAYMENT_SCHEDULE A ");
				sb.append("INNER JOIN ACCT_LOAN B ON (B.SERIALNO = A.OBJECTNO ");
				sb.append("OR B.SERIALNO = A.RELATIVEOBJECTNO) WHERE B.PUTOUTNO = :PUTOUTNO ");
				sb.append("AND A.SEQID = :SEQID ");
				rs = transaction.getASResultSet(new SqlObject(sb.toString())
						.setParameter("PUTOUTNO", contractNo)
						.setParameter("SEQID", seqId));
				if (rs.next()) {
					this.curNextPayDate = rs.getString("PAYDATE");
				} else {
					this.curNextPayDate = "";
				}
				rs.getStatement().close();
			}  else {
				this.curPayDate = payDate;
				this.curNextPayDate = nextDueDate;
			}
		} catch (NumberFormatException e) {
			logger.error("�����Ļ��������ڻ����������ա��Ż���ǰ���ͨ��У�鷢���쳣����\n" + e.getMessage());
			e.printStackTrace();
		} catch (ParseException e) {
			logger.error("�����Ļ��������ڻ����������ա��Ż���ǰ���ͨ��У�鷢���쳣����\n" + e.getMessage());
			e.printStackTrace();
		}
		
		sb = new StringBuffer();
		sb.append("SELECT TOTAL_USE_CNT,TOTAL_USED_CNT FROM BOMTR_USE_COUNT  WHERE OBJECTNO = :OBJECTNO");
		rs = transaction.getASResultSet(new SqlObject(sb.toString())
				.setParameter("OBJECTNO", contractNo));
		if(rs.next()){
			TotalUseCnt = rs.getInt("TOTAL_USE_CNT");
			TotalUsedCnt = rs.getInt("TOTAL_USED_CNT");
		} else {
			sb = new StringBuffer();
			sb.append("SELECT TOTAL_CNT FROM BOMTR_CONFIG WHERE PERIOD_TIME = :PERIOD_TIME");
			rs = transaction.getASResultSet(new SqlObject(sb.toString())
					.setParameter("PERIOD_TIME", pt));
			if (rs.next()){
				TotalUseCnt = rs.getInt("TOTAL_CNT");
			}
			TotalUsedCnt = 0;
		}
		leftTime = TotalUseCnt - TotalUsedCnt;
			
			
		return "true@" + applyTime + "@" + curPayDate + "@" + leftTime + "@" + perIods;
	}	
	
	public String getApplyTime() {
		return applyTime;
	}


	public void setApplyTime(String applyTime) {
		this.applyTime = applyTime;
	}


	public String getContractNo() {
		return contractNo;
	}


	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}


	public String getCurPayDate() {
		return curPayDate;
	}


	public void setCurPayDate(String curPayDate) {
		this.curPayDate = curPayDate;
	}


	public String getCurNextPayDate() {
		return curNextPayDate;
	}


	public void setCurNextPayDate(String curNextPayDate) {
		this.curNextPayDate = curNextPayDate;
	}


	public int getTotalUseCnt() {
		return TotalUseCnt;
	}


	public void setTotalUseCnt(int totalUseCnt) {
		TotalUseCnt = totalUseCnt;
	}


	public int getTotalUsedCnt() {
		return TotalUsedCnt;
	}


	public void setTotalUsedCnt(int totalUsedCnt) {
		TotalUsedCnt = totalUsedCnt;
	}

}
