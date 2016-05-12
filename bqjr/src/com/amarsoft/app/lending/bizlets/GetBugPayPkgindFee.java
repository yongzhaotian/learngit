package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;

import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.are.util.Arith;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �жϼ���ÿ�����Ļ����������
 * @author daihuafeng
 *
 */
public class GetBugPayPkgindFee {
	private String sBusinessSum_;//����
	private String stypeno;//ҵ��Ʒ��
	private String sTerm;//����
	private String sBugPayPkgind;//�Ƿ������Ļ������
	
	public String getFee(Transaction Sqlca) throws Exception{
		//���Ļ������
		double sBusinessSum = Double.parseDouble(sBusinessSum_);
		int term = Integer.parseInt(sTerm);
		double SuiXinHuanFee = 0.0d;
		if("1".equals(sBugPayPkgind)){
			SuiXinHuanFee= getSuiXinHuanFee(stypeno,sBusinessSum,term,Sqlca);
		}
		return String.valueOf(Arith.round(SuiXinHuanFee,8));
	}

	public double getSuiXinHuanFee(String stypeno,double sBusinessSum, int term,Transaction Sqlca) throws Exception{
		String sSql = "";
		ASResultSet rs = null;
		String termID = "";
		double SuiXinHuan = 0.0d;
		String ObjectNo = stypeno+"-"+"V1.0";
		sSql = "select termid from product_term_library where subtermtype = 'A18' and status='1' and  ObjectNo = '"+ObjectNo+"' ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		if(rs.next()){
			termID = rs.getString("termid");
		}else{
			return SuiXinHuan;
		}
		rs.getStatement().close();
		
		//���㷽ʽ
		String CalType = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeCalType","DefaultValue");
		if(CalType.equals("01")){//�̶����
			String FeeAmount = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeAmount","DefaultValue");
			SuiXinHuan = Double.parseDouble(FeeAmount);
		}else if(CalType.equals("02")){//������*����
			String FeeRate = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeRate","DefaultValue");
			//ÿ�·���
			SuiXinHuan = sBusinessSum * Double.parseDouble(FeeRate)*0.01;
		}else if(CalType.equals("15")){// �̶����*��ͬ����
			String FeeAmount = ProductConfig.getProductTermParameterAttribute(stypeno, "V1.0", termID, "FeeAmount","DefaultValue");
			// ÿ�·���
			SuiXinHuan = Double.parseDouble(FeeAmount);
		}
			
		return SuiXinHuan;
	}

	public String getsBusinessSum_() {
		return sBusinessSum_;
	}

	public void setsBusinessSum_(String sBusinessSum_) {
		this.sBusinessSum_ = sBusinessSum_;
	}

	public String getStypeno() {
		return stypeno;
	}

	public void setStypeno(String stypeno) {
		this.stypeno = stypeno;
	}

	public String getsTerm() {
		return sTerm;
	}

	public void setsTerm(String sTerm) {
		this.sTerm = sTerm;
	}

	public String getsBugPayPkgind() {
		return sBugPayPkgind;
	}

	public void setsBugPayPkgind(String sBugPayPkgind) {
		this.sBugPayPkgind = sBugPayPkgind;
	}
	
}
