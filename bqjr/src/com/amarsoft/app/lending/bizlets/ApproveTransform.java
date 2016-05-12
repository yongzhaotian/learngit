/*
		Author: --ccxie 2010/03/18
		Tester:
		Describe: ���������������ͨ��ʱ���е�һЩ��ز���
		Input Param:
				ObjectNo: ���������ͬ��ˮ��
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ApproveTransform extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��ͬ��ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sObjectType = (String)this.getAttribute("ObjectType");
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		ASResultSet rs = null,rs1 = null;
		SqlObject so = null; //��������
		
		so = new SqlObject("select RelativeSerialNo from GUARANTY_TRANSFORM where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo);
		String sContractSerialNo = Sqlca.getString(so);
		//��TRANSFORM_RELATIVE���еĹ�����ϵ���µ�CONTRACT_RELATIVE��
		String sSql = "";
		//������ͬ���Ϊ������״̬����ز���
		//1.	ִ��INSERT��������TR���������ĵ�����ͬ������ϵ���뵽CR���У�����CR.RelationStatus��Ϊ'010'
		//2.	ִ��UPDATE��������GC.ContractStatus����Ϊ��ǩ���ͬ-'020'
		
		sSql = " select ObjectNo,RelativeSum from TRANSFORM_RELATIVE where SerialNo =:SerialNo and RelationStatus = '020' ";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		while(rs.next()){
			sSql = " INSERT INTO CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo,RelativeSum,RelationStatus) values (:SerialNo,'GuarantyContract',"+
			":ObjectNo,:RelativeSum,'010')";
			so = new SqlObject(sSql).setParameter("SerialNo", sContractSerialNo).setParameter("ObjectNo", rs.getString(1)).setParameter("RelativeSum", rs.getString(2));
			Sqlca.executeSQL(so);
			
			//���������׶ε�����Ϣ����ˮ�Ų��ҵ���Ӧ�ĵ�������Ϣ
			sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
			" where ObjectType =:ObjectType "+
			" and ObjectNo =:ObjectNo "+
			" and ContractNo =:ContractNo ";
			so = new SqlObject(sSql).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sContractSerialNo).setParameter("ContractNo", rs.getString(1));
			rs1 = Sqlca.getASResultSet(so);
			while(rs1.next())
			{
				sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
				" values('BusinessContract',:ObjectNo,:ContractNo, "+
				" :GuarantyID,'Copy',:Status,:Type) ";
				so = new SqlObject(sSql).setParameter("ObjectNo", sContractSerialNo).setParameter("ContractNo", rs.getString(1))
				.setParameter("GuarantyID", rs1.getString("GuarantyID")).setParameter("Status", rs1.getString("Status")).setParameter("Type", rs1.getString("Type"));
				Sqlca.executeSQL(so);
				
			}
			rs1.getStatement().close();
		}
		rs.getStatement().close();
		
		sSql =  " update GUARANTY_CONTRACT set ContractStatus = '020' where SerialNo in (select ObjectNo from TRANSFORM_RELATIVE where SerialNo =:SerialNo and ObjectType = 'GuarantyContract' and RelationStatus = '020' )";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		
		//������ͬ���Ϊ����״̬����ز���
		//1.	ִ��UPDATE��������CR.RelationStatus��Ϊ'020'
		//2.	ִ��UPDATE������������һ�㵣����ͬ����GC.ContractStatus��Ϊ��ʧЧ-'030'
		sSql =  " update CONTRACT_RELATIVE set RelationStatus = '020' where SerialNo =:SerialNo " +
		" and ObjectType = 'GuarantyContract' and ObjectNo in (select ObjectNo from TRANSFORM_RELATIVE " +
		" where SerialNo =:SerialNo1 and ObjectType = 'GuarantyContract' and RelationStatus = '030' )";
		so = new SqlObject(sSql).setParameter("SerialNo", sContractSerialNo).setParameter("SerialNo1", sObjectNo);
		Sqlca.executeSQL(so);
		
		sSql =  " update GUARANTY_CONTRACT set ContractStatus = '030' where ContractType = '010' and SerialNo in " +
		" (select ObjectNo from TRANSFORM_RELATIVE where SerialNo =:SerialNo and ObjectType = 'GuarantyContract' and RelationStatus = '030' )";
		so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		
		//����BUSINESS_CONTRACT���е�TransformTimes�ֶ�ֵ
		//����BUSINESS_CONTRACT��ı�־λTransformFlag=0,��ʾ�ñ�����ͬ�ĵ�����ͬ������������
		sSql = " update BUSINESS_CONTRACT set TransformFlag = '0',TransformTimes = nvl(TransformTimes,0)+1 where SerialNo =:SerialNo";
		so = new SqlObject(sSql).setParameter("SerialNo", sContractSerialNo);
		Sqlca.executeSQL(so);

		return "success";
	 }

}
