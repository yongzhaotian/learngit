package com.amarsoft.app.check;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 业务申请信息完整性检查
 * @author syang
 * @since 2009/09/15
 */

public class ApplyInfoCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		//获得参数
		String sObjectType = (String)this.getAttribute("ObjectType");		//ObjectType,ObjectNo不属于任何业务对象，需要对场景中取
		BizObject apply = (BizObject)this.getAttribute("BusinessApply");	//引入JBO
		
		SqlObject so=null;//声明对象
		
		String sApplySerialNo = apply.getAttribute("SerialNo").getString();
		String sCustomerID = apply.getAttribute("CustomerID").getString();
		String sBusinessType = apply.getAttribute("BusinessType").getString();
		String sOccurType = apply.getAttribute("OccurType").getString();
		String sTempSaveFlag = apply.getAttribute("TempSaveFlag").getString();
		double dBusinessSum = apply.getAttribute("BusinessSum").getDouble();
		int dBillNum = apply.getAttribute("BillNum").getInt();
		
		boolean bContinue = true;
		String sCount="",sHasIERight="",sNum="";
		
		//1、暂存标志为必输项是否录入完整的检查标志
		if( sTempSaveFlag != null && sTempSaveFlag.equals("1")&& sTempSaveFlag != "2"){
			putMsg("申请基本信息必输项未录入完整");
			bContinue = false;
		}
		
		if( bContinue ){
			//发生类型为展期，则必须关联展期业务
			if(sOccurType.equals("015")){
				so = new SqlObject("select count(SerialNo) from Apply_RELATIVE where SerialNo=:SerialNo and ObjectType='BusinessDueBill'");
				so.setParameter("SerialNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("发生类型为展期，必须有相关的展期业务信息");						
				}
				
			//发生类型为借新还旧，则必须关联借新还旧的业务
			}else if(sOccurType.equals("020")){
				so = new SqlObject("select count(SerialNo) from Apply_RELATIVE where SerialNo=:SerialNo and ObjectType='BusinessDueBill'");
				so.setParameter("SerialNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("发生类型为借新还旧，必须有相关的借新还旧业务信息");						
				}
			//发生类型为资产重组，则必须关联资产重组方案
			}else if(sOccurType.equals("030")){
				so = new SqlObject("select count(SerialNo) from Apply_RELATIVE where SerialNo=:SerialNo and ObjectType='NPAReformApply'");
				so.setParameter("SerialNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("发生类型为资产重组，必须有相关的资产重组方案信息");	
				}
			}
			
			//业务品种为项目贷款，必须关联相应的项目信息
			if( sBusinessType.substring(0,4).equals("1030") ){					
				so = new SqlObject("select count(PR.ProjectNo) from PROJECT_RELATIVE PR,BUSINESS_APPLY BA where PR.ObjectNo=BA.SerialNo and PR.ObjectType='CreditApply' and PR.ObjectNo=:ObjectNo");
				so.setParameter("ObjectNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("业务品种为项目贷款，必须关联相应的项目信息");
				}
				
			//是否有进出口经营权
			}else if (sBusinessType.substring(0, 4).equals("1080")){
				so = new SqlObject("select HasIERight from ENT_INFO where CustomerID =:CustomerID ");
				so.setParameter("CustomerID", sCustomerID);
				sHasIERight=Sqlca.getString(so);
				
	        	if(sHasIERight==null) sHasIERight="";
	        	if(sHasIERight.equals("2"))
	        		putMsg("业务品种为国际融资，必须有进出口经营权");
	                
	        } 
			
			
			//查询出客户类型
			String sSql = " select CustomerType from CUSTOMER_INFO where CustomerID =:CustomerID ";
			so = new SqlObject(sSql);
			so.setParameter("CustomerID", sCustomerID);
			String sCustomerType = Sqlca.getString(so);
			if (sCustomerType == null) sCustomerType = "";	
			
			/*
			 * 与探测项010880,是否进行了风险度评估重复.故屏蔽
			if (sCustomerType.substring(0,2).equals("01")){ //公司客户
				so = new SqlObject("select Count(SerialNo) from EVALUATE_RECORD where ObjectType='CreditApply' and ObjectNo=:ObjectNo and EvaluateScore >=0");
				so.setParameter("ObjectNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("该申请还未进行风险度测评");
				}
			}
			*/
						
			if (sBusinessType.equals("1080020")){
				so = new SqlObject("select count(SerialNo) from LC_INFO where ObjectType = 'CreditApply' and ObjectNo =:ObjectNo");
				so.setParameter("ObjectNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("业务品种为信用证项下出口打包贷款业务，没有相关信用证信息");
				}					
			}
			
			if(sBusinessType.length()>=4) {
				//如果产品类型为贴现业务
				if(sBusinessType.substring(0,4).equals("1020") && !sBusinessType.equals("1020040"))	{
					so = new SqlObject("select count(SerialNo) from BILL_INFO  where ObjectType = 'CreditApply' and ObjectNo =:ObjectNo having sum(BillSum) =:dBusinessSum ");
					so.setParameter("ObjectNo", sApplySerialNo);
					so.setParameter("dBusinessSum", dBusinessSum);
					sCount = Sqlca.getString(so);
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){
						putMsg("业务品种为贴现业务，业务金额和票据金额总和不符");
					}
									
					so = new SqlObject("select count(SerialNo) from BILL_INFO  where ObjectType = 'CreditApply' and ObjectNo =:ObjectNo having count(SerialNo) =:dBillNum ");
					so.setParameter("ObjectNo", sApplySerialNo);
					so.setParameter("dBillNum", dBillNum);
					sCount = Sqlca.getString(so);
					if( sCount == null || Integer.parseInt(sCount) <= 0 ){
						putMsg("业务品种为贴现业务，业务中输入的票据张数和输入的票据张数不符");
					}									
				}
			}
			
			//信用证项下出口打包贷款、信用证项下出口押汇、托收项下出口押汇、信用证项下进口押汇,检查相关信用证信息
			if (sBusinessType.equals("1080020") ||sBusinessType.equals("1080030") ||sBusinessType.equals("1080040") ||sBusinessType.equals("1080010")){
				so = new SqlObject("select count(SerialNo) from LC_INFO where ObjectType =:ObjectType  and ObjectNo =:ObjectNo ");				
				so.setParameter("ObjectType", sObjectType);
				so.setParameter("ObjectNo", sApplySerialNo);
				sNum = Sqlca.getString(so);
				if( sNum == null || Integer.parseInt(sNum) <= 0 )
					putMsg("托收项下出口押汇、出口商业发票融资或信用证相关业务，没有相关信用证信息");
			}

			//进口保理、出口保理，检查相关发票信息
			if (sBusinessType.equals("1080310") ||  sBusinessType.equals("1080320")) {
				so = new SqlObject("select count(SerialNo) from INVOICE_INFO where ObjectType = 'CreditApply' and ObjectNo =:ObjectNo");
				so.setParameter("ObjectNo", sApplySerialNo);
				sCount = Sqlca.getString(so);
				if( sCount == null || Integer.parseInt(sCount) <= 0 ){
					putMsg("业务品种为进口保理业务或出口保理业务，没有增值税发票信息");
				}					
			}
			
			so = new SqlObject("select count(SerialNo) from FORMATDOC_DATA where ObjectType='CreditApply' and ObjectNo=:ObjectNo ");
			so.setParameter("ObjectNo", sApplySerialNo);
			sCount = Sqlca.getString(so);
			if( sCount == null || Integer.parseInt(sCount) <= 0 ){
				putMsg("该申请还未填写尽职调查报告信息");
			}
									
		}
		
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}

}
