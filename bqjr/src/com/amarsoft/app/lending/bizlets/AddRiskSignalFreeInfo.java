/*
		Author: --zywei 2005-08-13
		Tester:
		Describe: --������׼��Ԥ����Ϣ���Ƶ�Ԥ����Ϣ�����
		Input Param:
				ObjectNo: ��׼��Ԥ����Ϣ���				
		Output Param:
				SerialNo����ˮ��
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;


public class AddRiskSignalFreeInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{		
		//�������׼Ԥ����Ϣ��ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//��ȡ��ǰ�û�
		String sUserID = (String)this.getAttribute("UserID");
		
		//����ֵת���ɿ��ַ���		
		if(sObjectNo == null) sObjectNo = "";		
		if(sUserID == null) sUserID = "";
		
		//�����ˮ��
		String sSerialNo = DBKeyHelp.getSerialNo("RISK_SIGNAL","SerialNo","",Sqlca);
		//���������SQL���
		String sSql = "";		
						
		//ʵ�����û�����
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		
		//������׼����Ϣ���Ƶ�Ԥ����Ϣ�����
		sSql =  "insert into RISK_SIGNAL ( "+
					"ObjectType, "+          
					"ObjectNo, "+
					"SerialNo, "+
					"RelativeSerialNo, "+ 
					"SignalType, "+
					"SignalStatus, "+
					"InputOrgID, "+
					"InputUserID, "+
					"InputDate, "+
					"UpdateDate, "+
					"Remark, "+
					"SignalNo, "+
					"SignalName, "+
					"MessageOrigin, "+ 
					"MessageContent, "+
					"ActionFlag, "+
					"ActionType, "+											
					"FreeReason, "+
					"SignalChannel) "+					
					"select "+ 
					"ObjectType, "+          
					"ObjectNo, "+
					"'"+sSerialNo+"', "+
					"'"+sObjectNo+"', "+ 
					"'02', "+
					"'10', "+
					"'"+CurUser.getOrgID()+"', " + 
					"'"+CurUser.getUserID()+"', " +
					"'"+StringFunction.getToday()+"', " + 
					"'"+StringFunction.getToday()+"', " + 
					"'', "+
					"SignalNo, "+
					"SignalName, "+
					"MessageOrigin, "+ 
					"MessageContent, "+
					"ActionFlag, "+
					"ActionType, "+		
					"FreeReason, "+
					"SignalChannel "+					
					"from RISK_SIGNAL " +
					"where SerialNo='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);		
				
		return sSerialNo;
	}	
}
