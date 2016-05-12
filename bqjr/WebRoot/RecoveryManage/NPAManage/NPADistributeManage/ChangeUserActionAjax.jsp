<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%	
	/* 
	 * Content: 更改合同表不良资产的管理机构及人员
	 */
	String sReturnValue="";
	String sSerialNo = CurPage.getParameter("SerialNo"); //合同流水号	
	String sRecoveryOrgID = CurPage.getParameter("RecoveryOrgID"); //保全部机构号	
	String sRecoveryUser = CurPage.getParameter("RecoveryUserID"); //不良资产管理人
    String sSql= " UPDATE BUSINESS_CONTRACT SET RecoveryOrgID=:RecoveryOrgID,RecoveryUserID=:RecoveryUserID WHERE  SerialNo=:SerialNo";   
    SqlObject so = new SqlObject(sSql);
	so.setParameter("RecoveryOrgID",sRecoveryOrgID).setParameter("RecoveryUserID",sRecoveryUser).setParameter("SerialNo",sSerialNo);
    Sqlca.executeSQL(so);
    sReturnValue="true";

	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>