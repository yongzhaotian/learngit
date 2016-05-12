/*
		Author: --jschen 2010-03-18
		Tester:
		Describe: --����BUSINESS_CONTRACT������Ϣ��ReinforceFlag�ֶε�ֵ
		Input Param:
				ObjectNo: ��ͬ��ˮ��
				ReinforceFlag����������
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;


import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateReinforceFlag extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
		//���Ǳ�־
	 	String sReinforceFlag = (String)this.getAttribute("ReinforceFlag");
		//������ ��ͬ���
	 	String sObjectNo = (String)this.getAttribute("ObjectNo");
	 	//ҵ��Ʒ��
	 	String sBusinessType = (String)this.getAttribute("BusinessType");

		
		//����ֵת��Ϊ���ַ���
		if(sReinforceFlag == null) sReinforceFlag = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		SqlObject so;
		//�������
		String sSql="";

		if(sReinforceFlag.equals("010")) //δ������ɵ��Ŵ�ҵ��
		{
			sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '020' where SerialNo =:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
			Sqlca.executeSQL(so);
			UpdateFinished(Sqlca,sBusinessType,sObjectNo);
			
		}else if(sReinforceFlag.equals("110")) //δ������ɵ����Ŷ��
		{

			sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '120' where SerialNo =:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
			Sqlca.executeSQL(so);
			UpdateFinished(Sqlca,sBusinessType,sObjectNo);
		}else if(sReinforceFlag.equals("020")) //�������ҵ��
		{
			sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '010' where SerialNo =:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
			Sqlca.executeSQL(so);
			UpdateUnFinished(Sqlca,"",sObjectNo);
		}else if(sReinforceFlag.equals("120")) //������ɶ��
		{
			sSql = "Update BUSINESS_CONTRACT set ReinforceFlag = '110' where SerialNo =:SerialNo";
			so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
			Sqlca.executeSQL(so);
		}
		
		
		return "succeed";
	    
	 }
 
	 public void UpdateFinished(Transaction Sqlca,String sBusinessType,String sObjectNo)throws Exception{
		//�������
		String sSql2= "";
		ASResultSet rs = null;
		SqlObject so;
		String sCustomerID = "",sOperateUserID = "",sOperateOrgID = "",sInputOrgID = "",sInputUserID = "";
		 
		sSql2 = "Select CustomerID,OperateUserID,OperateOrgID,InputOrgID,InputUserID from BUSINESS_CONTRACT where SerialNo =:SerialNo";
		so = new SqlObject(sSql2).setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next())
		{
			sCustomerID = rs.getString("CustomerID");
			sOperateUserID = rs.getString("OperateUserID");
			sOperateOrgID = rs.getString("OperateOrgID");
			sInputUserID = rs.getString("InputUserID");
			sInputOrgID = rs.getString("InputOrgID");
			if(sOperateUserID == null || "".equalsIgnoreCase(sOperateUserID)){
				sOperateUserID = sInputUserID;
				//���º�ͬ���OperateUserID
				sSql2 = "Update BUSINESS_CONTRACT  set OperateUserID =:OperateUserID where SerialNo =:SerialNo";
				so = new SqlObject(sSql2).setParameter("OperateUserID", sOperateUserID).setParameter("SerialNo", sObjectNo);
				Sqlca.executeSQL(so);
			}
			
			if(sOperateOrgID == null || "".equalsIgnoreCase(sOperateOrgID)){
				sOperateOrgID = sInputOrgID;
				//���º�ͬ���OperateOrgID
				sSql2 = "Update BUSINESS_CONTRACT  set OperateOrgID =:OperateOrgID where SerialNo =:SerialNo ";
				so = new SqlObject(sSql2).setParameter("OperateUserID", sOperateUserID).setParameter("SerialNo", sObjectNo);
				Sqlca.executeSQL(so);
			}
		}
		rs.getStatement().close();
		
		//���¹鵵����
		sSql2 = "Update BUSINESS_CONTRACT  set PigeonholeDate =:PigeonholeDate where SerialNo =:SerialNo";
		so = new SqlObject(sSql2).setParameter("PigeonholeDate", StringFunction.getToday()).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		
		/******���½�ݱ��ϵ�BusinessType�ֶ� �����ֶ��Ƿ���ֵ���������ж϶�Ӧ��ͬ�����Ƿ���ɡ�ͬʱ���½���ϵ������ֶ�***/
		sSql2 = "Update BUSINESS_DUEBILL  set BusinessType =:BusinessType, " +
				"CustomerID =:CustomerID,"+
				"OperateUserID =:OperateUserID,"+
				"OperateOrgID =:OperateOrgID,"+
				"InputOrgID =:InputOrgID,"+
				"InputUserID =:InputUserID "+
				"where RelativeSerialNo2 =:RelativeSerialNo2";
		so = new SqlObject(sSql2).setParameter("BusinessType", sBusinessType)
		.setParameter("CustomerID", sCustomerID)
		.setParameter("OperateUserID", sOperateUserID)
		.setParameter("OperateOrgID", sOperateOrgID)
		.setParameter("InputOrgID", sInputOrgID)
		.setParameter("InputUserID", sInputUserID)
		.setParameter("RelativeSerialNo2", sObjectNo);
		Sqlca.executeSQL(so);
		
	    //��ѯ������ͬ�µĵ�����ͬ ����ˮ�ţ�����ֵ�����Ǹ�����
		sSql2 = "select ObjectNo from CONTRACT_RELATIVE where  SerialNo =:SerialNo and ObjectType ='GuarantyContract'";
		so = new SqlObject(sSql2).setParameter("SerialNo", sObjectNo);
	    String sSerialNo_sObjectNo_Array[]=Sqlca.getStringArray(so);//���������ΪString���� ������
	    //�������ʱ���¸õ�����ͬ�ĺ�ͬ״̬Ϊ'020'������ǩ��ͬ
	    for(int i=0;i<sSerialNo_sObjectNo_Array.length;i++){
	    	if(sSerialNo_sObjectNo_Array.length==0) break;
	    	else{
	    		so = new SqlObject("update Guaranty_Contract set ContractStatus ='020' where SerialNo =:SerialNo").setParameter("SerialNo", sSerialNo_sObjectNo_Array[i]);
	    		Sqlca.executeSQL(so);
	    	}
	    }
		 
	 }
	 
	 public void UpdateUnFinished(Transaction Sqlca,String sBusinessType,String sObjectNo)throws Exception{
		//�������
		String sSql2= "";
		SqlObject so;

		//���¹鵵����
		sSql2 = "Update BUSINESS_CONTRACT  set PigeonholeDate ='' where SerialNo =:SerialNo";
		so = new SqlObject(sSql2).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
		/******���½�ݱ��ϵ�BusinessType�ֶ� �����ֶ��Ƿ���ֵ���������ж϶�Ӧ��ͬ�����Ƿ���ɡ�ͬʱ���½���ϵ������ֶ�***/
		sSql2 = "Update BUSINESS_DUEBILL  set BusinessType =:BusinessType, " +
				"CustomerID = '',"+
				"OperateUserID = '',"+
				"OperateOrgID = '',"+
				"InputOrgID = '',"+
				"InputUserID = '' "+
				"where RelativeSerialNo2 =:RelativeSerialNo2";
		so = new SqlObject(sSql2).setParameter("BusinessType", sBusinessType).setParameter("RelativeSerialNo2", sObjectNo);
		Sqlca.executeSQL(so);
		
	    //��ѯ������ͬ�µĵ�����ͬ ����ˮ�ţ�����ֵ�����Ǹ�����
		sSql2 = "select ObjectNo from CONTRACT_RELATIVE where  SerialNo =:SerialNo and ObjectType ='GuarantyContract'";
		so = new SqlObject(sSql2).setParameter("SerialNo", sObjectNo);
	    String sSerialNo_sObjectNo_Array[]=Sqlca.getStringArray(so);//���������ΪString���� ������
	    //ת����δ���ʱ���¸õ�����ͬ�ĺ�ͬ״̬Ϊ'010'����δǩ��ͬ
	    for(int i=0;i<sSerialNo_sObjectNo_Array.length;i++){
	    	if(sSerialNo_sObjectNo_Array.length==0) break;
	    	else{
	    		//ֻ��һ�㵣����ͬ��Ϊ'010'����δǩ��ͬ����߶����ͬ����
	    		so = new SqlObject("update Guaranty_Contract set ContractStatus ='010' where ContractType = '010' and SerialNo =:SerialNo").setParameter("SerialNo", sSerialNo_sObjectNo_Array[i]);
	    		Sqlca.executeSQL(so);
	    	}
	    }
		 
	 }

}