package com.amarsoft.app.billions;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class UpdateMobilePosNo {
	private String SerialNo;
	private String applyserialno; //������ˮ��
	private String retaivestoreno; //�����ŵ�
	private String starttime; //��ʼʱ��	
	private String endtime; //����ʱ��

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
	 * ��ѯ�ŵ��Ƿ���ͬһʱ���ͬʱ�������ƶ�POS��_tangyb_add
	 * @param sqlca
	 * @return isRepeat �Ƿ��ظ� [0:��,1:��]
	 * @throws Exception
	 */
	public String checkStorePosApp(Transaction sqlca) throws Exception {
		System.out.println("������ˮ��[applyserialno]="+applyserialno);
		System.out.println("�����ŵ�[retaivestoreno]="+retaivestoreno);
		System.out.println("��ʼʱ��[starttime]="+starttime);
		System.out.println("����ʱ��[endtime]="+endtime);
		
		String isRepeat = "0"; //�Ƿ��ظ� [0:��,1:��]
		
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
