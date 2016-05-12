package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteTransformRelative extends Bizlet{


	public Object run(Transaction Sqlca) throws Exception {
		
		String sSerialNo = (String)this.getAttribute("SerialNo");//��������
		String sObjectNo = (String)this.getAttribute("ObjectNo");//��ͬ��
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sContractNo = (String)this.getAttribute("ContractNo");//������ͬ��
		
		if(sContractNo == null) sContractNo = "";
		if(sSerialNo == null) sSerialNo = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		
		//�������
		String sql = "";
		SqlObject so ;//��������
		//����Ʒ���ܻ��ж������������������
		so = new SqlObject("select GuarantyID from GUARANTY_RELATIVE  where ObjectType = 'BusinessContract' and ContractNo =:ContractNo").setParameter("ContractNo", sContractNo);
		String[] sGuarantyID = Sqlca.getStringArray(so);
		//ɾ��������ͬ�͵���Ʒ�Ĺ�����ϵ
		for(int i=0;i<sGuarantyID.length;i++){
			if(sGuarantyID.length==0){
				break;
			}else{
				sql = " delete from Guaranty_Relative where ContractNo =:ContractNo  and ObjectType = 'BusinessContract' and ObjectNo=:ObjectNo" +
				"  and GuarantyID in ('"+sGuarantyID[i]+"' )";
				so = new SqlObject(sql).setParameter("ContractNo", sContractNo).setParameter("ObjectNo", sObjectNo);
				Sqlca.executeSQL(so);
			}
		}
		
		//ɾ��������ͬ��Transform_Relative��Ĺ�ϵ
		sql = "delete from TRANSFORM_RELATIVE where SerialNo =:SerialNo and ObjectNo=:ObjectNo and ObjectType=:ObjectType ";
		so = new SqlObject(sql).setParameter("SerialNo", sSerialNo).setParameter("ObjectNo", sContractNo).setParameter("ObjectType",sObjectType);
		Sqlca.executeSQL(so);
		return "success";
	}

}
