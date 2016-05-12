package com.amarsoft.app.billions;

import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �ؼ������ͬ��
 * 
 * @author ybpan
 *
 */
public class PrimaryErrorContract {
	private String userID = "";

	/**
	 * ���۴�������ĺ�ͬ��������עΪ�ؼ���ǹؼ�����
	 * 
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String checkHavedError(Transaction Sqlca) throws Exception {
		// �÷�������ǰʱ��
		String curDateTime = DateX.format(new java.util.Date(),
				"yyyy/MM/dd HH:mm:ss");
		String isHave = "false";
		ASResultSet rs = Sqlca
				.getASResultSet(new SqlObject(
						"select count(1) as n "
								+ "  from  BUSINESS_CONTRACT bc, QUALITY_GRADE qg   "
								+ " WHERE (qg.QUALITYGRADE = '1' or (qg.QUALITYGRADE = '2'  AND ceil((to_date(:curDateTime,'yyyy-mm-dd hh24-mi-ss') - To_date(inputtime, 'yyyy-mm-dd hh24-mi-ss'))) < 4)) AND ceil((to_date(:curDateTime,'yyyy-mm-dd hh24-mi-ss') - To_date(inputtime, 'yyyy-mm-dd hh24-mi-ss'))) > 1 AND bc.SERIALNO=qg.ARTIFICIALNO AND bc.SALESEXECUTIVE='"
								+ userID + "'  ").setParameter("curDateTime",
						curDateTime));
		if (rs.next()) {
			int i = rs.getInt("n");
			if (i > 0) {
				isHave = "true";
			}
		}
		rs.getStatement().close();
		return isHave;
	}

	/**
	 * ���۾�������ĺ�ͬ��������עΪ�ؼ���ǹؼ�����
	 * 
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String checkSaleMangerQuality(Transaction Sqlca) throws Exception {
		// �÷�������ǰʱ��
		String curDateTime = DateX.format(new java.util.Date(),
				"yyyy/MM/dd HH:mm:ss");
		String isHave = "false";
		ASResultSet rs = Sqlca
				.getASResultSet(new SqlObject(
						"select count(1) as n "
								+ "  from  BUSINESS_CONTRACT bc, QUALITY_GRADE qg   "
								+ " WHERE (qg.QUALITYGRADE = '1' or (qg.QUALITYGRADE = '2' AND ceil((to_date(:curDateTime,'yyyy-mm-dd hh24-mi-ss') - To_date(inputtime, 'yyyy-mm-dd hh24-mi-ss'))) < 4)) AND ceil((to_date(:curDateTime,'yyyy-mm-dd hh24-mi-ss') - To_date(inputtime, 'yyyy-mm-dd hh24-mi-ss'))) > 1 AND bc.SERIALNO=qg.ARTIFICIALNO AND bc.salesmanager='"
								+ userID + "'  ").setParameter("curDateTime",
						curDateTime));
		if (rs.next()) {
			int i = rs.getInt("n");
			if (i > 0) {
				isHave = "true";
			}
		}
		rs.getStatement().close();
		return isHave;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

}
