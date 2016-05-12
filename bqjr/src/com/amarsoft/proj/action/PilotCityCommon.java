package com.amarsoft.proj.action;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class PilotCityCommon {
	private String subProductType;
	private String pilotType;
	private String citys;
	private String userID;
	private String todayNow = StringFunction.getTodayNow();
	
	public String addPilotCitys(Transaction Sqlca) throws  Exception{
   	 String[] sCity=citys.split("@");
   	 SqlObject so = null;
   	 
   	 for(int i=0;i<sCity.length;i++){
   		 String sSQL = "insert into pilot_city(subproducttype, city, verifytype, inputuserid, inputtime)  values(:subproducttype, :city, :verifytype, :inputuserid, :inputtime)";
   		 so = new SqlObject(sSQL).setParameter("subproducttype", subProductType)
   				 .setParameter("city", sCity[i]).setParameter("verifytype", pilotType)
   				 .setParameter("inputuserid", userID).setParameter("inputtime", todayNow);
   		 Sqlca.executeSQL(so);
	 }
   	 
       return "Success";
    }

	public String getSubProductType() {
		return subProductType;
	}

	public void setSubProductType(String subProductType) {
		this.subProductType = subProductType;
	}

	public String getPilotType() {
		return pilotType;
	}

	public void setPilotType(String pilotType) {
		this.pilotType = pilotType;
	}

	public String getCitys() {
		return citys;
	}

	public void setCitys(String citys) {
		this.citys = citys;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getTodayNow() {
		return todayNow;
	}

	public void setTodayNow(String todayNow) {
		this.todayNow = todayNow;
	}
	
}
