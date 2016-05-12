package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class UpdateCustomerRelaInfo extends Bizlet{
	
	public Object run(Transaction Sqlca) throws Exception
	 {		
        //�Զ���ô���Ĳ���ֵ		
		String sCustomerID   = (String)this.getAttribute("CustomerID");
		String sFromUserID   = (String)this.getAttribute("FromUserID");
		String sToUserID   = (String)this.getAttribute("ToUserID");
		
        //����ֵת���ɿ��ַ���		
		if(sCustomerID == null) sCustomerID = "";
		if(sFromUserID == null) sFromUserID = "";
		if(sToUserID == null) sToUserID = "";
		
		
		//�������	
        ASUser CurUser = null;
        String sCustomerType = "";
        String sFromOrgID = "";
        String sToUserName = "",sToOrgID = "",sToOrgName = "";
        String sUpdateDate = "",sUpdateTime = "";
        
        //��ȡת��ǰ�Ļ�������ͻ�������
        CurUser = ASUser.getUser(sFromUserID,Sqlca);
        sFromOrgID = CurUser.getOrgID();
        SqlObject so; //��������
        //��ȡת��ǰ�Ļ�������ͻ�������
        CurUser = ASUser.getUser(sToUserID,Sqlca);
        sToUserName = CurUser.getUserName();
        sToOrgID = CurUser.getOrgID();
        sToOrgName = CurUser.getOrgName();
       
        //��ȡ�������
        sUpdateDate = StringFunction.getToday();
        sUpdateTime = StringFunction.getTodayNow();
		//��ȡ�ͻ�����
        so = new SqlObject("select CustomerType from CUSTOMER_INFO where CustomerID =:CustomerID ").setParameter("CustomerID", sCustomerID);
        sCustomerType = Sqlca.getString(so);
		if (sCustomerType == null) sCustomerType = "";
		
		
		//****************�������������ţ�*****************
		//���¿ͻ�Ȩ��
		UpdateCustomerBelong(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //���¿ͻ��ſ�
		UpdateCustomerInfo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,Sqlca);
        //������ҵ�ͻ�������Ա���ͻ��߹ܡ����˴�������Ա���ɶ�����������ȨͶ����������������������
		//���¸�����ż����ͥ��Ա���������Ͷ����ҵ���
		UpdateCustomerRelative(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //������ҵ�ͻ����������ڻ���������Ϣ�Ϳͻ����¼�
		//���˴��¼�
		UpdateCustomerMemo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //���¹�˾�ͻ��ĵ���Ϣ
		//���˿ͻ��ṩ�������
		UpdateDocLibrary(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToUserName,sToOrgID,sToOrgName,sUpdateTime,Sqlca);
        //���¹�Ʊ��Ϣ
		UpdateCustomerStock(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //���³���ծȯ��Ϣ
		UpdateCustomerBond(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //������˰��Ϣ
		UpdateCustomerTaxPaying(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //���������ʲ���Ϣ
		UpdateImaAsserts(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);	
        //�����������ڻ���ҵ��
		UpdateCustomerOActivity(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
        //���¿ͻ��������
		//�����������
		UpdateCustomerAnarecord(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
		
		
		if(sCustomerType.substring(0,2).equals("01")){  //��˾�ͻ�			
	        //������ҵ�ͻ���
			UpdateEntInfo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���¹�Ʊ��
			UpdateEntIPO(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //����ծȯ��
			UpdateEntBondIssue(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���·��ز��������
			UpdateEntRealtyAuth(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���½�����ó��
			UpdateEntranceAuth(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //��������Ӫ��ҵ�������֤��Ϣ
			UpdateEntAuth(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���²�����Ŀ���
			UpdateProjectInfo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���²��񱨱�
			UpdateCustomerFSRecord(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,sUpdateTime,Sqlca);
	        //����Ӧ��Ӧ���ʿ���Ϣ
			UpdateEntFOA(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���¸��´����Ϣ
			UpdateEntInventory(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���¹̶��ʲ���Ϣ
			UpdateEntFixedAsserts(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);	
	        //�����ֽ���Ԥ��
			UpdateCashRecord(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,Sqlca);
	        //���¿ͻ����õȼ�����
			UpdateEvaluateRecordEnt(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToUserName,sToOrgID,Sqlca);
	        //���·���Ԥ���ź���������������޶�ο�
			UpdateRiskSignal(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	    }	
			
		if(sCustomerType.substring(0,2).equals("03")) 	//���˿ͻ�
		{
	        //���˸ſ���
			UpdateIndInfo(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //����ѧҵ����
			UpdateIndEducation(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //���˹�������
			UpdateIndResume(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //��ᱣ�ա��Ʋ����ա����ٱ���
			UpdateIndSi(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //�����ʲ����
			UpdateCustomerRealty(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //�����ʲ����
			UpdateCustomerVehicle(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //�����ʲ���Ϣ
			UpdateIndOasset(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //������ծ��Ϣ
			UpdateIndOdebt(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,sUpdateDate,Sqlca);
	        //�������õȼ�������Ϣ
			UpdateEvaluateRecordInd(sCustomerID,sFromUserID,sFromOrgID,sToUserID,sToOrgID,Sqlca);
		}	

		return "1";
				
	 }
	
	private void UpdateCustomerBelong(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca) 
		throws Exception
	{
		//��������
	    String sBelongAttribute1 = "",sBelongAttribute2 = "",sBelongAttribute3 = "",sBelongAttribute4 = "";
	    String sNewBelongAttribute1 = "",sNewBelongAttribute2 = "",sNewBelongAttribute3 = "",sNewBelongAttribute4 = "";
	    String sSql = "";
	    ASResultSet rs = null;	
	    SqlObject so ;
	    //��ԭ�û��Ըÿͻ���Ȩ��ȡ����
	    sSql =  " select BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4 "+
		        " from CUSTOMER_BELONG " +
		    	" where CustomerID =:CustomerID "+
		    	" and OrgID =:OrgID "+
		    	" and UserID =:UserID ";
	    so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID).setParameter("OrgID", sFromOrgID).setParameter("UserID", sFromUserID);
	    rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{
		    sBelongAttribute1 = DataConvert.toString(rs.getString("BelongAttribute1"));
		    sBelongAttribute2 = DataConvert.toString(rs.getString("BelongAttribute2"));
		    sBelongAttribute3 = DataConvert.toString(rs.getString("BelongAttribute3"));
		    sBelongAttribute4 = DataConvert.toString(rs.getString("BelongAttribute4"));
		}
	    rs.getStatement().close();
		
		//��Ŀ���û��Ըÿͻ���Ȩ��ȡ����
	    sSql =  " select BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4 "+
		    	" from CUSTOMER_BELONG " +
		    	" where CustomerID =:CustomerID "+
		    	" and OrgID =:OrgID "+
		    	" and UserID =:UserID ";
	    so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID).setParameter("OrgID", sToOrgID).setParameter("UserID", sToUserID);
	    rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{
		    sNewBelongAttribute1 = DataConvert.toString(rs.getString("BelongAttribute1"));
		    sNewBelongAttribute2 = DataConvert.toString(rs.getString("BelongAttribute2"));
		    sNewBelongAttribute3 = DataConvert.toString(rs.getString("BelongAttribute3"));
		    sNewBelongAttribute4 = DataConvert.toString(rs.getString("BelongAttribute4"));
	
            //ȡҵ������Ȩ����Ϣά��Ȩ��ҵ�����Ȩ�ĸ���Ȩ��
            if(Integer.parseInt(sBelongAttribute1) > Integer.parseInt(sNewBelongAttribute1) && sNewBelongAttribute1 != "")
                sBelongAttribute1 = sNewBelongAttribute1;
            if(Integer.parseInt(sBelongAttribute2) < Integer.parseInt(sNewBelongAttribute2) && sNewBelongAttribute2 != "")
                sBelongAttribute2 = sNewBelongAttribute2;
            if(Integer.parseInt(sBelongAttribute3) > Integer.parseInt(sNewBelongAttribute3) && sNewBelongAttribute3 != "")
                sBelongAttribute3 = sNewBelongAttribute3;
            if(Integer.parseInt(sBelongAttribute4) > Integer.parseInt(sNewBelongAttribute4) && sNewBelongAttribute4 != "")
                sBelongAttribute4 = sNewBelongAttribute4;
        }
        rs.getStatement().close();
           		
        //������ݿ��д�����Ҫ�����������ͬ�ļ�¼��������ɾ��ԭ���ļ�¼���ٽ��в����¼�¼��
        sSql =   " delete from CUSTOMER_BELONG where CustomerID=:CustomerID and OrgID=:OrgID and UserID=:UserID ";
        so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID).setParameter("OrgID", sToOrgID).setParameter("UserID", sToUserID);
        Sqlca.executeSQL(so);
        
        //����ǰ�û���Ȩ�޸��²����û���ΪĿ���û�
        sSql =  " update CUSTOMER_BELONG set "+
				" UserID =:UserIDNew, "+
				" OrgID =:OrgIDNew, " +
		        " BelongAttribute1 =:BelongAttribute1," +
		        " BelongAttribute2 =:BelongAttribute2," +
		        " BelongAttribute3 =:BelongAttribute3," +
		        " BelongAttribute4 =:BelongAttribute4, " +
		        " UpdateDate =:UpdateDate "+
		        " where CustomerID =:CustomerID "+
		        " and OrgID =:OrgID "+
		        " and UserID =:UserID ";
        so = new SqlObject(sSql).setParameter("UserIDNew", sToUserID).setParameter("OrgIDNew", sToOrgID).setParameter("BelongAttribute1", sBelongAttribute1)
        .setParameter("BelongAttribute2", sBelongAttribute2).setParameter("BelongAttribute3", sBelongAttribute3).setParameter("BelongAttribute4", sBelongAttribute4)
        .setParameter("UpdateDate", sUpdateDate).setParameter("CustomerID", sCustomerID).setParameter("OrgID", sFromOrgID).setParameter("UserID", sFromUserID);
        Sqlca.executeSQL(so);
	}
	
	 //���¿ͻ��ſ�
	 private void UpdateCustomerInfo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 SqlObject so;
		 sSql = " update CUSTOMER_INFO set "+
			 	" InputUserID =:InputUserIDNew, "+
			 	" InputOrgID =:InputOrgIDNew " +
			 	" where CustomerID =:CustomerID "+
			 	" and InputUserID =:InputUserID "+
			 	" and InputOrgID =:InputOrgID ";
		 so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("CustomerID", sCustomerID)
		 .setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 }
	 
	 //������ҵ�ͻ���
	 private void UpdateEntInfo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 SqlObject so;
		 sSql = " update ENT_INFO set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
		 
		 sSql = " update ENT_INFO set "+
		 		" UpdateUserID =:UpdateUserIDNew, "+
		 		" UpdateOrgID =:UpdateOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and UpdateUserID =:UpdateUserID "+
		 		" and UpdateOrgID =:UpdateOrgID ";
		 //ִ��ɾ�����
		 so = new SqlObject(sSql).setParameter("UpdateUserIDNew", sToUserID).setParameter("UpdateOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("UpdateUserID", sFromUserID).setParameter("UpdateOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 }
	 
	 //���¿ͻ�������Ա���ͻ��߹ܡ����˴�������Ա���ɶ�����������ȨͶ����������������������
	 private void UpdateCustomerRelative(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 SqlObject so;
		 sSql = " update CUSTOMER_RELATIVE set "+
		 		" InputUserID=:InputUserIDNew, "+
		 		" InputOrgID=:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 //ִ��ɾ�����
		 Sqlca.executeSQL(so);
	 }
	 
	 //���¹�Ʊ��
	 private void UpdateEntIPO(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_IPO set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 //ִ��ɾ�����
		SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 }
	 
	 //����ծȯ��
	 private void UpdateEntBondIssue(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_BONDISSUE set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 }
	 
     //���·��ز��������
	 private void UpdateEntRealtyAuth(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_REALTYAUTH set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
     //	���½�����ó��
	 private void UpdateEntranceAuth(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_ENTRANCEAUTH set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 	 	 
	 //��������Ӫ��ҵ�������֤��Ϣ
	 private void UpdateEntAuth(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_AUTH set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 	 
	 //���¿ͻ����������ڻ���������Ϣ�Ϳͻ����¼�
	 private void UpdateCustomerMemo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_MEMO set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
     //���²�����Ŀ���
	 private void UpdateProjectInfo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 //������Ŀ�ſ�
		
		 String sSql = "";
		 SqlObject so;
		 sSql = " update PROJECT_INFO set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where ProjectNo in (select ProjectNo from PROJECT_RELATIVE where ObjectType = 'Customer' " +
		 		" and ObjectNo =:ObjectNo) "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 //ִ��ɾ�����
		 so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		.setParameter("ObjectNo", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
		 
		 //������Ŀ�ʽ���Դ	
		 sSql = " update PROJECT_FUNDS set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where ProjectNo in (select ProjectNo from PROJECT_RELATIVE where ObjectType = 'Customer' " +
		 		" and ObjectNo =:ObjectNo) "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		.setParameter("ObjectNo", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
		 
		 //������Ŀ��չ���
		 sSql = " update PROJECT_PROGRESS set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where ProjectNo in (select ProjectNo from PROJECT_RELATIVE where ObjectType = 'Customer' " +
		 		" and ObjectNo =:ObjectNo) "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		.setParameter("ObjectNo", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
		 
		 //������ĿͶ�ʸ���	
		 sSql = " update PROJECT_BUDGET set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where ProjectNo in (select ProjectNo from PROJECT_RELATIVE where ObjectType = 'Customer' " +
		 		" and ObjectNo =:ObjectNo) "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		.setParameter("ObjectNo", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
     //�����ĵ���Ϣ
	 private void UpdateDocLibrary(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToUserName,String sToOrgID,String sToOrgName,String sUpdateTime,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 SqlObject so; 
		 //�����ĵ�������Ϣ
		 sSql = " update DOC_LIBRARY set "+
		 		" UserID =:UserID, "+
		 		" UserName =:UserName, "+
		 		" OrgID =:OrgIDNew, " +
		 		" OrgName =:OrgName, " +
		 		" UpdateTime =:UpdateTime "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo=:ObjectNo) "+
		 		" and UserID =:UserID "+
		 		" and OrgID =:OrgID ";
		 so = new SqlObject(sSql).setParameter("UserID", sToUserID).setParameter("UserName", sToUserName).setParameter("OrgIDNew", sToOrgID)
		 .setParameter("OrgName", sToOrgName).setParameter("UpdateTime", sUpdateTime).setParameter("ObjectNo", sCustomerID)
		 .setParameter("UserID", sFromUserID).setParameter("OrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
		 
		 sSql = " update DOC_LIBRARY set "+
		 		" InputUser =:InputUserNew, "+	 		
		 		" InputOrg =:InputOrg, " +	 		
		 		" UpdateTime =:UpdateTime "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo=:ObjectNo) "+
		 		" and InputUser =:InputUser "+
		 		" and InputOrg =:InputOrg ";
		 	so = new SqlObject(sSql).setParameter("InputUserNew", sToUserID).setParameter("InputOrg", sToOrgID).setParameter("UpdateTime", sUpdateTime)
		 	.setParameter("ObjectNo", sCustomerID).setParameter("InputUser", sFromUserID).setParameter("InputOrg", sFromOrgID);
			 Sqlca.executeSQL(so);
		 

		 sSql = " update DOC_LIBRARY set "+
		 		" UpdateUser =:UpdateUserNew, "+	 		 				
		 		" UpdateTime =:UpdateTime "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo=:ObjectNo) "+
		 		" and UpdateUser =:UpdateUser ";
		 so = new SqlObject(sSql).setParameter("UpdateUserNew", sToUserID).setParameter("UpdateTime", sUpdateTime)
		 .setParameter("ObjectNo", sCustomerID).setParameter("UpdateUser", sFromUserID);
		 Sqlca.executeSQL(so);
		 
		 //�����ĵ�������Ϣ
		 sSql = " update DOC_ATTACHMENT set "+
		 		" InputUser =:InputUserNew, "+		 		
		 		" InputOrg =:InputOrg, " +		 		
		 		" UpdateTime =:UpdateTime "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo=:ObjectNo) "+
		 		" and InputUser =:InputUser "+
		 		" and InputOrg =:InputOrg ";
		 so = new SqlObject(sSql).setParameter("InputUserNew", sToUserID).setParameter("InputOrg", sToOrgID).setParameter("UpdateTime", sUpdateTime)
		 .setParameter("ObjectNo", sCustomerID).setParameter("InputUser", sFromUserID).setParameter("InputOrg", sFromOrgID);
		 Sqlca.executeSQL(so);

		 sSql = " update DOC_ATTACHMENT set "+
		 		" UpdateUser =:UpdateUserNew, "+	 		 				
		 		" UpdateTime =:UpdateTime "+
		 		" Where DocNo in (select DocNo from DOC_RELATIVE Where ObjectType='Customer' " +
		 		" and ObjectNo=:ObjectNo) "+
		 		" and UpdateUser =:UpdateUser ";
		so = new SqlObject(sSql).setParameter("UpdateUserNew", sToUserID).setParameter("UpdateTime", sUpdateTime).setParameter("ObjectNo", sCustomerID)
		.setParameter("UpdateUser", sFromUserID);
		Sqlca.executeSQL(so);
	 } 
	 
     //���²��񱨱�
	 private void UpdateCustomerFSRecord(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,String sUpdateTime,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 SqlObject so;
		 sSql = " update CUSTOMER_FSRECORD set "+
		 		" UserID =:UserIDNew, "+
		 		" OrgID =:OrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and UserID =:UserID "+
		 		" and OrgID =:OrgID ";
		 so = new SqlObject(sSql).setParameter("UserIDNew", sToUserID).setParameter("OrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("UserID", sFromUserID).setParameter("OrgID", sFromOrgID);
		 Sqlca.executeSQL(so);

		 sSql = " update REPORT_RECORD set "+
		 		" UserID =:UserIDNew, "+
		 		" OrgID =:OrgIDNew, " +
		 		" UpdateTime =:UpdateTime "+
		 		" where ObjectType = 'CustomerFS' " +
		 		" and ObjectNo =:sCustomerID "+
		 		" and UserID =:sFromUserID "+
		 		" and OrgID =:sFromOrgID ";
		 so = new SqlObject(sSql).setParameter("UserIDNew", sToUserID).setParameter("OrgIDNew", sToOrgID).setParameter("UpdateTime", sUpdateTime)
		 .setParameter("sCustomerID", sCustomerID).setParameter("sFromUserID", sFromUserID).setParameter("sFromOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
	 
     //	����Ӧ��Ӧ���ʿ���Ϣ
	 private void UpdateEntFOA(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";

		 sSql = " update ENT_FOA set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
	 //	���´����Ϣ
	 private void UpdateEntInventory(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_INVENTORY set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
	 //	���¹̶��ʲ���Ϣ
	 private void UpdateEntFixedAsserts(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update ENT_FIXEDASSETS set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
     //���������ʲ���Ϣ
	 private void UpdateImaAsserts(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_IMASSET set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
     //���³��й�Ʊ��Ϣ
	 private void UpdateCustomerStock(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_STOCK set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
     //���³���ծȯ��Ϣ
	 private void UpdateCustomerBond(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_BOND set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
     //������˰��Ϣ
	 private void UpdateCustomerTaxPaying(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_TAXPAYING set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
	 //�����������ڻ���ҵ��
	 private void UpdateCustomerOActivity(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_OACTIVITY set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
     //�����ֽ���Ԥ��
	 private void UpdateCashRecord(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CASHFLOW_RECORD set "+
		 		" UserID =:UserIDNew, "+
		 		" OrgID =:OrgIDNew, " +
		 		" where CustomerID =:CustomerID "+
		 		" and UserID =:UserID "+
		 		" and OrgID =:OrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("UserIDNew", sToUserID).setParameter("OrgIDNew", sToOrgID)
		 .setParameter("CustomerID", sCustomerID).setParameter("UserID", sFromUserID).setParameter("OrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
	 //���¿ͻ��������
	 private void UpdateCustomerAnarecord(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 SqlObject so;
		 sSql = " update CUSTOMER_ANARECORD set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		  so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);

		 sSql = " update CUSTOMER_ANARECORD set "+
		 		" UserID =:UserIDNew, "+
		 		" OrgID =:OrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and UserID =:UserID "+
		 		" and OrgID =:OrgID ";
		  so = new SqlObject(sSql).setParameter("UserIDNew", sToUserID).setParameter("OrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("UserID", sFromUserID).setParameter("OrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
     //���¿ͻ����õȼ�����(010)����������޶�ο�(080)
	 private void UpdateEvaluateRecordEnt(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToUserName,String sToOrgID,Transaction Sqlca)
	    throws Exception
	 { 
		 String sSql = "";
		 SqlObject so;
		 sSql = " update EVALUATE_RECORD set "+
		 		" UserID =:UserIDNew, "+
		 		" OrgID =:OrgIDNew " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo =:ObjectNo" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType = '010' or ModelType = '080') "+
		 		" and UserID =:UserID "+
		 		" and OrgID =:OrgID ";
		 so = new SqlObject(sSql).setParameter("UserIDNew", sToUserID).setParameter("OrgIDNew", sToOrgID).setParameter("ObjectNo", sCustomerID)
		 .setParameter("UserID", sFromUserID).setParameter("OrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
		 
		 sSql = " update EVALUATE_RECORD set "+
		 		" CognUserID =:CognUserIDNew, "+
		 		" CognOrgID =:CognOrgIDNew " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo =:ObjectNo" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType = '010' or ModelType = '080') "+
		 		" and CognUserID =:CognUserID "+
		 		" and CognOrgID =:CognOrgID ";
		 so = new SqlObject(sSql).setParameter("CognUserIDNew", sToUserID).setParameter("CognOrgIDNew", sToOrgID).setParameter("ObjectNo", sCustomerID)
		 .setParameter("CognUserID", sFromUserID).setParameter("CognOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);

		 sSql = " update EVALUATE_RECORD set "+
		 		" CognUserID2 =:CognUserID2New, "+
		 		" CognUserName2 =:CognUserName2 " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo =:ObjectNo" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType = '010' or ModelType = '080') "+
		 		" and CognUserID2 =:CognUserID2 ";
		 so = new SqlObject(sSql).setParameter("CognUserID2New", sToUserID).setParameter("CognUserName2", sToUserName).setParameter("ObjectNo", sCustomerID)
		 .setParameter("CognUserID2", sFromUserID);
		 Sqlca.executeSQL(so);
			 
		 sSql = " update EVALUATE_RECORD set "+
		 		" CognUserID3 =:CognUserID3New, "+
		 		" CognUserName3 =:CognUserName3 " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo =:ObjectNo " +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType='010') "+
		 		" and CognUserID3 =:CognUserID3 ";
		 so = new SqlObject(sSql).setParameter("CognUserID3New", sToUserID).setParameter("CognUserName3", sToUserName).setParameter("ObjectNo", sCustomerID)
		 .setParameter("CognUserID3", sFromUserID);
		 Sqlca.executeSQL(so);
		 
		 sSql = " update EVALUATE_RECORD set "+
		 		" CognUserID4 =:CognUserID4New, "+
		 		" CognUserName4 =:CognUserName4 " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo =:ObjectNo" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType='010') "+
		 		" and CognUserID4 =:CognUserID4 ";
		 so = new SqlObject(sSql).setParameter("CognUserID4New", sToUserID).setParameter("CognUserName4", sToUserName).setParameter("ObjectNo", sCustomerID)
		 .setParameter("CognUserID4", sFromUserID);
		 Sqlca.executeSQL(so);
	 } 
	 
	 //���·���Ԥ���ź�����
	 private void UpdateRiskSignal(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 SqlObject so;
		 sSql = " update RISK_SIGNAL set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where ObjectType = 'Customer' " +
		 		" ObjectNo =:ObjectNo "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		 so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("ObjectNo", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
		 
		 sSql = " update RISKSIGNAL_OPINION set "+
		 		" CheckUser =:CheckUserNew, "+
		 		" CheckOrg =:CheckOrgNew " +		 		
		 		" where ObjectNo in (select SerialNo from RISK_SIGNAL where ObjectType = 'Customer' and ObjectNo =:ObjectNo) "+
		 		" and CheckUser =:CheckUser "+
		 		" and CheckOrg =:CheckOrg ";
		 so = new SqlObject(sSql).setParameter("CheckUserNew", sToUserID).setParameter("CheckOrgNew", sToOrgID).setParameter("ObjectNo", sCustomerID)
		 .setParameter("CheckUser", sFromUserID).setParameter("CheckOrg", sFromOrgID);
		 Sqlca.executeSQL(so);
		 
		 sSql = " update RISKSIGNAL_OPINION set "+
		 		" NextCheckUser =:NextCheckUser "+			 		
		 		" where ObjectNo in (select SerialNo from RISK_SIGNAL where ObjectType = 'Customer' and ObjectNo =:ObjectNo) "+
		 		" and NextCheckUser =:NextCheckUser ";
		 so = new SqlObject(sSql).setParameter("NextCheckUser", sToUserID).setParameter("ObjectNo", sCustomerID).setParameter("NextCheckUser", sFromUserID);
		 Sqlca.executeSQL(so);
	 } 
	 	 
	 
	 //******************�������*******************	 
	 //���˸ſ���
	 private void UpdateIndInfo(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 SqlObject so;
		 sSql = " update IND_INFO set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		  so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
		 
		 sSql = " update IND_INFO set "+
		 		" UpdateUserID =:UpdateUserIDNew, "+
		 		" UpdateOrgID =:UpdateOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and UpdateUserID =:UpdateUserID "+
		 		" and UpdateOrgID =:UpdateOrgID ";
		  so = new SqlObject(sSql).setParameter("UpdateUserIDNew", sToUserID).setParameter("UpdateOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("UpdateUserID", sFromUserID).setParameter("UpdateOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 	 
	 //������ż����ͥ��Ա������͹�˾�๫��UpdateCustomerRelative��
	 	 
     //����ѧҵ����
	 private void UpdateIndEducation(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_EDUCATION set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		  SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
     //���˹�������
	 private void UpdateIndResume(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_RESUME set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		  SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
     
	 //	���˴��¼�(ͬ��˾�๫��UpdateCustomerMemo)
	 
	 //�����ṩ�������(ͬ��˾�๫��UpdateDocLibrary)
	 
	 //��ᱣ�ա��Ʋ����ա����ٱ���
	 private void UpdateIndSi(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_SI set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		  SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
	 //�����ʲ����
	 private void UpdateCustomerRealty(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_REALTY set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		  SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
     //�����ʲ����
	 private void UpdateCustomerVehicle(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update CUSTOMER_VEHICLE set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		  SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
	 //���й�Ʊ��Ϣ��ͬ��˾�๫��UpdateCustomerStock��
	 
     //����ծȯ��Ϣ��ͬ��˾�๫��UpdateCustomerBond��
	 
	 //Ͷ����ҵ�����ͬ��˾�๫��UpdateCustomerRelative��
	 
     //��˰��Ϣ��ͬ��˾����UpdateCustomerTaxPaying��
	 
     //�����ʲ���Ϣ��ͬ��˾����UpdateImaAsserts��
	 
     //�����ʲ���Ϣ
	 private void UpdateIndOasset(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_OASSET set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		  SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 }
	 
	 //������ծ��Ϣ
	 private void UpdateIndOdebt(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,String sUpdateDate,Transaction Sqlca)
	    throws Exception
	 {
		 String sSql = "";
		 sSql = " update IND_ODEBT set "+
		 		" InputUserID =:InputUserIDNew, "+
		 		" InputOrgID =:InputOrgIDNew, " +
		 		" UpdateDate =:UpdateDate "+
		 		" where CustomerID =:CustomerID "+
		 		" and InputUserID =:InputUserID "+
		 		" and InputOrgID =:InputOrgID ";
		  SqlObject so = new SqlObject(sSql).setParameter("InputUserIDNew", sToUserID).setParameter("InputOrgIDNew", sToOrgID).setParameter("UpdateDate", sUpdateDate)
		 .setParameter("CustomerID", sCustomerID).setParameter("InputUserID", sFromUserID).setParameter("InputOrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 }
	 
	 
	 //�������õȼ�������Ϣ
	 private void UpdateEvaluateRecordInd(String sCustomerID,String sFromUserID,String sFromOrgID,String sToUserID,String sToOrgID,Transaction Sqlca)
	    throws Exception
	 { 
		 String sSql = "";
		 sSql = " update EVALUATE_RECORD set "+
		 		" UserID =:UserIDNew, "+
		 		" OrgID =:OrgIDNew " +
		 		" where ObjectType='Customer' "+
		 		" and ObjectNo =:ObjectNo" +
		 		" and ModelNo in (select ModelNo from EVALUATE_CATALOG where ModelType = '015') "+
		 		" and UserID =:UserID "+
		 		" and OrgID =:OrgID ";
		 SqlObject so = new SqlObject(sSql).setParameter("UserIDNew", sToUserID).setParameter("OrgIDNew", sToOrgID).setParameter("ObjectNo", sCustomerID)
		 .setParameter("UserID", sFromUserID).setParameter("OrgID", sFromOrgID);
		 Sqlca.executeSQL(so);
	 } 
	 
	 
	 //���������ڻ���ҵ����ͬ��˾����UpdateCustomerOActivity��
	 
	 //�����������(ͬ��˾����UpdateCustomerAnarecord)
	 
	 	 
	 //***********************���ſͻ�***************************	 
	 //���Ÿſ���ͬUpdateCustomerInfo��
	 
	 //���ų�Ա��ͬUpdateCustomerRelative��
	 
}
