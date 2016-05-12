/*
		Author: --zywei 2005-08-13
		Tester:
		Describe: --����ͬ������Ϣ���Ƶ�������
		Input Param:
				ObjectType: ��������
				ObjectNo: ������ˮ��
				UserID���û�����
		Output Param:
				SerialNo����ͬ��ˮ��
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.product.ProductManage;
import com.amarsoft.app.accounting.util.ACCOUNT_CONSTANTS;
import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class AddPutOutInfo extends Bizlet {

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
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sBusinessType == null) sBusinessType = "";
		if(sBillNo == null) sBillNo = "";
		if(sUserID == null) sUserID = "";
		
		SqlObject so = null; //��������
		
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
		//�����������ѯ�����
		ASResultSet rs = null;
		//ʵ�����û�����
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
		//���ݺ�ͬ��ˮ�Ż�ȡ��������
		sOccurType = Sqlca.getString(new SqlObject("select OccurType from BUSINESS_CONTRACT where SerialNo =:SerialNo").setParameter("SerialNo", sObjectNo));
		//����ֵת��Ϊ���ַ���			
		if(sOccurType == null) sOccurType = "";
	
		//����ҵ��Ʒ�ֻ�ȡ���״���
		sExchangeType = Sqlca.getString(new SqlObject("select SubTypeCode from BUSINESS_TYPE where TypeNo =:TypeNo").setParameter("TypeNo", sBusinessType));
		//����ֵת��Ϊ���ַ���
		if(sExchangeType == null) sExchangeType = "";
		if(sOccurType.equals("015")){ //չ��
			sExchangeType = "6201";
		}
		
		//��ҵ��Ʒ��Ϊ���гжһ�Ʊ���֡���ҵ�жһ�Ʊ���֡�Э�鸶ϢƱ������
		if(sBusinessType.equals("1020010") || sBusinessType.equals("1020020") || sBusinessType.equals("1020030")){
			if(!sBillNo.equals("")){ //�����Ż�Ʊ��Ϣ������������
				sSql = 	" select * from BILL_INFO "+
				" where ObjectType = 'BusinessContract' "+
				" and ObjectNo =:ObjectNo "+
				" and BillNo =:BillNo "+
				" and BillNo not in "+
				" (select BillNo from BUSINESS_PUTOUT "+
				" where ContractSerialNo =:ContractSerialNo)";
				so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("BillNo", sBillNo).setParameter("ContractSerialNo", sObjectNo);
				rs = Sqlca.getASResultSet(so);
			}else{ //�����ֺ�ͬ���µĻ�Ʊ��Ϣ������������
				sSql = 	" select * from BILL_INFO "+
				" where ObjectType = 'BusinessContract' "+
				" and ObjectNo =:ObjectNo"+
				" and BillNo not in "+
				" (select BillNo from BUSINESS_PUTOUT "+
				" where ContractSerialNo =:ContractSerialNo)";
				so = new SqlObject(sSql).setParameter("ObjectNo", sObjectNo).setParameter("ContractSerialNo", sObjectNo);
				rs = Sqlca.getASResultSet(so);
			}
			while(rs.next()){
				//��ó�����ˮ��
				sSerialNo = DBKeyHelp.getSerialNo("BUSINESS_PUTOUT","SerialNo","",Sqlca);
				String billNo = rs.getString("BillNo");
				double billSum = rs.getDouble("BillSum");
				String putoutDate = rs.getString("FinishDate");
				String maturity = rs.getString("Maturity");
				int endorseTimes = rs.getInt("EndorseTimes");
				double rate = rs.getDouble("Rate");
				String holderID = rs.getString("HolderID");
				String currency = rs.getString("LCCurrency");
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
							"ResumeIntType, " +	
							"REPRICETYPE," +
							"REPRICEFLAG," +
							"REPRICECYC," +
							"REPRICEDATE," +
							"LoanRateTermID," +
							"RPTTermID," +
							"ProductVersion," +
							"PutoutStatus " +	
							") "+
							"select "+ 
							"'"+sSerialNo+"', " + 
							"'"+sExchangeType+"', " +	
							"'"+billNo+"', " +
							""+billSum+", " +
							""+billSum+", " +
							""+rate+", " +
							"'"+DateFunctions.getRelativeDate(maturity, DateFunctions.TERM_UNIT_DAY, endorseTimes)+"', " +							
							""+endorseTimes+", " +	
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
							"'"+putoutDate+"', " +							
							"ICType, " +
							"ICCyc, " +
							"PayCyc, " +					
							"CorpusPayMethod, " +
							"CreditAggreement, " +
							"Purpose, " +
							"RateFloatType, " +
							"PdgSum, " +
							"'"+holderID+"', " +
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
							"'1', " +
							"'7'," +
							"''," +
							"0," +//���ַſ�ʱ���ֶ������ͣ�����Ϊ�մ��� 2013-12-14
							"''," +
							"LoanRateTermID," +
							"RPTTermID," +
							"ProductVersion," +
							"'0' " +
							"from BUSINESS_CONTRACT " +
							"where SerialNo= :BCSerialNo";
				Sqlca.executeSQL(new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo));
				
				transferAccountNo(Sqlca.getTransaction(),sObjectNo,sSerialNo);
				transferRate(Sqlca.getTransaction(),sObjectNo,sSerialNo);
				
				transferRPT(Sqlca.getTransaction(),sObjectNo,sSerialNo);
				transferSPT(Sqlca.getTransaction(),sObjectNo,sSerialNo);
				transferFee(Sqlca.getTransaction(),sObjectNo,sSerialNo,CurUser);
				AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
				BusinessObject bp = bom.loadObjectWithKey(BUSINESSOBJECT_CONSTATNTS.business_putout, sSerialNo);
				//	��������
				ProductManage pm= new ProductManage(bom);
				List<BusinessObject> boList = pm.createTermObject("RAT003",bp);
				if(boList != null && !boList.isEmpty())
				{
					boList.get(0).setAttributeValue("BusinessRate", rate);
				}
				bom.updateDB();
				sSerialNoStr = sSerialNoStr + sSerialNo + "@";
			}
			rs.getStatement().close();
		}else{
			//��ȡ��ͬ���ý��
			Bizlet bzGetPutOutSum = new GetPutOutSum();
			bzGetPutOutSum.setAttribute("ContractSerialNo",sObjectNo); 
			bzGetPutOutSum.setAttribute("SerialNo","");				
			String sSurplusPutOutSum = (String)bzGetPutOutSum.run(Sqlca);
			
			//��ó�����ˮ��
			sSerialNo = DBKeyHelp.getSerialNo("BUSINESS_PUTOUT","SerialNo","",Sqlca);
			//����ͬ��Ϣ���Ƶ�������Ϣ��
			sSql =  "insert into BUSINESS_PUTOUT ( "+
						"SerialNo, " + 
						"ExchangeType, " +
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
						"Maturity, " +
						"BusinessRate, " +
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
						"BusinessSum, " +
						"PreIntType, " +						
						"ResumeIntType," +
						"REPRICETYPE," +
						"REPRICEFLAG," +
						"REPRICECYC," +
						"REPRICEDATE," +
						"LoanRateTermID," +
						"RPTTermID," +
						"ProductVersion," +
						"PutoutStatus " +						
						") "+
						"select "+ 
						"'"+sSerialNo+"', " + 
						"'"+sExchangeType+"', " +					
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
						"PutoutDate, " +
						"Maturity, " +
						"BusinessRate, " +
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
						""+sSurplusPutOutSum+", " +
						"'0', " +
						"'1', " +
						"REPRICETYPE," +
						"REPRICEFLAG," +
						"REPRICECYC," +
						"REPRICEDATE," +
						"LoanRateTermID," +
						"RPTTermID," +
						"ProductVersion," +
						"'0' " +		
						"from BUSINESS_CONTRACT " +
						"where SerialNo= :BCSerialNo";
			Sqlca.executeSQL(new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo));
			
			transferAccountNo(Sqlca.getTransaction(),sObjectNo,sSerialNo);
			transferRate(Sqlca.getTransaction(),sObjectNo,sSerialNo);
			transferRPT(Sqlca.getTransaction(),sObjectNo,sSerialNo);
			transferSPT(Sqlca.getTransaction(),sObjectNo,sSerialNo);
			transferFee(Sqlca.getTransaction(),sObjectNo,sSerialNo,CurUser);
			
			sSerialNoStr = sSerialNoStr + sSerialNo + "@";
		}
				
		return sSerialNoStr;
	}	
	
	
	
	/**
	 * �������������Ӧ������
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferRate(JBOTransaction tx,String BCSerialNo,String BPSerialNo) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_rate_segment);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
						.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract)
		                .setParameter("ObjectNo", BCSerialNo)
		                .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
			newCO.setAttributeValue("ObjectNo", BPSerialNo);
			m.saveObject(newCO);
		}
	}
	
	
	/**
	 * �������������Ӧ�Ļ��ʽ
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferRPT(JBOTransaction tx,String BCSerialNo,String BPSerialNo) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_rpt_segment);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
									.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract)
							        .setParameter("ObjectNo", BCSerialNo)
							        .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
			newCO.setAttributeValue("ObjectNo", BPSerialNo);
			m.saveObject(newCO);
		}
	}
	
	
	/**
	 * �������������Ӧ�ķ���
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferFee(JBOTransaction tx,String BCSerialNo,String BPSerialNo,ASUser curUser) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.fee);
		BizObjectManager ms=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.fee_waive);
		BizObjectManager ma=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		tx.join(m);
		tx.join(ms);
		tx.join(ma);
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
								.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract)
						        .setParameter("ObjectNo", BCSerialNo)
						        .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
			newCO.setAttributeValue("ObjectNo", BPSerialNo);
			newCO.setAttributeValue("Status","1");
			newCO.setAttributeValue("AccountingOrgID",curUser.getOrgID());
			m.saveObject(newCO);
			
			String oldFeeSerialNo = biz.getAttribute("SerialNo").getString();
			String feeSerialNo = newCO.getAttribute("SerialNo").getString();
			List<BizObject> feeWaive = ms.createQuery("ObjectType=:ObjectType and ObjectNo=:ObjectNo")
											.setParameter("ObjectNo", oldFeeSerialNo)
											.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee)
											.getResultList(false);
			for(BizObject boWaive : feeWaive)
			{
				BizObject newWaive = ms.newObject();
				newWaive.setAttributesValue(boWaive);
				newWaive.setAttributeValue("SerialNo", null);
				newWaive.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
				newWaive.setAttributeValue("ObjectNo", feeSerialNo);
				ms.saveObject(newWaive);
			}
			
			List<BizObject> boAccounts=ma.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo ")
										.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee)
							            .setParameter("ObjectNo", oldFeeSerialNo)
							            .getResultList(false);
			for(BizObject boAccount:boAccounts){
				BizObject newAccount = ma.newObject();
				newAccount.setAttributesValue(boAccount);
				newAccount.setAttributeValue("SerialNo", null);
				newAccount.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.fee);
				newAccount.setAttributeValue("ObjectNo", feeSerialNo);
				ma.saveObject(newAccount);
			}
		}
	}
	
	/**
	 * �������������Ӧ����Ϣ
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferSPT(JBOTransaction tx,String BCSerialNo,String BPSerialNo) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_spt_segment);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
								.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract)
						        .setParameter("ObjectNo", BCSerialNo)
						        .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
			newCO.setAttributeValue("ObjectNo", BPSerialNo);
			m.saveObject(newCO);
		}
	}
	
	/**
	 * ����������Ϣ���˺���Ϣ
	 * @param tx
	 * @param approveSerialNo
	 * @throws Exception
	 */
	private void transferAccountNo(JBOTransaction tx,String BCSerialNo,String BPSerialNo) throws Exception{
		BizObjectManager m=JBOFactory.getBizObjectManager(BUSINESSOBJECT_CONSTATNTS.loan_accounts);
		tx.join(m);
		List<BizObject> lstbiz=m.createQuery("ObjectType = :ObjectType and ObjectNo = :ObjectNo")
								.setParameter("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_contract)
						        .setParameter("ObjectNo", BCSerialNo)
						        .getResultList(false);
		for(BizObject biz:lstbiz){
			BizObject newCO = m.newObject();
			newCO.setAttributesValue(biz);
			newCO.setAttributeValue("SerialNo", null);
			newCO.setAttributeValue("ObjectType", BUSINESSOBJECT_CONSTATNTS.business_putout);
			newCO.setAttributeValue("ObjectNo", BPSerialNo);
			m.saveObject(newCO);
		}
	}
}
