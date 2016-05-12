package com.amarsoft.app.billions;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class UpdateMobilePosNo {
	private String SerialNo;
	private String applyserialno; //申请流水号
	private String retaivestoreno; //关联门店
	private String starttime; //开始时间	
	private String endtime; //结束时间

	public String getSerialNo() {
		return SerialNo;
	}

	public void setSerialNo(String serialNo) {
		SerialNo = serialNo;
	}
	
	public String getApplyserialno() {
		return applyserialno;
	}

	public void setApplyserialno(String applyserialno) {
		this.applyserialno = applyserialno;
	}

	public String getRetaivestoreno() {
		return retaivestoreno;
	}

	public void setRetaivestoreno(String retaivestoreno) {
		this.retaivestoreno = retaivestoreno;
	}

	public String getStarttime() {
		return starttime;
	}

	public void setStarttime(String starttime) {
		this.starttime = starttime;
	}

	public String getEndtime() {
		return endtime;
	}

	public void setEndtime(String endtime) {
		this.endtime = endtime;
	}

	public void UpdatePosNo(Transaction sqlca) throws Exception {
		String sCityCode = sqlca.getString(new SqlObject(
				"select City from MobilePos_info where serialno =:serialno")
				.setParameter("serialno", SerialNo));
		System.out.println("____________sCityCode" + sCityCode);
		GenerateSerialNo gs = new GenerateSerialNo();
		gs.setCityCode(sCityCode);
		String sMoiblePosNo = gs.getMobilePosNo(sqlca);
		System.out.println("------------sMoiblePosNo" + sMoiblePosNo);
		sqlca.executeSQL(new SqlObject(
				"update MobilePos_info   set MOBLIEPOSNO=:MOBLIEPOSNO where serialno=:SerialNo")
				.setParameter("SerialNo", SerialNo).setParameter("MOBLIEPOSNO",
						sMoiblePosNo));

	}
	
	/***
	 * 查询门店是否在同一时间段同时申请多个移动POS点_tangyb_add
	 * @param sqlca
	 * @return isRepeat 是否重复 [0:否,1:是]
	 * @throws Exception
	 */
	public String checkStorePosApp(Transaction sqlca) throws Exception {
		System.out.println("申请流水号[applyserialno]="+applyserialno);
		System.out.println("关联门店[retaivestoreno]="+retaivestoreno);
		System.out.println("开始时间[starttime]="+starttime);
		System.out.println("结束时间[endtime]="+endtime);
		
		String isRepeat = "0"; //是否重复 [0:否,1:是]
		
		String sql = "SELECT COUNT(1) FROM mobilepos_info t WHERE t.retativestoreno = '"+retaivestoreno+"' "
					+ "AND t.applyserialno <> '"+applyserialno+"' AND t.status in ('01', '02', '03', '05', '07') "
					+ "AND (to_date(t.starttime, 'yyyy/MM/dd') = to_date('"+starttime+"', 'yyyy/MM/dd') "
					+ "OR to_date(t.starttime, 'yyyy/MM/dd') = to_date('"+endtime+"', 'yyyy/MM/dd') "
					+ "OR to_date(t.endtime, 'yyyy/MM/dd') = to_date('"+starttime+"', 'yyyy/MM/dd') "
					+ "OR to_date(t.endtime, 'yyyy/MM/dd') = to_date('"+endtime+"', 'yyyy/MM/dd') "
					+ "OR (to_date(t.starttime, 'yyyy/MM/dd') < to_date('"+starttime+"', 'yyyy/MM/dd') "
					+ "AND to_date(t.endtime,'yyyy/MM/dd') > to_date('"+starttime+"', 'yyyy/MM/dd')) "
					+ "OR (to_date(t.starttime, 'yyyy/MM/dd') < to_date('"+endtime+"', 'yyyy/MM/dd') "
					+ "AND to_date(t.endtime,'yyyy/MM/dd') > to_date('"+endtime+"', 'yyyy/MM/dd')) "
					+ "OR (to_date(t.starttime, 'yyyy/MM/dd') > to_date('"+starttime+"', 'yyyy/MM/dd') "
					+ "AND to_date(t.endtime,'yyyy/MM/dd') < to_date('"+endtime+"', 'yyyy/MM/dd')))";
		
		String count = sqlca.getString(new SqlObject(sql));
		
		if(count != null && Integer.parseInt(count) > 0){
			isRepeat = "1";
		}
		
		return isRepeat;
	}

}
