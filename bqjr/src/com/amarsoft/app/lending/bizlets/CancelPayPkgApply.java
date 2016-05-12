/**
 * 
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * @author huanghui
 *
 */
public class CancelPayPkgApply {
	
	String serialNo;//��ͬ����
	String CUSTOMERID;//��ͬ���
	String CustomerName;//Apply����
	String StartDate;//���̱��
	String EndDate;//���̽׶α��
	String CREATEOR;//�û�ID
	String UPDATEOR;//�û���������
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getCUSTOMERID() {
		return CUSTOMERID;
	}

	public void setCUSTOMERID(String cUSTOMERID) {
		CUSTOMERID = cUSTOMERID;
	}

	public String getCustomerName() {
		return CustomerName;
	}

	public void setCustomerName(String customerName) {
		CustomerName = customerName;
	}

	public String getStartDate() {
		return StartDate;
	}

	public void setStartDate(String startDate) {
		StartDate = startDate;
	}

	public String getEndDate() {
		return EndDate;
	}

	public void setEndDate(String endDate) {
		EndDate = endDate;
	}

	public String getCREATEOR() {
		return CREATEOR;
	}

	public void setCREATEOR(String cREATEOR) {
		CREATEOR = cREATEOR;
	}

	public String getUPDATEOR() {
		return UPDATEOR;
	}

	public void setUPDATEOR(String uPDATEOR) {
		UPDATEOR = uPDATEOR;
	}

	public String cancelApply(Transaction Sqlca) throws Exception {
		String returnValue;
		try{
			// ִ���ύ����
			SqlObject so;
			//��ÿ�ʼ���ڡ���������
			String sCREATETIME = StringFunction.getTodayNow();
			String sUPDATETIME = StringFunction.getTodayNow();
			String sCANCELSYSDATE = "";
			//�����Ļ��������״̬��0������/1����ɹ�/2����ʧ�ܣ�
			String sPkgStatus = "0";
			
			String sSql = "";
			ASResultSet rs = null;
			sSql = "SELECT BusinessDate,NextBatchExecuteDate FROM SYSTEM_SETUP where 1=1";
			rs = Sqlca.getASResultSet(new SqlObject(sSql));
			if (rs.next()) {
				sCANCELSYSDATE = rs.getString(1);
			}
			rs.getStatement().close();
			
		    sSql =  " insert into BUSINESS_PAYPKG_APPLY(CONTRACTNO,CUSTOMERID,CUSTOMERNAME,PkgStatus,StartDate,EndDate,CREATEOR, " +
				" CREATETIME,UPDATEOR,UPDATETIME,CANCELSYSDATE,APPROVEDATE) "+
				" values (:CONTRACTNO,:CUSTOMERID,:CUSTOMERNAME,:PkgStatus,:StartDate, " + 
				" :EndDate,:CREATEOR,:CREATETIME,:UPDATEOR,:UPDATETIME,:CANCELSYSDATE, " +
				" :APPROVEDATE )";
		    so = new SqlObject(sSql);
		    so.setParameter("CONTRACTNO", serialNo).setParameter("CUSTOMERID", CUSTOMERID).setParameter("CUSTOMERNAME", CustomerName).setParameter("PkgStatus", sPkgStatus)
		    .setParameter("StartDate", StartDate).setParameter("EndDate", EndDate).setParameter("CREATEOR", CREATEOR).setParameter("CREATETIME", sCREATETIME)
		    .setParameter("UPDATEOR", UPDATEOR).setParameter("UPDATETIME", sUPDATETIME).setParameter("CANCELSYSDATE", sCANCELSYSDATE).setParameter("APPROVEDATE", "");
		   
		    //ִ�в������
		    Sqlca.executeSQL(so);
			returnValue = "Success";
			
		}catch(Exception e){
			e.printStackTrace();
			returnValue = "Failure@"+e.getMessage();
		}
		return returnValue;
	}
}
