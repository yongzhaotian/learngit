/*
		Author: --cyyu 2009-03-26
		Tester:
		Describe: --���û�ͣ�����˵���Ŀ
		Input Param:
				ItemNo: ��Ŀ���
				IsInUse: ʹ��״̬
				Flag����־
		Output Param:
				sReturn��������ʾ
		HistoryLog:   sxjiang 2010/07/20 ��Line41��47��Ӷ�System_Menu�Ĳ�����ʹ��ҳ�����������ú�ͣ��ģ��
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ChangeState extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		//�����Ŀ���
		String sItemNo = (String)this.getAttribute("ItemNo");
		//���ʹ��״̬  ���� 0;���� 1;ͣ�� 2;
		String sIsInUse = (String)this.getAttribute("IsInUse");
		//��������û���ͣ�ñ�־  ���� 1;ͣ�� 2;
		String sFlag = (String)this.getAttribute("Flag");
		
		//����ֵת���ɿ��ַ���
		if(sItemNo == null) sItemNo = "";
		if(sIsInUse == null) sIsInUse = "";
		if(sFlag == null) sFlag = "";
		SqlObject so ;//��������
		//�������
		String sSql1 = "",sSql2 = "",sReturn = "false";
		//����
		if (sFlag.equals("1") && sIsInUse.equals("����")) {
			sReturn = "1";
		}
		if (sFlag.equals("1") && !sIsInUse.equals("����") && !sItemNo.equals("")) {
			sSql1 = "Update CODE_LIBRARY set IsInUse='1' where CodeNo='MainMenu' and ItemNo=:ItemNo "; 
			so = new SqlObject(sSql1).setParameter("ItemNo", sItemNo);
			Sqlca.executeSQL(so);
			sSql2 = "Update SYSTEM_MENU set IsInUse='1' where MenuId=:MenuId "; 
			so = new SqlObject(sSql2).setParameter("MenuId", sItemNo);
			Sqlca.executeSQL(so);
			sReturn = "success";
		}
		if (sFlag.equals("2") && !sIsInUse.equals("ͣ��") && !sItemNo.equals("")) {
			sSql1 = "Update CODE_LIBRARY set IsInUse='2' where CodeNo='MainMenu' and ItemNo=:ItemNo "; 
			so = new SqlObject(sSql1).setParameter("ItemNo", sItemNo);
			Sqlca.executeSQL(so);
			sSql2 = "Update SYSTEM_MENU set IsInUse='2' where MenuId=:MenuId ";
			so = new SqlObject(sSql2).setParameter("MenuId", sItemNo);
			Sqlca.executeSQL(so);
			sReturn = "success";
		}
		if (sFlag.equals("2") && sIsInUse.equals("ͣ��")) {
			sReturn = "2";
		}
		return sReturn;
	}

}
