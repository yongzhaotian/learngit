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
	
	String serialNo;//合同类型
	String CUSTOMERID;//合同编号
	String CustomerName;//Apply类型
	String StartDate;//流程编号
	String EndDate;//流程阶段编号
	String CREATEOR;//用户ID
	String UPDATEOR;//用户所属机构
	
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
			// 执行提交操作
			SqlObject so;
			//获得开始日期、结束日期
			String sCREATETIME = StringFunction.getTodayNow();
			String sUPDATETIME = StringFunction.getTodayNow();
			String sCANCELSYSDATE = "";
			//“随心还服务包”状态（0申请中/1申请成功/2申请失败）
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
		   
		    //执行插入语句
		    Sqlca.executeSQL(so);
			returnValue = "Success";
			
		}catch(Exception e){
			e.printStackTrace();
			returnValue = "Failure@"+e.getMessage();
		}
		return returnValue;
	}
}
