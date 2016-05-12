package com.amarsoft.app.lending.bizlets;

/**
 * @author pkyan 2010-04-02
 * ��ȡ���ʵ÷�
 */
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetFinancingScore extends Bizlet{


	public Object run(Transaction Sqlca) throws Exception {

		String sSerialNo = (String)this.getAttribute("SerialNo");//��ȡ�ñ������
		String sModelNo = (String)this.getAttribute("ModelNo");//��ȡ�ñ������ģ��ţ���Ҫ�������������ItemNo��ȡֵ
		if(sSerialNo == null) sSerialNo = "";
		if(sModelNo == null) sModelNo = "";
		
		//�����������
		String sql = ""; //����sql
		double dScore =0;//�����ȡ���ʵ÷ֱ���
		ASResultSet rs = null;
		
		if(sModelNo.equals("008")||sModelNo.equals("009")){//������ģ��ֱ���"Ͷ�ʹ�����ҵ���õȼ�������"��"�ǽ�������ز���ҵ���õȼ�������"
			sql = "select sum(ED.EvaluateScore) as Score from EVALUATE_DATA ED where SerialNo = '"+sSerialNo+"' and ItemNo >='1.2.7.1' and ItemNo <'1.2.7.4'";
		}else if(sModelNo.equals("003")){//���ģ������ҵ��ҵ���õȼ�������
			sql = "select sum(ED.EvaluateScore) as Score from EVALUATE_DATA ED where SerialNo ='"+sSerialNo+"' and ItemNo >='1.2.a.1' and ItemNo <'1.2.a.5'";
		}else if(sModelNo.equals("005")){//���ڻ��ʩ����ҵ���õȼ�����������ʵ÷�
			sql = "select sum(ED.EvaluateScore) as Score from EVALUATE_DATA ED where SerialNo ='"+sSerialNo+"' and ItemNo >='1.2.9.1' and ItemNo <='1.2.9.5'";
		}else{
			sql = "select sum(ED.EvaluateScore) as Score from EVALUATE_DATA ED where SerialNo ='"+sSerialNo+"' and ItemNo >='1.2.9.1' and ItemNo <'1.2.9.5'";
		}
		
		rs=Sqlca.getASResultSet(sql);
		if(rs.next()){
			dScore = rs.getDouble("Score");
		}else{
			throw new Exception("������ģ��û�����ʵ÷�ָ�꣡");
		}
		rs.getStatement().close();
		return Double.toString(dScore);
	}

}
