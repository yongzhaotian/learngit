/*
		Author: --zywei 2006-08-18
		Tester:
		Describe: ���µ���Ѻ��״̬�����������/����ۼ�
		Input Param:
			GuarantyID������Ѻ����
			GuarantyStatus������Ѻ��״̬
			UserID���Ǽ��˱��	
		Output Param:

		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.web.bizlets.RunTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;


public class InsertGuarantyAudit extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	 {
		//�Զ���ô���Ĳ���ֵ
		String sGuarantyID = (String)this.getAttribute("GuarantyID");
		if(sGuarantyID == null) sGuarantyID = "";
		String sGuarantyStatus = (String)this.getAttribute("GuarantyStatus");
		if(sGuarantyStatus == null) sGuarantyStatus = "";		
		String sInputUser   = (String)this.getAttribute("InputUser");
		if(sInputUser == null) sInputUser = "";
				
		//�������
		String sSql = "",sUpdateSql = "",sInsertSql = "",sGuarantyName = "";
		String sCurDate = "",sInputOrg = "",sSerialNo = "",sGuarantyType = "";
		ASResultSet rs = null;
		SqlObject so = null;
		
		//��ȡ����Ѻ����Ϣ
		sSql = 	" select GuarantyName,GuarantyType from GUARANTY_INFO "+
		" where GuarantyID=:GuarantyID ";
		so = new SqlObject(sSql).setParameter("GuarantyID", sGuarantyID);
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{
			sGuarantyName = rs.getString("GuarantyName");
			sGuarantyType = rs.getString("GuarantyType");
			//����ֵת��Ϊ���ַ���
			if(sGuarantyName == null) sGuarantyName = "";
			if(sGuarantyType == null) sGuarantyType = "";
		}
		rs.getStatement().close();
		
		//��ȡ��ˮ��
		sSerialNo = DBKeyHelp.getSerialNo("GUARANTY_AUDIT","SerialNo",Sqlca);
		//��ȡϵͳ����
		sCurDate = StringFunction.getToday();
		//��ȡ�û����ڻ���
		ASUser CurUser = ASUser.getUser(sInputUser,Sqlca);
		sInputOrg = CurUser.getOrgID();
		
		//���µ���Ѻ��״̬
		sUpdateSql = " update GUARANTY_INFO set GuarantyStatus=:GuarantyStatus "+
		 " where GuarantyID =:GuarantyID ";
		so = new SqlObject(sUpdateSql).setParameter("GuarantyStatus", sGuarantyStatus).setParameter("GuarantyID", sGuarantyID);
		Sqlca.executeSQL(so);
		//�������/����ۼ���Ϣ
		if(sGuarantyStatus.equals("02")){ //���
			sInsertSql = " insert into GUARANTY_AUDIT(SerialNo,GuarantyID,GuarantyName,GuarantyType, "+
		 	 " GuarantyStatus,HoldDate,InputOrg,InputUser,InputDate,UpdateDate) "+
		 	 " values(:SerialNo,:GuarantyID,:GuarantyName,:GuarantyType, "+
		 	 " :GuarantyStatus,:HoldDate,:InputOrg,:InputUser,:InputDate, "+
		 	 " :UpdateDate) ";
		  	so = new SqlObject(sInsertSql);
		  	so.setParameter("SerialNo", sSerialNo).setParameter("GuarantyID", sGuarantyID).setParameter("GuarantyName", sGuarantyName)
		  	.setParameter("GuarantyType", sGuarantyType).setParameter("GuarantyStatus", sGuarantyStatus).setParameter("HoldDate", sCurDate)
		  	.setParameter("InputOrg", sInputOrg).setParameter("InputUser", sInputUser).setParameter("InputDate", sCurDate).setParameter("UpdateDate", sCurDate);
			Sqlca.executeSQL(so);
		}
		if(sGuarantyStatus.equals("04")){ //����
			sInsertSql = " insert into GUARANTY_AUDIT(SerialNo,GuarantyID,GuarantyName,GuarantyType, "+
		 	 " GuarantyStatus,LostDate,InputOrg,InputUser,InputDate,UpdateDate) "+
		 	 " values(:SerialNo,:GuarantyID,:GuarantyName,:GuarantyType, "+
		 	 " :GuarantyStatus,:LostDate,:InputOrg,:InputUser,:InputDate, "+
		 	 " :UpdateDate) ";
			so = new SqlObject(sInsertSql);
			so.setParameter("SerialNo", sSerialNo).setParameter("GuarantyID", sGuarantyID).setParameter("GuarantyName", sGuarantyName)
			.setParameter("GuarantyType", sGuarantyType).setParameter("GuarantyStatus", sGuarantyStatus).setParameter("LostDate", sCurDate)
			.setParameter("InputOrg", sInputOrg).setParameter("InputUser", sInputUser).setParameter("InputDate", sCurDate).setParameter("UpdateDate", sCurDate);
			Sqlca.executeSQL(so);
		}
			
		Bizlet bizlet = new RunTransaction();
		bizlet.setAttribute("ObjectType", BUSINESSOBJECT_CONSTATNTS.guaranty_info);
		bizlet.setAttribute("ObjectNo", sGuarantyID);
		bizlet.setAttribute("RelativeObjectType", BUSINESSOBJECT_CONSTATNTS.guaranty_info);
		bizlet.setAttribute("RelativeObjectNo", sGuarantyID);
		
		bizlet.setAttribute("UserID",CurUser.getUserID());
		
		if(sGuarantyStatus.equals("02")){
			bizlet.setAttribute("TransactionCode", "7010");
			bizlet.run(Sqlca);
		}
		else if(sGuarantyStatus.equals("04")){
			bizlet.setAttribute("TransactionCode", "7020");
			bizlet.run(Sqlca);
		}
		
		return "1";
	 }

}
