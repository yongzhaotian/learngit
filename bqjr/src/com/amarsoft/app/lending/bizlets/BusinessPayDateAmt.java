package com.amarsoft.app.lending.bizlets;

import java.math.BigDecimal;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class BusinessPayDateAmt extends Bizlet {

	
	public Object run(Transaction Sqlca) throws Exception {
		//获取合同号，计划提前还款日
		String sContractSerialNo=(String)this.getAttribute("ContractSerialNo");
		String sScheduleDate=(String)this.getAttribute("ScheduleDate");
		String sYesNo=(String)this.getAttribute("YesNo");
		
		//全程应还金额
		double dPayAmt=0;
		//当期应还金额
		double dPayAmount=0;
		//应还总金额
		double dPayTotalAmt=0;
		
		String sSql="";
		ASResultSet rs=null;
		
		
		//获取下一还款日,借据号
		String selectSql="select nextduedate,serialno from acct_loan where putoutno=:putoutno";
		rs=Sqlca.getASResultSet(new SqlObject(selectSql).setParameter("putoutno", sContractSerialNo));
		String nextDueDate="";
		String sSerialno="";
		if(rs.next()){
			nextDueDate=rs.getString("nextduedate");
			sSerialno=rs.getString("serialno");
		}
		rs.close();		
		
		//提前还款手续费,贷款金额
		double dPrepayAmt=0,dBusinessSum=0;
		//获取犹豫期天数
		int sAdvanceHesitateDate = 0;
		//产品类型,组件ID
		String sBusinessType="",sTermId="";

		sSql="	select bc.businesstype,ptl.termid,bc.businesssum from business_contract bc,product_term_library ptl "+
				"	where  bc.businesstype||'-V1.0'=ptl.objectno "+
				"	and ptl.subtermtype='A9' "+
				"	and status='1' "+
				"	and bc.serialno='"+sContractSerialNo+"'";
		
		rs=Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			sBusinessType=rs.getString("businesstype");
			sTermId=rs.getString("termid");
			dBusinessSum=rs.getDouble("businesssum");
			
			sAdvanceHesitateDate = Integer.parseInt(ProductConfig.getProductTermParameterAttribute(sBusinessType, "V1.0", sTermId, "AdvancehesitateDate","DefaultValue"));
			
			//计算方式
			String CalType = ProductConfig.getProductTermParameterAttribute(sBusinessType, "V1.0", sTermId, "FeeCalType","DefaultValue");
			if(CalType.equals("01")){//固定金额
				dPrepayAmt = Double.parseDouble(ProductConfig.getProductTermParameterAttribute(sBusinessType, "V1.0", sTermId, "FeeAmount","DefaultValue"));
			}else if(CalType.equals("02")){//贷款金额*费率
				String FeeRate = ProductConfig.getProductTermParameterAttribute(sBusinessType, "V1.0", sTermId, "FeeRate","DefaultValue");
				dPrepayAmt = dBusinessSum * Double.parseDouble(FeeRate)*0.01;
			}
			
			double minAmt = Double.parseDouble(ProductConfig.getProductTermParameterAttribute(sBusinessType, "V1.0", sTermId, "FeeAmount","MinValue"));
			double maxAmt = Double.parseDouble(ProductConfig.getProductTermParameterAttribute(sBusinessType, "V1.0", sTermId, "FeeAmount","MaxValue"));
			
			if(dPrepayAmt > maxAmt){
				dPrepayAmt = maxAmt;
			}else if(dPrepayAmt < minAmt){
				dPrepayAmt = minAmt;
			}
		}
        rs.close();
				
		
		//得出提前还款可行日期
		String sPayDate="";
		if(DateFunctions.getDays(sScheduleDate,nextDueDate)>=15){
			sPayDate=nextDueDate;
		}else{
			sPayDate=DateFunctions.getRelativeDate(nextDueDate,DateFunctions.TERM_UNIT_MONTH, 1);
			String sql="select max(paydate) as paydate from acct_payment_schedule where objectno=:objectno and objecttype='jbo.app.ACCT_LOAN' ";
			rs=Sqlca.getASResultSet(new SqlObject(sql).setParameter("objectno", sSerialno));
			String sMaxPayDate="";
			if(rs.next()){
				sMaxPayDate=rs.getString("paydate");
				if(DateFunctions.getDays(sPayDate, sMaxPayDate)<0){
					sPayDate=sMaxPayDate;
				}
			}
			rs.close();
		}
		
		
		//获取审批通过日期
		selectSql="select putoutdate from business_contract  where serialno=:serialno";
		rs=Sqlca.getASResultSet(new SqlObject(selectSql).setParameter("serialno", sContractSerialNo));
		String PutoutDate=null;
		if(rs.next()){
			PutoutDate=rs.getString("putoutdate");
		}
		rs.close();

		if(PutoutDate==null || PutoutDate.length()==0) throw new Exception("该合同的putoutdate不存在，请检查");
		if(DateFunctions.getDays(PutoutDate,sScheduleDate)<sAdvanceHesitateDate){
			//CCS-847 PRM-421 客户多笔合同（或二月份）提前还款犹豫期内外逻辑冲突问题
			//CSS-848 PRM-420 提前还款可行日期显示区分犹豫期
			sPayDate=DateFunctions.getRelativeDate(PutoutDate,DateFunctions.TERM_UNIT_DAY, sAdvanceHesitateDate-1);//犹豫期的提前还款可行日(计息日+14天)
			selectSql=" select round(sum(nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0)),2) as payAmt" +
					 " from acct_payment_schedule aps,acct_loan al "+ 
					 " where al.serialno=aps.objectno and aps.objecttype='jbo.app.ACCT_LOAN' "+
					 " 	and (aps.finishdate is null or aps.finishdate =' ') and aps.paytype='1' "+
					 " 	and al.putoutno=:putoutno and al.loanstatus='0' ";
			
			rs=Sqlca.getASResultSet(new SqlObject(selectSql).setParameter("putoutno", sContractSerialNo));
			if(rs.next()){
				dPayTotalAmt=rs.getDouble("payAmt");
			}
			
			rs.close();
			return sPayDate+","+String.valueOf(dPayTotalAmt)+",false,0.0";
		}else{
			
			
			
			//全程的应还金额
			if(nextDueDate.equals(sPayDate)){
				sSql=" select round(sum(nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0)),2) as payAmt" +
						" from acct_payment_schedule aps,acct_loan al "+ 
						" where ((al.serialno=aps.objectno and aps.objecttype='jbo.app.ACCT_LOAN') or "+
						" 		(al.serialno=aps.relativeobjectno and aps.relativeobjecttype='jbo.app.ACCT_LOAN' and aps.paytype ='A11')) "+
						" 		and (aps.finishdate is null or aps.finishdate =' ') and aps.paytype<>'A9' "+
						" 		and al.putoutno=:putoutno and al.loanstatus='0' ";	      
			}else{
				sSql=" select round(sum(nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0)),2) as payAmt" +
						" from acct_payment_schedule aps,acct_loan al "+ 
						" where ((al.serialno=aps.objectno and aps.objecttype='jbo.app.ACCT_LOAN') or "+
						" 		(al.serialno=aps.relativeobjectno and aps.relativeobjecttype='jbo.app.ACCT_LOAN' and aps.paytype='A11')) "+
						" 		and (aps.finishdate is null or aps.finishdate =' ') and aps.paydate>nextDueDate "+
						" 		and al.putoutno=:putoutno and al.loanstatus='0'  and aps.paytype<>'A9' ";      
			}
			
			
			rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("putoutno", sContractSerialNo));
			if(rs.next()){
				dPayAmt=rs.getDouble("payAmt");
			}
			rs.close();
			//当期的应还金额
			sSql="	select round(sum(case when aps.relativeobjectno=al.serialno then nvl(aps.payprincipalamt,0)-nvl(aps.actualpayprincipalamt,0) "+
					"      else nvl(aps.payinteamt,0)-nvl(aps.actualpayinteamt,0) end),2) as payAmount"+         
					" from acct_payment_schedule aps,acct_loan al "+
					" where ((al.serialno=aps.objectno and aps.objecttype='jbo.app.ACCT_LOAN') or "+
					"     (al.serialno=aps.relativeobjectno and aps.relativeobjecttype='jbo.app.ACCT_LOAN' and aps.paytype not in ('A11'))) "+
					"     and (aps.finishdate is null or aps.finishdate =' ') "+
					"     and aps.paydate=:paydate  and aps.paytype<>'A9' "+
					"     and al.putoutno=:putoutno  and al.loanstatus='0'";
			
			rs=Sqlca.getASResultSet(new SqlObject(sSql).setParameter("paydate", sPayDate).setParameter("putoutno", sContractSerialNo));
			if(rs.next()){
				dPayAmount=rs.getDouble("payAmount");
			}
			
			rs.getStatement().close();
			if(sYesNo.equals("2")) dPrepayAmt = 0;
			
			dPayTotalAmt=dPayAmt+dPayAmount+dPrepayAmt;
			BigDecimal bigDecimal = new BigDecimal(dPayTotalAmt);
			bigDecimal = bigDecimal.setScale(2,BigDecimal.ROUND_HALF_UP);
			dPayTotalAmt = bigDecimal.doubleValue(); 
			
			return sPayDate+","+String.valueOf(dPayTotalAmt)+",true,"+String.valueOf(dPrepayAmt);
		}
	}	
}
