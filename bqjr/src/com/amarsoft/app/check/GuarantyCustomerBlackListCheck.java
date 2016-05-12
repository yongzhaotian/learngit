package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 保证人黑名单检查
 * @author syang
 * @since 2009/09/15
 */
public class GuarantyCustomerBlackListCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		BizObject jboApply = (BizObject)this.getAttribute("BusinessApply");		//取出申请JBO对象
		String sApplySerialNo = jboApply.getAttribute("SerialNo").getString();
		String sVouchType = jboApply.getAttribute("VouchType").getString();
		
		if(sApplySerialNo == null) sApplySerialNo = "";
		if(sVouchType == null) sVouchType = "";
		
		/** 变量定义 **/
		String sCount="";
		String sSql="";
		String sGuarantorID="";	
		String sGuarantorName="";	
		ASResultSet rs=null;
		SqlObject so = null;
		
		
		/** 程序体 **/
		if(sVouchType.length()>=3) {
			//假如业务基本信息中的主要担保方式为保证,则查询出保证人客户代码
			if(sVouchType.substring(0,3).equals("010")){
				sSql = 	" select GuarantorID,GuarantorName from GUARANTY_CONTRACT "+
						" where SerialNo in (select ObjectNo from APPLY_RELATIVE "+
						" where SerialNo =:SerialNo "+
						" and ObjectType = 'GuarantyContract') "+
						" and GuarantyType like '010%' ";
				so = new SqlObject(sSql);
				so.setParameter("SerialNo", sApplySerialNo);
		        rs = Sqlca.getASResultSet(so);
				
	        	while(rs.next()){
	            	sGuarantorID = rs.getString("GuarantorID");
	            	sGuarantorName = rs.getString("GuarantorName");
	            	//检查保证人是否存在黑名单中
					so = new SqlObject("select count(SerialNo) from CUSTOMER_SPECIAL where CustomerID =:CustomerID and SectionType = '40' ");
					so.setParameter("CustomerID", sGuarantorID);
					sCount = Sqlca.getString(so);
					if( sCount != null && Integer.parseInt(sCount,10) > 0  ){
						putMsg( "保证人["+sGuarantorName+"]属于黑名单客户");
					}	            	
	            						
				}
				rs.getStatement().close();
				rs = null;
			}
		}
		
		/** 返回结果处理 **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		return null;
	}
}
