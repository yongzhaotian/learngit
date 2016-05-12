package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.Arith;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetMonthPayment extends Bizlet {
	public Object run(Transaction Sqlca) throws Exception
	{
		//获取当前用户
		String sBusinessSum_ = (String)this.getAttribute("BusinessSum");//本金
		String stypeno = (String)this.getAttribute("BusinessType");//业务品种
		String sTerm = (String)this.getAttribute("Term");//期限
		String YesNo = (String)this.getAttribute("YesNo");//是否投保
		String sBugPayPkgind = (String)this.getAttribute("BugPayPkgind");//是否购买随心还服务包
		//将空值转化成空字符串
		if(sBusinessSum_ == null) sBusinessSum_ = "0";
		if(stypeno == null) stypeno = "";
		if(sTerm == null) sTerm = "0";
		//定义变量：SQL语句
		String sSql = "";
		int term = Integer.parseInt(sTerm);
		double BaseRate=0.0d;
		double MonthRate=0.0d;
		double MonthPayment = 0.0d;
		double sBusinessSum= Double.parseDouble(sBusinessSum_);
				
		sSql =  "select BASERATE,EFFECTIVEANNUALRATE from business_type where typeno = :stypeno ";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("stypeno", stypeno));
		double sYearRate = 0.0d;
		if(rs.next()){
			//term = rs.getInt(1);
			BaseRate = rs.getDouble(1);
			sYearRate = rs.getDouble(2);
		}
		rs.getStatement().close();
		
		//MonthRate=BaseRate/12;//产品月利率
		MonthRate=sYearRate/12;//有效年利率
		if(MonthRate==0.0){
			MonthPayment = sBusinessSum/term;
		}else{
			MonthPayment=sBusinessSum*MonthRate/100*(java.lang.Math.pow((1+MonthRate/100),term))/((java.lang.Math.pow((1+MonthRate/100),term)-1));
		}
		if(YesNo.equals("1")){
			double BaoXianFee = getBaoXianFee(stypeno,sBusinessSum,term,Sqlca);
			MonthPayment = MonthPayment + BaoXianFee;
		}
		//随心还服务费
		if("1".equals(sBugPayPkgind)){
			double SuiXinHuanFee = getSuiXinHuanFee(stypeno,sBusinessSum_,sTerm,sBugPayPkgind,Sqlca);
			MonthPayment = MonthPayment + SuiXinHuanFee;
		}
		return String.valueOf(Arith.round(MonthPayment,8));
	}

	private double getBaoXianFee(String stypeno,double sBusinessSum, int term, Transaction Sqlca) throws Exception {
		String sSql = "";
		ASResultSet rs = null;
		String termID = "";
		double BaoXianFee = 0.0d;
		String ObjectNo = stypeno+"-"+"V1.0";
		sSql = "select termid from product_term_library where subtermtype = 'A12' and status='1' and  ObjectNo = '"+ObjectNo+"' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		while(rs.next()){
			termID = rs.getString("termid");
		}
		rs.getStatement().close();
		
		//计算方式
		String CalType = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeCalType","DefaultValue");
		if(CalType.equals("01")){//固定金额
			String FeeAmount = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeAmount","DefaultValue");
			BaoXianFee = Double.parseDouble(FeeAmount);
		}else if(CalType.equals("02")){//贷款金额*费率
			String FeeRate = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeRate","DefaultValue");
			//每月保险费
			BaoXianFee = sBusinessSum * Double.parseDouble(FeeRate)*0.01;
		}
			
		return BaoXianFee;
	}

	private double getSuiXinHuanFee(String stypeno,String sBusinessSum_,String sTerm,String sBugPayPkgind,Transaction Sqlca) throws Exception {
		double SuiXinHuan = 0.0d;
		GetBugPayPkgindFee bppf = new GetBugPayPkgindFee();
		bppf.setStypeno(stypeno);
		bppf.setsBusinessSum_(sBusinessSum_);
		bppf.setsTerm(sTerm);
		bppf.setsBugPayPkgind(sBugPayPkgind);
		SuiXinHuan = Double.parseDouble(bppf.getFee(Sqlca));
		return SuiXinHuan;
	}
	
}
