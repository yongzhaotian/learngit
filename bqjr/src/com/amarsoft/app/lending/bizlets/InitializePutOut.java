/*
 * 		Author: zywei 2005-08-13
 * 		Tester:
 * 		Describe: ��ʼ���Ŵ����������
 * 		Input Param:
 * 				ObjectType: ��������
 * 				ObjectNo: ������
 * 				ApplyType����������
 * 				FlowNo�����̱��
 * 				PhaseNo���׶α��
 * 				UserID���û�����
 * 				OrgID���û�����
 * 		Output Param:
 * 				SerialNo����ͬ��ˮ��
 * 		HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import java.util.StringTokenizer;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitializePutOut extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//ҵ��Ʒ��
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//��Ʊ���
		String sBillNo = (String)this.getAttribute("BillNo");
		//��������
		String sApplyType = (String)this.getAttribute("ApplyType");
		//���̱��
		String sFlowNo = (String)this.getAttribute("FlowNo");
		//�׶α��
		String sPhaseNo = (String)this.getAttribute("PhaseNo");	
		//�û�����
		String sUserID = (String)this.getAttribute("UserID");
		//��������
		String sOrgID = (String)this.getAttribute("OrgID");
		//������ˮ��				
		String sSerialNo = "";
		
		//����AddPutOutInfo.java�Գ���������г�ʼ��				
	    Bizlet bzAddPutOut = new AddPutOutInfo();
		bzAddPutOut.setAttribute("ObjectType",sObjectType); 
		bzAddPutOut.setAttribute("ObjectNo",sObjectNo);	
		bzAddPutOut.setAttribute("BusinessType",sBusinessType);		
		bzAddPutOut.setAttribute("BillNo",sBillNo);
		bzAddPutOut.setAttribute("UserID",sUserID);
		sSerialNo = (String)bzAddPutOut.run(Sqlca);
		/*
		 * 2������ InitializeFlow.java�ԷŴ�����������̳�ʼ��		  
		*/
		int i = 0;
		StringTokenizer st = new StringTokenizer(sSerialNo,"@");
	    String [] sPutOutSerialNo = new String[st.countTokens()];

		while (st.hasMoreTokens())
	    {			
			sPutOutSerialNo[i] = st.nextToken();
	        i ++;
	    }
		
	    for(int j = 0 ; j < sPutOutSerialNo.length ; j ++)
	    {	    	
	    	Bizlet bzInitFlow = new InitializeFlow();
			bzInitFlow.setAttribute("ObjectType",sObjectType); 
			bzInitFlow.setAttribute("ObjectNo",sPutOutSerialNo[j]); 
			bzInitFlow.setAttribute("ApplyType",sApplyType);
			bzInitFlow.setAttribute("FlowNo",sFlowNo);
			bzInitFlow.setAttribute("PhaseNo",sPhaseNo);
			bzInitFlow.setAttribute("UserID",sUserID);
			bzInitFlow.setAttribute("OrgID",sOrgID);
			bzInitFlow.run(Sqlca);			
	    }
	    
	    return sPutOutSerialNo[0];
	 }
}
