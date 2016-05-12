package com.amarsoft.app.billions;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 
 * ��ԤԼ�ֽ�����ⲿ�����ͻ��ύ��ͬ����
 * 
 * @author tangyb
 * @date 2015-05-22
 */
public class OutUserCheck {
	
	private String userID; // ��½�˱��
	
	private String businessType; // ��Ʒ����
	
	private String objectNo; //��ͬ���

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}
	
	public String getBusinessType() {
		return businessType;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public void setBusinessType(String businessType) {
		this.businessType = businessType;
	}
	
	/**
	 * ���ݵ�½�û�ID����Ʒ�����ѯ�Ƿ���Ҫ��ԤԼ�ֽ���ⲿ�����ͻ����
	 * @param Sqlca
	 * @return isOutuser (0:��,1:��)
	 * @throws Exception
	 */
	public String queryOutuserPara(Transaction Sqlca) throws Exception{
		System.out.println("--------------userID:"+userID); //�û�ID
		System.out.println("--------------businessType:"+businessType); //��Ʒ����
		String isOutuser = Sqlca.getString(new SqlObject(
						"SELECT count(1) FROM noorderdcash_para np, user_info us, store_info st"
						+ " WHERE np.areacode = st.city AND us.attribute8 = st.sno"
						+ " AND us.userid = :userid AND np.businesstype = :businesstype"
						+ " AND np.isinuse = '1'"
						+ " AND (to_date(to_char(SYSDATE, 'yyyy/MM/dd'), 'yyyy/mm/dd')"
						+ " BETWEEN to_date(np.startdate, 'yyyy/MM/dd')"
						+ " AND to_date(np.enddate, 'yyyy/MM/dd'))")
						.setParameter("userid", userID)
						.setParameter("businesstype", businessType));
		if(isOutuser != null && !"".equals(isOutuser) && Integer.parseInt(isOutuser) > 0){
			isOutuser = "1";
		}else{
			isOutuser = "0";
		}
		System.out.println("queryOutuserPara_return:" + isOutuser);
		return isOutuser;
	}
	
	/**
	 * ���ݺ�ͬ��Ų�ѯ�Ƿ��ϴ�����������Ȩ��
	 * @param Sqlca
	 * @return String (0:��,1:��)
	 * @throws Exception
	 */
	public String queryCreditAuthorization(Transaction Sqlca) throws Exception{
		System.out.println("--------------objectNo:"+objectNo); //��ͬ���
		String isUpload = Sqlca.getString(new SqlObject(
				"SELECT count(1) FROM ecm_page WHERE objecttype = 'Business' and typeno = '302004' AND objectno = :objectno")
				.setParameter("objectno", objectNo));
		if (isUpload != null && !"".equals(isUpload) && Integer.parseInt(isUpload) > 0) {
			isUpload = "1";
		} else {
			isUpload = "0";
		}
		System.out.println("queryCreditAuthorization_return:" + isUpload);
		return isUpload;
	}
	
}
