package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.biz.reserve.business.BaseDateManager;
import com.amarsoft.biz.reserve.business.ReserveConstants;

/**
 * ���ݻ�ȡ��׼����
 *@author pwang 2009-10-30
 *
 */
public class ReserveGetBaseDate extends Bizlet{
	/**
	 * 
	 * @param baseDateModel ��׼���ڻ�ȡ��ʽ<br/>
	 * 	<li>10 �̶�ģʽ</li>
	 * 	<li>20 ���ģʽ</li>
	 * @param scope ����ھ�<br/>
	 * 	<li>1 ��</li>
	 * 	<li>3 ��</li>
	 * 	<li>6 ����</li>
	 */
	public Object run(Transaction Sqlca) throws Exception{
		
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		String sSql ="";
		ASResultSet rs = null;
		
		String ReserveFrequency ="";//����Ƶ��ģʽ
		int scope = ReserveConstants.FRE_Q;//���ȶ�Ϊ�ھ���
		
		String basedate ="";

		try{
			sSql = "select AvailabilityFlag from reserve_apply where serialno =:sObjectNo";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo));
			if(rs.next())
				ReserveFrequency = rs.getString("AvailabilityFlag");//����Ƶ��ģʽ��
		}catch(Exception e){
			throw new Exception(e);
		}finally{
			rs.getStatement().close();
			rs=null;
		}
		BaseDateManager bdm =  new BaseDateManager(ReserveFrequency,scope,StringFunction.getToday());
		basedate = bdm.getBaseDate();//��ȡ��׼���ڡ�
		ARE.getLog().debug("��׼���ڣ�"+basedate);
		
		return basedate;
	}
}
