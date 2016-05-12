package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 复制产品对应关联的版本的参数数据
 * @author bhxiao
 * @version 1.0
 * @date 2011-09-27
 */

public class DeleteVersionInfo extends Bizlet {

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		
		//定义变量
		String sSql = "";
		//待删除产品的id
		String TypeNo = (String)this.getAttribute("TypeNo");
		//待删除产品的版本号
		String sVersionID = (String)this.getAttribute("VersionID");
		
		//空值转换
		if(TypeNo==null) TypeNo="";
		if(sVersionID==null) sVersionID="";
		
//		boolean bAutoCommit = Sqlca.conn.getAutoCommit();
		try{
//			Sqlca.conn.setAutoCommit(false);
			
			sSql = "delete from PRODUCT_TERM_PARA where ObjectType='Product' and ObjectNo =  '"+TypeNo+"-"+sVersionID+"' ";
			Sqlca.executeSQL(sSql);
			
			sSql = "delete from PRODUCT_TERM_LIBRARY where ObjectType='Product' and ObjectNo =  '"+TypeNo+"-"+sVersionID+"' ";
			Sqlca.executeSQL(sSql);
			
			sSql = "delete from PRODUCT_TERM_RELATIVE where ObjectType='Product' and ObjectNo =  '"+TypeNo+"-"+sVersionID+"' ";
			Sqlca.executeSQL(sSql);
			
			sSql = "delete from PRODUCT_VERSION where ProductID='"+TypeNo+"' and VersionID = '"+sVersionID+"' ";
			Sqlca.executeSQL(sSql);
			
			Sqlca.commit();
			//提交事务
//			Sqlca.conn.commit();
		}catch(SQLException e){
			ARE.getLog().error("删除版本信息失败，数据库异常",e);
//			Sqlca.conn.rollback();
			Sqlca.rollback();
			return "false";
		}finally{
//			Sqlca.conn.setAutoCommit(bAutoCommit);
		}
		return "true";
	}

}
