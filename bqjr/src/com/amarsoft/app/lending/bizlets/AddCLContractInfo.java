/*
 *		Author: jgao1 2009-10-27
 *		Tester:
 *		Describe: ��ȵ���ʱ������CL_INFO
 *		Input Param:
 *		updatesuer:yhshan
 *      updatedate:2012/09/12
 *		HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class AddCLContractInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		//��ͬ��ˮ��
		String sBCSerialNo = (String)this.getAttribute("SerialNo");	
		//���Ž��
		String sBusinessSum = (String)this.getAttribute("BusinessSum");
		//����
		String sCurrency = (String)this.getAttribute("BusinessCurrency");
		//�����Ч��
		String sBeginDate = (String)this.getAttribute("BeginDate");
		//�����ʼ��
		String sPutOutDate = (String)this.getAttribute("PutOutDate");
		//��ȵ�����
		String sMaturity = (String)this.getAttribute("Maturity");
		//���ʹ���������
		String sLimitationTerm = (String)this.getAttribute("LimitationTerm");
		//�������ҵ����ٵ�������
		String sUseTerm = (String)this.getAttribute("UseTerm");
		//�Ǽ���
		String sInputUser = (String)this.getAttribute("InputUser");
		
		//����ֵת��Ϊ���ַ���
		if(sBCSerialNo == null) sBCSerialNo = "";		
		if(sBusinessSum == null) sBusinessSum = "";
		if(sCurrency == null) sCurrency = "";
		if(sPutOutDate == null) sPutOutDate = "";
		if(sMaturity == null) sMaturity = "";
		if(sLimitationTerm == null) sLimitationTerm = "";
		if(sUseTerm == null) sUseTerm = "";
		if(sBeginDate == null) sBeginDate = "";
		if(sInputUser == null) sInputUser = "";
		
		double dBusinessSum = DataConvert.toDouble(sBusinessSum);
		
		//��õ�ǰʱ��
	    String sCurDate = StringFunction.getToday();
	    //��ȡ�û�ʵ��
	    ASUser CurUser = ASUser.getUser(sInputUser,Sqlca);
	    String sSql = " update CL_INFO set LineSum1 =:LineSum1, "+
		  " Currency =:Currency,LineEffDate =:LineEffDate, "+
		  " BeginDate =:BeginDate,PutOutDeadLine =:PutOutDeadLine, "+
		  " MaturityDeadLine =:MaturityDeadLine,EndDate =:EndDate, "+
		  " InputOrg =:InputOrg,InputUser =:InputUser, "+
		  " InputTime =:InputTime,UpdateTime =:UpdateTime "+
		  " where BCSerialNo =:BCSerialNo  and ParentLineID is null or ParentLineID='' or ParentLineID=' ' ";
	    SqlObject so = new SqlObject(sSql).setParameter("LineSum1", dBusinessSum).setParameter("Currency", sCurrency).setParameter("LineEffDate", sBeginDate)
	    .setParameter("BeginDate", sPutOutDate).setParameter("PutOutDeadLine", sLimitationTerm).setParameter("MaturityDeadLine", sUseTerm).setParameter("EndDate", sMaturity)
	    .setParameter("InputOrg", CurUser.getOrgID()).setParameter("InputUser", CurUser.getUserID()).setParameter("InputTime", sCurDate).setParameter("UpdateTime", sCurDate)
	    .setParameter("BCSerialNo", sBCSerialNo);
	    Sqlca.executeSQL(so);

		
		return "1";			
	}	
}
