package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 保证人财务信息检查
 * @author syang
 * @since 2009/09/15
 */
public class GuarantyCustomerFSCheck extends AlarmBiz {
	
	/** 成员变量定义 **/
	String sCount="";

	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		BizObject jboApply = (BizObject)this.getAttribute("BusinessApply");		//取出申请JBO对象
		String sApplySerialNo = jboApply.getAttribute("SerialNo").getString();
		String sVouchType = jboApply.getAttribute("VouchType").getString();
		
		if(sApplySerialNo == null) sApplySerialNo = "";
		if(sVouchType == null) sVouchType = "";
		
		/** 变量定义 **/
		ASResultSet rs=null;
		String sSql="";
		String sGuarantorID="";	
		String sGuarantorName="";
		SqlObject so = null;//声明对象
		
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
	        	while(rs.next())
	        	{
	            	sGuarantorID = rs.getString("GuarantorID");
	            	sGuarantorName = rs.getString("GuarantorName");
	            	//处理过程
					String sAccMonth = "";//会计月份
					String sMinAccMonth = "";//前三月								
					String sCurToday = StringFunction.getToday();//当前日期
					sAccMonth = sCurToday.substring(0,7);//会计月份
					sMinAccMonth = StringFunction.getRelativeAccountMonth(sAccMonth,"Month",-3);
					so = new SqlObject("select count(RecordNo) from CUSTOMER_FSRECORD where CustomerID =:CustomerID And ReportDate >=:ReportDate");
					so.setParameter("CustomerID", sGuarantorID);
					so.setParameter("ReportDate", sMinAccMonth);
					sCount = Sqlca.getString(so);
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){
						putMsg("保证人["+sGuarantorName+"]已经有三个月没有登记财务报表");
					}			            						
				}
				rs.getStatement().close();					
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
