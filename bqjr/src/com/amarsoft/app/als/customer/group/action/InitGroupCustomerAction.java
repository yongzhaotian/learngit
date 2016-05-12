package com.amarsoft.app.als.customer.group.action;

import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

/**
 * �������ſͻ�ʱ��ʼ��GROUP_FAMILY_VERSION GROUP_FAMILY_MEMBER CUSTOMER_BELONG��
 * @author 
 */

public class InitGroupCustomerAction extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		
		/**
		 * ��ȡ����
		 */   
		String sGroupID = (String)this.getAttribute("GroupID");
		String sCustomerType = (String)this.getAttribute("CustomerType");	
		String sUserID = (String)this.getAttribute("UserID");
		
		//����ֵת��Ϊ���ַ���
		if(sGroupID == null) sGroupID = "";
		if(sCustomerType == null) sCustomerType = "";
		if(sUserID == null) sUserID = "";
		
		/**
		 * �������
		 * 
		 */
		String sSql = "";
		ASResultSet rs = null;						//��ѯ�����
		String sGroupName=""; 						//���ſͻ�����
		String sGroupCreditType="";					//��������
		String sKeyMemberCustomerID="";				//������ҵ
		String sGroupType2="";						//�Ƿ����м��й�������
		String sMgtUserID="";						//ҵ������ͻ�����
		String sMgtOrgID="";
		String sInputUserID="";
		String sInputOrgID="";
		String sRefVersionSeq="";
		String sCurrentVersionSeq="";
		String sFamilyMapStatus="";
		String sReturn = "0";

		//ʵ�����û�����
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		
		/**
		 * ��������߼�
		 */
		
		/** ���ݿͻ���ţ�������ӦSQL*/
		sSql = " select GroupID,GroupName,GroupCreditType,KeyMemberCustomerID,GroupType2,MgtUserID,MgtOrgID,InputUserID,InputOrgID,RefVersionSeq,CurrentVersionSeq,FamilyMapStatus,InputDate "+
				" from GROUP_INFO "+
				" where GroupID = :GroupID ";
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GroupID", sGroupID));
		
        /** ��ȡ��ѯ��� */
		if(rs.next()){
			sGroupID = rs.getString("GroupID");
			sGroupName=rs.getString("GroupName");
			sGroupCreditType=rs.getString("GroupCreditType");
			sKeyMemberCustomerID=rs.getString("KeyMemberCustomerID");
			sGroupType2=rs.getString("GroupType2");
			sMgtUserID=rs.getString("MgtUserID");
			sMgtOrgID=rs.getString("MgtOrgID");
			sInputUserID=rs.getString("InputUserID");
			sInputOrgID=rs.getString("InputOrgID");
			sRefVersionSeq=rs.getString("RefVersionSeq");
			sCurrentVersionSeq=rs.getString("CurrentVersionSeq");
			sFamilyMapStatus=rs.getString("FamilyMapStatus");
		}
		rs.getStatement().close();
		rs = null;
		if(sGroupID == null) sGroupID = "";
		if(sGroupName == null) sGroupName = "";
		if(sGroupCreditType == null) sGroupCreditType = "";
		if(sKeyMemberCustomerID == null) sKeyMemberCustomerID = "";
		if(sGroupType2 == null) sGroupType2 = "";
		if(sMgtUserID == null) sMgtUserID = "";
		if(sMgtOrgID == null) sMgtOrgID = "";
		if(sInputUserID == null) sInputUserID = "";
		if(sInputOrgID == null) sInputOrgID = "";
		if(sRefVersionSeq == null) sRefVersionSeq= "";
		if(sCurrentVersionSeq == null) sCurrentVersionSeq= "";
		if(sFamilyMapStatus == null) sFamilyMapStatus= "";
		
		/** ���ݲ�ѯ�������CUSTOMER_INFO */
		Sqlca.executeSQL(new SqlObject("update CUSTOMER_INFO set CustomerName = :CustomerName,BelongGroupID = :BelongGroupID where CustomerID = :CustomerID").
				setParameter("CustomerID", sGroupID).
				setParameter("CustomerName", sGroupName).
				setParameter("BelongGroupID",sGroupID));
		
		/** ���ݲ�ѯ��������¼��CUSTOMER_BELONG */
		String[] belongAttribute = {"2","2","2","1","2"};	//����ҵ������ͻ�����Ȩ��
		insertCustomerBelong(belongAttribute,sMgtUserID,sMgtOrgID,sGroupID,CurUser,Sqlca);
		
		String[] belongAttribute1 = {"1","1","1","1","1"};	//���輯�ż���ά����Ȩ��
		insertCustomerBelong1(belongAttribute1,sInputUserID,sInputOrgID,sGroupID,CurUser,Sqlca);
		
		String[] belongAttribute2 = {"2","1","2","2","2"};	//���輯�ż���ά���ڶԺ�����ҵ����Ϣ�鿴Ȩ��
		insertCustomerBelong2(belongAttribute2,sInputUserID,sInputOrgID,sKeyMemberCustomerID,CurUser,Sqlca);
		
		/** ���ݲ�ѯ��������¼��GROUP_FAMILY_VERSION */
		insertGroupFamilyVersion(sGroupID,sKeyMemberCustomerID,sFamilyMapStatus,CurUser,Sqlca);
		
		/** ���ݲ�ѯ��������¼��GROUP_EVENT */
		insertGroupEvent(sGroupID,sGroupName,CurUser,Sqlca);
		
		return sReturn;
		
	}
			
	/**
	 * ����������CUSTOMER_BELONG
	 * ����ÿͻ���Ȩ������û�У����봫��Ŀͻ������˹����������ڣ����ý�����
	 * @param attribute [����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ]��־,������Ȳ��������������ʹ��Ĭ��ֵ2,��������������ֻȡǰ���
	 * @param sCustomerID ���ſͻ�ID
	 * @param CurUser ����û�
	 * @param Sqlca
	 * @throws Exception
	 */
  	private void insertCustomerBelong(String[] attribute,String sMgtUserID,String sMgtOrgID,String sCustomerID,ASUser CurUser,Transaction Sqlca) throws Exception{
  		//��鵱ǰ�ͻ����û�����������Ϣ
  		boolean bExists = false;
  		String[] belongAttribute = {"2","2","2","2","2"};	//Ĭ�����κ�Ȩ��
  		for(int i=0;i<attribute.length&&i<belongAttribute.length;i++){
  			belongAttribute[i] = attribute[i];
  		}
  		
  		//���ͻ��Ƿ��뵱ǰ�û� ���������ˣ�����ѽ����������ٽ�������������
  		String sSql = " select UserID from CUSTOMER_BELONG "+
		" where CustomerID =:CustomerID and UserID=:UserID";
  		SqlObject so = new SqlObject(sSql);
  		so.setParameter("CustomerID", sCustomerID).setParameter("UserID", CurUser.getUserID());
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			bExists = true;
		}
		rs.getStatement().close();
		rs = null;
  		if(bExists == false){
  		sSql = "insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3," +
  				" BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate)"+
  				" values (:CustomerID,:OrgID,:UserID,:BelongAttribute,:BelongAttribute1,:BelongAttribute2,:BelongAttribute3," +
  				" :BelongAttribute4,:InputOrgID,:InputUserID,:InputDate,:UpdateDate)";
  		so = new SqlObject(sSql);
  		so.setParameter("CustomerID", sCustomerID).setParameter("OrgID", sMgtOrgID).setParameter("UserID", sMgtUserID).setParameter("BelongAttribute", belongAttribute[0])
  		.setParameter("BelongAttribute1", belongAttribute[1]).setParameter("BelongAttribute2", belongAttribute[2]).setParameter("BelongAttribute3", belongAttribute[3])
  		.setParameter("BelongAttribute4", belongAttribute[4]).setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputUserID", CurUser.getUserID())
  		.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
  		Sqlca.executeSQL(so);
  		}
  	}
  	
  	/**
	 * ����������CUSTOMER_BELONG
	 * ����ÿͻ���Ȩ������û�У����봫��Ŀͻ������˹����������ڣ����ý�����
	 * @param attribute [����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ]��־,������Ȳ��������������ʹ��Ĭ��ֵ2,��������������ֻȡǰ���
	 * @param sCustomerID ���ſͻ�ID
	 * @param CurUser ����û�
	 * @param Sqlca
	 * @throws Exception
	 */
  	private void insertCustomerBelong1(String[] attribute,String sInputUserID,String sInputOrgID,String sCustomerID,ASUser CurUser,Transaction Sqlca) throws Exception{
  		//��鵱ǰ�ͻ����û�����������Ϣ
  		boolean bExists = false;
  		String[] belongAttribute = {"2","2","2","2","2"};	//Ĭ�����κ�Ȩ��
  		for(int i=0;i<attribute.length&&i<belongAttribute.length;i++){
  			belongAttribute[i] = attribute[i];
  		}
  		
  		//���ͻ��Ƿ��뵱ǰ�û� ���������ˣ�����ѽ����������ٽ�������������
  		String sSql = " select UserID from CUSTOMER_BELONG "+
		" where CustomerID =:CustomerID and UserID=:UserID";
  		SqlObject so = new SqlObject(sSql);
  		so.setParameter("CustomerID", sCustomerID).setParameter("UserID", CurUser.getUserID());
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			bExists = true;
		}
		rs.getStatement().close();
		rs = null;
  		if(bExists == false){
  		sSql = "insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3," +
  				" BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate)"+
  				" values (:CustomerID,:OrgID,:UserID,:BelongAttribute,:BelongAttribute1,:BelongAttribute2,:BelongAttribute3," +
  				" :BelongAttribute4,:InputOrgID,:InputUserID,:InputDate,:UpdateDate)";
  		so = new SqlObject(sSql);
  		so.setParameter("CustomerID", sCustomerID).setParameter("OrgID", sInputOrgID).setParameter("UserID", sInputUserID).setParameter("BelongAttribute", belongAttribute[0])
  		.setParameter("BelongAttribute1", belongAttribute[1]).setParameter("BelongAttribute2", belongAttribute[2]).setParameter("BelongAttribute3", belongAttribute[3])
  		.setParameter("BelongAttribute4", belongAttribute[4]).setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputUserID", CurUser.getUserID())
  		.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
  		Sqlca.executeSQL(so);
  		}
  	}
  	
  	/**
	 * ����������CUSTOMER_BELONG
	 * ����ÿͻ���Ȩ������û�У����봫��Ŀͻ������˹����������ڣ����ý�����
	 * @param attribute [����Ȩ����Ϣ�鿴Ȩ����Ϣά��Ȩ��ҵ�����Ȩ]��־,������Ȳ��������������ʹ��Ĭ��ֵ2,��������������ֻȡǰ���
	 * @param sCustomerID ���ſͻ�ID
	 * @param CurUser ����û�
	 * @param Sqlca
	 * @throws Exception
	 */
  	private void insertCustomerBelong2(String[] attribute,String sInputUserID,String sInputOrgID,String sKeyMemberCustomerID,ASUser CurUser,Transaction Sqlca) throws Exception{
  		//��鵱ǰ�ͻ����û�����������Ϣ
  		boolean bExists = false;
  		String[] belongAttribute = {"2","2","2","2","2"};	//Ĭ�����κ�Ȩ��
  		for(int i=0;i<attribute.length&&i<belongAttribute.length;i++){
  			belongAttribute[i] = attribute[i];
  		}
  		
  		//���ͻ��Ƿ��뵱ǰ�û� ���������ˣ�����ѽ����������ٽ�������������
  		String sSql = " select UserID from CUSTOMER_BELONG "+
		" where CustomerID =:CustomerID and UserID=:UserID";
  		SqlObject so = new SqlObject(sSql);
  		so.setParameter("CustomerID", sKeyMemberCustomerID).setParameter("UserID", CurUser.getUserID());
		ASResultSet rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			bExists = true;
		}
		rs.getStatement().close();
		rs = null;
  		if(bExists == false){
  		sSql = "insert into CUSTOMER_BELONG(CustomerID,OrgID,UserID,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3," +
  				" BelongAttribute4,InputOrgID,InputUserID,InputDate,UpdateDate)"+
  				" values (:CustomerID,:OrgID,:UserID,:BelongAttribute,:BelongAttribute1,:BelongAttribute2,:BelongAttribute3," +
  				" :BelongAttribute4,:InputOrgID,:InputUserID,:InputDate,:UpdateDate)";
  		so = new SqlObject(sSql);
  		so.setParameter("CustomerID", sKeyMemberCustomerID).setParameter("OrgID", sInputOrgID).setParameter("UserID", sInputUserID).setParameter("BelongAttribute", belongAttribute[0])
  		.setParameter("BelongAttribute1", belongAttribute[1]).setParameter("BelongAttribute2", belongAttribute[2]).setParameter("BelongAttribute3", belongAttribute[3])
  		.setParameter("BelongAttribute4", belongAttribute[4]).setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputUserID", CurUser.getUserID())
  		.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
  		Sqlca.executeSQL(so);
  		}
  	}
  	
  	/**
		 * ����������GROUP_FAMILY_VERSION
		 * @param 
		 * @throws Exception 
		 */
  	private void insertGroupFamilyVersion(String sCustomerID,String sKeyMemberCustomerID,String sFamilyMapStatus,ASUser CurUser,Transaction Sqlca)throws Exception{
		    String sVersionNo="S"+DBKeyHelp.getSerialNo("GROUP_FAMILY_VERSION","VersionSeq",Sqlca);
  		    StringBuffer sbSql = new StringBuffer();
  			SqlObject so ;
  			sbSql.append(" insert into GROUP_FAMILY_VERSION(") 	
  				.append(" GroupID,")					
  				.append(" VersionSeq,")				
  				.append(" InfoSource, ")		        
  				.append(" EffectiveStatus, ")	
  				.append(" InputOrgID, ")	
  				.append(" InputUserID, ")	
  				.append(" InputDate, ")	
  				.append(" ApproveUserID ")	
  				.append(" )values(:GroupID, :VersionSeq, :InfoSource, :EffectiveStatus, :InputOrgID, :InputUserID, :InputDate, :ApproveUserID )");
  			so = new SqlObject(sbSql.toString());
  			so.setParameter("GroupID", sCustomerID).setParameter("VersionSeq", sVersionNo).setParameter("InfoSource", "S").setParameter("EffectiveStatus", sFamilyMapStatus);
  			so.setParameter("InputOrgID", CurUser.getOrgID()).setParameter("InputUserID", CurUser.getUserID()).setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("ApproveUserID", "");
  			Sqlca.executeSQL(so);	
		
  			/** ���¼��װ汾����GROUP_INFO */
  			Sqlca.executeSQL(new SqlObject("update GROUP_INFO set RefVersionSeq = :RefVersionSeq,CurrentVersionSeq = :CurrentVersionSeq,UpdateDate = :UpdateDate where GroupID = :GroupID ").
  					setParameter("GroupID", sCustomerID).
  					setParameter("RefVersionSeq", sVersionNo).
  					setParameter("CurrentVersionSeq", sVersionNo).
  					setParameter("UpdateDate",DateX.format(new java.util.Date(), "yyyy/MM/dd")));
  			
  			/** ���ݲ�ѯ��������¼��GROUP_FAMILY_MEMBER */
  			insertGroupFamilyMember(sCustomerID,sKeyMemberCustomerID,sVersionNo,CurUser,Sqlca);
  	  	}	
 		
  	/**
	 * ����������GROUP_FAMILY_MEMBER
	 * @param 
	 * @throws Exception 
	 */
	private void insertGroupFamilyMember(String sCustomerID,String sKeyMemberCustomerID,String sRefVersionSeq,ASUser CurUser,Transaction Sqlca)throws Exception{
		//�������
		String sSql="";
		String sMemberName="";
		String sMemberCustomerID="";
		String sMemberType="";
		String sMemberCertType="";
		String sMemberCertID="";
			
		/** ���ݿͻ���ţ�������ӦSQL��ѯ������ҵ��Ϣ*/
		sSql = " select CustomerID,CustomerName,CustomerType,CertType,CertID "+
				" from CUSTOMER_INFO "+
				" where CustomerID = :CustomerID ";
		ASResultSet rs =null; 
        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID", sKeyMemberCustomerID));
		
        /** ��ȡ��ѯ��� */
		if(rs.next()){
			sMemberName = rs.getString("CustomerName");
			sMemberCustomerID = rs.getString("CustomerID");
			sMemberType=rs.getString("CustomerType");
			sMemberCertType=rs.getString("CertType");
			sMemberCertID=rs.getString("CertID");

		}
		rs.getStatement().close();
		rs = null;
		if(sMemberName == null) sMemberName = "";
		if(sMemberCustomerID == null) sMemberCustomerID = "";
		if(sMemberType == null) sMemberType = "";
		if(sMemberCertType == null) sMemberCertType = "";
		if(sMemberCertID == null) sMemberCertID = "";
		
		/**�����¼��GROUP_FAMILY_MEMBER*/
		String sMemberID=DBKeyHelp.getSerialNo("GROUP_FAMILY_MEMBER","MemberID",Sqlca);		
		StringBuffer sbSql = new StringBuffer();
			SqlObject so1 ;
			sbSql.append(" insert into GROUP_FAMILY_MEMBER(") 
				.append(" MemberID,")	
				.append(" GroupID,")					
				.append(" VersionSeq,")				
				.append(" MemberName, ")		         
				.append(" MemberCustomerID, ")	
				.append(" MemberType, ")	
				.append(" MemberCertType, ")	
				.append(" MemberCertID, ")	
				.append(" MemberCorpID,")					
				.append(" ParentMemberID,")						         
				.append(" ReviseFlag, ")	
				.append(" InfoSource, ")	
				.append(" InputOrgID, ")	
				.append(" InputUserID, ")	
				.append(" InputDate, ")	
				.append(" UpdateDate ")	
				.append(" )values(:MemberID, :GroupID, :VersionSeq, :MemberName, :MemberCustomerID, :MemberType, " +
						         ":MemberCertType,:MemberCertID, :MemberCorpID, :ParentMemberID, :ReviseFlag,:InfoSource, " +
								 ":InputOrgID, :InputUserID, :InputDate, :UpdateDate )");
			so1 = new SqlObject(sbSql.toString());
			so1.setParameter("MemberID", sMemberID).setParameter("GroupID", sCustomerID).setParameter("VersionSeq", sRefVersionSeq);
			so1.setParameter("MemberName", sMemberName).setParameter("MemberCustomerID", sMemberCustomerID);
			so1.setParameter("MemberType", "01").setParameter("MemberCertType", sMemberCertType).setParameter("MemberCertID", sMemberCertID).setParameter("MemberCorpID", "");
			so1.setParameter("ParentMemberID", "None").setParameter("ReviseFlag", "NEW").setParameter("InfoSource", "").setParameter("InputOrgID", CurUser.getOrgID());
			so1.setParameter("InputUserID", CurUser.getUserID()).setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			Sqlca.executeSQL(so1);
  		
  	}
	
  	/**
	 * ����������GROUP_EVENT
	 * @param 
	 * @throws Exception 
	 */
	private void insertGroupEvent(String sGroupID,String sGroupName,ASUser CurUser,Transaction Sqlca)throws Exception{
		    String sEventID=DBKeyHelp.getSerialNo("GROUP_EVENT","EventID",Sqlca);
			StringBuffer sbSql = new StringBuffer();
			SqlObject so ;								
			sbSql.append(" insert into GROUP_EVENT(") 	
				.append(" EventID,")					
				.append(" GroupID,")				
				.append(" EventType, ")		         
				.append(" OccurDate, ")	
				.append(" RefMemberID, ")	
				.append(" EventValue, ")	
				.append(" InputOrgID, ")	
				.append(" InputUserID, ")	
				.append(" InputDate, ")	
				.append(" UpdateDate, ")
				.append(" OldEventValue, ")	
				.append(" RefMemberName, ")	
				.append(" ChangeContext ")	
				.append(" )values(:EventID, :GroupID, :EventType, :OccurDate, :RefMemberID, :EventValue, :InputOrgID, :InputUserID, :InputDate," +
						" :UpdateDate, :OldEventValue, :RefMemberName, :ChangeContext )");
			so = new SqlObject(sbSql.toString());
			so.setParameter("EventID", sEventID).setParameter("GroupID", sGroupID).setParameter("EventType", "01").setParameter("OccurDate",  DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("RefMemberID", "").setParameter("EventValue", "").setParameter("InputOrgID",CurUser.getOrgID() ).setParameter("InputUserID", CurUser.getUserID());
			so.setParameter("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")).setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			so.setParameter("OldEventValue", "").setParameter("RefMemberName", "").setParameter("ChangeContext", "����"+sGroupName+"����");
			Sqlca.executeSQL(so);	
  	}
}
