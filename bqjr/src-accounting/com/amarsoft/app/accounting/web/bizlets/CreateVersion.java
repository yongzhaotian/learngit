package com.amarsoft.app.accounting.web.bizlets;



import java.sql.SQLException;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.app.accounting.product.ProductManage;


/**
 * 启用产品新版本
 * @author bhxiao 
 * @version 1.0
 * @date 2011-09-27
 * 
 */

public class CreateVersion extends Bizlet {

	@Override
	public Object run(Transaction Sqlca) throws Exception {

		//获取产品编号
		String ProductID = (String) this.getAttribute("ProductID");
		//获取版本号
		String versionID = (String) this.getAttribute("newVersionID");
		String userID = (String) this.getAttribute("userID");
		
		//执行事务
	
		try{
			ProductManage biz = new ProductManage(Sqlca);
			biz.setAttribute("ProductID",ProductID);
			biz.setAttribute("VersionID",versionID);
			biz.setAttribute("UserID",userID);
			biz.createProduct();
			
		}catch(SQLException e){
			ARE.getLog().error("执行版本更新失败，数据库异常",e);
			return "false";
		}finally{
			
		}
		return "true";
	}
	
}
