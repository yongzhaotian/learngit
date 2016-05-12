/*
		Author: --ccxie 2010/03/22
		Tester:
		Describe: --将担保合同信息拷贝到担保合同变更申请表中
		Input Param:
				SerialNo: 合同流水号
		Output Param:
				sNewSerialNo：担保合同变更申请流水号
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class AddTransformInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//合同流水号
		String sSerialNo = (String)this.getAttribute("SerialNo");
		if(sSerialNo == null) sSerialNo = "";
		String sNewSerialNo = DBKeyHelp.getSerialNo("GUARANTY_TRANSFORM","SerialNo","",Sqlca);
		String sSql = "";
		SqlObject so = null; //声明对象
		//拷贝合同信息到担保合同变更表中
		sSql =  " INSERT INTO GUARANTY_TRANSFORM (SerialNo,RelativeSerialNo,ObjectType,ArtificialNo,CustomerID,CustomerName," +
				" OccurType,BusinessType,BusinessCurrency,BusinessSum,Balance,TransformReason,ManageOrgID,InputDate,UpdateDate)" +
				" select '"+sNewSerialNo+"',SerialNo,'TransformApply',ArtificialNo,CustomerID,CustomerName,OccurType,BusinessType,BusinessCurrency,BusinessSum,Balance," +
				" '',ManageOrgID,'"+StringFunction.getToday()+"','"+StringFunction.getToday()+"' from BUSINESS_CONTRACT where SerialNo = '"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);
		
		//拷贝CONTRACT_RELATIVE表相关的信息到TRANSFORM_RELATIVE表中
		sSql =  " INSERT INTO TRANSFORM_RELATIVE (SerialNo,ObjectType,ObjectNo,RelativeSum,RelationStatus) " +
				" select '"+sNewSerialNo+"',ObjectType ,ObjectNo,RelativeSum,RelationStatus from CONTRACT_RELATIVE where SerialNo = '"+sSerialNo+"'" +
				" and ObjectType = 'GuarantyContract' and RelationStatus = '010' ";
		Sqlca.executeSQL(sSql);
		
		//设置BUSINESS_CONTRACT表的标志位TransformFlag=1,表示该笔主合同正处于担保合同变更流程中
		so = new SqlObject("update BUSINESS_CONTRACT set TransformFlag = '1' where SerialNo =:SerialNo ").setParameter("SerialNo", sSerialNo);
		Sqlca.executeSQL(so);
		
		
		return sNewSerialNo;
	}
}
