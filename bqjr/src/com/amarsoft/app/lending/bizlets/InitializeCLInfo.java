/*
 		Author: --κ���� 2005-11-23
		Tester:
		Describe: --�������Ŷ�������¼ʱ����ͬʱ�ڶ����Ϣ��CL_INFO������һ�ʼ�¼
		Input Param:
				ObjectNo��������
				BusinessType��ҵ��Ʒ��
				CustomerID: �ͻ�����
				CustomerName: �ͻ�����				
		Output Param:

		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitializeCLInfo extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");	
		//ҵ��Ʒ��
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//�ͻ����
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//�ͻ�����		
		String sCustomerName = (String)this.getAttribute("CustomerName");		
		//�Ǽ���
		String sInputUser = (String)this.getAttribute("InputUser");
		//�Ǽǻ���
		String sInputOrg = (String)this.getAttribute("InputOrg");
		
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sCustomerID == null) sCustomerID = "";
	    if(sCustomerName == null) sCustomerName = "";
	    if(sInputUser == null) sInputUser = "";
	    if(sInputOrg == null) sInputOrg = "";
	   	SqlObject so ;
	    //��õ�ǰʱ��
	    String sCurDate = StringFunction.getToday();
	    String sSerialNo="",sClTypeName="",sSql="";
	    
	    
        sSql =  " insert into Business_Apply(Serialno) "+
        " values (:sSerialNo)";
        so = new SqlObject(sSql);
        so.setParameter("sSerialNo", sObjectNo);
	    //ִ�в������
	    Sqlca.executeSQL(so);
	    
	    
	    
	    //���ҵ��Ʒ���Ƕ�ȣ�������ڶ����Ϣ��CL_INFO�в���һ����Ϣ
	    if(sBusinessType.startsWith("3"))
	    {
	        sSerialNo = DBKeyHelp.getSerialNo("CL_INFO","LineID",Sqlca);
	        
	         sSql = "select TypeName from Business_Type where typeno=:typeno";
	         so = new SqlObject(sSql).setParameter("typeno", sBusinessType);
	         sClTypeName = Sqlca.getString(so);

	         sSql =  " insert into CL_INFO(LineID,CLTypeID,ClTypeName,ApplySerialNo,CustomerID,CustomerName, "+
     		" FreezeFlag,InputUser,InputOrg,InputTime,UpdateTime) "+
             " values (:LineID,'001',:ClTypeName,:ApplySerialNo,:CustomerID, " + 
      	    " :CustomerName,'1',:InputUser,:InputOrg,:InputTime,:UpdateTime)"; 
	         so = new SqlObject(sSql);
	         so.setParameter("LineID", sSerialNo).setParameter("ClTypeName", sClTypeName).setParameter("ApplySerialNo", sObjectNo)
	         .setParameter("CustomerID", sCustomerID).setParameter("InputUser", sInputUser).setParameter("InputOrg", sInputOrg)
	         .setParameter("InputTime", sCurDate).setParameter("UpdateTime", sCurDate).setParameter("CustomerName", sCustomerName);
		     //ִ�в������
		     Sqlca.executeSQL(so);
	    }	    
		return "1";
	 }
}
