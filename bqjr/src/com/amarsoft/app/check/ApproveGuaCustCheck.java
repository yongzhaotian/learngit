package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 批复信息保证人客户信息完整性检查
 * @author syang
 * @since 2009/09/15
 */
public class ApproveGuaCustCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		BizObject jboApprove = (BizObject)this.getAttribute("BusinessApprove");					//取业务申请
		BizObject[] jboGuarantys = (BizObject[])this.getAttribute("GuarantyContract");	//取担保合同，因为担保合同可能有多个存在的情况
		
		
		String sVouchType = jboApprove.getAttribute("VouchType").getString();
		if(sVouchType == null) sVouchType = "";
		
		/** 变量定义 **/
		String sSql="";
		boolean bContinue = true;
		String sCount="";
		String sGuarantorID="";
		String sGuarantorName="";
		String sCustomerType="";
		SqlObject so = null; //声明对象
		
		/** 程序体 **/
		if(sVouchType.length()>=3) {
			//假如业务基本信息中的主要担保方式为保证,则查询出保证人客户代码
			if(sVouchType.substring(0,3).equals("010")){
				for(int i=0;i<jboGuarantys.length;i++){
					BizObject jboGuaranty = jboGuarantys[i];
					String sGuarantyType = jboGuaranty.getAttribute("GuarantyType").getString();
					if(sGuarantyType == null) sGuarantyType = "";
					if(sGuarantyType.indexOf("010") < 0 ){
						continue;
					}
					
	            	sGuarantorID = jboGuaranty.getAttribute("GuarantorID").getString();
	            	if(sGuarantorID == null || sGuarantorID.equals("")) sGuarantorID = "";
	            	sGuarantorName = jboGuaranty.getAttribute("GuarantorName").getString();
	            	
	            	 so = new SqlObject("select CustomerType from CUSTOMER_INFO where CustomerID =:CustomerID");
	            	 so.setParameter("CustomerID", sGuarantorID);
	            	 sCustomerType=Sqlca.getString(so);
	            	 
	            	if(sCustomerType == null||sCustomerType.length()<=0) {
	            		throw new Exception("客户号："+sGuarantorID+"客户类型[CustomerType]为空，请检查数据的完整性");
	            	}
	            	//根据查询得出的保证人客户代码，查询他们的客户概况是否录入完整
	            	//公司客户
	            	if (sCustomerType.substring(0,2).equals("01")){ 
						so = new SqlObject("select Count(CustomerID) from ENT_INFO  where CustomerID =:CustomerID  and TempSaveFlag = '1'");
		            	so.setParameter("CustomerID", sGuarantorID);
		            	sCount = Sqlca.getString(so);
	            	}
	            	//相关个人
	            	if (sCustomerType.substring(0,2).equals("03")){	           
	            		so = new SqlObject("select Count(CustomerID) from IND_INFO where CustomerID =:CustomerID and TempSaveFlag = '1' ");
		            	so.setParameter("CustomerID", sGuarantorID);
		            	sCount = Sqlca.getString(so);
	            	}
	            	
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){												
					}else{
					 	putMsg("保证人["+sGuarantorName+"]的客户概况信息录入不完整");
					 	bContinue = false;
					}
					
					if( bContinue ){
						sCount = null;
						//申请人客户类型为“公司客户的”，高管信息中必须有法人代表信息
						if( sCustomerType.substring(0,2).equals("01") ){
							so = new SqlObject("select count(CustomerID) from CUSTOMER_RELATIVE where Relationship='0100' and CustomerID=:CustomerID ");
			            	so.setParameter("CustomerID", sGuarantorID);
			            	sCount = Sqlca.getString(so);
							if( sCount == null || Integer.parseInt(sCount) <= 0 ){
								putMsg("保证人["+sGuarantorName+"]的高管信息中缺少法人代表信息");
							}
						}
					}					
				}
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
