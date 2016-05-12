/**
 * 取得担保合同的可用担保额度
 * @author syang
 * @date 2009/10/20
 */
package com.amarsoft.app.creditline.bizlets;

import java.text.DecimalFormat;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;



public class GetGuarantyBalance extends Bizlet {

 public Object  run(Transaction Sqlca) throws Exception{
	 
	 	/**
	 	 * 担保合同号
	 	 */
	 	String sGuarantyNo = (String)this.getAttribute("GuarantyNo");
	 	if(sGuarantyNo == null) sGuarantyNo = "";
	 	
	 	/**
	 	 * 定义变量
	 	 */
	 	String sSql = "";
	 	String sTmp = "";
	 	
	 	double dUsedLimit = 0.0;		//已占用额度
	 	double dGuarantySum = 0.0;		//总担保额度
	 	double dGuarantyBalance = 0.0; 	//担保余额
		SqlObject so = null;//声明对象
	 	
	 	//查询该笔担保关联的所有业务合同，并出取出有效合同，计算他们的总额
		sSql = "select sum(Balance*GetErate(businesscurrency,'01','')) from BUSINESS_CONTRACT BC "
	 			+" where SerialNo in("
	 			+" select SerialNo from Contract_Relative "
	 			+" where objecttype='GuarantyContract' "
	 			+" and ObjectNo=:ObjectNo "
	 			+")"
	 			+" and (BC.FinishDate is null or BC.FinishDate = '' or BC.FinishDate = ' ')"
	 			;
		so = new SqlObject(sSql);
		so.setParameter("ObjectNo", sGuarantyNo);
		sTmp = Sqlca.getString(so);
	 	if(sTmp == null) sTmp = "0";
	 	
	 	dUsedLimit = Double.parseDouble(sTmp);
	 	
	 	//取担保合用总额
	 	sSql = "select GuarantyValue*GetErate(GuarantyCurrency,'01','') from GUARANTY_CONTRACT GC where SerialNo=:SerialNo";
	 	so = new SqlObject(sSql);
		so.setParameter("SerialNo", sGuarantyNo);
		sTmp = Sqlca.getString(so);
	 	if(sTmp == null) sTmp = "0";
	 	dGuarantySum = Double.parseDouble(sTmp);
	 	
	 	//计算担保余额
	 	dGuarantyBalance = dGuarantySum - dUsedLimit;
	 	DecimalFormat df = new DecimalFormat("#.####");//如果有小数，则保留4位小数
	 	sTmp = df.format(dGuarantyBalance);
	 	return sTmp;
 }
}
