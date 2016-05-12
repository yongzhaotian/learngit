package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 保证人的预警信号检查
 * @author syang
 * @since 2009/11/12
 */
public class ApproveGuaCustRiskSignalCheck extends AlarmBiz {
	
	/** 成员变量定义 **/
	String sCount="";

	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		BizObject jboApprove = (BizObject)this.getAttribute("BusinessApprove");		//取出批复JBO对象
		String sApproveSerialNo = jboApprove.getAttribute("SerialNo").getString();
		String sVouchType = jboApprove.getAttribute("VouchType").getString();
		
		if(sApproveSerialNo == null) sApproveSerialNo = "";
		if(sVouchType == null) sVouchType = "";
		
		/** 变量定义 **/
		String sSql="";
		ASResultSet rs=null;
		String sGuarantorID="";
		String sGuarantorName="";
		
		
		/** 程序体 **/
		if(sVouchType.length()>=3) {
			//假如业务基本信息中的主要担保方式为保证,则查询出保证人客户代码
			if(sVouchType.substring(0,3).equals("010")){
				sSql = 	" select GuarantorID,GuarantorName from GUARANTY_CONTRACT "+
						" where SerialNo in (select ObjectNo from APPROVE_RELATIVE "+
						" where SerialNo =:SerialNo "+
						" and ObjectType = 'GuarantyContract') "+
						" and GuarantyType like '010%' ";
				SqlObject so = new SqlObject(sSql);
				so.setParameter("SerialNo", sApproveSerialNo);
		        rs = Sqlca.getASResultSet(so);
	        	while(rs.next()){
	            	sGuarantorID = rs.getString("GuarantorID");
	            	sGuarantorName = rs.getString("GuarantorName");
	            	//检查该客户是否存在已生效的预警信息
	            	sSql = "select count(SerialNo) from RISK_SIGNAL where ObjectType = 'Customer' and ObjectNo =:ObjectNo and SignalType = '1' ";
	            	so = new SqlObject(sSql);
	            	so.setParameter("ObjectNo", sGuarantorID);
	            	sCount = Sqlca.getString(so);
					if( sCount != null && Integer.parseInt(sCount,10) > 0  ){
						putMsg("保证人["+sGuarantorName+"]存在生效的预警信号");
					}					
				}
				rs.getStatement().close();
				rs  = null;
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
