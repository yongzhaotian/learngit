package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;


public class UpdateGroupType extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ	    
		String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sUserID   = (String)this.getAttribute("UserID");
		String sChangeFlag   = (String)this.getAttribute("ChangeFlag");
		//����ֵת��Ϊ���ַ���
		if(sCustomerID == null) sCustomerID = "";
		if(sUserID == null) sUserID = "";
		if(sChangeFlag == null) sChangeFlag = "";
		
		//�������		
		ASResultSet rs = null;
		String sSql = "";//Sql���
		SqlObject so;
		String sCustomerType = "";//�ͻ�����
		String sGroupType = "";//���ſͻ�����
		String sChangeType = "";//�������
		String sSerialNo = "";//�����ˮ��
		
		//ʵ�����û�����
	    ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		if(sChangeFlag.equals("1To2"))//��һ�༯�ſͻ�ת��Ϊ���༯�ſͻ�
		{
			sCustomerType = "0202";
			sGroupType = "2";
			sChangeType = "050";
		}
		if(sChangeFlag.equals("2To1"))//�����༯�ſͻ�ת��Ϊһ�༯�ſͻ�
		{
			sCustomerType = "0201";
			sGroupType = "1";
			sChangeType = "040";
		}
		
		//�����ſͻ��Ŀͻ�������һ�༯�ſͻ�����Ϊ���༯�ſͻ�
		sSql =  " update CUSTOMER_INFO "+
				" set CustomerType =:CustomerType "+
				" where CustomerID =:CustomerID ";
		//ִ�и������
		so = new SqlObject(sSql).setParameter("CustomerType", sCustomerType).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
	    
	    //�����ſͻ��ſ���Ϣ�Ļ���������һ�༯�ſͻ�����Ϊ���༯�ſͻ�
		sSql =  " update ENT_INFO "+
				" set OrgNature =:OrgNature , "+
				" GroupFlag =:GroupFlag "+
				" where CustomerID =:CustomerID ";
		//ִ�и������
		so = new SqlObject(sSql).setParameter("OrgNature", sCustomerType)
		.setParameter("GroupFlag", sGroupType).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
	    	    	    
	    //�����ų�Ա�ſ���Ϣ�Ļ������ʡ����ſͻ���־��һ�༯�ſͻ�����Ϊ���༯�ſͻ�
		sSql =  " update ENT_INFO "+
				" set GroupFlag =:GroupFlag "+
				" where CustomerID in "+
				" (select RelativeID "+
				" from CUSTOMER_RELATIVE "+
				" where CustomerID =:CustomerID "+
				" and RelationShip like '04%' "+
				" and length(RelationShip)>2) "; 
		//ִ�и������
		so = new SqlObject(sSql).setParameter("GroupFlag", sGroupType).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so);
	    
	   //�����ų�Ա�ļ��ŷ�����һ�༯�ſͻ�����Ϊ���༯�ſͻ�
		sSql =  " update CUSTOMER_RELATIVE "+
				" set Describe =:Describe "+
				" where CustomerID =:CustomerID "+
				" and RelationShip like '04%' "+
				" and length(RelationShip)>2 ";
		//ִ�и������
		so = new SqlObject(sSql).setParameter("Describe", sGroupType).setParameter("CustomerID", sCustomerID);
		Sqlca.executeSQL(so); 
		
		//�ǼǼ��ų�Ա�����¼
	    //��ȡ���ų�Ա�Ŀͻ���š��ͻ����ơ�֤�����͡���֯��������
		sSql = 	" select RelativeID,CustomerName,CertType,CertID "+
				" from CUSTOMER_RELATIVE "+
				" where CustomerID =:CustomerID "+
				" and RelationShip like '04%' "+
				" and length(RelationShip)>2 ";
		so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
		rs = Sqlca.getASResultSet(so);
	    while(rs.next())
	    {
	    	String sRelativeID = rs.getString("RelativeID");
	    	String sRelativeName = rs.getString("CustomerName");
	    	String sCertType = rs.getString("CertType");
	    	String sCertID = rs.getString("CertID");
	    	if(sCertType.equals("Ent01"))
	    	{
	    		//�����ˮ�ţ����Ŵ��룬�ͻ����룬�䶯���ͣ�ԭ�ͻ����ƣ��䶯���ڣ�����������������Ա���ͻ����ƣ���֯��������
	    		//�䶯��־��010��������020��ɾ����030�������� 040������תһ�ࣻ050��һ��ת����
	    		sSerialNo = DBKeyHelp.getSerialNo("GROUP_CHANGE","SerialNo",Sqlca);
	    		sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
		 			   " values(:SerialNo,:GroupNo,:CustomerID,:ChangeType,:OldName,:UpdateDate,:UpdateOrgid, "+
		 			   " :UpdateUserid,:CustomerName,:Corp)";
	    		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("GroupNo", sCustomerID).setParameter("CustomerID", sRelativeID)
	    		.setParameter("ChangeType", sChangeType).setParameter("OldName", sRelativeName).setParameter("UpdateDate", StringFunction.getToday())
	    		.setParameter("UpdateOrgid", CurUser.getOrgID()).setParameter("UpdateUserid", sUserID).setParameter("CustomerName", sRelativeName).setParameter("Corp", sCertID);
	    		Sqlca.executeSQL(so);	
	    	}else
	    	{
	    		//�����ˮ�ţ����Ŵ��룬�ͻ����룬�䶯���ͣ�ԭ�ͻ����ƣ��䶯���ڣ�����������������Ա���ͻ����ƣ���֯��������
	    		//�䶯��־��010��������020��ɾ����030�������� 040������תһ�ࣻ050��һ��ת����
	    		sSerialNo = DBKeyHelp.getSerialNo("GROUP_CHANGE","SerialNo",Sqlca);
	    		sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
		 			   " values(:SerialNo,:GroupNo,:CustomerID,:ChangeType,:OldName,:UpdateDate,:UpdateOrgid, "+
		 			   " :UpdateUserid,:CustomerName,'')";
	    		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("GroupNo", sCustomerID).setParameter("CustomerID", sRelativeID)
	    		.setParameter("ChangeType", sChangeType).setParameter("OldName", sRelativeName).setParameter("UpdateDate", StringFunction.getToday())
	    		.setParameter("UpdateOrgid", CurUser.getOrgID()).setParameter("UpdateUserid", sUserID).setParameter("CustomerName", sRelativeName);
	    		Sqlca.executeSQL(so);
	    	}
	    }
	    rs.getStatement().close();
	    
	    return "1";
	    
	 }

}
