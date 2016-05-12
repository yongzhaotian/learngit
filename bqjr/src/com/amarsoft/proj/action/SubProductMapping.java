package com.amarsoft.proj.action;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class SubProductMapping {

	
	/**
	 * 判断规则引擎是否返回期数跟金额
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String existPrincipalPeriodOrNot(Transaction Sqlca,String businessContractSerialNo) throws Exception{
		String result ="true";
		String principalSql ="select cprincipal from cashpost_data where applyno = :ObjectNo";
		String principalReturn= Sqlca.getString(new SqlObject(principalSql).setParameter("ObjectNo", businessContractSerialNo));
		String periodSql ="select cperiods from cashpost_data where applyno = :ObjectNo";
		String periodReturn= Sqlca.getString(new SqlObject(periodSql).setParameter("ObjectNo", businessContractSerialNo));
		ARE.getLog().info("201505211435-----------------ruleReturn="+principalReturn+","+periodReturn);
		if(("0".equals(principalReturn)&&"0".equals(periodReturn))||(principalReturn==null&&periodReturn==null)){
			result = "false";
		}
		return result;
	}
	/**
	 * 检查规则引擎对金额改变后，该金额是否在产品系列下所有产品的最大金额跟最小金额范围内
	 *  @param Sqlca
	 *	@return
	 * @throws Exception 
	 * add by ybpan at 20150423  CCS-485
	 */
	public String cprincipalMapping(Transaction Sqlca,String BusinessType,int CprincipalNew) throws Exception{
		String flag = "FAIL";
		int sMaxPrincipal =0;
		int sMinPrincipal =0;
		
		String productSeriesNoSql ="select PRODUCTSERIESID from product_businessType where BUSTYPEID =:BUSTYPEID";
		String productSeriesNo= Sqlca.getString(new SqlObject(productSeriesNoSql).setParameter("BUSTYPEID", BusinessType));
		String sMaxMinsql = "select max(bt.TALLPRINCIPAL),min(LOWPRINCIPAL) from business_type bt,   "+
			"(select pb.bustypeid from product_businessType pb where pb.productseriesid =:productSeriesID) b "+
					" where bt.typeno=b.bustypeid";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sMaxMinsql).setParameter("productSeriesID", productSeriesNo));
		if(rs.next()){
			 sMaxPrincipal = rs.getInt(1);
			 sMinPrincipal = rs.getInt(2);
		}
		rs.getStatement().close();		
		ARE.getLog().info("CprincipalNew"+CprincipalNew+"sMaxPrincipal"+sMaxPrincipal+"sMinPrincipal"+sMinPrincipal);
		if(CprincipalNew>=sMinPrincipal&&CprincipalNew<=sMaxPrincipal){flag = sMaxPrincipal+"@"+sMinPrincipal+"@"+productSeriesNo;}
		return flag;
	}
	/**
	 * 检查系统中有没有符合条件的产品
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 * add by ybpan at 20150424 CCS-485
	 */
	public String checkBusinessType(Transaction Sqlca,int CprincipalNew,int CperiodNew ,String productSeriesNo)  throws Exception{
		String  changedBusinessType ="";
		String sql = "select TYPENO from business_type bt,product_businessType pb where bt.typeno=pb.bustypeid and pb.productseriesid=:productSeriesID and  TALLPRINCIPAL>=:TALLPRINCIPAL and LOWPRINCIPAL<=:LOWPRINCIPAL and term=:CperiodNew  and SUBPRODUCTTYPE='2'";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql)
		.setParameter("TALLPRINCIPAL", CprincipalNew)
		.setParameter("LOWPRINCIPAL", CprincipalNew)
		.setParameter("CperiodNew", CperiodNew)
		.setParameter("productSeriesID", productSeriesNo)
		);
		if(rs.next()){
			changedBusinessType = rs.getString(1);
		}
		rs.getStatement().close();		
		return changedBusinessType;
		
	}
	
	/**
	 * 附条件批准阶段查询某个合同的期数，金额，规则引擎返回的期数金额以及原合同中的产品
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 * add by ybpan at 20150427
	 */
	public String subConditionCapitalPeriod(Transaction Sqlca,String businessContractSerialNo)  throws Exception{
		//规则引擎返回金额
		String sCprincipalSql = "select cprincipal from cashpost_data where applyno = :ObjectNo";
		String ssCprincipal=Sqlca.getString(new SqlObject(sCprincipalSql).setParameter("ObjectNo", businessContractSerialNo));
		if(ssCprincipal==null) ssCprincipal="0";
		int sCprincipal = Integer.valueOf(ssCprincipal).intValue();
		//规则引擎返回期数
		String sCperiodSql = "select nvl(cperiods,0) from cashpost_data where applyno = :ObjectNo";
		String ssCperiodSql=Sqlca.getString(new SqlObject(sCperiodSql).setParameter("ObjectNo", businessContractSerialNo));
		if(ssCperiodSql==null) ssCperiodSql="0";
		int sCperiod = Integer.valueOf(ssCperiodSql).intValue();
		
		//该客户在合同表中的期数
		String sBusinessCperiodSql = "select Periods from business_contract where serialno = :ObjectNo";
		String ssBusinessCperiodSql=Sqlca.getString(new SqlObject(sBusinessCperiodSql).setParameter("ObjectNo", businessContractSerialNo));
		if(ssBusinessCperiodSql==null) ssBusinessCperiodSql="0";
		int sBusinessCperiod = Integer.valueOf(ssBusinessCperiodSql).intValue();
		//该客户在合同表中的金额
		String sBusinessCprincipalSql = "select BusinessSum from business_contract where serialno= :ObjectNo";
		String ssBusinessCprincipalSql=Sqlca.getString(new SqlObject(sBusinessCprincipalSql).setParameter("ObjectNo", businessContractSerialNo));
		if(ssBusinessCprincipalSql==null) ssBusinessCprincipalSql="0";
		int sBusinessCprincipal = Integer.valueOf(ssBusinessCprincipalSql).intValue();
		//该客户在合同表中原来申请贷款的产品
		String sBusinessProductSql = "select businesstype from business_contract where serialno= :ObjectNo";
		String sBusinessProduct = Sqlca.getString(new SqlObject(sBusinessProductSql).setParameter("ObjectNo", businessContractSerialNo));
		
		return sCprincipal +"@"+sCperiod+"@"+sBusinessCprincipal+"@"+sBusinessCperiod+"@"+sBusinessProduct;
	}
	
	
}
