/*
 *	Author: jgao1 2009-10-22
 *	Tester:
 *	Describe: ��������ֵ׼���϶����̳�ʼ��ʱ����Reserve_Total�е����ݸ��Ƶ�Reserve_Apply
 *	Input Param: 	
 *			SerialNo����������ֵ׼��������ˮ��		
 *	Output Param:			
 *	HistoryLog:
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReserveInitApply extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception {			
		//������ˮ��
		String sSerialNo = (String)this.getAttribute("SerialNo");
		if(sSerialNo == null) sSerialNo = "";
		
		String sSql = "",sAccountMonth="",sDuebillNo="",sAvailFlag="";
		ASResultSet rs=null;
		SqlObject so; //��������
		//���������RESERVE_APPLYȡ�û���·ݺͽ�ݺ�
		sSql = "select AccountMonth,DuebillNo,AvailAbilityFlag from RESERVE_APPLY where SerialNo=:SerialNo";
		so = new SqlObject(sSql).setParameter("SerialNo", sSerialNo);
		rs = Sqlca.getASResultSet(so);
		if (rs.next()){
			sAccountMonth = rs.getString("AccountMonth");
			sDuebillNo = rs.getString("DuebillNo");	
			sAvailFlag = rs.getString("AvailAbilityFlag");
		}
		rs.getStatement().close();
		if(sAccountMonth == null) sAccountMonth = "";
		if(sDuebillNo == null) sDuebillNo = "";
		if(sAvailFlag == null) sAvailFlag = "";
		String sDBName = Sqlca.getConnection().getMetaData().getDatabaseProductName().toUpperCase();
		if(sDBName.startsWith("INFORMIX"))
		{
			sSql = " update RESERVE_APPLY set (SUBJECTNO,CERTTYPE,CERTID,INDUSTRYGRADE,ISMSINDUSTRY,BELONGAREA,ISMARKET,BUSINESSTYPE,INDUSTRYTYPE,PUTOUTORGID,PUTOUTSUM,"+
			   " PUTOUTDATE,VOUCHTYPE,CURRENCY,EXCHANGERATE,MATURITY,CONTRACTRATE,OCCUREXPENSES,AUDITRATE,SURPLUSCOST,ISEVERDEVALUE,ISMAXTOTAL,OVERDUESTATE,"+
			   " CALCULATEFLAG,COGNIZANCEFLAG,PRDDISCOUNT,RESERVESUM,RMBRESERVESUM,ISDEVALUE,LASTPRDDISCOUNT,RESERVESUMCHANGE,CANCELRESERVESUM,LOSSRETSUM,MINUSSUM,"+
			   " RETRACTOMITSUM,EXFORLOSS,ISCANCEL,FINISHDATE,FINISHACCOUNTMONTH,OMITSUM,RETSUM,UPDATEDATE,BATCHTIME,CALCULATETIME) "+
			   " = ((select SUBJECTNO,CERTTYPE,CERTID,INDUSTRYGRADE,ISMSINDUSTRY,BELONGAREA,ISMARKET,BUSINESSTYPE,INDUSTRYTYPE,PUTOUTORGID,PUTOUTSUM,PUTOUTDATE,"+
			   " VOUCHTYPE,CURRENCY,EXCHANGERATE,MATURITY,CONTRACTRATE,OCCUREXPENSES,AUDITRATE,SURPLUSCOST,ISEVERDEVALUE,ISMAXTOTAL,OVERDUESTATE,CALCULATEFLAG,"+
			   " COGNIZANCEFLAG,PRDDISCOUNT,RESERVESUM,RMBRESERVESUM,ISDEVALUE,LASTPRDDISCOUNT,RESERVESUMCHANGE,CANCELRESERVESUM,LOSSRETSUM,MINUSSUM,RETRACTOMITSUM,"+
			   " EXFORLOSS,ISCANCEL,FINISHDATE,FINISHACCOUNTMONTH,OMITSUM,RETSUM,UPDATEDATE,BATCHTIME,CALCULATETIME from RESERVE_TOTAL "+
			   " where AccountMonth=:AccountMonth and DuebillNo=:DuebillNo)) "+
			   " where SerialNo =:SerialNo";
				so = new SqlObject(sSql).setParameter("AccountMonth", sAccountMonth).setParameter("DuebillNo", sDuebillNo).setParameter("SerialNo", sSerialNo);
			
		}else
		{
			sSql = " update RESERVE_APPLY set (SUBJECTNO,CERTTYPE,CERTID,INDUSTRYGRADE,ISMSINDUSTRY,BELONGAREA,ISMARKET,BUSINESSTYPE,INDUSTRYTYPE,PUTOUTORGID,PUTOUTSUM,"+
			   " PUTOUTDATE,VOUCHTYPE,CURRENCY,EXCHANGERATE,MATURITY,CONTRACTRATE,OCCUREXPENSES,AUDITRATE,SURPLUSCOST,ISEVERDEVALUE,ISMAXTOTAL,OVERDUESTATE,"+
			   " CALCULATEFLAG,COGNIZANCEFLAG,PRDDISCOUNT,RESERVESUM,RMBRESERVESUM,ISDEVALUE,LASTPRDDISCOUNT,RESERVESUMCHANGE,CANCELRESERVESUM,LOSSRETSUM,MINUSSUM,"+
			   " RETRACTOMITSUM,EXFORLOSS,ISCANCEL,FINISHDATE,FINISHACCOUNTMONTH,OMITSUM,RETSUM,UPDATEDATE,BATCHTIME,CALCULATETIME) "+
			   " = (select SUBJECTNO,CERTTYPE,CERTID,INDUSTRYGRADE,ISMSINDUSTRY,BELONGAREA,ISMARKET,BUSINESSTYPE,INDUSTRYTYPE,PUTOUTORGID,PUTOUTSUM,PUTOUTDATE,"+
			   " VOUCHTYPE,CURRENCY,EXCHANGERATE,MATURITY,CONTRACTRATE,OCCUREXPENSES,AUDITRATE,SURPLUSCOST,ISEVERDEVALUE,ISMAXTOTAL,OVERDUESTATE,CALCULATEFLAG,"+
			   " COGNIZANCEFLAG,PRDDISCOUNT,RESERVESUM,RMBRESERVESUM,ISDEVALUE,LASTPRDDISCOUNT,RESERVESUMCHANGE,CANCELRESERVESUM,LOSSRETSUM,MINUSSUM,RETRACTOMITSUM,"+
			   " EXFORLOSS,ISCANCEL,FINISHDATE,FINISHACCOUNTMONTH,OMITSUM,RETSUM,UPDATEDATE,BATCHTIME,CALCULATETIME from RESERVE_TOTAL "+
			   " where AccountMonth=:AccountMonth and DuebillNo=:DuebillNo) "+
			   " where SerialNo =:SerialNo ";
			so = new SqlObject(sSql).setParameter("AccountMonth", sAccountMonth).setParameter("DuebillNo", sDuebillNo).setParameter("SerialNo", sSerialNo);
		}
		//��Reserve_Total���и������ݸ� Reserve_Apply
		Sqlca.executeSQL(so);
		//����Reserve_Total�������ֶΣ��϶��׶�Ϊ��ʼ���׶�0010,���ݲɼ�ģʽΪѡ���AvailAbilityFlag
		sSql = " update RESERVE_TOTAL set CognizanceFlag='0010',AvailAbilityFlag=:AvailAbilityFlag "+
	       " where AccountMonth=:AccountMonth and DuebillNo=:DuebillNo ";
		so = new SqlObject(sSql).setParameter("AvailAbilityFlag", sAvailFlag).setParameter("AccountMonth", sAccountMonth).setParameter("DuebillNo", sDuebillNo);
		Sqlca.executeSQL(so);
		return "1";	    
	 }

}
