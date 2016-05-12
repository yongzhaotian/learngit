package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 批复：保证人本行授信业务检查
 * @author syang
 * @since 2009/09/15
 */
public class ApproveGuaCustCreditBizCheck extends AlarmBiz {

	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		BizObject jboApprove = (BizObject)this.getAttribute("BusinessApprove");		//取出批复JBO对象
		String sApproveSerialNo = jboApprove.getAttribute("SerialNo").getString();
		String sVouchType = jboApprove.getAttribute("VouchType").getString();
		
		if(sApproveSerialNo == null) sApproveSerialNo = "";
		if(sVouchType == null) sVouchType = "";
		
		/** 变量定义 **/
		String sCount="";
		String sSql="";
		String sGuarantorID="";	
		String sGuarantorName="";	
		ASResultSet rs=null;
		ASResultSet rs1=null;
		SqlObject so = null; //声明对象
		
		/** 程序体 **/
		if(sVouchType.length()>=3) {
			//假如业务基本信息中的主要担保方式为保证,则查询出保证人客户代码
			if(sVouchType.substring(0,3).equals("010")){
				sSql = 	" select GuarantorID,GuarantorName from GUARANTY_CONTRACT "+
						" where SerialNo in (select ObjectNo from APPROVE_RELATIVE "+
						" where SerialNo =:SerialNo "+
						" and ObjectType = 'GuarantyContract') "+
						" and GuarantyType like '010%' ";
				so = new SqlObject(sSql);
				so.setParameter("SerialNo", sApproveSerialNo);
				rs = Sqlca.getASResultSet(so);
	        	while(rs.next()){
	            	sGuarantorID = rs.getString("GuarantorID");
	            	sGuarantorName = rs.getString("GuarantorName");
	            	//全行范围内	
	            	sSql = 	" select count(*) from BUSINESS_CONTRACT "+
					" where CustomerID =:CustomerID "+
					" and BusinessType not like '3%' "+
					" and (FinishDate is null "+
					" or FinishDate = ' ') ";	
	            	so = new SqlObject(sSql);
					so.setParameter("CustomerID", sGuarantorID);
			        sCount = Sqlca.getString(so);
	            	
					if( sCount != null && Integer.parseInt(sCount,10) > 0 ){	
						putMsg("保证人["+sGuarantorName+"]在全行范围内未结清的授信业务笔数："+sCount);
						sSql = 	" select sum(BusinessSum*getERate(BusinessCurrency,'01','')) as BusinessSum, "+
								" sum(Balance*getERate(BusinessCurrency,'01','')) as BalanceSum "+
								" from BUSINESS_CONTRACT "+
								" where CustomerID =:CustomerID "+
								" and BusinessType not like '3%' "+
								" and (FinishDate is null "+
								" or FinishDate = ' ') ";
						so = new SqlObject(sSql);
						so.setParameter("CustomerID", sGuarantorID);
						rs1 = Sqlca.getResultSet(so);
						if(rs1.next()){
							String sBusinessSum = rs1.getString("BusinessSum");
							String sBalanceSum = rs1.getString("BalanceSum");
							if(sBusinessSum == null) sBusinessSum = "0.00";
							if(sBalanceSum == null) sBalanceSum = "0.00";
							putMsg("保证人["+sGuarantorName+"]在全行范围内未结清的授信业务发放总金额（折人民币）："+DataConvert.toMoney(sBusinessSum));
							putMsg("保证人["+sGuarantorName+"]在全行范围内未结清的授信业务总余额（折人民币）："+DataConvert.toMoney(sBalanceSum));
						}
						rs1.getStatement().close();
						rs1 = null;
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
