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


public class InitializeFlow extends Bizlet 
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
        		
		//�������:�û����ơ��������ơ��������ơ��׶����ơ��׶����͡���ʼʱ�䡢������ˮ�š�SQL
		String sUserName = "";
		String sOrgName = "";
		String sFlowName = "";
		String sPhaseName = "";	
		String sPhaseType = "";
		String sBeginTime = "";
		String sSerialNo = "";
		String sSql = "";
		//�����������ѯ�����
		ASResultSet rs=null;
		SqlObject so;
		// add by fhuang  ����ͻ���������С��ҵ��ʹ������ģ�� SMECreditFlow
		if(sObjectType == null) sObjectType = "";
	
		if(sObjectType.equals("CreditApply")){
			//�ҳ�CustomerID
			String[] sFlowNoArray = sFlowNo.split("@");
			sSql = "select CustomerID from Business_Contract where SerialNo=:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
			String sCustomerID = Sqlca.getString(so);
			if(sCustomerID == null) sCustomerID = "";
			sSql = "select CustomerType from Customer_Info where CustomerID=:CustomerID ";
			so = new SqlObject(sSql).setParameter("CustomerID", sCustomerID);
			String sCustomerType = Sqlca.getString(so);
			if(sCustomerType == null) sCustomerType = "";
			//0120 ��С����ҵ,ʹ�����ÿ�������̺�
			
			//FlowNo��ʽ��CreditFlow@SMEStandardFlow����1λ��ʾ������ҵʹ�����̣���2λ��ʾ��С��ҵʹ������
			if(sCustomerType.equals("0120")){
				if(sFlowNoArray.length >= 2){
					sFlowNo = sFlowNoArray[1];
				}else{
					sFlowNo = sFlowNoArray[0];
				}
			}else{
				sFlowNo = sFlowNoArray[0];
			}
			
			//��ȡ��ʼ���׶�
			sSql = "select InitPhase from FLOW_CATALOG where FlowNo =:FlowNo ";
			so = new SqlObject(sSql).setParameter("FlowNo", sFlowNo);
			sPhaseNo = Sqlca.getString(so);
			//���û�г�ʼ�׶α�ţ��׳���ʾ��Ϣ
			if(sPhaseNo==null||sPhaseNo.trim().equals(""))
				throw new Exception("��������"+sFlowNo+"û�г�ʼ���׶α�ţ�");
		}
		
		//�������һ���·�����ҵ���ֻ�������ȣ�����BUSINESS_TYPE��ָ������������,���֮��ȡ���������̱�źͳ�ʼ�׶α�ţ������ǵ��Ѿ�ȡ�õ�Ĭ��ֵ��
		//add by wlu 2009-02-20
		if(sObjectType.equals("CreditApply"))
		{
			String sOccurtype="";
			if(sApplyType==null)sApplyType="";
			if(!sApplyType.equals("CreditLineApply")){
				so = new SqlObject("select Occurtype from Business_Contract where SerialNo=:SerialNo").setParameter("SerialNo", sObjectNo);
				sOccurtype = Sqlca.getString(so);
				if(sOccurtype==null)sOccurtype="";
			}
			//��������010���·�����ҵ�������������
			if(sApplyType.equals("CreditLineApply")||sOccurtype.equals("010")){
				//��ҵ����в�ѯ�������̱��
				sSql = " select Attribute9 from Business_Type where TypeNo= "+
				   " (select businesstype from Business_Contract where serialno=:serialno) ";
				so = new SqlObject(sSql).setParameter("serialno", sObjectNo);
				String sFlowNo1 = Sqlca.getString(so);
				
				if(sFlowNo1 == null) sFlowNo1 = "";
				
				//��������������̱�����ѯ��ʼ�׶α��
				if(!sFlowNo1.equals("")||sFlowNo1.trim().length()>0)			
				{
					sFlowNo = sFlowNo1;
					//��ȡ��ʼ���׶�
					sSql = "select InitPhase from FLOW_CATALOG where FlowNo =:FlowNo";
					so = new SqlObject(sSql).setParameter("FlowNo", sFlowNo);
					sPhaseNo = Sqlca.getString(so);
					//���û�г�ʼ�׶α�ţ��׳���ʾ��Ϣ
					if(sPhaseNo==null||sPhaseNo.trim().equals("")) {
						ARE.getLog().error("��������"+sFlowNo1+"û�г�ʼ���׶α��");
						throw new Exception("��������"+sFlowNo1+"û�г�ʼ���׶α�ţ�");
					}
				}
			}
												
		}
				
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
	   	    
	    //�����̶����FLOW_OBJECT������һ����Ϣ
	    String sSql1 =  " Insert into FLOW_OBJECT(ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName,PhaseNo, " +
	    " PhaseName,OrgID,OrgName,UserID,UserName,InputDate) " +
        " values (:ObjectType,:ObjectNo,:PhaseType,:ApplyType,:FlowNo, " +
        " :FlowName,:PhaseNo,:PhaseName,:OrgID,:OrgName,:UserID, "+
        " :UserName,:InputDate) ";
	    so = new SqlObject(sSql1);
	    so.setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("PhaseType", sPhaseType).setParameter("ApplyType", sApplyType)
	    .setParameter("FlowNo", sFlowNo).setParameter("FlowName", sFlowName).setParameter("PhaseNo", sPhaseNo).setParameter("PhaseName", sPhaseName).setParameter("OrgID", sOrgID)
	    .setParameter("OrgName", sOrgName).setParameter("UserID", sUserID).setParameter("UserName", sUserName).setParameter("InputDate", StringFunction.getToday());
	    //�����������FLOW_TASK������һ����Ϣ
	    /** --update Object_Maxsnȡ���Ż� tangyb 20150817 start-- 
	    sSerialNo = DBKeyHelp.getSerialNo("FLOW_TASK","SerialNo",Sqlca); */
	    sSerialNo = DBKeyHelp.getWorkNo(); 
	    /** --end --*/
	    
	    String sSql2 =  " insert into FLOW_TASK(SerialNo,ObjectType,ObjectNo,PhaseType,ApplyType,FlowNo,FlowName, " +
			" PhaseNo,PhaseName,OrgID,UserID,UserName,OrgName,BegInTime) "+
			" values (:SerialNo,:ObjectType,:ObjectNo,:PhaseType,:ApplyType, " + 
			" :FlowNo,:FlowName,:PhaseNo,:PhaseName,:OrgID,:UserID, " +
			" :UserName,:OrgName,:BeginTime )";
	    SqlObject so1 = new SqlObject(sSql2);
	    so1.setParameter("SerialNo", sSerialNo).setParameter("ObjectType", sObjectType).setParameter("ObjectNo", sObjectNo).setParameter("PhaseType", sPhaseType)
	    .setParameter("ApplyType", sApplyType).setParameter("FlowNo", sFlowNo).setParameter("FlowName", sFlowName).setParameter("PhaseNo", sPhaseNo)
	    .setParameter("PhaseName", sPhaseName).setParameter("OrgID", sOrgID).setParameter("UserID", sUserID).setParameter("UserName", sUserName)
	    .setParameter("OrgName", sOrgName).setParameter("BeginTime", sBeginTime);
	   
	    //ִ�в������
	    Sqlca.executeSQL(so);
	    Sqlca.executeSQL(so1);
	    	    
	    return "1";
	    
	 }

}
