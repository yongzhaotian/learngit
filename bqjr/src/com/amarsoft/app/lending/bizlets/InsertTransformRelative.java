package com.amarsoft.app.lending.bizlets;

/*
Author: --ccxie 2010/04/06
Tester:
Describe: --������߶����ͬ�µĵ���Ʒ
Input Param:
Output Param:
		
HistoryLog:
*/

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InsertTransformRelative extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");//������ͬ���
		String sSerialNo = (String)this.getAttribute("SerialNo");//������ͬ���������ˮ��
		String sRelationStatus = (String)this.getAttribute("RelationStatus");
		SqlObject so;
		//����ͬ���
		so = new SqlObject("select RelativeSerialNo from GUARANTY_TRANSFORM where SerialNo =:SerialNo").setParameter("SerialNo", sSerialNo);
		String sContractNo =  Sqlca.getString(so);
		//����ֵת��Ϊ���ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSerialNo == null) sSerialNo = "";
		if(sRelationStatus == null) sRelationStatus = "";	
		if(sContractNo == null) sContractNo = "";	

		//�������		
		String sSql = "";//Sql���
		ASResultSet rs = null;
		String sGuarantyID = "";
		//���뵣����ͬ������ͬ�Ĺ�����ϵ
		sSql = "select count(*) from TRANSFORM_RELATIVE where SerialNo =:SerialNo and ObjectNo =:ObjectNo and ObjectType = 'GuarantyContract'";
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo).setParameter("ObjectNo", sObjectNo);
		String sCount = Sqlca.getString(so);
		if(sCount.equals("0")){
			sSql = "insert into TRANSFORM_RELATIVE(SerialNo,ObjectNo,ObjectType,RelationStatus) values(:SerialNo,:ObjectNo,:ObjectType,:RelationStatus)";
			so = new SqlObject(sSql);
			so.setParameter("SerialNo", sSerialNo).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType).setParameter("RelationStatus", sRelationStatus);
			Sqlca.executeSQL(so);	
			//���Ƶ�����ͬ�뱻�������߶����ͬ�����ĵ���Ʒ�Ĺ�����ϵ
			sSql = 	" select distinct GuarantyID from GUARANTY_RELATIVE "+
			" where ObjectType = 'BusinessContract' "+
			" and ContractNo =:ContractNo ";
			so = new SqlObject(sSql).setParameter("ContractNo", sObjectNo);
			rs = Sqlca.getASResultSet(so);
			while(rs.next())
			{
				
				sGuarantyID = rs.getString("GuarantyID");
				sSql = 	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
				" values('BusinessContract',:ObjectNo,:ContractNo,:GuarantyID,'Copy','1','Import')";
				so = new SqlObject(sSql).setParameter("ObjectNo", sContractNo).setParameter("ContractNo", sObjectNo).setParameter("GuarantyID", sGuarantyID);
				Sqlca.executeSQL(so);
			}
			rs.getStatement().close();			
			return "SUCCEEDED";
		}else
			return "EXIST";
	}		
}
