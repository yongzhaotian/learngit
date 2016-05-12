package com.amarsoft.app.lending.bizlets;

import java.util.ArrayList;

import com.amarsoft.app.accounting.config.loader.DateFunctions;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;

public class InsertFeeWaive extends Bizlet{
	
	public Object  run(Transaction Sqlca) throws Exception{
		
		//自动获得传入的参数值
		String sUserID = (String)this.getAttribute("UserID");
		String sBusinessType = (String)this.getAttribute("BusinessType");//产品代码
		String objectType = (String)this.getAttribute("ObjectType");//对象类型
		String objectNo = (String)this.getAttribute("ObjectNo");//单据编号
		
		//DBKeyHelp
		//定义变量
		ASResultSet rs = null;
		String sSql = "";
		String insertSql = "";
		String waiveSerialno="";
		String waivefromstage="";
		String waivetostage="";
		String costreductiontype="";
		SqlObject so; //声明对象
		//实例化用户对象
		ASUser CurUser = ASUser.getUser(sUserID,Sqlca);
				
		//取得合同关联的费用信息
		sSql = "select serialno,feetype,feetermid from acct_fee where objectno =:objectNo";		
		so = new SqlObject(sSql).setParameter("objectNo", objectNo);
		rs = Sqlca.getResultSet(so);
		
		//删除该合同下前面产生的减免信息
		String deleteSql = "DELETE FROM acct_fee_waive where objectno in (select serialno from acct_fee where objectno = :objectNo) ";
		so = new SqlObject(deleteSql);
		so.setParameter("objectNo", objectNo);
		Sqlca.executeSQL(so);
		
		ArrayList<String> feeWaiveList = new ArrayList<String>();
		String feeobject= "";
		
		while(rs.next()){
			String serialno = rs.getString("serialno");
			String feetype = rs.getString("feetype");
			String feetermid = rs.getString("feetermid");
			feeobject +="@"+serialno+","+feetype+","+feetermid;
		}
		rs.close();
		
		//取得产品关联的费用减免信息 开始期次，到期其次，费用类型【】
		sSql = "select serialno from acct_fee_waive where typeno =:sBusinessType";		
		so = new SqlObject(sSql).setParameter("sBusinessType", sBusinessType);
		rs = Sqlca.getResultSet(so);
		ArrayList<String> waiveList = new ArrayList<String>();
		
		while(rs.next()){
			waiveList.add(rs.getString("serialno"));
		}
		rs.close();
		for(int i=0;i<waiveList.size();i++){
			waiveSerialno = waiveList.get(i);
			sSql = "select serialno,waivefromstage,waivetostage,costreductiontype from acct_fee_waive where typeno =:sBusinessType and serialno=:waiveSerialno";		
			so = new SqlObject(sSql).setParameter("sBusinessType", sBusinessType).setParameter("waiveSerialno",	waiveSerialno);		
			rs = Sqlca.getResultSet(so);
			if(rs.next()){ 
				waivefromstage = rs.getString("waivefromstage");
				waivetostage = rs.getString("waivetostage");
				costreductiontype = rs.getString("costreductiontype");
			}

			rs.getStatement().close();	
			
			String WaiveFromDate = "";
			String WaiveToDate = "";
			//DateFunctions.getRelativeDate(sScheduleDate, DateFunctions.TERM_UNIT_MONTH, 1)
			//ArrayList<String> costreTypeList = new ArrayList<String>();
			
			String[] costreductiontypes=costreductiontype.split(",");
			for(int j=0;j<costreductiontypes.length;j++){
				String costtypes = costreductiontypes[j];
				String feeType = "";
				if(costtypes.equals("3")){//印花税
					feeType="A11";
				}else if(costtypes.equals("4")){//保险费
					feeType="A12";
				}else if(costtypes.equals("6")){//月财务顾问费
					feeType="A7";
				}else if(costtypes.equals("7")){//月客户服务费
					feeType="A2";
				}
				String[] feeobjectsub = feeobject.substring(feeobject.indexOf("@")+1).trim().split("@");
				
				for(String feeobject_type:feeobjectsub){
					String[] rules = feeobject_type.split(",");
					String feeserialno_object = rules[0];
					String feetype_object = rules[1];
					if(feetype_object.equals(feeType)){						
						insertSql = "insert into acct_fee_waive (serialno,objecttype,objectno,status,waivefromstage,waivetostage,waivetype,inputtime,COSTREDUCTIONTYPE)" +
								"  values(:serialno,'jbo.app.ACCT_FEE',:objectno,'1',:waivefromstage,:waivetostage,'0',:inputtime,:COSTREDUCTIONTYPE) ";
						so = new SqlObject(insertSql);
						so.setParameter("serialno", DBKeyHelp.getSerialNo("acct_fee_waive","SerialNo",Sqlca)).setParameter("objectno", feeserialno_object).setParameter("waivefromstage",waivefromstage )
						.setParameter("waivetostage",waivetostage).setParameter("inputtime", StringFunction.getToday()).setParameter("COSTREDUCTIONTYPE", feeType);
						//执行更新语句
						Sqlca.executeSQL(so);
						
					}
					
				}
				
			}
			 
		}
		
		return "success";
	}
	
}
