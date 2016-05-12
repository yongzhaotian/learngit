package com.amarsoft.app.lending.bizlets;



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

public class NewCopyVersion extends Bizlet {

	@Override
	public Object run(Transaction Sqlca) throws Exception {

		//��ȡ��Ʒ���
		String ProductID = (String) this.getAttribute("ProductID");
		//��ȡ�汾��
		String versionID = (String) this.getAttribute("versionID");
		String newVersionID = (String) this.getAttribute("newVersionID");
		String userID = (String) this.getAttribute("userID");
		
		//ִ������
	
		try{
			ProductManage biz = new ProductManage(Sqlca);
			biz.setAttribute("ProductID",ProductID);
			biz.setAttribute("NewProductID",ProductID);
			biz.setAttribute("VersionID",versionID);
			biz.setAttribute("NewVersionID",newVersionID);
			biz.setAttribute("UserID",userID);
			biz.copyProduct();
			
		}catch(SQLException e){
			ARE.getLog().error("ִ�а汾����ʧ�ܣ����ݿ��쳣",e);
			return "false";
		}finally{
			
		}
		return "true";
	}
	
}
