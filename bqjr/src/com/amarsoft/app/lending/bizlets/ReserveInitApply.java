/*
 *	Author: jgao1 2009-10-22
 *	Tester:
 *	Describe: 单项计提减值准备认定流程初始化时，把Reserve_Total中的数据复制到Reserve_Apply
 *	Input Param: 	
 *			SerialNo：单项计提减值准备申请流水号		
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
		//申请流水号
		String sSerialNo = (String)this.getAttribute("SerialNo");
		if(sSerialNo == null) sSerialNo = "";
		
		String sSql = "",sAccountMonth="",sDuebillNo="",sAvailFlag="";
		ASResultSet rs=null;
		SqlObject so; //声明对象
		//根据申请表RESERVE_APPLY取得会计月份和借据号
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
		//从Reserve_Total表中复制数据给 Reserve_Apply
		Sqlca.executeSQL(so);
		//更新Reserve_Total的申请字段：认定阶段为初始化阶段0010,数据采集模式为选择的AvailAbilityFlag
		sSql = " update RESERVE_TOTAL set CognizanceFlag='0010',AvailAbilityFlag=:AvailAbilityFlag "+
	       " where AccountMonth=:AccountMonth and DuebillNo=:DuebillNo ";
		so = new SqlObject(sSql).setParameter("AvailAbilityFlag", sAvailFlag).setParameter("AccountMonth", sAccountMonth).setParameter("DuebillNo", sDuebillNo);
		Sqlca.executeSQL(so);
		return "1";	    
	 }

}
