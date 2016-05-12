package com.amarsoft.app.billions;

import java.sql.SQLException;

import org.apache.commons.lang.StringUtils;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
/**
 * ��ȡ�Ѿ��ϴ�����Ƭ��Ϣ
 * @author William Liu
 *
 */

public class UploadedImageCommon {
	private String objectNo = "";//��ͬ���

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}
	
	/**
	 * ���ݺ�ͬ�Ż�ȡ�Ѿ��ϴ���Ӱ������ ���ظ�ʽΪ xxxx;xxx
	 * @param Sqlca
	 * @return
	 * @throws SQLException
	 */
	public String getUploadedImageTypes(Transaction Sqlca) throws SQLException{
		
		if(StringUtils.isEmpty(this.objectNo)) return "";
		
		StringBuilder sbResult = new StringBuilder();
		
		String sSql = "SELECT T.IMAGEINFO FROM ECM_PAGE T WHERE T.OBJECTNO=:objectNo";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("objectNo", this.objectNo));
		while(rs.next()){
			sbResult.append(rs.getString("IMAGEINFO")).append(";");
		}
		rs.getStatement().close();
		
		if(sbResult.length()>0){
			return sbResult.substring(0, sbResult.length());
		}
		
		return sbResult.toString();
	}
	
}
