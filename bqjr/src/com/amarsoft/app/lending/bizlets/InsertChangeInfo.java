package com.amarsoft.app.lending.bizlets;

import java.sql.PreparedStatement;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;
import com.amarsoft.core.util.StringUtil;

public class InsertChangeInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sMobilePhone = (String)this.getAttribute("MobilePhone");
		//����ֵת��Ϊ���ַ���
		if(sSerialNo == null) sSerialNo = "";
		
		//�������
		ASResultSet rs = null;
		String sSql = "";
		String sBCSerialno="";       //��ͬ��ˮ��
		String sCustomerID="";     //�ͻ�ID
	    String sCustomerName="";   //�ͻ�����
	    String sCertID = "";       //֤������
	   // String sTelPhone="";      //�ֻ�����
	    String sReplaceAccount="";   //�ɴ����˻����
	    String sReplaceName = "";     //�ɴ����˻�����
	    String sOpenBank="";      //�ɴ����˻������� 
	    String sCity = "";     //���ڴ����˺�ʡ��
	    String sRepaymentWay = "";     //���ʽ
	    String sInputUserID="";   //¼���û�
	    String sInputOrgID = "";     //¼�����
	    String sInputDate="";      //¼������
	    String sApplySerialno= "";      //������ˮ��
		//int iCount = 0;
		
		//ʵ�����û�����
		SqlObject so = null; //��������
		//���ݺ�ͬ��ˮ�Ų�ѯ��Ҫ�����������˻���Ϣ��WITHHOLD_CHARGE_INFO�е��ֶΡ�
		sSql = 	" select serialNo,CustomerID,CustomerName,CertID,ReplaceAccount,ReplaceName,OpenBank,city,repaymentway,"
				+ "InputUserID,InputOrgID,InputDate,applyserialno from BUSINESS_CONTRACT "+
		" where SerialNo =:SerialNo "; 
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
		rs = Sqlca.getASResultSet(so);
		while(rs.next()){
			sBCSerialno = rs.getString("serialNo");
			sCustomerID = rs.getString("CustomerID");
			sCustomerName = rs.getString("CustomerName");
			sCertID = rs.getString("CertID");
			//sTelPhone = rs.getString("MobilePhone");
			sReplaceAccount = rs.getString("ReplaceAccount");
			sReplaceAccount = StringUtil.trimToEmpty(sReplaceAccount);//���������ݿ����NULL�ַ���
			sReplaceName = rs.getString("ReplaceName");
			sReplaceName = StringUtil.trimToEmpty(sReplaceName);//���������ݿ����NULL�ַ���
			sOpenBank = rs.getString("OpenBank");
			sOpenBank = StringUtil.trimToEmpty(sOpenBank);//���������ݿ����NULL�ַ���
			sCity = rs.getString("city");
			sCity = StringUtil.trimToEmpty(sCity);//���������ݿ����NULL�ַ���
			sRepaymentWay = rs.getString("repaymentway");
			sInputUserID = rs.getString("InputUserID");
			sInputOrgID = rs.getString("InputOrgID");
			sInputDate = rs.getString("InputDate");
			sApplySerialno = rs.getString("applyserialno");
			
			sSql =  "insert into WITHHOLD_CHARGE_INFO ( "+
					"SerialNo, " + 
					"ApplySerialNo, " + 
					"ContractSerialNo, " +
					"CustomerName, " +
					"CustomerID, " +
					"CertID, " +
					"TelPhone, " +
					"OldAccount, " +
					"OldAccountName, " +												
					"OldBankName, " + 
					"OldCity, " +
					"OldRepaymentWay, " +
					"InputUserID, " + 
					"InputOrgID, " + 	
					"InputDate, " +
					"ApplicationType, " +
					"Status " +
					") "+
					"select "+ 
					"'"+DBKeyHelp.getSerialNo("WITHHOLD_CHARGE_INFO","SerialNo","",Sqlca)+"', " + 
					"'"+sApplySerialno+"', " + 
					"'"+sBCSerialno+"', " +	
					"'"+sCustomerName+"', " +
					"'"+sCustomerID+"', " +
					"'"+sCertID+"', " +
					"'"+sMobilePhone+"', " +
					"'"+sReplaceAccount+"', " +							
					"'"+sReplaceName+"', " +	
					"'"+sOpenBank+"', " + 
					"'"+sCity+"', " + 
					"'"+sRepaymentWay+"', " + 
					"'"+sInputUserID+"', " + 
					"'"+sInputOrgID+"', " + 
					"'"+sInputDate+"', " + 
					"'01', " + 
					"'01' " +
					"from BUSINESS_CONTRACT " +
					"where SerialNo= '"+sSerialNo+"'";
			Sqlca.executeSQL(sSql);
			
		}
		rs.getStatement().close();
		return "success";
	}
	
}
