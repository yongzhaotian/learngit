/*
		Author: --fwang 2009-06-12
		Tester:
		Describe: --�жϿͻ�����֮��Ĺ�ϵ
		Input Param:
				CustomerID:�ͻ�ID
				UserID����ǰ�û�ID
				OrgID����ǰ����ID
		Output Param:
				"1":�ͻ�������ͬһ����
				"2":�ͻ�������ͬһ�ϼ�����
				"3":�ͻ�������ͬһ�ϼ�����
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CheckRoleApply extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//��ÿͻ�ID
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//��õ�ǰ�û�ID
		String sUserID = (String)this.getAttribute("UserID");
		//��������
		String sOrgID = (String)this.getAttribute("OrgID");
		
		//����ֵת��Ϊ���ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
		
		//�������	
		String  sSql = "";//���sql���	
		String  sSuperiorOrgID = "";//����ϼ����ڻ�������
		String  sOldOrgID = "";//���û���ǰ�����ͻ��������ID
		String  sOldRelativeOrgID = "";//���û���ǰ�����ͻ������ϼ�����ID
		String	sApplyType ="";
		ASResultSet rs = null;//��Ž����
		SqlObject so ;//��������
		
		//��ȡ���û�ԭ�����ͻ��������ID
		sSql = "select OrgID from CUSTOMER_BELONG where CustomerID=:CustomerID and BelongAttribute='1'";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
		rs = Sqlca.getASResultSet(so);
		
		if(rs.next())
		{
			sOldOrgID = rs.getString("OrgID");
		}
		rs.getStatement().close();
		
		//��ȡ���û�ԭ�����ͻ���������ϼ�����
		sSql = 	" select RelativeOrgID from ORG_INFO where OrgID =:OrgID ";
		so = new SqlObject(sSql).setParameter("OrgID", sOldOrgID);
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{
			sOldRelativeOrgID = rs.getString("RelativeOrgID");	
		}
		rs.getStatement().close();
		
		//��ȡ��ǰ�������ϼ�����
		sSql = 	" select OI.RelativeOrgID as SuperiorOrgID"+
		" from ORG_INFO OI"+
		" where OI.OrgID =:OrgID ";
		so = new SqlObject(sSql).setParameter("OrgID", sOrgID);
        rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{
			sSuperiorOrgID = rs.getString("SuperiorOrgID");	
		}
		rs.getStatement().close();
		
		//�ж��Ƿ�����ͬһ����
		if(sOldOrgID.equals(sOrgID)){
			sApplyType = "1" ;
		//�ж��Ƿ�����ͬһ�ϼ�����
		}else if(sOldRelativeOrgID.equals(sSuperiorOrgID)){
			sApplyType = "2" ;
		//�ж��Ƿ����ڲ�ͬ�ϼ�����
		}else {
			sApplyType = "3" ;
		}
		sSql = " update CUSTOMER_BELONG set ApplyType =:ApplyType where CustomerID =:CustomerID " ;
		so = new SqlObject(sSql).setParameter("ApplyType", sApplyType).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
		
		return "1";
	}
}


