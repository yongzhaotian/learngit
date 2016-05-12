package com.amarsoft.app.lending.bizlets;

import java.math.BigDecimal;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class BusinessHesitationPeriod extends Bizlet {

	
	public Object run(Transaction Sqlca) throws Exception {
		//获取合同号，计划提前还款日
		String sContractSerialNo=(String)this.getAttribute("ContractSerialNo");
		//String sScheduleDate=(String)this.getAttribute("ScheduleDate");
		//String sYesNo=(String)this.getAttribute("YesNo");
		
		String sSql="";
		ASResultSet rs=null;
		
		//获取犹豫期天数
		int sAdvanceHesitateDate1 = 0;
		String sAdvanceHesitateDate="";
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
			
			sAdvanceHesitateDate1 = Integer.parseInt(ProductConfig.getProductTermParameterAttribute(sBusinessType, "V1.0", sTermId, "AdvancehesitateDate","DefaultValue"));
		}
		rs.getStatement().close();
		sAdvanceHesitateDate=String.valueOf(sAdvanceHesitateDate1);
		return sAdvanceHesitateDate;
	}	
}
