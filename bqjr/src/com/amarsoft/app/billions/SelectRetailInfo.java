package com.amarsoft.app.billions;

import java.sql.SQLException;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class SelectRetailInfo {

	public synchronized void UpdateStoreConfirLetter(Transaction Sqlca)
			throws Exception {
		String sql = " select SI.Regcode from STORE_INFO SI "
				+ " left outer join RETAIL_INFO RI "
				+ " on RI.SerialNo = SI.RserialNo "
				+ " where SI.PrimaryApproveTime is not null "
				+ " and SI.PrimaryApproveStatus = '1' "
				+ " and SI.status = '02' "
				+ " Order by RI.SerialNo Desc, SI.SerialNo desc ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql));

		while (rs.next()) {

			String count = Sqlca
					.getString("select count(*) from DOC_ATTACHMENT where  Type='A0002' and ObjectNo='"
							+ rs.getString("RegCode") + "' ");
			int count1 = Integer.parseInt(count);
			if (count1 == 0) {
				
				Sqlca.executeSQL(new SqlObject(
						"update store_info set ISSTORECONFIRLETTER='2' where regcode='"
								+ rs.getString("RegCode") + "'"));
			} else {

				Sqlca.executeSQL(new SqlObject(
						"update store_info set ISSTORECONFIRLETTER='1' where regcode='"
								+ rs.getString("RegCode") + "'"));
			}

		}

	}

	public synchronized void UpdateStoreEntrustedCollection(Transaction Sqlca)
			throws Exception {
		String sql = " select SI.SerialNo as SerialNo, RI.Rname as RetailName,SI.ACCOUNTNAME as AccountName from STORE_INFO SI "
				+ " left outer join RETAIL_INFO RI "
				+ " on RI.SerialNo = SI.RserialNo "
				+ " where SI.PrimaryApproveTime is not null "
				+ " and SI.PrimaryApproveStatus = '1' "
				+ " and SI.status = '02' "
				+ " Order by RI.SerialNo Desc, SI.SerialNo desc ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql));

		while (rs.next()) {

			if (rs.getString("RetailName").equals(rs.getString("AccountName"))) {

				Sqlca.executeSQL(new SqlObject(
						"update store_info set ISENTRUSTEDCOLLECTION='1' where SerialNo='"
								+ rs.getString("SerialNo") + "'"));

			} else {
				Sqlca.executeSQL(new SqlObject(
						"update store_info set ISENTRUSTEDCOLLECTION='2' where SerialNo='"
								+ rs.getString("SerialNo") + "'"));
			}

		}

	}

}