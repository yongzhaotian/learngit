<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%	
	/* 
	 * Content: ���ĺ�ͬ�����ʲ��Ĺ����������Ա
	 */
	String sReturnValue="";
	String sSerialNo = CurPage.getParameter("SerialNo"); //��ͬ��ˮ��	
	String sRecoveryOrgID = CurPage.getParameter("RecoveryOrgID"); //��ȫ��������	
	String sRecoveryUser = CurPage.getParameter("RecoveryUserID"); //�����ʲ�������
    String sSql= " UPDATE BUSINESS_CONTRACT SET RecoveryOrgID=:RecoveryOrgID,RecoveryUserID=:RecoveryUserID WHERE  SerialNo=:SerialNo";   
    SqlObject so = new SqlObject(sSql);
	so.setParameter("RecoveryOrgID",sRecoveryOrgID).setParameter("RecoveryUserID",sRecoveryUser).setParameter("SerialNo",sSerialNo);
    Sqlca.executeSQL(so);
    sReturnValue="true";

	out.println(sReturnValue);
%><%@ include file="/IncludeEndAJAX.jsp"%>