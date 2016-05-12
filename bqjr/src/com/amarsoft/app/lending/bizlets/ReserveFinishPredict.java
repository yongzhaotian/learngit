package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 保存单次预测未来现金流数据,并做RESERVE_TOTAL的PrdDisCount和updatedate字段值更新.
 * 
 * @author pwang 2009/10/27 
 */
public class ReserveFinishPredict extends Bizlet {
	/**
	 * @param accountMonth 会计月份
	 * 		  duebillNo    借据号
	 *  	  objectNo     单项计提申请对象编号
	 * @return 1 成功 0 失败
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
		SqlObject so; //声明对象
		double dDiscountSum = 0.0;

		String sToday = DataConvert.toString(StringFunction.getToday());
		try{			
			/**本期现金流折现总计*/
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
	   	     
	   		 /**更新本期现金流折现值*/
	   		 sSql = "update  RESERVE_TOTAL set PrdDisCount =:PrdDisCount,updatedate=:updatedate where AccountMonth =:AccountMonth and DuebillNo =:DuebillNo " ;
	   		 so = new SqlObject(sSql);
	   		 so.setParameter("PrdDisCount", dDiscountSum).setParameter("updatedate", sToday).setParameter("AccountMonth", sAccountMonth).setParameter("DuebillNo", sDuebillNo);
			 Sqlca.executeSQL(so);
			 /**更新本期现金流折现值*/
			 sSql = "update  RESERVE_APPLY set PrdDisCount =:PrdDisCount,updatedate=:updatedate where SerialNo =:SerialNo" ;
			 so = new SqlObject(sSql).setParameter("PrdDisCount", dDiscountSum).setParameter("updatedate", sToday).setParameter("SerialNo", sObjectNo);
			 Sqlca.executeSQL(so);
			 //调用计算类，运行完成后，该类会自动把减值金额更新至Reserve_Total的ReserveSum字段中
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



