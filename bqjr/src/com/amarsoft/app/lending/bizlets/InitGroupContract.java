/*
 *	Author: jgao1 2009-10-22
 *	Tester:
 *	Describe: �������Ŷ�����ɼ��ų�Ա�����Ŷ�Ⱥ�ͬ��������CL_INFO��
 *	Input Param: 			
 *	Output Param:			
 *	HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitGroupContract extends Bizlet{

	public Object  run(Transaction Sqlca) throws Exception{			
		//���������Ŷ�Ⱥ�ͬ���
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		
		String sSql = "";
		SqlObject so ;//��������
		ASResultSet rs = null;
		String gLine = "";//�ڼ�������Gline_INFO�е�Э���
		String sLine = "";
		String iLine = "";//��CL_INFO�б�־�����ų�Ա���Э���
		String sBBCSerialno = "";//���Ÿ���Ա��ͬ��		
		//��CL_INFO��ȡ�ü������Ŷ������ͬ��Э���
		sSql = " select LineID from CL_INFO where BCSerialNo=:BCSerialNo order by LineID";
		so = new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo);
		sLine = Sqlca.getString(so);
		if(sLine == null) sLine = "";
		//��GLINE_INFO��ȡ�ü��ų�Ա���Э���
		sSql = " select LineID from GLINE_INFO where BCSerialNo =:BCSerialNo and ParentLineID =:ParentLineID order by LineID";
		so = new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo).setParameter("ParentLineID", sLine);
		rs=Sqlca.getASResultSet(so);
		while(rs.next()){
			gLine = rs.getString("LineID");
			if(gLine == null) gLine="";
			//�Ȼ�ü��ų�Ա�ĺ�ͬ��
			sBBCSerialno = AddContractInfo(sObjectNo,gLine,Sqlca);
			//��ü��ų�Ա��Э���
			iLine=AddCLInfo(gLine,sLine,Sqlca);
			UpdateCLInfo(sBBCSerialno,iLine,Sqlca);			
		}
		rs.getStatement().close();
	    return "true";	    
	 }
	
	/*
	 * Ϊÿ�����ų�Ա��CL_INFO��������¼��
	 */
	private String AddCLInfo(String gLine,String groupID,Transaction Sqlca) throws Exception{
		//groupIDΪ�������Ŷ�ȵ�CL_INFOЭ���
		if(groupID==null) groupID="";
		if(gLine==null) gLine="";
		String cLine="";
		cLine = DBKeyHelp.getSerialNo("CL_INFO","LineID",Sqlca);
		//��ʱ����Ϊȫ�����룬����Ҫ���º�ͬ�ֶ��Լ�һЩ�������ֶα�֤��ȷ�������ɵ�Э�����ParentLineIDΪ�գ�Ϊ����չ��ҵ��Ʒ��ʱ�ķ����Լ�ƥ��CL_INFO���߼�
		String insertSql = " insert into CL_INFO(LINEID,CLTYPEID,CLTYPENAME,APPLYSERIALNO,APPROVESERIALNO,BCSERIALNO,LINECONTRACTNO,CUSTOMERID,CUSTOMERNAME,"+
	 					" LINESUM1,LINESUM2,LINESUM3,CURRENCY,LINEEFFDATE,LINEEFFFLAG,PUTOUTDEADLINE,MATURITYDEADLINE,ROTATIVE,APPROVALPOLICY,FREEZEFLAG,"+
	 					" RECENTCHECK,RECENTCHECKSTATUS,CHECKRESULT,OVERFLOWTYPE,INPUTUSER,INPUTORG,INPUTTIME,UPDATETIME,BEGINDATE,ENDDATE,"+
	 					" USEORGID,USEORGNAME,BAILRATIO,BUSINESSTYPE,USEDSUM,USABLESUM,CALCULATETIME,SUBBALANCE,GROUPLINEID)"+
	                    " select '"+cLine+"',CLTYPEID,getBusinessName('3020010') as CLTYPENAME,APPLYSERIALNO,APPROVESERIALNO,BCSERIALNO,LINECONTRACTNO,CUSTOMERID,CUSTOMERNAME,"+
	                    " LINESUM1,LINESUM2,LINESUM3,CURRENCY,LINEEFFDATE,LINEEFFFLAG,PUTOUTDEADLINE,MATURITYDEADLINE,ROTATIVE,APPROVALPOLICY,'1',"+
	                    " RECENTCHECK,RECENTCHECKSTATUS,CHECKRESULT,OVERFLOWTYPE,INPUTUSER,INPUTORG,INPUTTIME,UPDATETIME,BEGINDATE,ENDDATE,"+
	                    " USEORGID,USEORGNAME,BAILRATIO,BUSINESSTYPE,USEDSUM,USABLESUM,CALCULATETIME,SUBBALANCE,'"+groupID+"' "+
	                    " from GLINE_INFO "+
	                    " where LineID='"+gLine+"'";
		Sqlca.executeSQL(insertSql);
		return cLine;
	}
	
	 /*
	  * ����CL_INFO���߼������ͬǩ��һ��
	  */
	private void UpdateCLInfo(String bcSerialNo,String cLine,Transaction Sqlca) throws Exception{
		//��Ա��ͬ��
		if(bcSerialNo==null) bcSerialNo="";
		//��ԱCL_INFOЭ���
		if(cLine==null) cLine="";
		String updatesql = " update CL_INFO set(BCSerialNo,LineSum1,Currency,PutOutDeadLine,LineEffDate,BeginDate,EndDate,MaturityDeadLine,Rotative)= "+
		" (select SerialNo,BusinessSum,BusinessCurrency,LimitationTerm,BeginDate,PutOutDate,Maturity,UseTerm,CreditCycle "+
		" from BUSINESS_CONTRACT "+
		" where SerialNo=:SerialNo) "+
		" where LineID=:LineID";
	    SqlObject so  = new SqlObject(updatesql).setParameter("SerialNo", bcSerialNo).setParameter("LineID", cLine);
	    Sqlca.executeSQL(so);
	}
 
 	/*
 	 * Ϊÿ�����ų�Ա�������Ŷ�Ⱥ�ͬ
 	 */
 	private String AddContractInfo(String bcSerialNo,String gline,Transaction Sqlca) throws Exception{
 		//�ж��Ƿ�Ϊ��
 		if(bcSerialNo==null) bcSerialNo="";
 		if(gline==null) gline="";
 		//�����Ӻ�ͬ��ˮ�ţ��ͻ���ţ��ͻ����ƣ����֣��Ƿ�ѭ��
 		String nSerialNo="",sCustomerID="",sCustomerName="",sCurrency="",sRotative="";
 		//���弯�ų�Ա�����޶��֤�����
 		double dLineSum1=0.0,dBailratio=0.0;
 		ASResultSet rs=null;
 		//�Ӽ��ų�Ա���Ŷ��GLINE_INFO����ȡ��ÿ���ͻ������ƣ������޶����ϢԪ��
 		String sSql = " select CustomerID,CustomerName,LineSum1,Currency,Rotative,Bailratio from GLINE_INFO where LineID=:LineID";
 		SqlObject so = new SqlObject(sSql).setParameter("LineID", gline);
 		rs=Sqlca.getASResultSet(so);
 		if(rs.next()){
 			//���ų�Ա�ͻ����
 			sCustomerID=rs.getString("CustomerID");
 			sCustomerName=rs.getString("CustomerName");
 			//��Ӧ�������Ŷ�ȵ�BusinessSum
 			dLineSum1=rs.getDouble("LineSum1");
 			//��Ӧ�������Ŷ�ȵı���
 			sCurrency=rs.getString("Currency");
 			//�Ƿ��ѭ������Ӧ��ͬ��CREDITCYCLE
 			sRotative=rs.getString("Rotative");
 			dBailratio=rs.getDouble("Bailratio");
 		}
 		rs.getStatement().close();
 		if(sCustomerID==null) sCustomerID="";
 		if(sCustomerName==null) sCustomerName="";
 		if(sCurrency==null) sCurrency="";
 		if(sRotative==null) sRotative="";
 		//���ɼ��ų�Ա�ĺ�ͬ��
 		nSerialNo = DBKeyHelp.getSerialNo("BUSINESS_CONTRACT","SerialNo",Sqlca);
 		//��ʱ����Ϊȫ�����룬����Ҫ���º�ͬ�ֶ��Լ�һЩ�������ֶα�֤��ȷ��GroupLineIDΪ�����ܶ�Ⱥ�ͬ��
 		String insertSql = " insert into BUSINESS_CONTRACT(SERIALNO,RELATIVESERIALNO,ARTIFICIALNO,OCCURDATE,CUSTOMERID,CUSTOMERNAME,BUSINESSTYPE,OLDBUSINESSTYPE,"+
	 					" BUSINESSSUBTYPE,OCCURTYPE,CREDITDIGEST,CREDITCYCLE,CREDITTYPE,CURRENYLIST,CURRENCYMODE,BUSINESSTYPELIST,CALCULATEMODE,USEORGLIST,"+
	 					" FLOWREDUCEFLAG,CONTRACTFLAG,SUBCONTRACTFLAG,SELFUSEFLAG,CREDITINDEX,CREDITREDUCESUM,LIMITATIONTERM,USETERM,CREDITAGGREEMENT,RELATIVEAGREEMENT,"+
	 					" LOANFLAG,TOTALSUM,OURROLE,REVERSIBILITY,BILLNUM,HOUSETYPE,LCTERMTYPE,RISKATTRIBUTE,SURETYPE,SAFEGUARDTYPE,CREDITBUSINESS,BUSINESSCURRENCY,BUSINESSSUM,"+
	 					" BUSINESSPROP,TERMYEAR,TERMMONTH,TERMDAY,LGTERM,BASERATETYPE,BASERATE,RATEFLOATTYPE,RATEFLOAT,BUSINESSRATE,ICTYPE,ICCYC,PDGRATIO,PDGSUM,PDGPAYMETHOD,"+
	 					" PDGPAYPERIOD,PROMISESFEERATIO,PROMISESFEESUM,PROMISESFEEPERIOD,PROMISESFEEBEGIN,MFEERATIO,MFEESUM,MFEEPAYMETHOD,AGENTFEE,DEALFEE,TOTALCAST,DISCOUNTINTEREST,"+
	 					" PURCHASERINTEREST,BARGAINORINTEREST,DISCOUNTSUM,BAILRATIO,BAILCURRENCY,BAILSUM,BAILACCOUNT,FINERATETYPE,FINERATE,DRAWINGTYPE,FIRSTDRAWINGDATE,"+
	 					" DRAWINGPERIOD,PAYTIMES,PAYCYC,GRACEPERIOD,OVERDRAFTPERIOD,OLDLCNO,OLDLCTERMTYPE,REMITMODE,OLDLCSUM,OLDLCLOADINGDATE,OLDLCVALIDDATE,DIRECTION,PURPOSE,"+
	 					" PLANALLOCATION,IMMEDIACYPAYSOURCE,PAYSOURCE,CORPUSPAYMETHOD,INTERESTPAYMETHOD,PUTOUTDATE,MATURITY,THIRDPARTY1,THIRDPARTYID1,THIRDPARTY2,THIRDPARTYID2,THIRDPARTY3,"+
	 					" THIRDPARTYID3,THIRDPARTYREGION,THIRDPARTYACCOUNTS,CARGOINFO,PROJECTNAME,OPERATIONINFO,CONTEXTINFO,SECURITIESTYPE,SECURITIESREGION,CONSTRUCTIONAREA,USEAREA,"+
	 					" FLAG1,FLAG2,FLAG3,TRADECONTRACTNO,INVOICENO,TRADECURRENCY,TRADESUM,LCNO,PAYMENTDATE,OPERATIONMODE,BEGINDATE,ENDDATE,VOUCHCLASS,VOUCHTYPE,VOUCHTYPE1,VOUCHTYPE2,"+
	 					" VOUCHFLAG,WARRANTOR,WARRANTORID,OTHERCONDITION,GUARANTYVALUE,GUARANTYRATE,BASEEVALUATERESULT,RISKRATE,LOWRISK,OTHERAREALOAN,LOWRISKBAILSUM,APPLYTYPE,"+
	 					" ORIGINALPUTOUTDATE,EXTENDTIMES,LNGOTIMES,GOLNTIMES,DRTIMES,GUARANTYNO,PUTOUTSUM,ACTUALPUTOUTSUM,BALANCE,NORMALBALANCE,OVERDUEBALANCE,DULLBALANCE,BADBALANCE,"+
	 					" INTERESTBALANCE1,INTERESTBALANCE2,FINEBALANCE1,FINEBALANCE2,OVERDUEDAYS,OWEINTERESTDAYS,TABALANCE,TAINTERESTBALANCE,TATIMES,LCATIMES,PBINTERESTSUM,PBMFEESUM,"+
	 					" PBPDGSUM,PBLEGALCOSTSUM,POLEGALCOSTSUM,ORIGINALBADDATE,BASECLASSIFYRESULT,CLASSIFYRESULT,CLASSIFYTYPE,CLASSIFYDATE,CLASSIFYORGID,RESERVESUM,EXPECTLOSSSUM,"+
	 					" BAILRATE,FINISHORG,FINISHTYPE,FINISHDATE,DESCRIBE1,REINFORCEFLAG,MANAGEORGID,MANAGEUSERID,RECOVERYORGID,RECOVERYUSERID,STATORGID,STATUSERID,OPERATEORGID,"+
	 					" OPERATEUSERID,OPERATEDATE,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,PIGEONHOLEDATE,REMARK,FLAG4,PAYCURRENCY,PAYDATE,FLAG5,CLASSIFYSUM1,CLASSIFYSUM2,"+
	 					" CLASSIFYSUM3,CLASSIFYSUM4,CLASSIFYSUM5,SHIFTTYPE,OPERATETYPE,FUNDSOURCE,CYCLEFLAG,CREDITFREEZEFLAG,SHIFTBALANCE,CLASSIFYFREQUENCY,CLASSIFYLEVEL,VOUCHNEWFLAG,"+
	 					" ACTUALARTIFICIALNO,DELETEFLAG,ACCOUNTNO,LOANACCOUNTNO,SECONDPAYACCOUNT,ADJUSTRATETYPE,ADJUSTRATETERM,OVERINTTYPE,RATEADJUSTCYC,PDGACCOUNTNO,DEDUCTDATE,"+
	 					" FZANBALANCE,ACCEPTINTTYPE,RATIO,THIRDPARTYADD1,THIRDPARTYZIP1,THIRDPARTYADD2,THIRDPARTYZIP2,THIRDPARTYADD3,THIRDPARTYZIP3,EFFECTAREA,TERMDATE1,TERMDATE2,"+
	 					" TERMDATE3,FIXCYC,DESCRIBE2,CANCELSUM,CANCELINTEREST,LOANTERM,PUTOUTORGID,TEMPSAVEFLAG,OVERDUEDATE,OWEINTERESTDATE,FREEZEFLAG,APPROVEDATE,SHIFTSTATUS,"+
	 					" RECOVERYCOGNORGID,RECOVERYCOGNUSERID,SHIFTDOCDESCRIBE,GUARANTYFLAG,TOTALBALANCE,GROUPLINEID) "+
	                    " select '"+nSerialNo+"',RELATIVESERIALNO,ARTIFICIALNO,OCCURDATE,'"+sCustomerID+"','"+sCustomerName+"','3020010' as BUSINESSTYPE,OLDBUSINESSTYPE,"+
	 					" BUSINESSSUBTYPE,OCCURTYPE,CREDITDIGEST,'"+sRotative+"',CREDITTYPE,CURRENYLIST,CURRENCYMODE,BUSINESSTYPELIST,CALCULATEMODE,USEORGLIST,"+
	 					" FLOWREDUCEFLAG,CONTRACTFLAG,SUBCONTRACTFLAG,SELFUSEFLAG,CREDITINDEX,CREDITREDUCESUM,LIMITATIONTERM,USETERM,CREDITAGGREEMENT,RELATIVEAGREEMENT,"+
	 					" LOANFLAG,TOTALSUM,OURROLE,REVERSIBILITY,BILLNUM,HOUSETYPE,LCTERMTYPE,RISKATTRIBUTE,SURETYPE,SAFEGUARDTYPE,CREDITBUSINESS,'"+sCurrency+"',"+dLineSum1+","+
	 					" BUSINESSPROP,TERMYEAR,TERMMONTH,TERMDAY,LGTERM,BASERATETYPE,BASERATE,RATEFLOATTYPE,RATEFLOAT,BUSINESSRATE,ICTYPE,ICCYC,PDGRATIO,PDGSUM,PDGPAYMETHOD,"+
	 					" PDGPAYPERIOD,PROMISESFEERATIO,PROMISESFEESUM,PROMISESFEEPERIOD,PROMISESFEEBEGIN,MFEERATIO,MFEESUM,MFEEPAYMETHOD,AGENTFEE,DEALFEE,TOTALCAST,DISCOUNTINTEREST,"+
	 					" PURCHASERINTEREST,BARGAINORINTEREST,DISCOUNTSUM,"+dBailratio+",BAILCURRENCY,BAILSUM,BAILACCOUNT,FINERATETYPE,FINERATE,DRAWINGTYPE,FIRSTDRAWINGDATE,"+
	 					" DRAWINGPERIOD,PAYTIMES,PAYCYC,GRACEPERIOD,OVERDRAFTPERIOD,OLDLCNO,OLDLCTERMTYPE,REMITMODE,OLDLCSUM,OLDLCLOADINGDATE,OLDLCVALIDDATE,DIRECTION,PURPOSE,"+
	 					" PLANALLOCATION,IMMEDIACYPAYSOURCE,PAYSOURCE,CORPUSPAYMETHOD,INTERESTPAYMETHOD,PUTOUTDATE,MATURITY,THIRDPARTY1,THIRDPARTYID1,THIRDPARTY2,THIRDPARTYID2,THIRDPARTY3,"+
	 					" THIRDPARTYID3,THIRDPARTYREGION,THIRDPARTYACCOUNTS,CARGOINFO,PROJECTNAME,OPERATIONINFO,CONTEXTINFO,SECURITIESTYPE,SECURITIESREGION,CONSTRUCTIONAREA,USEAREA,"+
	 					" FLAG1,FLAG2,FLAG3,TRADECONTRACTNO,INVOICENO,TRADECURRENCY,TRADESUM,LCNO,PAYMENTDATE,OPERATIONMODE,BEGINDATE,ENDDATE,VOUCHCLASS,VOUCHTYPE,VOUCHTYPE1,VOUCHTYPE2,"+
	 					" VOUCHFLAG,WARRANTOR,WARRANTORID,OTHERCONDITION,GUARANTYVALUE,GUARANTYRATE,BASEEVALUATERESULT,RISKRATE,LOWRISK,OTHERAREALOAN,LOWRISKBAILSUM,APPLYTYPE,"+
	 					" ORIGINALPUTOUTDATE,EXTENDTIMES,LNGOTIMES,GOLNTIMES,DRTIMES,GUARANTYNO,PUTOUTSUM,ACTUALPUTOUTSUM,BALANCE,NORMALBALANCE,OVERDUEBALANCE,DULLBALANCE,BADBALANCE,"+
	 					" INTERESTBALANCE1,INTERESTBALANCE2,FINEBALANCE1,FINEBALANCE2,OVERDUEDAYS,OWEINTERESTDAYS,TABALANCE,TAINTERESTBALANCE,TATIMES,LCATIMES,PBINTERESTSUM,PBMFEESUM,"+
	 					" PBPDGSUM,PBLEGALCOSTSUM,POLEGALCOSTSUM,ORIGINALBADDATE,BASECLASSIFYRESULT,CLASSIFYRESULT,CLASSIFYTYPE,CLASSIFYDATE,CLASSIFYORGID,RESERVESUM,EXPECTLOSSSUM,"+
	 					" BAILRATE,FINISHORG,FINISHTYPE,FINISHDATE,DESCRIBE1,REINFORCEFLAG,MANAGEORGID,MANAGEUSERID,RECOVERYORGID,RECOVERYUSERID,STATORGID,STATUSERID,OPERATEORGID,"+
	 					" OPERATEUSERID,OPERATEDATE,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,'"+StringFunction.getToday()+"',REMARK,FLAG4,PAYCURRENCY,PAYDATE,FLAG5,CLASSIFYSUM1,CLASSIFYSUM2,"+
	 					" CLASSIFYSUM3,CLASSIFYSUM4,CLASSIFYSUM5,SHIFTTYPE,OPERATETYPE,FUNDSOURCE,CYCLEFLAG,CREDITFREEZEFLAG,SHIFTBALANCE,CLASSIFYFREQUENCY,CLASSIFYLEVEL,VOUCHNEWFLAG,"+
	 					" ACTUALARTIFICIALNO,DELETEFLAG,ACCOUNTNO,LOANACCOUNTNO,SECONDPAYACCOUNT,ADJUSTRATETYPE,ADJUSTRATETERM,OVERINTTYPE,RATEADJUSTCYC,PDGACCOUNTNO,DEDUCTDATE,"+
	 					" FZANBALANCE,ACCEPTINTTYPE,RATIO,THIRDPARTYADD1,THIRDPARTYZIP1,THIRDPARTYADD2,THIRDPARTYZIP2,THIRDPARTYADD3,THIRDPARTYZIP3,EFFECTAREA,TERMDATE1,TERMDATE2,"+
	 					" TERMDATE3,FIXCYC,DESCRIBE2,CANCELSUM,CANCELINTEREST,LOANTERM,PUTOUTORGID,TEMPSAVEFLAG,OVERDUEDATE,OWEINTERESTDATE,FREEZEFLAG,APPROVEDATE,SHIFTSTATUS,"+
	 					" RECOVERYCOGNORGID,RECOVERYCOGNUSERID,SHIFTDOCDESCRIBE,GUARANTYFLAG,TOTALBALANCE,'"+bcSerialNo+"' "+
	                    " from BUSINESS_CONTRACT "+
	                    " where SerialNo='"+bcSerialNo+"'";
 		Sqlca.executeSQL(insertSql);
 		return nSerialNo;
 	}
}