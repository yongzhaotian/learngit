/*
		Author: --fwang 2009-11-16
		Tester:
		Describe: --��ʼ�������������������
		Input Param:
				ObjectType: ��������
				ObjectNo: ������
				ApplyType����������
				FlowNo�����̱��
				PhaseNo���׶α��
				UserID���û�����
				OrgID���û�����
				ApproveType����������
				DisagreeOpinion��������
		Output Param:
				SerialNo��������ˮ��
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitializeGreenWay extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
	    //������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//�û�����
		String sUserID = (String)this.getAttribute("UserID");
		//��������
		String sOrgID = (String)this.getAttribute("OrgID");
				
		String sSerialNo = "";
		
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
				
		
		/*
		 * �����������������ʼ�������� InitializeFlow.java		  
		*/
		Bizlet bzAddContract = new GreenWay();
		bzAddContract.setAttribute("ObjectNo",sObjectNo);
		bzAddContract.setAttribute("UserID",sUserID);
		sSerialNo = (String)bzAddContract.run(Sqlca);
		  
	    return sSerialNo;
	    
	 }

}
