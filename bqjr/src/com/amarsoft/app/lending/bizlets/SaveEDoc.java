package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ������Ӻ�ͬ��������ҵ��Ʒ��
 * @author ljzhong
 *
 */

public class SaveEDoc extends Bizlet {

	/**
	 * ���з�������
	 */
	public Object run(Transaction Sqlca) throws Exception {
		//�Զ���ô���Ĳ���ֵ
		String sTypeNo = (String)this.getAttribute("TypeNo");
		String sEDocNo = (String)this.getAttribute("EDocNo");
		
		//�������������ֵ��SQLִ�����
		String sReturn = "true";
		String sTypeName = "";
		String sSql = null;
		SqlObject so ;//��������
		ASResultSet rs = null;
		
		//�������ҵ��Ʒ�ֱ�Ž�������Ϊ����
		String sTypeNos[] = sTypeNo.split("@");
		
		//ɾ��ԭ���Ӻ�ͬ��ҵ��Ʒ�ֹ�ϵ
		sSql = "Delete From EDOC_RELATIVE Where EDocNo =:EDocNo ";
		so = new SqlObject(sSql).setParameter("EDocNo", sEDocNo);
		Sqlca.executeSQL(so);
		
		//�����µĵ��Ӻ�ͬ��ҵ��Ʒ�ֹ�ϵ
		for(int i = 0; i < sTypeNos.length; i ++){
			//�ж�ҵ��Ʒ���Ƿ�Ϊ��
			if(!"".equals(sTypeNos[i])){
				//��ȡҵ��Ʒ������
				sSql = " Select TypeName from BUSINESS_TYPE where TypeNo = :TypeNo";
				so = new SqlObject(sSql).setParameter("TypeNo", sTypeNos[i]);
				rs = Sqlca.getASResultSet(so);
				while(rs.next()){
					sTypeName = rs.getString(1);
				}
				rs.getStatement().close();
				//ִ�в���
				sSql = " Insert Into EDOC_RELATIVE(TypeNo,TypeName,EDocNo) Values(:TypeNo,:TypeName,:EDocNo) ";
				so = new SqlObject(sSql).setParameter("TypeNo", sTypeNos[i]).setParameter("TypeName", sTypeName).setParameter("EDocNo", sEDocNo);
				Sqlca.executeSQL(so);
			}
			
		}
		
		return sReturn;
	}
	
	

}
