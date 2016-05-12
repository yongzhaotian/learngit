package com.amarsoft.app.lending.bizlets;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.app.accounting.businessobject.BUSINESSOBJECT_CONSTATNTS;
import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.businessobject.AbstractBusinessObjectManager;
import com.amarsoft.app.accounting.businessobject.DefaultBusinessObjectManager;

public class UpdateFineBusinessRate extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sql = "";
		
		AbstractBusinessObjectManager bom = new DefaultBusinessObjectManager(Sqlca);
		
		String objectType = (String)this.getAttribute("ObjectType");
		String objectNo = (String)this.getAttribute("ObjectNo");
		
		if(objectType == null)
		{
			objectType = "";
		}
		if(objectNo == null)
		{
			objectNo = "";
		}
		//�������
		BusinessObject bo = bom.loadObjectWithKey(objectType, objectNo);
		/**
		 * �˴����˵��̶����͵ķ�Ϣ�������и��¶��� 
		 * */
		if(bo != null)
		{
			updateRateSegment(objectType,objectNo,Sqlca);
		}else
		{
			throw new Exception("����"+objectType+"."+objectNo+"�������ڣ�");
		}
		//modify end 
		
		return "true";
	}	
	
	private void updateRateSegment(String objectType,String objectNo,Transaction Sqlca) throws Exception
	{
		double businessRate = 0.0,baseRate = 0.0;
		String sql = "select nvl(BusinessRate,0),nvl(BaseRate,0) from Acct_Rate_Segment where ObjectType = '"+objectType+"' and ObjectNo = '"+objectNo+"' and RateTermID like 'RAT%' and Status <> '2' order by SEGFROMSTAGE asc "; 
		ASResultSet rs = Sqlca.getASResultSet(sql);
		if(rs.next())
		{
			businessRate = rs.getDouble(1);
			baseRate = rs.getDouble(2);
		}
		rs.getStatement().close();
		
		//�����Ʒ������Ϊ����ִ������BaseRateType = '100'�͸���Ϊ����ִ������
		sql = "update Acct_Rate_Segment set BaseRate = "+businessRate+",BusinessRate = " +
			  "(case when RateFloatType = '0' then "+businessRate+"*(1+nvl(RateFloat,0)/100) else "+businessRate+"+nvl(RateFloat,0) end) " +
			  "where ObjectType = '"+objectType+"' and ObjectNo = '"+objectNo+"' and RateTermID like 'FIN%' and BaseRateType = '100' " +
			  "and RateMode='1' ";
		Sqlca.executeSQL(sql);
		//�����Ʒ�����ò��Ǵ���ִ������BaseRateType <> '100' �͸���Ϊ��׼����
		sql = "update Acct_Rate_Segment set BaseRate = "+businessRate+",BusinessRate = " +
			  "(case when RateFloatType = '0' then "+businessRate+"*(1+nvl(RateFloat,0)/100) else "+businessRate+"+nvl(RateFloat,0) end) " +
			  "where ObjectType = '"+objectType+"' and ObjectNo = '"+objectNo+"' and RateTermID like 'FIN%' and BaseRateType <> '100' " +
			  "and RateMode='1' ";
		Sqlca.executeSQL(sql);
	}
}
