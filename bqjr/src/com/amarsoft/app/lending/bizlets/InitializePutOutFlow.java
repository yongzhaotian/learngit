package com.amarsoft.app.lending.bizlets;

/**
 * ���̳�ʼ����
 * @history fhuang 2007.01.08 ������С��ҵ����ѡ��
 * 			syang 2009/10/26 ����ע��
 */
import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class InitializePutOutFlow extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
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
		System.err.println("sObjectType="+sObjectType+",sApplyType="+sApplyType+",sFlowNo="+sFlowNo+",sUserID="+sUserID+",sOrgID="+sOrgID);
        		
		//�������:�û����ơ��������ơ��������ơ��׶����ơ��׶����͡���ʼʱ�䡢������ˮ�š�SQL
		String sUserName = "";
		String sOrgName = "";
		String sFlowName = "";
		String sPhaseName = "";	
		String sPhaseType = "";
		String sBeginTime = "";
		String sSerialNo = "";
		String sSql = "";
		String sObjectNo="";
		//�����������ѯ�����
		ASResultSet rs=null;
		SqlObject so;
		// add by fhuang  ����ͻ���������С��ҵ��ʹ������ģ�� SMECreditFlow
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
		
		//��ÿ�ʼ����
	    sBeginTime = StringFunction.getToday()+" "+StringFunction.getNow();	 
		System.out.println("sPhaseName="+sPhaseName+",sPhaseType="+sPhaseType);

	    //����ֵת���ɿ��ַ���
	    if(sObjectType == null) sObjectType = "";
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
	    sSql="select serialno from business_contract where CreditAttribute = '0001'";  
	    rs = Sqlca.getASResultSet(sSql);
	    while(rs.next()){
	    	sObjectNo=rs.getString("serialno");
	    	sSql="select count(ObjectNo) from FLOW_OBJECT where ObjectNo=:ObjectNo and ObjectType =:ObjectType "; 
	    	so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType);
	    	String count = Sqlca.getString(so);
	    	SqlObject so1=null;
	    	if(count!=null &&count.equals("0")){
		    	 //�����̶����FLOW_OBJECT������һ����Ϣ
			    String sSql1 =  " Insert into FLOW_OBJECT(ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName,PhaseNo, " +
			    " PhaseName,OrgID,OrgName,UserID,UserName,InputDate) " +
		        " values (:ObjectType,:ObjectNo,:PhaseType,:ApplyType,:FlowNo, " +
		        " :FlowName,:PhaseNo,:PhaseName,:OrgID,:OrgName,:UserID, "+
		        " :UserName,:InputDate) ";
			    so1 = new SqlObject(sSql1);
			    so1.setParameter("ObjectType", sObjectType).setParameter("ObjectNo",sObjectNo ).setParameter("PhaseType", sPhaseType).setParameter("ApplyType", sApplyType)
			    .setParameter("FlowNo", sFlowNo).setParameter("FlowName", sFlowName).setParameter("PhaseNo", sPhaseNo).setParameter("PhaseName", sPhaseName).setParameter("OrgID", sOrgID)
			    .setParameter("OrgName", sOrgName).setParameter("UserID", sUserID).setParameter("UserName", sUserName).setParameter("InputDate", StringFunction.getToday());
			    //ִ�в������
			    Sqlca.executeSQL(so1);
	    	}
	    	
	    	sSql="select count(ObjectNo) from FLOW_TASK where ObjectNo=:ObjectNo and ObjectType =:ObjectType and FlowNo=:FlowNo"; 
	    	so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType).setParameter("FlowNo", sFlowNo);
	    	count = Sqlca.getString(so);
	    	SqlObject so2=null;
	    	if(count!=null &&count.equals("0")){
	    		//�����������FLOW_TASK������һ����Ϣ
	    		/** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
	    		sSerialNo = DBKeyHelp.getSerialNo("FLOW_TASK","SerialNo",Sqlca);*/
	    		sSerialNo = DBKeyHelp.getWorkNo();
	    		/** --end --*/
			    
			    String sSql2 =  " insert into FLOW_TASK(SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
					" PhaseNo,PhaseName,OrgID,UserID,UserName,OrgName,BegInTime) "+
					" values (:SerialNo,:ObjectType,:ObjectNo,:PhaseType,:ApplyType, " + 
					" :FlowNo,:FlowName,:PhaseNo,:PhaseName,:OrgID,:UserID, " +
					" :UserName,:OrgName,:BeginTime )";
			    so2= new SqlObject(sSql2);
			    so2.setParameter("SerialNo", sSerialNo).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("PhaseType", sPhaseType)
			    .setParameter("ApplyType", sApplyType).setParameter("FlowNo", sFlowNo).setParameter("FlowName", sFlowName).setParameter("PhaseNo", sPhaseNo)
			    .setParameter("PhaseName", sPhaseName).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("UserName", sUserName)
			    .setParameter("OrgName", sOrgName).setParameter("BeginTime", sBeginTime);
			    Sqlca.executeSQL(so2);
	    	}
		   
	    }	   
	    return "1";    
	 }
}
