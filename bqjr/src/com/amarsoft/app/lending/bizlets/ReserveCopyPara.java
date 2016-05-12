/*
 *	Author: jgao1 2009-10-22
 *	Tester:
 *	Describe: 减值准备基础参数复制逻辑，自动复制本期的减值准备参数，如果本期参数已存在，则不允许复制
 *	Input Param: 	
 *			AccountMonth:传入会计月份
 *			AssetsType:传入资产组
 *	        CustomerType:传入客户类型
 *			Flag:传入会计月份的划分间隔，1：按月，3：按季，6：按半年，12：按年
 *	Output Param:			
 *	HistoryLog:
 */

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.biz.reserve.business.DateTools;

public class ReserveCopyPara extends Bizlet {
	
	public Object  run(Transaction Sqlca) throws Exception {
		//传入会计月份
		String sInAccountMonth = (String)this.getAttribute("AccountMonth");
		//传入资产组
		String sAssetsType = (String)this.getAttribute("AssetsType");
		//传入客户类型
		String sCustomerType = (String)this.getAttribute("CustomerType");
		//传入会计月份间隔标志
		String sFlag = (String)this.getAttribute("Flag");
		//判断是否为空
		if(sInAccountMonth == null) sInAccountMonth = "";
		if(sAssetsType == null) sAssetsType = "";
		if(sFlag == null) sFlag = "";
		if(sCustomerType == null) sCustomerType = "";
		
		String sCuAccountMonth = "";
		String sSql = "";
		String sTable = "";
		String sReturn = "";
		ASResultSet rs=null;
		SqlObject so; //声明对象
		int iCount = 0;
		int iFlag = DataConvert.toInt(sFlag);
		//根据底层减值准备支持包，调用获得本期会计月份的函数
		sCuAccountMonth = DateTools.getAccountMonth("yyyy/MM/dd",iFlag);
		//取得参数主数据表
		//如果客户类型为公司客户
		if(sCustomerType.equals("01")) sTable = "RESERVE_ENTPARA";
		//如果客户类型为个人客户
		if(sCustomerType.equals("03")) sTable = "RESERVE_INDPARA";
		
		//判断本期会计月份参数是否存在
		sSql = " select count(*) from "+sTable+" where AccountMonth =:AccountMonth and AssetsType=:AssetsType";
		so = new SqlObject(sSql).setParameter("AccountMonth", sCuAccountMonth).setParameter("AssetsType", sAssetsType);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			iCount = rs.getInt(1);
		}
		rs.getStatement().close();
		if(iCount>0){
			//表示本期会计月份的参数已经存在
			sReturn = "Exit";
		}else{
			//如果本期会计月份的参数不存在，则复制传入参数的会计月份的内容到本期
			sSql = " insert into "+sTable+"(ACCOUNTMONTH,ASSETSTYPE,LOSSRATECALTYPE,LOSSRATE1,LOSSRATE2,LOSSRATE3,LOSSRATE4,"+
			       " LOSSRATE5,LOSSRATE6,LOSSRATE7,LOSSRATE8,LOSSRATE9,LOSSRATE10,LOSSRATE11,LOSSRATE12,LOSSRATE13,LOSSRATE14,"+
			       " LOSSRATE15,LOSSRATE16,LOSSRATE17,LOSSRATE18,LOSSRATE19,LOSSRATE20,ADJUSTMODULUS,RATEOFLOSS)"+
			       " select '"+sCuAccountMonth+"',ASSETSTYPE,LOSSRATECALTYPE,LOSSRATE1,LOSSRATE2,LOSSRATE3,LOSSRATE4,LOSSRATE5,LOSSRATE6,"+
			       " LOSSRATE7,LOSSRATE8,LOSSRATE9,LOSSRATE10,LOSSRATE11,LOSSRATE12,LOSSRATE13,LOSSRATE14,LOSSRATE15,LOSSRATE16,LOSSRATE17,"+
			       " LOSSRATE18,LOSSRATE19,LOSSRATE20,ADJUSTMODULUS,RATEOFLOSS "+
			       " from "+sTable+
			       " where AccountMonth='"+sInAccountMonth+"' and AssetsType='"+sAssetsType+"'";
			Sqlca.executeSQL(sSql);
			sReturn = "SuccessFul";
		}
		return sReturn;
	}
}
