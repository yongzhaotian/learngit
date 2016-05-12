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
 * 依据获取基准日期
 *@author pwang 2009-10-30
 *
 */
public class ReserveGetBaseDate extends Bizlet{
	/**
	 * 
	 * @param baseDateModel 基准日期获取方式<br/>
	 * 	<li>10 固定模式</li>
	 * 	<li>20 随机模式</li>
	 * @param scope 计提口径<br/>
	 * 	<li>1 月</li>
	 * 	<li>3 季</li>
	 * 	<li>6 半年</li>
	 */
	public Object run(Transaction Sqlca) throws Exception{
		
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		String sSql ="";
		ASResultSet rs = null;
		
		String ReserveFrequency ="";//测试频率模式
		int scope = ReserveConstants.FRE_Q;//季度定为口径。
		
		String basedate ="";

		try{
			sSql = "select AvailabilityFlag from reserve_apply where serialno =:sObjectNo";
			rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("sObjectNo", sObjectNo));
			if(rs.next())
				ReserveFrequency = rs.getString("AvailabilityFlag");//测试频率模式。
		}catch(Exception e){
			throw new Exception(e);
		}finally{
			rs.getStatement().close();
			rs=null;
		}
		BaseDateManager bdm =  new BaseDateManager(ReserveFrequency,scope,StringFunction.getToday());
		basedate = bdm.getBaseDate();//获取基准日期。
		ARE.getLog().debug("基准日期："+basedate);
		
		return basedate;
	}
}
