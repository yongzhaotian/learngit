<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%
	/* Content: �����ʲ���Ĺ����������Ա
	 */
	String sReturnValue="";
	String sSerialNo = CurPage.getParameter("SerialNo"); //�ʲ���ˮ��	
	String sManageOrgID = CurPage.getParameter("ManageOrgID"); //�����˻�����	
	String sManageUserID = CurPage.getParameter("ManageUserID"); //��ծ�ʲ�������

	String sSql= " UPDATE Asset_Info SET ManageOrgID=:ManageOrgID,ManageUserID=:ManageUserID WHERE  SerialNo=:SerialNo";
	Sqlca.executeSQL(new SqlObject(sSql).setParameter("ManageOrgID",sManageOrgID).setParameter("ManageUserID",sManageUserID).setParameter("SerialNo",sSerialNo));
	sReturnValue="true";
	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>