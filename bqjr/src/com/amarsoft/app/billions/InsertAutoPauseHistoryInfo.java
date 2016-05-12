package com.amarsoft.app.billions;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 录入记录到AutoPause_History_Info表
 * @author huzp 
 * @date 2016-03-15
 */
public class InsertAutoPauseHistoryInfo {
	private String SERIALNO; //编号
	private String AUTOPAUSE_CODE; //类型
	private String A_CLASS; 
	private String B_CLASS; 
	private String C_CLASS; 
	private String D_CLASS; 
	private String OK_CLASS; 
	private String UPDATEORG;  //更新部门
	private String UPDATEUSER; //更新
	private String UPDATEDATE; //更新时间
	

	public void addAutoPauseHistoryInfo(Transaction Sqlca) throws Exception {
		SqlObject  osql = null;
		String sql = "insert into AutoPause_history_Info ("
				+ "SERIALNO,"
				+ "AUTOPAUSE_CODE,"
				+ "A_CLASS,"
				+ "B_CLASS,"
				+ "C_CLASS,"
				+ "D_CLASS,"
				+ "OK_CLASS,"
				+ "UPDATEORG,"
				+ "UPDATEUSER,"
				+ "UPDATEDATE"
				+ ") values ("
				+ getvalus(SERIALNO)+","
				+ getvalus(AUTOPAUSE_CODE)+","
				+ getvalus(A_CLASS)+","
				+ getvalus(B_CLASS)+","
				+ getvalus(C_CLASS)+","
				+ getvalus(D_CLASS)+","
				+ getvalus(OK_CLASS)+","
				+ getvalus(UPDATEORG)+","
				+ getvalus(UPDATEUSER)+","
				+ ":UPDATEDATE" 
				+ ")"; 
		osql = new SqlObject(sql);
		Sqlca.executeSQL(osql.setParameter("UPDATEDATE", UPDATEDATE));
	}
	
	public String getSERIALNO() {
		return SERIALNO;
	}

	public void setSERIALNO(String sERIALNO) {
		SERIALNO = sERIALNO;
	}

	public String getAUTOPAUSE_CODE() {
		return AUTOPAUSE_CODE;
	}

	public void setAUTOPAUSE_CODE(String aUTOPAUSE_CODE) {
		AUTOPAUSE_CODE = aUTOPAUSE_CODE;
	}

	public String getA_CLASS() {
		return A_CLASS;
	}

	public void setA_CLASS(String a_CLASS) {
		A_CLASS = a_CLASS;
	}

	public String getB_CLASS() {
		return B_CLASS;
	}

	public void setB_CLASS(String b_CLASS) {
		B_CLASS = b_CLASS;
	}

	public String getC_CLASS() {
		return C_CLASS;
	}

	public void setC_CLASS(String c_CLASS) {
		C_CLASS = c_CLASS;
	}

	public String getD_CLASS() {
		return D_CLASS;
	}

	public void setD_CLASS(String d_CLASS) {
		D_CLASS = d_CLASS;
	}

	public String getOK_CLASS() {
		return OK_CLASS;
	}

	public void setOK_CLASS(String oK_CLASS) {
		OK_CLASS = oK_CLASS;
	}

	public String getUPDATEORG() {
		return UPDATEORG;
	}

	public void setUPDATEORG(String uPDATEORG) {
		UPDATEORG = uPDATEORG;
	}

	public String getUPDATEUSER() {
		return UPDATEUSER;
	}

	public void setUPDATEUSER(String uPDATEUSER) {
		UPDATEUSER = uPDATEUSER;
	}

	public String getUPDATEDATE() {
		return UPDATEDATE;
	}

	public void setUPDATEDATE(String uPDATEDATE) {
		UPDATEDATE = uPDATEDATE;
	}


	private String getvalus(String val){
		if(null==val){
			return val;
		}
		if("undefined".equals(val)){
			return null;
		}
		
		return  "'"+val+"'";
	}
}
