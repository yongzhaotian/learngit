package com.amarsoft.app.billions;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ¼���¼��Bib_History_Info��
 * @author huzp 
 * @date 2015-05-26
 */
public class InsertBibHistoryInfo {
	private String SERIALNO; //���
	private String TypeCode; //����
	private String BibValue; //ֵ
	private String Flag;     //��ʶ��BIBǰ�ڻ��Ǻ��ڡ���ǰ�ڣ�B������:A��
	private String UpDateOrg;  //���²���
	private String UpDateUser; //����
	private String UpDateDate; //����ʱ��

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
