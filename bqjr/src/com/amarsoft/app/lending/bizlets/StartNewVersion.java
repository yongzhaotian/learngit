package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 * 版本更新
 * @author jliu 2013-3-20
 *
 */
public class StartNewVersion extends Bizlet{
	
	@Override
	public Object run(Transaction Sqlca) throws Exception {
		String productID = DataConvert.toString((String) this.getAttribute("productID"));
		String versionID = DataConvert.toString((String) this.getAttribute("versionID"));
		String status = DataConvert.toString((String) this.getAttribute("status"));
		String formate = "yyyy/MM/dd";
		SimpleDateFormat sdf = new SimpleDateFormat(formate);
		Date now = new Date();
		String nowStr = sdf.format(now);
		//String nowStr = StringFunction.getToday();
		if("1".equals(status)){
			try{
				String sql = "update product_version set status='"+status+
						"',IsNew='"+status+ "',Effdate='"+nowStr+"',InvalidationDate='"+""+"'where ProductID='"+productID +"'and versionID='"+versionID+"'";
				Sqlca.executeSQL(sql);	
				Sqlca.commit();
			}catch(SQLException e){
				ARE.getLog().error("删除版本信息失败，数据库异常",e);
				Sqlca.rollback();
				return "false";
			}
			return "true";
		}else if("2".equals(status)){
			try{
				String sql = "update product_version set status='"+status+
						"',isNew='"+status+ "',InvalidationDate='"+nowStr+"'where ProductID='"+productID +"'and versionID='"+versionID+"'";
				Sqlca.executeSQL(sql);	
				Sqlca.commit();
			}catch(SQLException e){
				ARE.getLog().error("删除版本信息失败，数据库异常",e);
				Sqlca.rollback();
				return "false";
			}
			return "true";
		}
		return "true";
	}
}









