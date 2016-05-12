package com.amarsoft.app.lending.bizlets;
/*
		Author: --zywei 2005-12-10
		Tester:
		Describe: --ɾ��������ͬ;
		Input Param:
				ObjectType: --��������(ҵ��׶�)��
				ObjectNo: --�����ţ�����/����/��ͬ��ˮ�ţ���
				SerialNo:--������ͬ��
		Output Param:
				return������ֵ��SUCCEEDED --ɾ���ɹ���

		HistoryLog:
 */
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteGuarantyContract extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sSerialNo = (String)this.getAttribute("SerialNo");
		
		SqlObject so ;//��������
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSerialNo == null) sSerialNo = "";
				
		//���ݶ������ͻ�ù�������
		String sRelativeTableName = "";
		String sSql = " select RelativeTable from OBJECTTYPE_CATALOG "+
        " where ObjectType =:ObjectType ";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType);
        ASResultSet rs = Sqlca.getASResultSet(so);
        
		if(rs.next())
			sRelativeTableName = DataConvert.toString(rs.getString("RelativeTable"));
		rs.getStatement().close();
		
		//�õ�����ͬ�Ƿ��ѱ�����ҵ��ʹ�ù�
		int iCount = 0;
		sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT "+
		" where SerialNo =:SerialNo "+
		" and ContractType = '020' "+
		" and (ContractStatus = '020' "+
		" or ContractStatus = '030')";
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
        rs = Sqlca.getASResultSet(so);
        
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		if(iCount <= 0)//����߶����ͬ
		{
			//ɾ���뵣����ͬ�й���δ���ĵ���Ѻ��
			sSql =  " delete from GUARANTY_INFO "+
			" where GuarantyID in "+
			" (select GuarantyID from GUARANTY_RELATIVE "+
			" where ObjectType =:ObjectType "+
			" and ObjectNo=:ObjectNo "+
			" and ContractNo =:ContractNo "+
			" and Channel = 'New') "+
			" and GuarantyStatus = '01' ";
			so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", sSerialNo);
	        Sqlca.executeSQL(so);
						
			//ɾ��������ͬ
	        sSql =  " delete from GUARANTY_CONTRACT "+
			" where SerialNo =:SerialNo ";
	        so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
	        Sqlca.executeSQL(so);
		}
		
		//ɾ��������ͬ�����Ѻ��Ĺ�����ϵ
		sSql =  " delete from GUARANTY_RELATIVE "+
		" where ObjectType =:ObjectType "+
		" and ObjectNo =:ObjectNo "+
		" and ContractNo =:ContractNo ";
		so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("ContractNo", sSerialNo);
        Sqlca.executeSQL(so);
		
		//�����ҵ���뵣����ͬ����Ĺ�����ϵ
        sSql = "delete from Transform_relative where SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType ='GuarantyContract'";
        so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo).setParameter("ObjectNo", sSerialNo);
		Sqlca.executeSQL(so);
		
		//ɾ��ҵ���뵣����ͬ�Ĺ�����ϵ
		sSql =  " delete from "+sRelativeTableName+" "+
		" where SerialNo =:SerialNo "+
		" and ObjectType = 'GuarantyContract' "+
		" and ObjectNo=:ObjectNo ";
		 so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo).setParameter("ObjectNo", sSerialNo);
        Sqlca.executeSQL(so);
	
		return "SUCCEEDED";
	}
}
