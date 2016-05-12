/*
 * 		Author: sjchuan 2009-09-23
 * 		Tester:
 * 		Describe: ��Ʊ��ҵ��ĺ�ͬ������Ϣ���Ƶ�BUSINESS_PUTOUT����Ʊ����Ϣ�ͳ�����Ϣ�Ĺ������Ƶ�PUTOUT_RELATIVE��
 * 		Input Param:
 * 				ObjectType: ��ͬ����
 * 				ObjectNo: ��ͬ��ˮ��
 * 				UserID���û����
 * 		Output Param:
 * 				SerialNo��������ˮ��
 * 		HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class AddBPandPR extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//��ú�ͬ����
		String sObjectType = (String)this.getAttribute("ObjectType");
		//��ú�ͬ��ˮ��
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//���ҵ��Ʒ��
		String sBusinessType = (String)this.getAttribute("BusinessType");
		//��û�Ʊ���
		String sBillNo = (String)this.getAttribute("BillNo");
		//��ȡ��ǰ�û�
		String sUserID = (String)this.getAttribute("UserID");
		
		SqlObject so = null;//��������
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sBillNo == null) sBillNo = "";
		if(sUserID == null) sUserID = "";
		
		//���������������ˮ��
		String sSerialNo = "";
		//���������������ˮ���ַ�����@�ָ���
		String sSerialNoStr = "";
		//���������Sql���
		String sSql = "";
		//�����������������
		String sOccurType = "";
		//������������״���
		String sExchangeType = "";	
		//ʵ�����û�����
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		//���ݺ�ͬ��ˮ�Ż�ȡ��������
		so = new SqlObject("select OccurType from BUSINESS_CONTRACT where SerialNo =:SerialNo ");
		so.setParameter("SerialNo", sObjectNo);
		sOccurType = Sqlca.getString(so);
		
			//����ֵת��Ϊ���ַ���			
		if(sOccurType == null) sOccurType = "";
	
		//����ҵ��Ʒ�ֻ�ȡ���״���
		so = new SqlObject("select SubTypeCode from BUSINESS_TYPE where TypeNo=:TypeNo ");
		so.setParameter("TypeNo", sBusinessType);
		sExchangeType = Sqlca.getString(so);
		
		//����ֵת��Ϊ���ַ���
		if(sExchangeType == null) sExchangeType = "";
		if(sOccurType.equals("015")) //չ��
		{
			sExchangeType = "6201";
		}
		
		//��ҵ��Ʒ��Ϊ���гжһ�Ʊ���֡���ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ������
		//
		//��ó�����ˮ��
		sSerialNo = DBKeyHelp.getSerialNo("BUSINESS_PUTOUT","SerialNo","",Sqlca);
		//��ΪƱ��ҵ��ĳ������벢���Ƕ�ĳһ�ž����Ʊ����Ϣ���г������룬���Բ�����Ҫ�������Ʊ����Ϣ���Ƶ�������Ϣ���У������Լ������Ĭ��ֵ����
        sBillNo = null;
		String sBillSum ="0.0" ;
		String sRate = "0.0";
		String sMaturity ="";					
		String sEndorseTimes = "0";
		//����ͬ��Ϣ���Ƶ�������Ϣ��
		sSql =  "insert into BUSINESS_PUTOUT ( "+
				"SerialNo, " + 
				"ExchangeType, " +
				"BillNo, " +
				"BillSum, " +
				"BusinessSum, " +
				"BusinessRate, " +
				"Maturity, " +
				"FixCyc, " +												
				"OperateOrgID, " + 
				"OperateUserID, " + 
				"OperateDate, " + 	
				"InputOrgID, " +
				"InputUserID, " + 
				"InputDate, " + 
				"UpdateDate, " + 	
				"ContractSerialNo, " + 
				"ArtificialNo, " + 					
				"CustomerID, " +
				"CustomerName, " +
				"BusinessType, " +				
				"BusinessCurrency, " +
				"ContractSum, " +					
				"TermYear, " +
				"TermMonth, " +
				"TermDay, " +
				"PutoutDate, " +
				"ICType, " +
				"ICCyc, " +
				"PayCyc, " +					
				"CorpusPayMethod, " +
				"CreditAggreement, " +
				"Purpose, " +
				"RateFloatType, " +
				"PdgSum, " +
				"PdgPayMethod, " +
				"ConsignAccountNo, " +
				"AccountNo, " +
				"LoanAccountNo, " +
				"SecondPayAccount, " +					
				"OccurDate, " +					
				"BaseRateType, " +
				"BaseRate, " +
				"RateFloat, " +
				"AdjustRateType, " +
				"AdjustRateTerm, " +
				"AcceptIntType, " +
				"OverIntType, " +
				"RateAdjustCyc, " +
				"PdgAccountNo, " +
				"BailAccount, " +
				"FZANBalance, " +
				"BailCurrency, " +
				"BailRatio, " +
				"RiskRate, " +	
				"PreIntType, " +
				"ResumeIntType " +								
				") "+
				"select "+ 
				"'"+sSerialNo+"', " + 
				"'"+sExchangeType+"', " +	
				"'"+sBillNo+"', " +
				""+sBillSum+", " +
				""+sBillSum+", " +
				""+sRate+", " +
				"'"+sMaturity+"', " +							
				""+sEndorseTimes+", " +	
				"'"+CurUser.getOrgID()+"', " + 
				"'"+CurUser.getUserID()+"', " + 
				"'"+StringFunction.getToday()+"', " + 
				"'"+CurUser.getOrgID()+"', " + 
				"'"+CurUser.getUserID()+"', " + 
				"'"+StringFunction.getToday()+"', " + 
				"'"+StringFunction.getToday()+"', " + 	
				"SerialNo, " + 
				"ArtificialNo, " + 					
				"CustomerID, " +
				"CustomerName, " +
				"BusinessType, " +				
				"BusinessCurrency, " +
				"BusinessSum, " +
				"TermYear, " +
				"TermMonth, " +
				"TermDay, " +
				"'', " +							
				"ICType, " +
				"ICCyc, " +
				"PayCyc, " +					
				"CorpusPayMethod, " +
				"CreditAggreement, " +
				"Purpose, " +
				"RateFloatType, " +
				"PdgSum, " +
				"PdgPayMethod, " +
				"ThirdPartyAccounts, " +
				"AccountNo, " +
				"LoanAccountNo, " +
				"SecondPayAccount, " +
				"OccurDate, " +										
				"BaseRateType, " +
				"BaseRate, " +
				"RateFloat, " +
				"AdjustRateType, " +
				"AdjustRateTerm, " +
				"AcceptIntType, " +
				"OverIntType, " +
				"RateAdjustCyc, " +
				"PdgAccountNo, " +
				"BailAccount, " +
				"PdgRatio, " +
				"BailCurrency, " +
				"BailRatio, " +
				"RiskRate, " +								
				"'0', " +
				"'1' " +							
				"from BUSINESS_CONTRACT " +
				"where SerialNo='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);	
		//����ĳ�γ���������ĳ��Ʊ�ݵĹ���
		sSql =  "insert into PUTOUT_RELATIVE ("+
				"PutOutNo, " +
				"SerialNo, " +
				"OccurDate, " +
				"InputUserID, " +
				"BusinessType " +
				") "+
				"select "+ 
				"'"+sSerialNo+"', " + 
				"SerialNo, " +	
				"'"+StringFunction.getToday()+"', " + 
				"'"+CurUser.getUserID()+"', " + 
				"'"+sBusinessType+"' " + 			
				"from BILL_INFO " +
				"where ObjectNo='"+sObjectNo+"' and ObjectType ='BusinessContract'";
		Sqlca.executeSQL(sSql);
		
		sSerialNoStr = sSerialNoStr + sSerialNo + "@";
		return sSerialNoStr;
	}	
}
