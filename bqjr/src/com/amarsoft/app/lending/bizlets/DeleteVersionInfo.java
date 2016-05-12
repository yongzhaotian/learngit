package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ���Ʋ�Ʒ��Ӧ�����İ汾�Ĳ�������
 * @author bhxiao
 * @version 1.0
 * @date 2011-09-27
 */

public class DeleteVersionInfo extends Bizlet {

	@Override
	public Object run(Transaction Sqlca) throws Exception {
		
		//�������
		String sSql = "";
		//��ɾ����Ʒ��id
		String TypeNo = (String)this.getAttribute("TypeNo");
		//��ɾ����Ʒ�İ汾��
		String sVersionID = (String)this.getAttribute("VersionID");
		
		//��ֵת��
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
			//�ύ����
//			Sqlca.conn.commit();
		}catch(SQLException e){
			ARE.getLog().error("ɾ���汾��Ϣʧ�ܣ����ݿ��쳣",e);
//			Sqlca.conn.rollback();
			Sqlca.rollback();
			return "false";
		}finally{
//			Sqlca.conn.setAutoCommit(bAutoCommit);
		}
		return "true";
	}

}
