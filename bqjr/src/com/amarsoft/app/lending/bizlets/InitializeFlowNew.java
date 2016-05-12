package com.amarsoft.app.lending.bizlets;

/**
 * ���̳�ʼ����
 * @history fhuang 2007.01.08 ������С��ҵ����ѡ��
 * 			syang 2009/10/26 ����ע��
 */
import com.amarsoft.app.als.process.action.BusinessProcessAction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class InitializeFlowNew extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
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
        SqlObject so; //��������	
		//�������:�û����ơ��������ơ��������ơ��׶����ơ��׶����͡���ʼʱ�䡢������ˮ�š�SQL
		String sUserName = "";
		String sOrgName = "";
		String sFlowName = "";
		String sPhaseName = "";	
		String sPhaseType = "";
		String sSql = "";
		//�����������ѯ�����
		ASResultSet rs=null;
		
		if(sObjectType == null) sObjectType = "";
				
		//��ȡ���û�����
		sSql = " select UserName from USER_INFO where UserID =:UserID ";
		so = new SqlObject(sSql).setParameter("UserID", sUserID);
		sUserName = Sqlca.getString(so);
	    //ȡ�û�������
		sSql = " select OrgName from ORG_INFO where OrgID =:OrgID ";
		so = new SqlObject(sSql).setParameter("OrgID", sOrgID);
		sOrgName = Sqlca.getString(so);
        //ȡ����������
		sSql = " select FlowName from FLOW_CATALOG where FlowNo =:FlowNo ";
		so = new SqlObject(sSql).setParameter("FlowNo", sFlowNo);
		sFlowName = Sqlca.getString(so);
        //ȡ�ý׶�����
		sSql = " select PhaseName,PhaseType from FLOW_MODEL where FlowNo =:FlowNo and PhaseNo =:PhaseNo ";
		so = new SqlObject(sSql).setParameter("FlowNo", sFlowNo).setParameter("PhaseNo", sPhaseNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{ 
			sPhaseName = rs.getString("PhaseName");
			sPhaseType = rs.getString("PhaseType");
			
			//����ֵת���ɿ��ַ���
			if(sPhaseName == null) sPhaseName = "";
			if(sPhaseType == null) sPhaseType = "";
		}
		rs.getStatement().close(); 
	    
	    //����ֵת���ɿ��ַ���
	    if(sObjectType == null) sObjectType = "";
	    if(sObjectNo == null) sObjectNo = "";
	    if(sPhaseType == null) sPhaseType = "";
	    if(sApplyType == null) sApplyType = "";
	    if(sFlowNo == null) sFlowNo = "";
	    if(sFlowName == null) sFlowName = "";
	    if(sPhaseNo == null) sPhaseNo = "";
	    if(sPhaseName == null) sPhaseName = "";
	    if(sUserID == null) sUserID = "";
	    if(sUserName == null) sUserName = "";
	    if(sOrgID == null) sOrgID = "";
	    if(sOrgName == null) sOrgName = "";
	    
	    BusinessProcessAction bpAction = new BusinessProcessAction();
	    bpAction.setObjectNo(sObjectNo);
	    bpAction.setObjectType(sObjectType);
	    bpAction.setApplyType(sApplyType);
	    bpAction.setProcessDefID(sFlowNo);
	    bpAction.setUserID(sUserID);
	    bpAction.start();
	    return "1";
	    
	 }

}
