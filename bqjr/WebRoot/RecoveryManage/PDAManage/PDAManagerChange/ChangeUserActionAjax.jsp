<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/* Content: 更改资产表的管理机构及人员
	 */
	String sReturnValue="";
	String sSerialNo = CurPage.getParameter("SerialNo"); //资产流水号	
	String sManageOrgID = CurPage.getParameter("ManageOrgID"); //管理人机构号	
	String sManageUserID = CurPage.getParameter("ManageUserID"); //抵债资产管理人

	String sSql= " UPDATE Asset_Info SET ManageOrgID=:ManageOrgID,ManageUserID=:ManageUserID WHERE  SerialNo=:SerialNo";
	Sqlca.executeSQL(new SqlObject(sSql).setParameter("ManageOrgID",sManageOrgID).setParameter("ManageUserID",sManageUserID).setParameter("SerialNo",sSerialNo));
	sReturnValue="true";
	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>