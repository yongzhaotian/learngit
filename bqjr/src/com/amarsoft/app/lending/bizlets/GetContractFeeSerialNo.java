package com.amarsoft.app.lending.bizlets;

import java.util.Date;

import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;
import com.amarsoft.app.accounting.util.FeeFunctions;
import com.amarsoft.app.als.sadre.util.DateUtil;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetContractFeeSerialNo extends Bizlet{
	public Object run(Transaction Sqlca) throws Exception
	{
		//��ȡ��ǰ�û�
		String objectNo = (String)this.getAttribute("SerialNo");//��ͬ��ˮ��
		String feeTermID = (String)this.getAttribute("feeTermID");//�������id
		String feeschduleSerialno = (String)this.getAttribute("feeschduleSerialno");//���üƻ���ˮ
		
		//����ֵת���ɿ��ַ���
		if(objectNo == null) objectNo = "";
		if(feeTermID == null) feeTermID = "";
		
		AbstractBusinessObjectManager bom =new DefaultBusinessObjectManager(Sqlca);
		//���������SQL���
		ASResultSet rs = null;
		String sSql = "";
		String feeSerialNo = "";
		String oldfeeserialno = "";
		String sFeeSum = "";
		String feeamount = "";
		String actualfeeamount = "";
		String sRetrun = "";
		String objectType = "jbo.app.BUSINESS_CONTRACT";
		
		//Ӧ�շ����ܶ�		
		sSql =  "SELECT SUM(bc.fee) FROM BUSINESS_CONTRACT bc,car_info ci where bc.serialno="+objectNo+" and bc.serialno=ci.relativeserialno and ci.carstatus='010' ";
		sFeeSum = Sqlca.getString(new SqlObject(sSql));
		
		//����ǰ��ͬ�շѼ�¼
		sSql = " select feeserialno,amount,actualamount from acct_fee_schedule where feetype='A14' and objectno='"+objectNo+"' and objecttype='jbo.app.BUSINESS_CONTRACT' and FEEFLAG='R' and finishdate is null ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql));
		while(rs.next()){
			oldfeeserialno = rs.getString("feeserialno");
			feeamount = rs.getString("amount");
			actualfeeamount = rs.getString("actualamount");
		}
		rs.getStatement().close();
		if(oldfeeserialno == null) oldfeeserialno = "";
		if(feeamount == null) feeamount = "";
		if(actualfeeamount == null) actualfeeamount = "";
		
		if(oldfeeserialno==null||oldfeeserialno.length()==0){//���շѼ�¼
			BusinessObject relativeObject=null;
			relativeObject = bom.loadObjectWithKey(objectType, objectNo);
			if(relativeObject==null) throw new Exception("δ�ҵ�����{"+objectType+"-"+objectNo+"}");
			BusinessObject fee = FeeFunctions.createFee(feeTermID, relativeObject,bom);
			bom.setBusinessObject(AbstractBusinessObjectManager.operateflag_new, fee);
			fee.setAttributeValue("AMOUNT", sFeeSum);
			bom.updateDB();
			
		    feeSerialNo = fee.getString("SerialNo");
			sSql=" insert into acct_fee_schedule (SERIALNO, FEESERIALNO, AMOUNT, CURRENCY, PAYDATE, WAIVEAMOUNT, ACTUALAMOUNT, FINISHDATE, OBJECTTYPE, OBJECTNO, FEETYPE, FEEFLAG)" +
				"values ('"+feeschduleSerialno+"', '"+feeSerialNo+"', '"+sFeeSum+"', '01', '"+DateUtil.getToday()+"', 0.00, 0.00, '', 'jbo.app.BUSINESS_CONTRACT', '"+objectNo+"', 'A14', 'R') ";
			Sqlca.executeSQL(new SqlObject(sSql));
			
			sRetrun = "�����ɹ�,������ˮ�ţ�"+feeSerialNo;
		}else if(feeamount.equals(actualfeeamount)&&(sFeeSum.equals(feeamount))&&feeamount.length()>0){
			sRetrun = "����ȡ,�����ظ���ȡ��";
		}else if(feeamount.equals(sFeeSum)&&Double.parseDouble(actualfeeamount)<=0&&feeamount.length()>0){
			sRetrun = "�ѷ��Ͳ���ۿ�,��Ҫ�ظ������";
			
		}

		return sRetrun;
	}
}
