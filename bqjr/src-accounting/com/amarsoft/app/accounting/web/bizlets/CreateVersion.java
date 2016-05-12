package com.amarsoft.app.accounting.web.bizlets;



import java.sql.SQLException;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.app.accounting.product.ProductManage;


/**
 * ���ò�Ʒ�°汾
 * @author bhxiao 
 * @version 1.0
 * @date 2011-09-27
 * 
 */

public class CreateVersion extends Bizlet {

	@Override
	public Object run(Transaction Sqlca) throws Exception {

		//��ȡ��Ʒ���
		String ProductID = (String) this.getAttribute("ProductID");
		//��ȡ�汾��
		String versionID = (String) this.getAttribute("newVersionID");
		String userID = (String) this.getAttribute("userID");
		
		//ִ������
	
		try{
			ProductManage biz = new ProductManage(Sqlca);
			biz.setAttribute("ProductID",ProductID);
			biz.setAttribute("VersionID",versionID);
			biz.setAttribute("UserID",userID);
			biz.createProduct();
			
		}catch(SQLException e){
			ARE.getLog().error("ִ�а汾����ʧ�ܣ����ݿ��쳣",e);
			return "false";
		}finally{
			
		}
		return "true";
	}
	
}
