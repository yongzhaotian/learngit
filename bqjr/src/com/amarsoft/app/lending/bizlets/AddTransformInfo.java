/*
		Author: --ccxie 2010/03/22
		Tester:
		Describe: --��������ͬ��Ϣ������������ͬ����������
		Input Param:
				SerialNo: ��ͬ��ˮ��
		Output Param:
				sNewSerialNo��������ͬ���������ˮ��
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AddTransformInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//��ͬ��ˮ��
		String sSerialNo = (String)this.getAttribute("SerialNo");
		if(sSerialNo == null) sSerialNo = "";
		String sNewSerialNo = DBKeyHelp.getSerialNo("GUARANTY_TRANSFORM","SerialNo","",Sqlca);
		String sSql = "";
		SqlObject so = null; //��������
		//������ͬ��Ϣ��������ͬ�������
		sSql =  " INSERT INTO GUARANTY_TRANSFORM (SerialNo,RelativeSerialNo,ObjectType,ArtificialNo,CustomerID,CustomerName," +
				" OccurType,BusinessType,BusinessCurrency,BusinessSum,Balance,TransformReason,ManageOrgID,InputDate,UpdateDate)" +
				" select '"+sNewSerialNo+"',SerialNo,'TransformApply',ArtificialNo,CustomerID,CustomerName,OccurType,BusinessType,BusinessCurrency,BusinessSum,Balance," +
				" '',ManageOrgID,'"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' from BUSINESS_CONTRACT where SerialNo = '"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);
		
		//����CONTRACT_RELATIVE����ص���Ϣ��TRANSFORM_RELATIVE����
		sSql =  " INSERT INTO TRANSFORM_RELATIVE (SerialNo,ObjectType,ObjectNo,RelativeSum,RelationStatus) " +
				" select '"+sNewSerialNo+"',ObjectType ,ObjectNo,RelativeSum,RelationStatus from CONTRACT_RELATIVE where SerialNo = '"+sSerialNo+"'" +
				" and ObjectType = 'GuarantyContract' and RelationStatus = '010' ";
		Sqlca.executeSQL(sSql);
		
		//����BUSINESS_CONTRACT��ı�־λTransformFlag=1,��ʾ�ñ�����ͬ�����ڵ�����ͬ���������
		so = new SqlObject("update BUSINESS_CONTRACT set TransformFlag = '1' where SerialNo =:SerialNo ").setParameter("SerialNo", sSerialNo);
		Sqlca.executeSQL(so);
		
		
		return sNewSerialNo;
	}
}
