/*
 *	Author: jgao1 2009-10-26
 *	Tester:
 *	Describe: 在集团授信总额更改时，检查缩小总额时，配额是否满足要求
 *	Input Param:
 *			ObjectType:对象类型
 *			ObjectNo: 对象编号
 *			BusinessSum: 授信额度协议金额
 *	Output Param:
 *	HistoryLog:
 *  @updatesuer:yhshan
 *  @updatedate:2012/09/12
 */

package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CheckGroupLineSum extends Bizlet{

	public Object  run(Transaction Sqlca) throws Exception{
	 	//对象类型，
	 	String sObjectType = (String)this.getAttribute("ObjectType");
	 	//对象编号，用来查找授信总额
	 	String sObjectNo = (String)this.getAttribute("ObjectNo");
	 	//授信额度协议金额
	 	String sBusinessSum = (String)this.getAttribute("BusinessSum");
	 	if(sBusinessSum==null||sBusinessSum.equals("")) sBusinessSum = "0";
	 	double dLineSum = DataConvert.toDouble(sBusinessSum);
	 	
	 	//返回值标志：1."00":表示正常；2."02":子额度授信限额>额度协议金额
		String flag = "00";
		
		SqlObject so = null;//声明对象
		
		String sSql = "";
		//授信额度ID
		String sParentLineID = "";
		//集团授信额度币种
		String sCurrency="";
		//集团额度币种转换成授信额度币种后汇率值
		double dERateValue=0;
		ASResultSet rs = null;
		//不同的对象类型它的取值也不同
		if(sObjectType.equals("CreditApply"))
		{
			sSql = " select LineID,Currency from CL_INFO where ApplySerialNo =:ApplySerialNo order by LineID";
			so = new SqlObject(sSql);
			so.setParameter("ApplySerialNo", sObjectNo);
			rs=Sqlca.getASResultSet(so);
			if(rs.next())
			{
				sParentLineID=rs.getString("LineID"); 
				sCurrency=rs.getString("Currency"); 
			}
		}
		if(sObjectType.equals("BusinessContract"))
		{
			sSql = " select LineID,Currency from CL_INFO where BCSerialNo =:BCSerialNo order by LineID";
			so = new SqlObject(sSql);
			so.setParameter("BCSerialNo", sObjectNo);
			rs=Sqlca.getASResultSet(so);
			if(rs.next())
			{
				sParentLineID=rs.getString("LineID");
				sCurrency=rs.getString("Currency");
			}
		}
		rs.getStatement().close();
				
	 	//子额度个数
	 	int iCount =0;
	 	so = new SqlObject("select LineSum1,GetERate1(Currency,:sCurrency) as ERateValue from GLINE_INFO where ParentLineID=:ParentLineID ");
		so.setParameter("sCurrency", sCurrency);
		so.setParameter("ParentLineID", sParentLineID);
		String[][] sArray = Sqlca.getStringMatrix(so);
		iCount = sArray.length;
		for(int i=0;i<iCount;i++){
			if(Double.valueOf(sArray[i][0])*Double.valueOf(sArray[i][1])//授信限额*汇率转换值
					>dLineSum)//子额度授信限额>额度协议金额
				flag="02";	
		}		
		return flag;
	}
}
	

