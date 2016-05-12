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
		//��ȡ��ǰ�û�
		String sBusinessSum_ = (String)this.getAttribute("BusinessSum");//����
		String stypeno = (String)this.getAttribute("BusinessType");//ҵ��Ʒ��
		String sTerm = (String)this.getAttribute("Term");//����
		String YesNo = (String)this.getAttribute("YesNo");//�Ƿ�Ͷ��
		String sBugPayPkgind = (String)this.getAttribute("BugPayPkgind");//�Ƿ������Ļ������
		//����ֵת���ɿ��ַ���
		if(sBusinessSum_ == null) sBusinessSum_ = "0";
		if(stypeno == null) stypeno = "";
		if(sTerm == null) sTerm = "0";
		//���������SQL���
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
		
		//MonthRate=BaseRate/12;//��Ʒ������
		MonthRate=sYearRate/12;//��Ч������
		if(MonthRate==0.0){
			MonthPayment = sBusinessSum/term;
		}else{
			MonthPayment=sBusinessSum*MonthRate/100*(java.lang.Math.pow((1+MonthRate/100),term))/((java.lang.Math.pow((1+MonthRate/100),term)-1));
		}
		if(YesNo.equals("1")){
			double BaoXianFee = getBaoXianFee(stypeno,sBusinessSum,term,Sqlca);
			MonthPayment = MonthPayment + BaoXianFee;
		}
		//���Ļ������
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
		
		//���㷽ʽ
		String CalType = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeCalType","DefaultValue");
		if(CalType.equals("01")){//�̶����
			String FeeAmount = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeAmount","DefaultValue");
			BaoXianFee = Double.parseDouble(FeeAmount);
		}else if(CalType.equals("02")){//������*����
			String FeeRate = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeRate","DefaultValue");
			//ÿ�±��շ�
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
