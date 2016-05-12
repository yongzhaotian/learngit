package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class DeleteGroupInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ�����ų�Ա���,���ű��,������
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sRelativeID = (String)this.getAttribute("RelativeID");
		String sUserID  = (String)this.getAttribute("UserID");
		//����ֵת��Ϊ���ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sRelativeID == null) sRelativeID = "";
		if(sUserID == null) sUserID = "";
		
		ASResultSet rs = null;
		SqlObject so ;//��������
		String sSql = "";
		//�ͻ�����
		String sCustomerName = "";
		//֤������
		String sCertType = "";
		//֤�����
		String sCertID = "";
				
		//ʵ�����û�����
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
				
		//���ݼ��ų�Ա�����ȡ���ų�Ա���ơ�֤�����͡�֤�����
		sSql = 	" select CustomerName,CertType,CertID "+
		" from CUSTOMER_INFO "+
		" where CustomerID =:CustomerID  ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
        rs = Sqlca.getASResultSet(so);
		
		if (rs.next()) 
		{					
			sCustomerName = rs.getString("CustomerName");	
			sCertType = rs.getString("CertType");
			sCertID = rs.getString("CertID");
			if(sCustomerName == null) sCustomerName = "";
			if(sCertType == null) sCertType = "";
			if(sCertID == null) sCertID = "";
		}
		rs.getStatement().close();
		
		//���¼��ų�Ա����������
		sSql =  " update CUSTOMER_INFO set BelongGroupID = null "+
		" where CustomerID =:CustomerID ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
        Sqlca.executeSQL(so);
			
		//���¼��ų�Ա�ļ��ű�־	
        sSql = 	" update ENT_INFO set GroupFlag = '0' "+
		" where CustomerID =:CustomerID ";
        so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
        Sqlca.executeSQL(so);
        
		//�������ų�Ա�����¼
		//�����ˮ�ţ����Ŵ��룬�ͻ����룬�䶯���ͣ�ԭ�ͻ����ƣ��䶯���ڣ�����������������Ա���ͻ����ƣ���֯��������
		//�䶯��־��010��������020��ɾ��
		String sSerialNo = DBKeyHelp.getSerialNo("GROUP_CHANGE","SerialNo",Sqlca);
		if(sCertType.equals("Ent01"))
		{
			//ֻ��֤������Ϊ��֯��������֤ʱ���ż�¼��֯��������
			sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
			   " values(:SerialNo,:GroupNo,:CustomerID,'020',:OldName,:UpdateDate,:UpdateOrgid, "+
			   " :UpdateUserid,:CustomerName,:Corp)";
			so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("GroupNo", sRelativeID).setParameter("CustomerID", sCustomerID).setParameter("OldName", sCustomerName).setParameter("UpdateDate", StringFunction.getToday()).setParameter("UpdateOrgid", CurUser.getOrgID())
			.setParameter("UpdateUserid", CurUser.getUserID()).setParameter("CustomerName", sCustomerName).setParameter("Corp", sCertID);
		}else
		{   
			sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
			   " values(:SerialNo,:GroupNo,:CustomerID,'020',:OldName,:UpdateDate,:UpdateOrgid, "+
			   " :UpdateUserid,:CustomerName,'')";
			so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("GroupNo", sRelativeID).setParameter("CustomerID", sCustomerID).setParameter("OldName", sCustomerName).setParameter("UpdateDate", StringFunction.getToday()).setParameter("UpdateOrgid", CurUser.getOrgID())
			.setParameter("UpdateUserid", CurUser.getUserID()).setParameter("CustomerName", sCustomerName);
		}
		Sqlca.executeSQL(so);	
		return "1";
	}		
}
