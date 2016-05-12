package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * 客户信息完整性检查
 * @author syang 
 * @since 2009/09/15
 */
public class CustomerCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** 取参数 **/
		BizObject jboCustomer = (BizObject)this.getAttribute("CustomerInfo");
		String sCustomerID = jboCustomer.getAttribute("CustomerID").getString();
		String sCustomerType = jboCustomer.getAttribute("CustomerType").getString();
		
		/** 变量定义 **/
		boolean bContinue = true;
		String sCount = "";
		String sTempSaveFlag = "";
		SqlObject so = null;//声明对象
		/** 程序体 **/
		//处理过程
		// 申请人客户概况必须录入（必输字段已输入）
		
		//申请人为个人客户，检查暂存标志是否为否
		if( sCustomerType.substring(0,2).equals("03")){
			so = new SqlObject("select TempSaveFlag from IND_INFO where CustomerID=:CustomerID ");
			so.setParameter("CustomerID", sCustomerID);
			sTempSaveFlag = Sqlca.getString(so);
			if(sTempSaveFlag == null) sTempSaveFlag = "";
			if( sTempSaveFlag.equals("1")){
				putMsg("该客户的客户概况信息录入不完整");
			}
			bContinue = false;
			
		//申请人为个人客户，检查暂存标志是否为否
		}else if( sCustomerType.substring(0,2).equals("01") ){	
			so = new SqlObject("select TempSaveFlag from ENT_INFO where CustomerID=:CustomerID ");
			so.setParameter("CustomerID", sCustomerID);
			sTempSaveFlag = Sqlca.getString(so);
			if(sTempSaveFlag == null) sTempSaveFlag = "";
			if( sTempSaveFlag.equals("1") )
				putMsg("该客户的客户概况信息录入不完整");			
		}
		
		if( bContinue ){
			sCount = null;
			//申请人客户类型为“公司客户的”，高管信息中必须有法人代表信息
			if( sCustomerType.substring(0,2).equals("01") ){
				so = new SqlObject("select count(CustomerID) from CUSTOMER_RELATIVE where Relationship='0100' and CustomerID=:CustomerID");
				so.setParameter("CustomerID", sCustomerID);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 )
					putMsg("该客户的高管信息中缺少法人代表信息");
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
