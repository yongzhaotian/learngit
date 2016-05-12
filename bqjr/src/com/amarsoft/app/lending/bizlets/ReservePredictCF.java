package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.biz.reserve.business.CashFlowDiscountFormula;
import com.amarsoft.biz.reserve.business.DateTools;
/**
 * 
 * Ԥ��δ���ֽ������ּ��㡣
 * @author pwang
 *
 */
public class ReservePredictCF extends Bizlet {
	/** 
	 * @param rate,cashflow
	 */
	public Object run(Transaction Sqlca) throws Exception{
		
		String sRate = (String)this.getAttribute("rate");				//���ʣ�������
		String sCashFlow = (String)this.getAttribute("cashflow");		//δ���ֽ���
		String sFutureDate = (String)this.getAttribute("futureDate");	//δ������
		String sBaseDate = (String)this.getAttribute("baseDate");		//��׼����	
		
		double[] sCashFlowDouble= new double[1];
		double sRate1 = 0.0;	
		
		
		
		if(sRate == null) sRate = "";
		if(sCashFlow == null) sCashFlow = "";
		double ReturnValue =0.0;
		
		//�������
		sRate1 =Double.parseDouble(sRate);			//ϵͳĿǰΪ������
		sCashFlowDouble[0] =Double.parseDouble(sCashFlow);

	
		//��1������������������������
		int days = DateTools.getDateDistance(sBaseDate,sFutureDate);
		//����=����/30(����)
		double time = days/30.0;
		
		ReturnValue = CashFlowDiscountFormula.getCashFlow(sRate1,Double.parseDouble(sCashFlow),time);
		ARE.getLog().debug("����Ԥ��δ���ֽ������֣�"+ReturnValue);
		return ""+ReturnValue;
	}

}
