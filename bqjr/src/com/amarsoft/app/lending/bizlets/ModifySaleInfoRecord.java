package com.amarsoft.app.lending.bizlets;

import java.sql.PreparedStatement;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * CCS-594 PRM-262 ���۵�½ʱ��Լ����ֻ�����
 * @author rqiao 20150326
 *
 */

public class ModifySaleInfoRecord extends Bizlet {
	
	public Object run(Transaction Sqlca) throws Exception {
		//���۴�����
		String sUserID = (String)this.getAttribute("UserID");
		//�����ֻ�����
		String sResetMobileTel = (String)this.getAttribute("ResetMobileTel");
		
		//����ֵת��Ϊ���ַ���
		if(sUserID == null) sUserID = "";
		if(sResetMobileTel == null) sResetMobileTel = "";
		
		ASResultSet rs = null;
		String sUserName = "",sMobileTel = "",sLastResetMobileTel = "";//���۴������ơ����۴����ֻ����롢���۴����ϴ������ֻ�����
		String sSql = "select UserName,MobileTel,ResetMobileTel from User_Info where UserID = :UserID";//��ѯ���۴���ԭ�ֻ�������Ϣ
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("UserID", sUserID));
		if(rs.next())
		{
			sUserName = rs.getString(1);
			if(null == sUserName) sUserName = "";
			sMobileTel = rs.getString(2);
			if(null == sMobileTel) sMobileTel = "";
			sLastResetMobileTel = rs.getString(3);
			if(null == sLastResetMobileTel) sLastResetMobileTel = "";
		}
		rs.getStatement().close();
		
		if((sMobileTel.equals(sResetMobileTel)&&!sLastResetMobileTel.equals(sResetMobileTel)&&!"".equals(sLastResetMobileTel))||(!sMobileTel.equals(sResetMobileTel)&&!sLastResetMobileTel.equals(sResetMobileTel)))
		{
			//��¼����ÿһ�ε��ֻ����������Ϣ
			String InsertSql = "insert into Modify_SaleInfo_Record(UserID,UserName,SysMobileTel,LastResetMobileTel,ResetMobileTel,InputUserID,InputTime)values(?,?,?,?,?,?,?)";
			//�����۴����޸ĵ����º�����µ��û���Ϣ�е����۴������ú��ֻ������ֶ���
			String UpdateSql = "Update User_Info set ResetMobileTel = ? where UserID = ? ";
			PreparedStatement ps = null;
			PreparedStatement ps_update = null;
			try {
				ps = Sqlca.getConnection().prepareStatement(InsertSql);
				ps.setString(1, sUserID);
				ps.setString(2, sUserName);
				ps.setString(3, sMobileTel);
				ps.setString(4, sLastResetMobileTel);
				ps.setString(5, sResetMobileTel);
				ps.setString(6, sUserID);
				ps.setString(7, StringFunction.getTodayNow());
	
				ps_update = Sqlca.getConnection().prepareStatement(UpdateSql);
				ps_update.setString(1, sResetMobileTel);
				ps_update.setString(2, sUserID);
	
				ps.executeUpdate();
				ps_update.executeUpdate();
	
				ps.close();
				ps_update.close();
			} catch (Exception e) {
				if (ps != null)
					ps.close();
				if (ps_update != null)
					ps_update.close();
				e.printStackTrace();
				return "false";
			}
		}
		return "Success";
	}

}
