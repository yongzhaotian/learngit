package com.amarsoft.app.lending.bizlets;

import java.sql.PreparedStatement;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * CCS-594 PRM-262 销售登陆时填报自己的手机号码
 * @author rqiao 20150326
 *
 */

public class ModifySaleInfoRecord extends Bizlet {
	
	public Object run(Transaction Sqlca) throws Exception {
		//销售代表编号
		String sUserID = (String)this.getAttribute("UserID");
		//重置手机号码
		String sResetMobileTel = (String)this.getAttribute("ResetMobileTel");
		
		//将空值转化为空字符串
		if(sUserID == null) sUserID = "";
		if(sResetMobileTel == null) sResetMobileTel = "";
		
		ASResultSet rs = null;
		String sUserName = "",sMobileTel = "",sLastResetMobileTel = "";//销售代表名称、销售代表手机号码、销售代表上次重置手机号码
		String sSql = "select UserName,MobileTel,ResetMobileTel from User_Info where UserID = :UserID";//查询销售代表原手机号码信息
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
			//记录销售每一次的手机号码更改信息
			String InsertSql = "insert into Modify_SaleInfo_Record(UserID,UserName,SysMobileTel,LastResetMobileTel,ResetMobileTel,InputUserID,InputTime)values(?,?,?,?,?,?,?)";
			//将销售代表修改的最新号码更新到用户信息中的销售代表重置后手机号码字段中
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
