package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * ���浥��Ԥ��δ���ֽ�������,����RESERVE_TOTAL��PrdDisCount��updatedate�ֶ�ֵ����.
 * 
 * @author pwang 2009/10/27 
 */
public class ReserveFinishPredict extends Bizlet {
	/**
	 * @param accountMonth ����·�
	 * 		  duebillNo    ��ݺ�
	 *  	  objectNo     ����������������
	 * @return 1 �ɹ� 0 ʧ��
	 */
	public Object run(Transaction Sqlca) throws Exception{
		
		String sAccountMonth = (String)this.getAttribute("AccountMonth");
		String sDuebillNo = (String)this.getAttribute("DuebillNo");
		String sObjectNo = (String)this.getAttribute("ObjectNo");

		if(sDuebillNo == null) sDuebillNo = "";
		if(sAccountMonth == null) sAccountMonth = "";
		if(sObjectNo == null) sObjectNo = "";
		String sSql = "";
		String sReturnValue = "";
		ASResultSet rs = null;
		SqlObject so; //��������
		double dDiscountSum = 0.0;

		String sToday = DataConvert.toString(StringFunction.getToday());
		try{			
			/**�����ֽ��������ܼ�*/
			sSql =  " select nvl(sum(DiscountSum),0) from RESERVE_PREDICTDATA " + 
            " where DuebillNo =:DuebillNo " + 
            " and AccountMonth=:AccountMonth "+
            " and ObjectNo=:ObjectNo";	
			so = new SqlObject(sSql).setParameter("DuebillNo", sDuebillNo).setParameter("AccountMonth", sAccountMonth).setParameter("ObjectNo", sObjectNo);
			rs = Sqlca.getASResultSet(so);
	   		 if(rs.next()){
	   		    dDiscountSum = rs.getDouble(1);   		    			
		     }
	   		 rs.getStatement().close();
	   	     
	   		 /**���±����ֽ�������ֵ*/
	   		 sSql = "update  RESERVE_TOTAL set PrdDisCount =:PrdDisCount,updatedate=:updatedate where AccountMonth =:AccountMonth and DuebillNo =:DuebillNo " ;
	   		 so = new SqlObject(sSql);
	   		 so.setParameter("PrdDisCount", dDiscountSum).setParameter("updatedate", sToday).setParameter("AccountMonth", sAccountMonth).setParameter("DuebillNo", sDuebillNo);
			 Sqlca.executeSQL(so);
			 /**���±����ֽ�������ֵ*/
			 sSql = "update  RESERVE_APPLY set PrdDisCount =:PrdDisCount,updatedate=:updatedate where SerialNo =:SerialNo" ;
			 so = new SqlObject(sSql).setParameter("PrdDisCount", dDiscountSum).setParameter("updatedate", sToday).setParameter("SerialNo", sObjectNo);
			 Sqlca.executeSQL(so);
			 //���ü����࣬������ɺ󣬸�����Զ��Ѽ�ֵ��������Reserve_Total��ReserveSum�ֶ���
			 ReserveSingleReserveSum rsr = new ReserveSingleReserveSum();
			 rsr.setAttribute("AccountMonth", sAccountMonth);
			 rsr.setAttribute("DuebillNo", sDuebillNo);
			 rsr.setAttribute("Flag", "false");
			 rsr.run(Sqlca);
	   		 
	     	 sReturnValue = "1";
	    }catch(Exception ex){
		    sReturnValue = "0";
		    ARE.getLog().error(ex.getMessage());
		}
		return sReturnValue;		
	}
}



