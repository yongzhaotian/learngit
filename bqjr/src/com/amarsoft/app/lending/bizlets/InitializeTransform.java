/*
		Author: --ccxie 2010/03/18
		Tester:
		Describe: --��ʼ�����������ͬ
		Input Param:
				SerialNo: ��ͬ��ˮ��
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitializeTransform extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��ͬ��ˮ��
		String sSerialNo = (String)this.getAttribute("SerialNo");
		//���̱��
		String sFlowNo = (String)this.getAttribute("FlowNo");
		//�׶α��
		String sPhaseNo = (String)this.getAttribute("PhaseNo");	
		//�û�����
		String sUserID = (String)this.getAttribute("UserID");
		//��������
		String sOrgID = (String)this.getAttribute("OrgID");
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//��������
		String sApplyType = (String)this.getAttribute("ApplyType");
		//����ֵת��Ϊ���ַ���
		if(sSerialNo == null) sSerialNo = "";
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";
		if(sUserID == null) sUserID = "";
		if(sOrgID == null) sOrgID = "";
		if(sObjectType == null) sObjectType = "";
		if(sApplyType == null) sApplyType = "";
		String sNewSerialNo = "";
		
		//����������ͬ����������Ϣ
		Bizlet addTransformInfo = new AddTransformInfo();
		addTransformInfo.setAttribute("SerialNo",sSerialNo);
		sNewSerialNo = (String) addTransformInfo.run(Sqlca);
		
		//��ʼ��������Ϣ
		Bizlet bzInitFlow = new InitializeFlow();
		bzInitFlow.setAttribute("ObjectType",sObjectType); 
		bzInitFlow.setAttribute("ObjectNo",sNewSerialNo); 
		bzInitFlow.setAttribute("ApplyType",sApplyType); 
		bzInitFlow.setAttribute("UserID",sUserID); 
		bzInitFlow.setAttribute("OrgID",sOrgID); 
		bzInitFlow.setAttribute("FlowNo",sFlowNo); 
		bzInitFlow.setAttribute("PhaseNo",sPhaseNo); 
		bzInitFlow.run(Sqlca);
	   
		return sNewSerialNo;
	 }

}
