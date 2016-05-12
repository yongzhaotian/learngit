package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �жϸò�Ʒ�Ƿ��������Ļ����������
 * @author daihuafeng
 *
 */
public class CheckBugPayPkgind {
	private String businessType;//��Ʒ����
	
	public String checkSuiXinHuan(Transaction Sqlca) throws SQLException{
		ASResultSet rs = null;
		int iCount = 0;
		
		String sSql = "select count(1) as cnt from product_term_library where subtermtype = 'A18' and status='1' and  ObjectNo ='"+businessType+"-V1.0'";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			iCount = rs.getInt("cnt");
		}
		rs.close();
		return ""+iCount;
	}
	public String getBusinessType() {
		return businessType;
	}
	public void setBusinessType(String businessType) {
		this.businessType = businessType;
	}
	
}
