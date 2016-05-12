package com.amarsoft.app.billions;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 
 * 无预约现金贷款外部名单客户提交合同检验
 * 
 * @author tangyb
 * @date 2015-05-22
 */
public class OutUserCheck {
	
	private String userID; // 登陆人编号
	
	private String businessType; // 产品代码
	
	private String objectNo; //合同编号

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
	 * 根据登陆用户ID、产品代码查询是否需要无预约现金贷外部名单客户检查
	 * @param Sqlca
	 * @return isOutuser (0:否,1:是)
	 * @throws Exception
	 */
	public String queryOutuserPara(Transaction Sqlca) throws Exception{
		System.out.println("--------------userID:"+userID); //用户ID
		System.out.println("--------------businessType:"+businessType); //产品代码
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
	 * 根据合同编号查询是否上传个人征信授权书
	 * @param Sqlca
	 * @return String (0:否,1:是)
	 * @throws Exception
	 */
	public String queryCreditAuthorization(Transaction Sqlca) throws Exception{
		System.out.println("--------------objectNo:"+objectNo); //合同编号
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
