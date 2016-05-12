/*
		Author: --jschen 2010-03-17
		Tester:
		Describe: --�����������Ŷ��ʱ����ͬʱ�ڶ����Ϣ��CL_INFO������һ�ʼ�¼
		Input Param:
				BCSerialNo�����Э���	
		Output Param:

		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitialInputCLInfo extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	{
		//������
		String sObjectNo = (String)this.getAttribute("BCSerialNo");	
		//ҵ��Ʒ��
		String sBusinessType = "";
		//�ͻ����
		String sCustomerID = "";
		//�ͻ�����		
		String sCustomerName = "";		
		//�Ǽ���
		String sInputUser = "";
		//�Ǽǻ���
		String sInputOrg = "";
		//�����־
		String sFreezeFlag = "";
		 
		SqlObject so=null;
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
	   	
	    //��õ�ǰʱ��
	    String sCurDate = StringFunction.getToday();
	    String sSerialNo="",sClTypeName="",sSql="";
	    
	    //��ȡ��������Ϣ�����뵽CL_INFO����
	    sSql = "select BusinessType,CustomerID,CustomerName,InputUserID,InputOrgID,FreezeFlag from BUSINESS_CONTRACT where SerialNo =:SerialNo";
	    so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
	    ASResultSet rs = Sqlca.getASResultSet(so);
        if(rs.next()){
        	sBusinessType = rs.getString("BusinessType");
        	sCustomerID = rs.getString("CustomerID");
        	sCustomerName = rs.getString("CustomerName");
        	sInputUser = rs.getString("InputUserID");
        	sInputOrg = rs.getString("InputOrgID");
        	sFreezeFlag = rs.getString("FreezeFlag");
        }
	    rs.getStatement().close();
        
	    sSerialNo = DBKeyHelp.getSerialNo("CL_INFO","LineID",Sqlca);
	    so = new SqlObject("select TypeName from Business_Type where typeno=:typeno").setParameter("typeno", sBusinessType);
	    sClTypeName = Sqlca.getString(so);
	    sSql =  " insert into CL_INFO(LineID,CLTypeID,ClTypeName,BCSerialNo,CustomerID,CustomerName, "+
		" FreezeFlag,InputUser,InputOrg,InputTime,UpdateTime) "+
        " values (:LineID,'001',:ClTypeName,:BCSerialNo,:CustomerID, " + 
 	    " :CustomerName,:FreezeFlag,:InputUser,:InputOrg,:InputTime,:UpdateTime)";        
		//ִ�в������
	    so = new SqlObject(sSql);
	    so.setParameter("LineID", sSerialNo).setParameter("ClTypeName", sClTypeName).setParameter("BCSerialNo", sObjectNo)
	    .setParameter("CustomerID", sCustomerID).setParameter("CustomerName", sCustomerName).setParameter("FreezeFlag", sFreezeFlag)
	    .setParameter("InputUser", sInputUser).setParameter("InputTime", sCurDate).setParameter("UpdateTime", sCurDate).setParameter("InputOrg", sInputOrg);
		Sqlca.executeSQL(so);	
		//������������Ϣ
		
		return "1";
	 }
}
