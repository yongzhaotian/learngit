package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �Զ�����̽�����ݴ�״̬���
 * @author djia
 * @since 2009/11/05
 *
 */
public class SaveFlagCheck extends AlarmBiz{
	
	public Object  run(Transaction Sqlca) throws Exception
	{		 
		//��ȡ�������������ͺͶ�����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//���������SQL���
		String sSql = "";
		//�����������Ҫ�����������������
		String sMainTable = "",sRelativeTable = "";
		//����������ݴ��־
		String sTempSaveFlag = "";
		//�����������ѯ�����
		ASResultSet rs = null;			
		
		//���ݶ������ͻ�ȡ�������
		sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = :ObjectType ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", sObjectType));
		if (rs.next()) { 
			sMainTable = rs.getString("ObjectTable");
			sRelativeTable = rs.getString("RelativeTable");
			//����ֵת���ɿ��ַ���
			if (sMainTable == null) sMainTable = "";
			if (sRelativeTable == null) sRelativeTable = "";
		}
		rs.getStatement().close();
		
		if (!sMainTable.equals("")) {
			sSql = 	" select TempSaveFlag from "+sMainTable+" where SerialNo = :SerialNo ";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", sObjectNo));
			while (rs.next()) { 			
				sTempSaveFlag = rs.getString("TempSaveFlag");	 
				//����ֵת���ɿ��ַ���
				if (sTempSaveFlag == null) sTempSaveFlag = "";				
				if (sTempSaveFlag.equals("1")||sTempSaveFlag.equals("")) {
					putMsg("��Ϣ����Ϊ�ݴ�״̬��������д����Ϣ���鲢������水ť");
				}			
			}
			rs.getStatement().close();
		} 
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
