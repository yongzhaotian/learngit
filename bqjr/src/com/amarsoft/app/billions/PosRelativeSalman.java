package com.amarsoft.app.billions;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/*
 * add by clhuang 2015/06/04
 * 移动POS点关联销售人员
 */
public class PosRelativeSalman {
		private String Serialno ="";
		private String PosNo = "";
		private String InputOrg = "";
		private String InputUser = "";
		private String InputDate = "";
		private String SalManForPos = "";//销售编号字符串
		private String Salesmanager ="";
		
		public String getPosNo() {
			return PosNo;
		}


		public void setPosNo(String posNo) {
			PosNo = posNo;
		}


		public String getInputOrg() {
			return InputOrg;
		}


		public void setInputOrg(String inputOrg) {
			InputOrg = inputOrg;
		}


		public String getInputUser() {
			return InputUser;
		}


		public void setInputUser(String inputUser) {
			InputUser = inputUser;
		}


		public String getInputDate() {
			return InputDate;
		}


		public void setInputDate(String inputDate) {
			InputDate = inputDate;
		}


		public String getSalManForPos() {
			return SalManForPos;
		}


		public void setSalManForPos(String salManForPos) {
			SalManForPos = salManForPos;
		}


		public String getSerialno() {
			return Serialno;
		}


		public void setSerialno(String serialno) {
			Serialno = serialno;
		}


		public String getSalesmanager() {
			return Salesmanager;
		}


		public void setSalesmanager(String salesmanager) {
			Salesmanager = salesmanager;
		}
		
		public String sRelativeSalMan(Transaction Sqlca){
			try{
			String sRetVal = null;
			String[] hasStoreList = null;
			String sSql = "INSERT INTO MOBLIEPOSRELATIVESALMAN (SERIALNO,POSNO,SALESMANNO,INPUTORG,INPUTUSER, INPUTDATE,SALEMANAGERNO) "
					+ "VALUES (:SERIALNO,:POSNO,:SALESMANNO,:INPUTORG,:INPUTUSER,:INPUTDATE,:SALEMANAGERNO)";
			String sSqlDel = "delete from MOBLIEPOSRELATIVESALMAN where serialno=:serialno";
			ARE.getLog().info("sSalManForPos="+SalManForPos);
			if(!SalManForPos.equals("")){
			hasStoreList = SalManForPos.split("@");
			}else{
				return "NoSal";
			}
			String sSerialNo ="";
			for(int i=0 ; i<hasStoreList.length ; i++){
				if(i==0){
					sSerialNo=this.Serialno;
					Sqlca.executeSQL(new SqlObject(sSqlDel).setParameter("SERIALNO", sSerialNo));
				}else{
				sSerialNo = DBKeyHelp.getSerialNo("MOBLIEPOSRELATIVESALMAN", "SerialNo");
				
				}
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("SERIALNO", sSerialNo).setParameter("POSNO", PosNo)
						.setParameter("SALESMANNO", hasStoreList[i]).setParameter("INPUTORG", InputOrg).setParameter("SALEMANAGERNO", Salesmanager)
						.setParameter("INPUTUSER", InputUser).setParameter("INPUTDATE", InputDate));
			}
			return "TRUE";
			}catch(Exception e){
				e.printStackTrace();
				return "FALSE";
			}
		}

}

