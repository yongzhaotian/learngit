package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class CheckSaveFlag extends AlarmBiz
{
	public Object  run(Transaction Sqlca) throws Exception
	{		 
		//��ȡ�������������ͺͶ�����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//�����������ʾ��Ϣ��SQL��䡢��Ʒ���͡��ͻ�����
		String sSql = "";
		//�����������Ҫ������ʽ���ͻ����롢�����������������
		String sTableName = "";
		//����������ݴ��־,�Ƿ�ͷ���
		String sTempSaveFlag = "";
		//����������������͡��������͡������˴���
		//�����������ѯ�����
		ASResultSet rs = null;			
		
		//��ͬ�׶��ڲ�ͬ���в�ѯCustomerID
		if(sObjectType.equalsIgnoreCase("BusinessContract"))
		{
			sTableName = "BUSINESS_CONTRACT";
		}else if(sObjectType.equalsIgnoreCase("ApproveApply"))
		{
			sTableName = "BUSINESS_APPROVE";
		}else if(sObjectType.equalsIgnoreCase("CreditApply"))
		{
			sTableName = "BUSINESS_APPLY";
		}
		
		if (!sTableName.equals("")) {
			//--------------�������������������Ƿ�ȫ������---------------
			//����Ӧ�Ķ���������л�ȡ����Ʒ���͡�Ʊ����������������
			sSql = 	" select TempSaveFlag from "+sTableName+" where SerialNo = :sObjectNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo));
			while (rs.next()) { 			
				sTempSaveFlag = rs.getString("TempSaveFlag");	 
				//����ֵת���ɿ��ַ���
				if (!"2".equals(sTempSaveFlag)) {			
					putMsg("��Ϣ����Ϊ�ݴ�״̬,������д����Ϣ���鲢������水ť!");
				}
			}
			rs.getStatement().close();
		} 
		/* ���ؽ������  */
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
		

}
