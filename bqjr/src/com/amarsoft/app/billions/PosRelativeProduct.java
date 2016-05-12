package com.amarsoft.app.billions;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/*
 * add by phe 2015/06/04
 * 移动POS点关联产品
 */
public class PosRelativeProduct {
		private String SerialNo="";
		private String POSNO="";
		private String PNO="";
		private String PNAME="";
		private String INPUTORG;
		private String INPUTUSER;
		private String INPUTDATE;
		private String UPDATEORG;
		private String UPDATEUSER;
		private String UPDATEDATE;
		
		public String sRelativeProduct(Transaction Sqlca){
			try{
			String sRetVal = null;
			String[] hasPNO = null;
			String[] hasPNAME = null;
			
			String sSql = " insert into MOBILEPOSRELATIVEPRODUCT(SerialNo,POSNO,PNO,PNAME,INPUTORG,INPUTUSER,INPUTDATE,UPDATEORG,UPDATEUSER,UPDATEDATE) "+
						" values (:SerialNo,:POSNO,:PNO,:PNAME,:INPUTORG,:INPUTUSER,:INPUTDATE,:UPDATEORG,:UPDATEUSER,:UPDATEDATE)";
			String delSql = "delete from MOBILEPOSRELATIVEPRODUCT where serialno=:serialno";
			if(PNO.equals("")||PNAME.equals("")){
				return "NoProduct";
			}else{
				hasPNO = PNO.split("@");
				hasPNAME = PNAME.split("@");
			}
			String sSerialNo ="";
			for(int i=0 ; i<hasPNO.length ; i++){
				if(i==0){
					sSerialNo = this.SerialNo;
					Sqlca.executeSQL(new SqlObject(delSql).setParameter("serialno", sSerialNo));
				}else{
					sSerialNo = DBKeyHelp.getSerialNo("MOBILEPOSRELATIVEPRODUCT", "SerialNo");
				}
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("POSNO", POSNO)
						.setParameter("PNO", hasPNO[i]).setParameter("PNAME", hasPNAME[i]).setParameter("INPUTORG", INPUTORG)
						.setParameter("INPUTUSER", INPUTUSER).setParameter("INPUTDATE", INPUTDATE).setParameter("UPDATEORG", UPDATEORG)
						.setParameter("UPDATEUSER", UPDATEUSER).setParameter("UPDATEDATE", UPDATEDATE));
			}
			return "TRUE";
			}catch(Exception e){
				e.printStackTrace();
				return "FALSE";
			}
		}

		public String getSerialNo() {
			return SerialNo;
		}

		public void setSerialNo(String serialNo) {
			SerialNo = serialNo;
		}

		public String getPOSNO() {
			return POSNO;
		}

		public void setPOSNO(String pOSNO) {
			POSNO = pOSNO;
		}

		public String getPNO() {
			return PNO;
		}

		public void setPNO(String pNO) {
			PNO = pNO;
		}

		public String getPNAME() {
			return PNAME;
		}

		public void setPNAME(String pNAME) {
			PNAME = pNAME;
		}

		public String getINPUTORG() {
			return INPUTORG;
		}

		public void setINPUTORG(String iNPUTORG) {
			INPUTORG = iNPUTORG;
		}

		public String getINPUTUSER() {
			return INPUTUSER;
		}

		public void setINPUTUSER(String iNPUTUSER) {
			INPUTUSER = iNPUTUSER;
		}

		public String getINPUTDATE() {
			return INPUTDATE;
		}

		public void setINPUTDATE(String iNPUTDATE) {
			INPUTDATE = iNPUTDATE;
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

}

