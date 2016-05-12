package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 判断计算每月还款额是否支持投保
 * @author hepu
 */
public class CheckCreditCycle {
	
	private String businessType;	// 产品代码
	
	private String insuranceNo;		// 保险公司
	
	public String CreditCycle(Transaction Sqlca) throws SQLException{
		ASResultSet rs = null;
		int iCount = 0;
		
		if("".equals(businessType) || businessType==null){
			return "false@BusinessType";//产品代码为空
		}
		
		String sSql = "select count(1) as cnt from product_term_library where subtermtype = 'A12' and status='1' and  ObjectNo ='"+businessType+"-V1.0'";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			iCount = rs.getInt("cnt");
		}
		rs.close();
		if(iCount == 0){
			return "false@product";//产品未关联保险费
		}
		
		if("".equals(insuranceNo) || insuranceNo==null){
			return "false@InsuranceNo";//城市下没有保险公司
		} 
		
		return "true";
	}
	
	/**
	 * 检查必要性
	 * @return
	 */
	public String checkNecessity(Transaction transaction) throws SQLException {
		
		String res = "";
		String sql = "SELECT DEFAULTVALUE FROM PRODUCT_TERM_PARA A INNER JOIN PRODUCT_TERM_LIBRARY B "
				+ "ON B.TERMID = A.TERMID AND B.SUBTERMTYPE = 'A12' AND B.OBJECTTYPE = A.OBJECTTYPE "
				+ "AND B.OBJECTNO = A.OBJECTNO WHERE A.OBJECTTYPE = 'Product' AND A.OBJECTNO = :OBJECTNO "
				+ "AND A.PARAID = 'FeeAPermission'";
		ASResultSet rs = transaction.getASResultSet(new SqlObject(sql).setParameter("OBJECTNO", businessType + "-V1.0"));
		if (rs.next()) {
			res = rs.getString("DEFAULTVALUE");
		}
		if (rs != null) {
			rs.getStatement().close();
		}
		
		return res;
	}
	
	public String getBusinessType() {
		return businessType;
	}
	
	public void setBusinessType(String businessType) {
		this.businessType = businessType;
	}
	
	public String getInsuranceNo() {
		return insuranceNo;
	}
	
	public void setInsuranceNo(String insuranceNo) {
		this.insuranceNo = insuranceNo;
	}
	
}
