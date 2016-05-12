package com.amarsoft.app.billions;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 录入记录到Bib_History_Info表
 * @author huzp 
 * @date 2015-05-26
 */
public class InsertBibHistoryInfo {
	private String SERIALNO; //编号
	private String TypeCode; //类型
	private String BibValue; //值
	private String Flag;     //标识是BIB前期还是后期。（前期：B。后期:A）
	private String UpDateOrg;  //更新部门
	private String UpDateUser; //更新
	private String UpDateDate; //更新时间

	public String getSERIALNO() {
		return SERIALNO;
	}

	public void setSERIALNO(String sERIALNO) {
		SERIALNO = sERIALNO;
	}

	public String getTypeCode() {
		return TypeCode;
	}

	public void setTypeCode(String typeCode) {
		TypeCode = typeCode;
	}

	public String getBibValue() {
		return BibValue;
	}

	public void setBibValue(String bibValue) {
		BibValue = bibValue;
	}

	public String getFlag() {
		return Flag;
	}

	public void setFlag(String flag) {
		Flag = flag;
	}

	public String getUpDateOrg() {
		return UpDateOrg;
	}

	public void setUpDateOrg(String upDateOrg) {
		UpDateOrg = upDateOrg;
	}

	public String getUpDateUser() {
		return UpDateUser;
	}

	public void setUpDateUser(String upDateUser) {
		UpDateUser = upDateUser;
	}

	public String getUpDateDate() {
		return UpDateDate;
	}

	public void setUpDateDate(String upDateDate) {
		UpDateDate = upDateDate;
	}

	public void addBibHistoryInfo(Transaction Sqlca) throws Exception {
		SqlObject  osql = null;
		String sql = "insert into Bib_history_Info ("
				+ "SERIALNO,"
				+ "TYPECODE,"
				+ "BIBVALUE,"
				+ "FLAG,"
				+ "UPDATEORG,"
				+ "UPDATEUSER,"
				+ "UPDATEDATE"
				+ ") values ("
				+ getvalus(SERIALNO)+","
				+ getvalus(TypeCode)+","
				+ getvalus(BibValue)+","
				+ getvalus(Flag)+","
				+ getvalus(UpDateOrg)+","
				+ getvalus(UpDateUser)+","
				+ ":UpDateDate" 
				+ ")"; 
		osql = new SqlObject(sql);
		Sqlca.executeSQL(osql.setParameter("UpDateDate", UpDateDate));
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
